// hooks/code.ts
var CodeHook = {
  mounted() {
    if (this.el.tagName === "PRE") {
      this._scrollTop = this.el.scrollTop;
      this._scrollLeft = this.el.scrollLeft;
    }
  },
  beforeUpdate() {
    if (this.el.tagName === "PRE") {
      this._scrollTop = this.el.scrollTop;
      this._scrollLeft = this.el.scrollLeft;
    }
  },
  updated() {
    if (this.el.tagName !== "PRE") return;
    const st = this._scrollTop ?? 0;
    const sl = this._scrollLeft ?? 0;
    requestAnimationFrame(() => {
      this.el.scrollTop = st;
      this.el.scrollLeft = sl;
    });
  }
};
export {
  CodeHook as Code
};
