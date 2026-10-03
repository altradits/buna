import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "phoneInput", "displayPhone", "amountDisplay", "spinner", "successState", "errorState", "errorMessage", "submitButton"]
  static values = { orderId: Number, checkUrl: String }

  connect() {
    this.pollInterval = null
  }

  disconnect() {
    this.stopPolling()
  }

  openModal(event) {
    const phone = this.phoneInputTarget.value.trim()
    if (!phone) {
      alert("Please enter a valid phone number (e.g. 0707172370 or 254707172370)")
      event.preventDefault()
      return
    }

    if (this.hasDisplayPhoneTarget) {
      this.displayPhoneTarget.textContent = phone
    }

    this.modalTarget.classList.remove("hidden")
    this.spinnerTarget.classList.remove("hidden")
    this.successStateTarget.classList.add("hidden")
    this.errorStateTarget.classList.add("hidden")
  }

  closeModal() {
    this.stopPolling()
    this.modalTarget.classList.add("hidden")
  }

  startPolling(checkUrl) {
    this.stopPolling()
    let attempts = 0
    const maxAttempts = 30 // 60 seconds total

    this.pollInterval = setInterval(async () => {
      attempts++
      try {
        const response = await fetch(checkUrl, {
          headers: { "Accept": "application/json" }
        })
        const data = await response.json()

        if (data.status === "paid") {
          this.stopPolling()
          this.spinnerTarget.classList.add("hidden")
          this.successStateTarget.classList.remove("hidden")
          setTimeout(() => {
            window.location.href = data.redirect_url || `/orders/${this.orderIdValue}`
          }, 1500)
        } else if (data.status === "failed" || data.status === "cancelled") {
          this.stopPolling()
          this.spinnerTarget.classList.add("hidden")
          this.errorMessageTarget.textContent = data.message || "Payment cancelled or timed out. Please try again."
          this.errorStateTarget.classList.remove("hidden")
        }
      } catch (err) {
        console.error("Polling error:", err)
      }

      if (attempts >= maxAttempts) {
        this.stopPolling()
        this.spinnerTarget.classList.add("hidden")
        this.errorMessageTarget.textContent = "Request timed out. If you received a confirmation SMS, your order will update shortly."
        this.errorStateTarget.classList.remove("hidden")
      }
    }, 2000)
  }

  stopPolling() {
    if (this.pollInterval) {
      clearInterval(this.pollInterval)
      this.pollInterval = null
    }
  }
}
