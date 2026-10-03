import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "countySelect", "courierRadio", "shippingDisplay", "shippingDisplayEtb",
    "totalDisplay", "totalDisplayEtb", "submitBtnText", "phoneInput",
    "phoneStatus", "processingModal", "modalPhone", "modalAmount"
  ]
  static values = {
    subtotalKes: Number,
    subtotalEtb: Number,
    rateKesToEtb: { type: Number, default: 0.88 }
  }

  // Authoritative Kenyan county baseline logistics rates (matches Logistics::EastAfricanCourierService)
  countyRates = {
    "Nairobi": 350,
    "Kiambu": 450,
    "Machakos": 480,
    "Kajiado": 500,
    "Mombasa": 650,
    "Nakuru": 520,
    "Kisumu": 600,
    "Eldoret": 580,
    "Uasin Gishu": 580,
    "Kilifi": 700,
    "Nyeri": 500,
    "Meru": 550
  }

  courierSurcharges = {
    "Fargo Courier East Africa": 0,
    "Sendy Express Kenya": 150,
    "DHL East Africa": 450
  }

  connect() {
    this.updateCalculations()
    this.validatePhone()
  }

  updateCalculations() {
    const county = this.hasCountySelectTarget ? this.countySelectTarget.value : "Nairobi"
    const courier = this.selectedCourier()

    const baseRate = this.countyRates[county] || 400
    const courierExtra = this.courierSurcharges[courier] || 0
    const shippingKes = baseRate + courierExtra
    const shippingEtb = Math.round(shippingKes * this.rateKesToEtbValue * 100) / 100

    const totalKes = this.subtotalKesValue + shippingKes
    const totalEtb = Math.round((this.subtotalEtbValue + shippingEtb) * 100) / 100

    // Update Shipping Display
    if (this.hasShippingDisplayTarget) {
      this.shippingDisplayTarget.textContent = this.formatCurrency(shippingKes, "KES")
    }

    // Update Total Display
    if (this.hasTotalDisplayTarget) {
      this.totalDisplayTarget.textContent = this.formatCurrency(totalKes, "KES")
    }

    if (this.hasTotalDisplayEtbTarget) {
      this.totalDisplayEtbTarget.textContent = this.formatCurrency(totalEtb, "ETB")
    }

    // Update Submit Button Text
    if (this.hasSubmitBtnTextTarget) {
      this.submitBtnTextTarget.textContent = `Complete Order • ${this.formatCurrency(totalKes, "KES")}`
    }

    if (this.hasModalAmountTarget) {
      this.modalAmountTarget.textContent = this.formatCurrency(totalKes, "KES")
    }
  }

  selectedCourier() {
    if (!this.hasCourierRadioTargets) return "Fargo Courier East Africa"
    const checked = this.courierRadioTargets.find(r => r.checked)
    return checked ? checked.value : "Fargo Courier East Africa"
  }

  formatPhone() {
    this.validatePhone()
  }

  validatePhone() {
    if (!this.hasPhoneInputTarget || !this.hasPhoneStatusTarget) return

    let phone = this.phoneInputTarget.value.trim().replace(/\D/g, "")

    if (phone.length === 0) {
      this.phoneStatusTarget.innerHTML = `<span class="text-neutral-400">e.g. 0707 172 370</span>`
      return
    }

    let isValid = false
    let normalized = ""

    if (phone.startsWith("254") && phone.length === 12) {
      isValid = true
      normalized = phone
    } else if (phone.startsWith("0") && phone.length === 10) {
      isValid = true
      normalized = "254" + phone.slice(1)
    } else if (phone.length === 9 && (phone.startsWith("7") || phone.startsWith("1"))) {
      isValid = true
      normalized = "254" + phone
    }

    if (isValid) {
      this.phoneStatusTarget.innerHTML = `
        <span class="text-emerald-600 font-semibold text-xs">
          +${normalized}
        </span>
      `
      if (this.hasModalPhoneTarget) {
        this.modalPhoneTarget.textContent = `+${normalized}`
      }
    } else {
      this.phoneStatusTarget.innerHTML = `
        <span class="text-amber-600 font-medium text-xs">Enter valid 10-digit number</span>
      `
    }
  }

  handleSubmit(event) {
    if (this.hasPhoneInputTarget) {
      const phone = this.phoneInputTarget.value.trim().replace(/\D/g, "")
      if (phone.length < 9) {
        alert("Please provide a valid phone number.")
        event.preventDefault()
        return
      }
    }

    // Show processing modal
    if (this.hasProcessingModalTarget) {
      this.processingModalTarget.classList.remove("hidden")
      document.body.classList.add("overflow-hidden")
    }
  }

  formatCurrency(amount, currency) {
    const formatted = Math.round(amount).toLocaleString("en-KE")
    return currency === "ETB" ? `ETB ${formatted}` : `KSh ${formatted}`
  }
}
