import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";

type CodeHookState = {
  _scrollTop?: number;
  _scrollLeft?: number;
};

const CodeHook: Hook<object & HookInterface<HTMLElement> & CodeHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & CodeHookState) {
    if (this.el.tagName === "PRE") {
      this._scrollTop = this.el.scrollTop;
      this._scrollLeft = this.el.scrollLeft;
    }
  },

  beforeUpdate(this: object & HookInterface<HTMLElement> & CodeHookState) {
    if (this.el.tagName === "PRE") {
      this._scrollTop = this.el.scrollTop;
      this._scrollLeft = this.el.scrollLeft;
    }
  },

  updated(this: object & HookInterface<HTMLElement> & CodeHookState) {
    if (this.el.tagName !== "PRE") return;
    const st = this._scrollTop ?? 0;
    const sl = this._scrollLeft ?? 0;
    requestAnimationFrame(() => {
      this.el.scrollTop = st;
      this.el.scrollLeft = sl;
    });
  },
};

export { CodeHook as Code };
