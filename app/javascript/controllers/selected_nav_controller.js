import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"];

  static values = { controller: String }

  updateClasses(target) {
    target.classList.add("bg-gray-900", "text-white")
    target.classList.remove("text-gray-300", "hover:bg-gray-700", "hover:text-white")
  }

  connect() {
    if (this.controllerValue == "community" && this.itemTarget.dataset.itemId == "community") {
      this.updateClasses(this.itemTarget)
    } else if (this.controllerValue == "locations" && this.itemTarget.dataset.itemId == "location") {
      this.updateClasses(this.itemTarget)
    } else if (this.controllerValue == "registrations" && this.itemTarget.dataset.itemId == "profile") {
      this.updateClasses(this.itemTarget)
    }
  }
}
