class ModeConfigurator {
  modes = ["default", "dark", "light"];
  cache = {};

  constructor() {
    this.modeElement = document.getElementById("mode");
    this.toggleElement = document.querySelector("#toggle");
    this.iconElement = this.toggleElement.querySelector(".icon");

    this.toggleElement.addEventListener("click", () => this.toggleMode());

    this.setMode(this.getMode());
  }

  getMode() {
    const stored = localStorage.getItem("mode");
    return stored ?? "default";
  }

  async setMode(mode) {
    localStorage.setItem("mode", mode);
    await this.sync();
    return mode;
  }

  async toggleMode() {
    const modeIndex = this.modes.indexOf(this.getMode());
    const mode = this.modes[(modeIndex + 1) % this.modes.length];
    await this.setMode(mode);
  }

  async sync() {
    const current = this.getMode();
    const source = this.modeElement.dataset[current];

    if (!this.cache[source]) {
      const response = await fetch(source);
      if (!response.ok) {
        return;
      }
      this.cache[source] = await response.text();
    }

    this.toggleElement.innerHTML = this.cache[source];

    const preferred = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
    const mode = current != "default" ? current : preferred;

    document.documentElement.classList.remove(mode == "dark" ? "light" : "dark", mode);
    document.documentElement.classList.add(mode);
  }
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => new ModeConfigurator());
} else {
  new ModeConfigurator();
}
