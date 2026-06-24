import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    center: Object,
    markers: Array,
    icons: Object,
    range: Number
  }

  async connect() {
    // Load leaflet only when a map actually connects, so the library isn't
    // fetched on every page (the controller is eager-registered in index.js).
    const L = (await import("leaflet")).default

    // leaflet.markercluster ships no ESM build — it augments a global `L`.
    // Expose it, then load the plugin so it can attach L.markerClusterGroup.
    window.L = L
    await import("leaflet.markercluster")

    const { lat, lng } = this.centerValue
    this.map = L.map(this.element).setView([lat, lng], 8)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a> contributors'
    }).addTo(this.map)

    const youIcon = L.circleMarker([lat, lng], { radius: 8, color: "#4f46e5", fillColor: "#4f46e5", fillOpacity: 0.9 })
    youIcon.addTo(this.map).bindPopup("You")

    // Leaflet's default-icon path guessing breaks under digested asset URLs,
    // so build the icon explicitly from Rails-provided (digested) image paths.
    const { icon, icon2x, shadow } = this.iconsValue
    const userIcon = L.icon({
      iconUrl: icon,
      iconRetinaUrl: icon2x,
      shadowUrl: shadow,
      iconSize: [25, 41],
      iconAnchor: [12, 41],
      popupAnchor: [1, -34],
      shadowSize: [41, 41]
    })

    const cluster = L.markerClusterGroup()
    this.markersValue.forEach(({ lat: mLat, lng: mLng, name, city }) => {
      cluster.addLayer(L.marker([mLat, mLng], { icon: userIcon }).bindPopup(this.popupContent(name, city)))
    })
    this.map.addLayer(cluster)
  }

  // Build popup as DOM nodes so user-controlled name/city can't inject HTML (XSS).
  popupContent(name, city) {
    const el = document.createElement("div")
    const strong = document.createElement("strong")
    strong.textContent = name
    el.appendChild(strong)
    el.appendChild(document.createElement("br"))
    el.appendChild(document.createTextNode(city))
    return el
  }

  invalidateSize() {
    if (this.map) this.map.invalidateSize()
  }

  disconnect() {
    if (this.map) {
      this.map.remove()
      this.map = null
    }
  }
}
