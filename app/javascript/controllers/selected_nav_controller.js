import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"];

  static values = { controller: String }

  updateClasses(target) {
    target.classList.add("border-indigo-500", "text-gray-900")
    target.classList.remove("border-transparent", "text-gray-500", "hover:border-gray-300", "hover:text-gray-700")
  }

  connect() {
    if (this.controllerValue == "community" && this.itemTarget.dataset.itemId == "community") {
      this.updateClasses(this.itemTarget)
    } else if (this.controllerValue == "locations" && this.itemTarget.dataset.itemId == "location") {
      this.updateClasses(this.itemTarget)
    } else if (this.controllerValue == "registrations" && this.itemTarget.dataset.itemId == "profile") {
      this.updateClasses(this.itemTarget)
    } else if (this.controllerValue == "options" && this.itemTarget.dataset.itemId == "options") {
      this.updateClasses(this.itemTarget)
    }
  }
}
