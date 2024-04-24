import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="checkbox"
export default class extends Controller {
  static targets = ["checkbox"];

  toggle() {
    this.checkboxTarget.value = this.checkboxTarget.checked ? 1 : 0;
  }
}
