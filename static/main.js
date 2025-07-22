class ModeConfigurator {
  modes = ["default", "dark", "light"];
  cache = {};

  constructor() {
    this.modeElement = document.getElementById("mode");
    this.toggleElement = document.querySelector("#toggle");
    this.iconElement = this.toggleElement.querySelector(".icon");

    this.lightSyntax = document.querySelector("#light-syntax");
    this.darkSyntax = document.querySelector("#dark-syntax");

    this.toggleElement.addEventListener("click", () => this.toggleMode());

    this.sync();
  }

  getMode() {
    const stored = localStorage.getItem("mode");
    return stored ?? "default";
  }

  setMode(mode) {
    localStorage.setItem("mode", mode);
    this.sync();
    return mode;
  }

  async toggleMode() {
    const modeIndex = this.modes.indexOf(this.getMode());
    const mode = this.modes[(modeIndex + 1) % this.modes.length];
    await this.setMode(mode);
  }

  sync() {
    const current = this.getMode();
    const preferred = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
    const mode = current != "default" ? current : preferred;

    document.documentElement.classList.remove(mode == "dark" ? "light" : "dark", mode);
    document.documentElement.classList.add(mode);

    this.darkSyntax.media = mode === "light" ? "not all" : "all";
    this.lightSyntax.media = mode === "light" ? "all" : "not all";

    const source = this.modeElement.dataset[current];

    if (!this.cache[source]) {
      fetch(source)
        .then((response) => {
          if (!response.ok) {
            return Promise.reject();
          }
          return response.text();
        })
        .then((text) => {
          this.cache[source] = text;
          this.toggleElement.innerHTML = this.cache[source];
        })
        .catch(() => {});
    } else {
      this.toggleElement.innerHTML = this.cache[source];
    }
  }
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => new ModeConfigurator());
} else {
  new ModeConfigurator();
}
