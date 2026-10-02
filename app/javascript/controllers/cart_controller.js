import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["drawer", "backdrop", "count"]

  connect() {
    this.boundCloseOnEscape = this.closeOnEscape.bind(this)
    document.addEventListener("keydown", this.boundCloseOnEscape)
    this.boundCartOpen = this.open.bind(this)
    document.addEventListener("cart:open", this.boundCartOpen)
    this.boundCartClose = this.close.bind(this)
    document.addEventListener("cart:close", this.boundCartClose)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundCloseOnEscape)
    document.removeEventListener("cart:open", this.boundCartOpen)
    document.removeEventListener("cart:close", this.boundCartClose)
  }

  open() {
    if (this.hasBackdropTarget) {
      this.backdropTarget.classList.remove("hidden")
      requestAnimationFrame(() => {
        this.backdropTarget.classList.remove("opacity-0")
        this.backdropTarget.classList.add("opacity-100")
      })
    }
    if (this.hasDrawerTarget) {
      this.drawerTarget.classList.remove("translate-x-full")
      this.drawerTarget.classList.add("translate-x-0")
    }
    document.body.classList.add("overflow-hidden")
  }

  close() {
    if (this.hasDrawerTarget) {
      this.drawerTarget.classList.remove("translate-x-0")
      this.drawerTarget.classList.add("translate-x-full")
    }
    if (this.hasBackdropTarget) {
      this.backdropTarget.classList.remove("opacity-100")
      this.backdropTarget.classList.add("opacity-0")
      setTimeout(() => {
        if (!this.drawerTarget.classList.contains("translate-x-0")) {
          this.backdropTarget.classList.add("hidden")
        }
      }, 300)
    }
    document.body.classList.remove("overflow-hidden")
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}
