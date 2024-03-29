import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-password-toggle"
export default class extends Controller {
  static targets = ["password", "showButton", "hideButton"];

  toggle() {
    this.passwordTarget.type = this.passwordTarget.type === "password" ? "text" : "password"
    this.showButtonTarget.classList.toggle("hidden")
    this.hideButtonTarget.classList.toggle("hidden")
  }
}
