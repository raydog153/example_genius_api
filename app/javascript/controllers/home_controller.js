import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  static targets = ["artist", "submit"]
  initialize() {
    console.log("home controller initialize called");
    super.initialize();
  }

  connect() {
    console.log("home  controller connected to element");
    this.submitTarget.setAttribute("data-action", "click->home#fetch_artist_songs");
  }

  fetch_artist_songs(e) {
    console.log("Artists selected: " + this.artistTarget.value)
    e.preventDefault();
    this.url = this.element.getAttribute("data-href");
    this.url += "?artist=" + this.artistTarget.value
    fetch(this.url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    }).then(r => r.text())
        .then(html => Turbo.renderStreamMessage(html));
  }
}
