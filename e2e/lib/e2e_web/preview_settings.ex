defmodule E2eWeb.PreviewSettings do
  @moduledoc false

  def script do
    """
    (() => {
      if ("scrollRestoration" in history) history.scrollRestoration = "manual";

      const scrollTop = () => {
        if (!window.location.hash) window.scrollTo(0, 0);
      };

      scrollTop();
      document.addEventListener("DOMContentLoaded", scrollTop, { once: true });
      window.addEventListener("pageshow", (event) => {
        if (event.persisted) scrollTop();
      });

      const getSystemMode = () =>
        window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";

      const modeToggleIds = ["mode-switcher", "mode-switcher-menu", "toggle-anatomy-mode"];

      const syncModeToggles = (mode) => {
        const pressed = mode === "dark";
        for (const id of modeToggleIds) {
          const el = document.getElementById(id);
          if (!el) continue;
          el.dispatchEvent(
            new CustomEvent("corex:toggle:set-pressed", { bubbles: true, detail: { pressed } })
          );
        }
      };

      const setMode = (mode) => {
        const resolved = mode === "dark" || mode === "light" ? mode : getSystemMode();
        localStorage.setItem("phx:mode", resolved);
        document.cookie = "phx_mode=" + resolved + "; path=/; max-age=31536000";
        document.documentElement.setAttribute("data-mode", resolved);
        syncModeToggles(resolved);
      };

      setMode(localStorage.getItem("phx:mode") || document.documentElement.getAttribute("data-mode") || getSystemMode());

      window.addEventListener("storage", (e) => e.key === "phx:mode" && e.newValue && setMode(e.newValue));

      const handleSetMode = (e) => {
        const detail = e.detail || {};
        if (typeof detail.pressed === "boolean") {
          setMode(detail.pressed ? "dark" : "light");
          return;
        }
        const value = detail.value;
        const mode = Array.isArray(value) && value[0] ? value[0] : "light";
        setMode(mode);
      };

      document.addEventListener("corex:preview:set-mode", handleSetMode, true);
      document.addEventListener("phx:set-mode", handleSetMode, true);

      const validThemes = ["neo", "uno", "duo", "leo"];
      const setTheme = (theme) => {
        const resolved = validThemes.includes(theme) ? theme : "neo";
        localStorage.setItem("phx:theme", resolved);
        document.cookie = "phx_theme=" + resolved + "; path=/; max-age=31536000";
        document.documentElement.setAttribute("data-theme", resolved);
      };

      setTheme(localStorage.getItem("phx:theme") || document.documentElement.getAttribute("data-theme") || "neo");

      window.addEventListener("storage", (e) => e.key === "phx:theme" && e.newValue && setTheme(e.newValue));

      const handleSetTheme = (e) => {
        const value = e.detail?.value;
        const theme = Array.isArray(value) && value[0] ? value[0] : "neo";
        setTheme(theme);
      };

      document.addEventListener("corex:preview:set-theme", handleSetTheme, true);
      document.addEventListener("phx:set-theme", handleSetTheme, true);

      const setAuthoring = (authoring) => {
        const resolved =
          authoring === "class" ? "class" : authoring === "markup" ? "markup" : "attr";
        localStorage.setItem("phx:authoring", resolved);
        document.cookie = "phx_authoring=" + resolved + "; path=/; max-age=31536000";
        document.documentElement.setAttribute("data-authoring", resolved);
      };

      setAuthoring(
        localStorage.getItem("phx:authoring") ||
          document.documentElement.getAttribute("data-authoring") ||
          "attr"
      );

      window.addEventListener("storage", (e) => {
        if (e.key === "phx:authoring" && e.newValue) setAuthoring(e.newValue);
      });

      document.addEventListener(
        "corex:preview:set-authoring",
        (e) => {
          const value = e.detail?.value;
          const authoring = Array.isArray(value) && value[0] ? value[0] : "attr";
          setAuthoring(authoring);
        },
        true
      );
    })();
    """
  end

  def full_script, do: script()
end
