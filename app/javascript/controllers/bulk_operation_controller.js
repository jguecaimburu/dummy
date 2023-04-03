import { Controller } from "@hotwired/stimulus"
import { post } from '@rails/request.js'

export default class extends Controller {
  static targets = ["button", "checkbox"];
  static values = { selectedIds: Array };

  toggle(event) {
    const checkbox = event.currentTarget;
    if (checkbox.checked) {
      this.buttonTargets.forEach(button => button.removeAttribute("disabled"))
    } else if (this.checkboxTargets.every(checkbox => !(checkbox.checked))) {
      this.buttonTargets.forEach(button => button.setAttribute("disabled", true))
    }
  }

  execute(event) {
    event.preventDefault;

    const url = event.currentTarget.dataset.operationUrl;
    const selectedIds = this.checkboxTargets.filter(c => c.checked).map(c => c.value);

    post(url, { body: { selected_ids: selectedIds }, contentType: "application/json", responseKind: "turbo-stream" })
  }
}
