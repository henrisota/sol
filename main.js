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
      let code = "";

      if (block.dataset.linenos == undefined) {
        code = block.textContent;
      } else {
        const table = block.querySelector("table");

        const rows = Array.from(table.rows).map((row) => {
          const cells = Array.from(row.cells).slice(1);
          return cells.map((cell) => cell.textContent).join("");
        });
        code = rows.join("");
      }

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
