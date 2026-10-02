import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "openIcon", "closeIcon"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen = !this.isOpen
    if (this.isOpen) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.isOpen = true
    if (this.hasMenuTarget) this.menuTarget.classList.remove("hidden")
    if (this.hasOpenIconTarget) this.openIconTarget.classList.add("hidden")
    if (this.hasCloseIconTarget) this.closeIconTarget.classList.remove("hidden")
  }

  close() {
    this.isOpen = false
    if (this.hasMenuTarget) this.menuTarget.classList.add("hidden")
    if (this.hasOpenIconTarget) this.openIconTarget.classList.remove("hidden")
    if (this.hasCloseIconTarget) this.closeIconTarget.classList.add("hidden")
  }
}
