import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select"
export default class extends Controller {
  static targets = [ "option" ]

  static values = { range: Number }

  connect() {
    this.optionTarget.selected = this.optionTarget.text == this.rangeValue 
  }
}
