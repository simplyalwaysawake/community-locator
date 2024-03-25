import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ["dropdown", "closedButton", "openButton"];

  toggleMenu() {
    this.dropdownTarget.classList.toggle("hidden")
  }

  toggleButton() {
    this.closedButtonTarget.classList.toggle("hidden")
    this.closedButtonTarget.classList.toggle("block")

    this.openButtonTarget.classList.toggle("hidden")
    this.openButtonTarget.classList.toggle("block")
  }
}
