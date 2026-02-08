import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { SignaturePad } from "../components/signature-pad";
import type { Props, DataUrlType } from "@zag-js/signature-pad";

import { getString, getBoolean, getNumber } from "../lib/util";

type SignaturePadHookState = {
  signaturePad?: SignaturePad;
  handlers?: Array<CallbackRef>;
  onClear?: (event: Event) => void;
};

const SignaturePadHook: Hook<object & SignaturePadHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & SignaturePadHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const signaturePad = new SignaturePad(el, {
      id: el.id,
      drawing: {
        fill: getString(el, "drawingFill"),
        size: getNumber(el, "drawingSize"),
        simulatePressure: getBoolean(el, "drawingSimulatePressure"),
      },
      onDrawEnd: (details) => {
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
    });
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
    this.signaturePad?.updateProps({
      id: this.el.id,
      drawing: {
        fill: getString(this.el, "drawingFill") || "black",
        size: getNumber(this.el, "drawingSize") || 2,
        simulatePressure: getBoolean(this.el, "drawingSimulatePressure"),
      },
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
