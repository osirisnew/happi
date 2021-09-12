import ApplicationController from "./application_controller";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends ApplicationController {
  change(event) {
    const url = event.target.value;
    Turbo.visit(url);
  }
}
