class Configurator {
  configuration = undefined;

  constructor() {
    this.configuration = this.loadConfiguration();

    this.configureCode();
  }

  loadConfiguration() {
    const configuration = document.querySelector("#code-configuration");
    if (!configuration) {
      return null;
    }

    return {
      copyIcon: configuration.dataset.copyIcon,
      checkIcon: configuration.dataset.checkIcon,
    };
  }

  configureCode() {
    if (!this.configuration) {
      return;
    }

    this.initializeCopyButtons();
  }

  initializeCopyButtons() {
    document.querySelectorAll("pre").forEach((block) => {
      block.appendChild(this.createCopyButton(block));
    });
  }

  createCopyButton(block) {
    const button = document.createElement("button");

    button.className = "copy";
    button.innerHTML = this.configuration.copyIcon;

    const handleCopy = () => {
      const content = block.querySelector("code").cloneNode(true);
      content.querySelectorAll(".giallo-ln").forEach((number) => number.remove());
      const code = content.textContent;

      navigator.clipboard.writeText(code).then(() => {
        button.innerHTML = this.configuration.checkIcon;
        button.classList.add("copied");

        setTimeout(() => {
          button.innerHTML = this.configuration.copyIcon;
          button.classList.remove("copied");
        }, 1000);
      });
    };

    button.addEventListener("click", handleCopy);

    return button;
  }
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => new Configurator());
} else {
  new Configurator();
}
