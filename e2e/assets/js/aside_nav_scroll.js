const selectedSelector =
  '[data-scope="tree-view"][data-part="item"][data-selected], [data-scope="tree-view"][data-part="branch-control"][data-selected]'

export default {
  mounted() {
    this.boundStop = () => this.flushScroll()
    window.addEventListener("phx:page-loading-stop", this.boundStop)
    this.flushScroll()
  },
  updated() {
    this.flushScroll()
  },
  destroyed() {
    window.removeEventListener("phx:page-loading-stop", this.boundStop)
    this.teardownObserve()
  },
  flushScroll() {
    if (this.scrollToSelection()) {
      this.teardownObserve()
      return
    }
    this.teardownObserve()
    this.observer = new MutationObserver(() => {
      if (this.scrollToSelection()) {
        this.teardownObserve()
      }
    })
    this.observer.observe(this.el, {
      subtree: true,
      attributes: true,
      attributeFilter: ["data-selected", "data-loading"],
    })
    clearTimeout(this.retryTimer)
    this.retryTimer = setTimeout(() => this.teardownObserve(), 2500)
  },
  teardownObserve() {
    if (this.observer) {
      this.observer.disconnect()
      this.observer = null
    }
    clearTimeout(this.retryTimer)
    this.retryTimer = null
  },
  scrollToSelection() {
    const node = this.el.querySelector(selectedSelector)
    if (!node) return false
    node.scrollIntoView({ block: "nearest", inline: "nearest", behavior: "auto" })
    return true
  },
}
