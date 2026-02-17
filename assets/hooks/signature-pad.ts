import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { SignaturePad } from "../components/signature-pad";
import type { Props } from "@zag-js/signature-pad";

import { getString, getBoolean, getNumber } from "../lib/util";

function getPaths(el: HTMLElement, attr: string): unknown[] {
  const value = el.dataset[attr];
  if (!value) return [];
  try {
    return JSON.parse(value);
  } catch {
    return [];
  }
}

function buildDrawingOptions(el: HTMLElement): Props["drawing"] {
  return {
    fill: getString(el, "drawingFill") || "black",
    size: getNumber(el, "drawingSize") ?? 2,
    simulatePressure: getBoolean(el, "drawingSimulatePressure"),
    smoothing: getNumber(el, "drawingSmoothing") ?? 0.5,
    thinning: getNumber(el, "drawingThinning") ?? 0.7,
    streamline: getNumber(el, "drawingStreamline") ?? 0.65,
  };
}

type SignaturePadHookState = {
  signaturePad?: SignaturePad;
  handlers?: Array<CallbackRef>;
  onClear?: (event: Event) => void;
};

const SignaturePadHook: Hook<object & SignaturePadHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & SignaturePadHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const controlled = getBoolean(el, "controlled");
    const paths = getPaths(el, "paths");
    const defaultPaths = getPaths(el, "defaultPaths");

    const signaturePad = new SignaturePad(el, {
      id: el.id,
      name: getString(el, "name"),
      ...(controlled && paths.length > 0 ? { paths: paths } : undefined),
      ...(!controlled && defaultPaths.length > 0 ? { defaultPaths: defaultPaths } : undefined),
      drawing: buildDrawingOptions(el),
      onDrawEnd: (details) => {
        signaturePad.setPaths(details.paths);

        const hiddenInput = el.querySelector<HTMLInputElement>(
          '[data-scope="signature-pad"][data-part="hidden-input"]'
        );
        if (hiddenInput) {
          hiddenInput.value = details.paths.length > 0 ? JSON.stringify(details.paths) : "";
          hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
          hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
        }

        details.getDataUrl("image/png").then((url) => {
          signaturePad.imageURL = url;

          const eventName = getString(el, "onDrawEnd");
          if (eventName && this.liveSocket.main.isConnected()) {
            pushEvent(eventName, {
              id: el.id,
              paths: details.paths,
              url: url,
            });
          }

          const eventNameClient = getString(el, "onDrawEndClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: true,
                detail: {
                  id: el.id,
                  paths: details.paths,
                  url: url,
                },
              })
            );
          }
        });
      },
    } as Props);
    signaturePad.init();
    this.signaturePad = signaturePad;

    this.onClear = (event: Event) => {
      const { id: targetId } = (event as CustomEvent<{ id: string }>).detail;
      if (targetId && targetId !== el.id) return;
      signaturePad.api.clear();
    };
    el.addEventListener("phx:signature-pad:clear", this.onClear);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("signature_pad_clear", (payload: { signature_pad_id?: string }) => {
        const targetId = payload.signature_pad_id;
        if (targetId && targetId !== el.id) return;
        signaturePad.api.clear();
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & SignaturePadHookState) {
    const controlled = getBoolean(this.el, "controlled");
    const paths = getPaths(this.el, "paths");
    const defaultPaths = getPaths(this.el, "defaultPaths");
    const name = getString(this.el, "name");

    if (name) {
      this.signaturePad?.setName(name);
    }

    this.signaturePad?.updateProps({
      id: this.el.id,
      name: name,
      ...(controlled && paths.length > 0 ? { paths: paths } : {}),
      ...(!controlled && defaultPaths.length > 0 ? { defaultPaths: defaultPaths } : {}),
      drawing: buildDrawingOptions(this.el),
    } as Props);
  },

  destroyed(this: object & HookInterface<HTMLElement> & SignaturePadHookState) {
    if (this.onClear) {
      this.el.removeEventListener("phx:signature-pad:clear", this.onClear);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.signaturePad?.destroy();
  },
};

export { SignaturePadHook as SignaturePad };
