import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  switchCurrency(event) {
    const currency = event.currentTarget.dataset.currency
    const form = document.createElement("form")
    form.method = "POST"
    form.action = "/currencies/switch"

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")

    const csrfInput = document.createElement("input")
    csrfInput.type = "hidden"
    csrfInput.name = "authenticity_token"
    csrfInput.value = csrfToken || ""
    form.appendChild(csrfInput)

    const currencyInput = document.createElement("input")
    currencyInput.type = "hidden"
    currencyInput.name = "currency"
    currencyInput.value = currency
    form.appendChild(currencyInput)

    document.body.appendChild(form)
    form.submit()
  }
}
