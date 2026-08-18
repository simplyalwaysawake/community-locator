const root = document.querySelector("[data-admin-community-map]")

if (root) initializeCommunityMap(root)

async function initializeCommunityMap(rootElement) {
  const statusElement = rootElement.querySelector("[data-map-status]")
  const errorElement = rootElement.querySelector("[data-map-error]")
  const mapElement = rootElement.querySelector("[data-map]")
  const drawButtons = Array.from(rootElement.querySelectorAll("[data-draw-shape]"))
  const clearButton = rootElement.querySelector("[data-clear-selection]")
  const copyEmailsButton = rootElement.querySelector("[data-copy-emails]")
  const downloadButton = rootElement.querySelector("[data-download-selection]")
  const selectionCountElement = rootElement.querySelector("[data-selection-count]")

  let map
  let cluster
  let selectionLayer
  let selectionShape
  let users = []
  let totalCount = 0
  let selectedIds = new Set()
  let markerByUserId = new Map()

  try {
    const L = (await import("leaflet")).default
    window.L = L

    await import("leaflet.markercluster")
    await import("@geoman-io/leaflet-geoman-free")

    const [{ booleanPointInPolygon }, { default: Papa }] = await Promise.all([
      import("@turf/boolean-point-in-polygon"),
      import("papaparse")
    ])

    map = L.map(mapElement, {
      minZoom: 2,
      worldCopyJump: true
    }).setView([20, 0], 2)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a> contributors'
    }).addTo(map)

    map.pm.setGlobalOptions({
      allowSelfIntersection: false,
      exitModeOnEscape: true,
      finishOnEnter: true,
      snappable: false
    })

    const regularIcon = L.divIcon({
      className: "admin-community-map-marker",
      iconAnchor: [7, 7],
      iconSize: [14, 14]
    })
    const selectedIcon = L.divIcon({
      className: "admin-community-map-selected-marker",
      iconAnchor: [8, 8],
      iconSize: [16, 16]
    })

    cluster = L.markerClusterGroup({
      chunkDelay: 25,
      chunkInterval: 100,
      chunkedLoading: true,
      iconCreateFunction: clusterLayer => clusterIcon(L, clusterLayer),
      removeOutsideVisibleBounds: true
    })
    map.addLayer(cluster)

    drawButtons.forEach(button => {
      button.setAttribute("aria-pressed", "false")
      button.addEventListener("click", () => startDrawing(button.dataset.drawShape))
    })
    clearButton.addEventListener("click", clearSelection)
    copyEmailsButton.addEventListener("click", copySelectedEmails)
    downloadButton.addEventListener("click", downloadSelection)

    map.on("pm:drawstart", event => {
      setActiveDrawButton(event.shape)
      statusElement.textContent = drawingInstructions(event.shape)
    })

    map.on("pm:drawend", () => {
      setActiveDrawButton(null)
      renderStatus()
    })

    map.on("pm:create", event => {
      if (!["Circle", "Polygon"].includes(event.shape)) {
        map.removeLayer(event.layer)
        return
      }

      if (selectionLayer && map.hasLayer(selectionLayer)) map.removeLayer(selectionLayer)

      selectionLayer = event.layer
      selectionShape = event.shape
      selectionLayer.setStyle({
        color: "#f97316",
        fillColor: "#fb923c",
        fillOpacity: 0.18,
        weight: 3
      })

      applySelection()
      clearButton.disabled = false
    })

    const response = await fetch(rootElement.dataset.membersUrl, {
      credentials: "same-origin",
      headers: { Accept: "application/json" }
    })
    if (!response.ok) throw new Error("Member request failed with status " + response.status)

    const payload = await response.json()
    if (!payload || !Array.isArray(payload.users)) throw new Error("Member response was invalid")

    users = payload.users.map(normalizeUser).filter(Boolean)
    totalCount = Number(payload.total_count) || users.length
    markerByUserId = new Map()

    const markers = users.map(user => {
      const marker = L.marker([user.latitude, user.longitude], {
        icon: regularIcon,
        memberId: user.id,
        pmIgnore: true,
        selected: false,
        title: user.name
      })
      marker.bindPopup(() => popupContent(user))
      markerByUserId.set(user.id, marker)
      return marker
    })

    cluster.options.chunkProgress = (processed, total) => {
      if (processed === total) {
        renderStatus()
      } else {
        statusElement.textContent = "Placing " + processed.toLocaleString() + " of " +
          total.toLocaleString() + " members on the map…"
      }
    }
    cluster.addLayers(markers)

    if (users.length > 0) {
      const bounds = L.latLngBounds(users.map(user => [user.latitude, user.longitude]))
      map.fitBounds(bounds, { maxZoom: 6, padding: [30, 30] })
    }

    drawButtons.forEach(button => { button.disabled = users.length === 0 })
    renderStatus()

    function startDrawing(shape) {
      map.pm.disableDraw()
      map.pm.enableDraw(shape, {
        allowSelfIntersection: false,
        continueDrawing: false,
        pathOptions: {
          color: "#f97316",
          fillColor: "#fb923c",
          fillOpacity: 0.18,
          weight: 3
        },
        snappable: false
      })
    }

    function clearSelection() {
      map.pm.disableDraw()
      if (selectionLayer && map.hasLayer(selectionLayer)) map.removeLayer(selectionLayer)

      selectionLayer = null
      selectionShape = null
      updateSelectedMarkers(new Set())
      clearButton.disabled = true
      setActiveDrawButton(null)
      renderStatus()
    }

    function applySelection() {
      const nextSelectedIds = new Set()
      let polygon

      if (selectionShape === "Polygon") polygon = selectionLayer.toGeoJSON()

      users.forEach(user => {
        let selected = false

        if (selectionShape === "Circle") {
          selected = selectionLayer.getLatLng().distanceTo(
            L.latLng(user.latitude, user.longitude)
          ) <= selectionLayer.getRadius()
        } else if (polygon) {
          selected = booleanPointInPolygon([user.longitude, user.latitude], polygon)
        }

        if (selected) nextSelectedIds.add(user.id)
      })

      updateSelectedMarkers(nextSelectedIds)
      renderStatus()
    }

    function updateSelectedMarkers(nextSelectedIds) {
      selectedIds.forEach(id => {
        if (nextSelectedIds.has(id)) return

        const marker = markerByUserId.get(id)
        if (marker) {
          marker.options.selected = false
          marker.setIcon(regularIcon)
        }
      })

      nextSelectedIds.forEach(id => {
        if (selectedIds.has(id)) return

        const marker = markerByUserId.get(id)
        if (marker) {
          marker.options.selected = true
          marker.setIcon(selectedIcon)
        }
      })

      selectedIds = nextSelectedIds
      copyEmailsButton.disabled = selectedIds.size === 0
      downloadButton.disabled = selectedIds.size === 0
      selectionCountElement.textContent = selectedIds.size > 0
        ? " (" + selectedIds.size.toLocaleString() + ")"
        : ""
      cluster.refreshClusters()
    }

    function downloadSelection() {
      if (selectedIds.size === 0) return

      const selectedUsers = sortedSelectedUsers()
      const csv = Papa.unparse({
        fields: ["Name", "Email", "Telegram"],
        data: selectedUsers.map(user => [user.name, user.email, user.telegram || ""])
      }, {
        escapeFormulae: true,
        header: true,
        newline: "\r\n"
      })

      const blob = new Blob(["\uFEFF", csv], { type: "text/csv;charset=utf-8" })
      const downloadUrl = URL.createObjectURL(blob)
      const link = document.createElement("a")
      link.href = downloadUrl
      link.download = "community-members-" + new Date().toISOString().slice(0, 10) + ".csv"
      link.hidden = true
      document.body.appendChild(link)
      link.click()
      window.setTimeout(() => {
        link.remove()
        URL.revokeObjectURL(downloadUrl)
      }, 1_000)

      statusElement.textContent = "Downloaded " + selectedIds.size.toLocaleString() +
        " selected members."
    }

    async function copySelectedEmails() {
      if (selectedIds.size === 0) return

      const emails = sortedSelectedUsers()
        .map(user => user.email)
        .filter(Boolean)

      try {
        await writeClipboard(emails.join(", "))
        statusElement.textContent = "Copied " + emails.length.toLocaleString() +
          " email addresses."
      } catch (error) {
        statusElement.textContent = "Email addresses could not be copied. Please try again."
        console.error("Copying selected email addresses failed:", error)
      }
    }

    function sortedSelectedUsers() {
      const collator = new Intl.Collator(undefined, { sensitivity: "base" })

      return users
        .filter(user => selectedIds.has(user.id))
        .sort((left, right) => collator.compare(left.name, right.name))
    }

    function renderStatus() {
      if (selectionLayer) {
        statusElement.textContent = selectedIds.size.toLocaleString() + " of " +
          users.length.toLocaleString() + " mapped members selected."
        return
      }

      const unmappedCount = Math.max(totalCount - users.length, 0)
      if (users.length === 0) {
        statusElement.textContent = "No community members with a mapped location were found."
      } else if (unmappedCount > 0) {
        statusElement.textContent = users.length.toLocaleString() +
          " members loaded; " + unmappedCount.toLocaleString() +
          " without coordinates cannot be shown."
      } else {
        statusElement.textContent = users.length.toLocaleString() + " members loaded."
      }
    }

    function setActiveDrawButton(shape) {
      drawButtons.forEach(button => {
        button.setAttribute("aria-pressed", String(button.dataset.drawShape === shape))
      })
    }
  } catch (error) {
    errorElement.textContent = "Community members could not be loaded. Please reload the page and try again."
    errorElement.classList.remove("hidden")
    statusElement.textContent = "Map unavailable."
    console.error("Admin community map failed:", error)
    if (map) map.remove()
  }
}

async function writeClipboard(text) {
  if (navigator.clipboard?.writeText) {
    await navigator.clipboard.writeText(text)
    return
  }

  const textarea = document.createElement("textarea")
  textarea.value = text
  textarea.setAttribute("readonly", "")
  textarea.style.position = "fixed"
  textarea.style.opacity = "0"
  document.body.appendChild(textarea)
  textarea.select()

  try {
    if (!document.execCommand("copy")) throw new Error("Clipboard command was rejected")
  } finally {
    textarea.remove()
  }
}

function normalizeUser(user) {
  const latitude = Number(user.latitude)
  const longitude = Number(user.longitude)
  if (!Number.isFinite(latitude) || latitude < -90 || latitude > 90) return null
  if (!Number.isFinite(longitude) || longitude < -180 || longitude > 180) return null

  return {
    id: user.id,
    name: String(user.name || ""),
    email: String(user.email || ""),
    telegram: String(user.telegram || ""),
    latitude,
    longitude,
    location: String(user.location || "")
  }
}

function popupContent(user) {
  const container = document.createElement("div")
  const name = document.createElement("strong")
  name.textContent = user.name
  container.appendChild(name)

  appendPopupLine(container, user.location)
  appendPopupLine(container, user.email)
  if (user.telegram) appendPopupLine(container, formatTelegram(user.telegram))

  return container
}

function appendPopupLine(container, text) {
  if (!text) return

  const line = document.createElement("div")
  line.textContent = text
  container.appendChild(line)
}

function formatTelegram(telegram) {
  return telegram.startsWith("@") ? telegram : "@" + telegram
}

function clusterIcon(L, clusterLayer) {
  const count = clusterLayer.getChildCount()
  const hasSelectedMember = clusterLayer
    .getAllChildMarkers()
    .some(marker => marker.options.selected)
  let size = "large"
  if (count < 10) size = "small"
  else if (count < 100) size = "medium"

  return L.divIcon({
    className: "marker-cluster marker-cluster-" + size +
      (hasSelectedMember ? " marker-cluster-selected" : ""),
    html: "<div><span>" + count + "</span></div>",
    iconSize: L.point(40, 40)
  })
}

function drawingInstructions(shape) {
  if (shape === "Circle") return "Click the circle center, then click its outer edge."

  return "Click to add polygon corners; click the first corner or press Enter to finish."
}
