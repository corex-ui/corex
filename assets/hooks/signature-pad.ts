import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { SignaturePad } from "../components/signature-pad";
import type { Props } from "@zag-js/signature-pad";

import { getBoolean, getNumber, getString } from "../lib/util";
import { idMatches, readPayloadId } from "../lib/respond-to";
import {
  queueLiveViewFormInputSync,
  reapplyLiveViewValueInputUsage,
} from "../lib/live-view-form-input";

export function parsePathsFromDataset(el: HTMLElement, key: "defaultPaths" | "paths"): string[] {
  const raw = el.dataset[key];
  if (!raw) return [];
  return raw
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean);
}

export function buildDrawingOptions(el: HTMLElement): NonNullable<Props["drawing"]> {
  const o: Record<string, unknown> = {
    fill: getString(el, "drawingFill"),
    size: getNumber(el, "drawingSize"),
    simulatePressure: getBoolean(el, "drawingSimulatePressure"),
    smoothing: getNumber(el, "drawingSmoothing"),
    thinning: getNumber(el, "drawingThinning"),
    streamline: getNumber(el, "drawingStreamline"),
  };
  const easing = getString(el, "drawingEasing");
  if (easing) o.easing = easing;
  return o as NonNullable<Props["drawing"]>;
}

function queueFormBubblingInputForPhoenix(
  el: HTMLElement,
  getValue: () => string,
  opts: { onPadTouched: () => void }
): void {
  const input = el.querySelector<HTMLInputElement>(
    '[data-scope="signature-pad"][data-part="hidden-input"]'
  );
  if (!input) return;
  queueLiveViewFormInputSync(input, getValue, opts.onPadTouched);
}

type SignaturePadHookState = {
  signaturePad?: SignaturePad;
  handlers?: Array<CallbackRef>;
  onClear?: (event: Event) => void;
  padTouched: boolean;
};

const SignaturePadHook: Hook<object & SignaturePadHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & SignaturePadHookState) {
    const el = this.el;
    const hook = this as object & SignaturePadHookState;
    const pushEvent = this.pushEvent.bind(this);
    hook.padTouched = false;
    const markTouched = () => {
      hook.padTouched = true;
    };

    const defaultPaths = parsePathsFromDataset(el, "defaultPaths");
    {
      const input = el.querySelector<HTMLInputElement>(
        '[data-scope="signature-pad"][data-part="hidden-input"]'
      );
      if (String(input?.value ?? "") !== "" || defaultPaths.length > 0) {
        hook.padTouched = true;
        queueMicrotask(() => {
          const i = el.querySelector<HTMLInputElement>(
            '[data-scope="signature-pad"][data-part="hidden-input"]'
          );
          if (i) reapplyLiveViewValueInputUsage(i);
        });
      }
    }

    const signaturePad = new SignaturePad(el, {
      id: el.id,
      name: getString(el, "name"),
      ...(defaultPaths.length > 0 ? { defaultPaths } : {}),
      drawing: buildDrawingOptions(el),
      onDrawEnd: (details) => {
        signaturePad.setPaths(details.paths);

        queueFormBubblingInputForPhoenix(
          el,
          () => (details.paths.length > 0 ? details.paths.join("\n") : ""),
          { onPadTouched: markTouched }
        );

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
      queueFormBubblingInputForPhoenix(el, () => "", { onPadTouched: markTouched });
    };
    el.addEventListener("corex:signature-pad:clear", this.onClear);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("signature_pad_clear", (payload: unknown) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        signaturePad.api.clear();
        queueFormBubblingInputForPhoenix(el, () => "", { onPadTouched: markTouched });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & SignaturePadHookState) {
    const el = this.el;
    const name = getString(el, "name");

    if (name) {
      this.signaturePad?.setName(name);
    }

    this.signaturePad?.updateProps({
      id: el.id,
      name: name,
      drawing: buildDrawingOptions(el),
    } as Partial<Props>);

    if (!this.padTouched) {
      return;
    }
    queueMicrotask(() => {
      const input = this.el.querySelector<HTMLInputElement>(
        '[data-scope="signature-pad"][data-part="hidden-input"]'
      );
      if (input) {
        reapplyLiveViewValueInputUsage(input);
      }
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & SignaturePadHookState) {
    if (this.onClear) {
      this.el.removeEventListener("corex:signature-pad:clear", this.onClear);
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
