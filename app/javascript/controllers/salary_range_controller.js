import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "display"]

  update() {
    const value = this.element.value
    if (this.hasDisplayTarget) {
      this.displayTarget.textContent = new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD",
        maximumFractionDigits: 0
      }).format(value)
    }
  }
}
