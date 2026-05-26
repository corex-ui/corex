import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { SignaturePad } from "../components/signature-pad";
import type { Props } from "@zag-js/signature-pad";

import { getBoolean, getDir, getNumber, getString } from "../lib/util";
import { getJsonStringList, readFormFieldServerPaths } from "../lib/read-props";
import { idMatches, readPayloadId } from "../lib/respond-to";
import {
  bindArrayFieldSubmitIntent,
  isFormFieldUsed,
  syncArrayHiddenInputsForPhoenix,
} from "../lib/form-array-submit";
import { queueLiveViewFormInputSync } from "../lib/live-view-form-input";

export function parsePathsFromDataset(el: HTMLElement, key: "defaultPaths" | "paths"): string[] {
  const json = getJsonStringList(el, key);
  if (json !== undefined) return json;

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

function zagNameForForm(el: HTMLElement): string | undefined {
  if (getString(el, "submitName")) return undefined;
  return getString(el, "name");
}

function syncSignatureFormForPhoenix(
  el: HTMLElement,
  paths: ReadonlyArray<string>,
  opts: { onPadTouched: () => void; notifyLiveView?: boolean; fieldTouched?: boolean }
): void {
  const submitName = getString(el, "submitName");
  const fieldTouched = opts.fieldTouched === true;

  if (submitName) {
    syncArrayHiddenInputsForPhoenix(el, paths, {
      onTouched: opts.onPadTouched,
      scope: "signature-pad",
      submitName,
      notifyLiveView: opts.notifyLiveView ?? true,
      fieldTouched,
    });
    return;
  }

  const input = el.querySelector<HTMLInputElement>(
    '[data-scope="signature-pad"][data-part="hidden-input"]'
  );
  if (!input) return;

  if (opts.notifyLiveView === false) {
    input.value = paths.length > 0 ? paths.join("\n") : "";
    return;
  }

  queueLiveViewFormInputSync(
    input,
    () => (paths.length > 0 ? paths.join("\n") : ""),
    opts.onPadTouched
  );
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
    const hook = this as object & HookInterface<HTMLElement> & SignaturePadHookState;
    const pushEvent = this.pushEvent.bind(this);
    hook.padTouched = false;
    const markTouched = () => {
      hook.padTouched = true;
    };

    const defaultPaths = parsePathsFromDataset(el, "defaultPaths");

    const signaturePad = new SignaturePad(el, {
      id: el.id,
      name: zagNameForForm(el),
      dir: getDir(el),
      ...(defaultPaths.length > 0 ? { defaultPaths } : {}),
      drawing: buildDrawingOptions(el),
      onDrawEnd: (details) => {
        signaturePad.setPaths(details.paths);

        syncSignatureFormForPhoenix(el, details.paths, {
          onPadTouched: markTouched,
          notifyLiveView: true,
          fieldTouched: true,
        });

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

    const syncForm = (
      paths: ReadonlyArray<string>,
      opts: { notifyLiveView?: boolean; fieldTouched?: boolean }
    ) => {
      syncSignatureFormForPhoenix(el, paths, {
        onPadTouched: () => {},
        notifyLiveView: opts.notifyLiveView,
        fieldTouched: isFormFieldUsed(el, hook.padTouched || opts.fieldTouched === true),
      });
    };

    queueMicrotask(() => {
      if (!hook.padTouched) {
        syncForm(defaultPaths, { notifyLiveView: false, fieldTouched: false });
      }
    });

    hook.unbindSubmitIntent = bindArrayFieldSubmitIntent(el, () => {
      hook.padTouched = true;
      const paths = signaturePad.api.paths ?? [];
      syncForm(paths.length > 0 ? paths : [], { notifyLiveView: false, fieldTouched: true });
    });

    this.onClear = (event: Event) => {
      const { id: targetId } = (event as CustomEvent<{ id: string }>).detail;
      if (targetId && targetId !== el.id) return;
      signaturePad.api.clear();
      syncSignatureFormForPhoenix(el, [], {
        onPadTouched: markTouched,
        notifyLiveView: true,
        fieldTouched: true,
      });
    };
    el.addEventListener("corex:signature-pad:clear", this.onClear);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("signature_pad_clear", (payload: unknown) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        signaturePad.api.clear();
        syncSignatureFormForPhoenix(el, [], {
          onPadTouched: markTouched,
          notifyLiveView: true,
          fieldTouched: true,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & SignaturePadHookState) {
    const el = this.el;

    this.signaturePad?.updateProps({
      id: el.id,
      name: zagNameForForm(el),
      dir: getDir(el),
      drawing: buildDrawingOptions(el),
    } as Partial<Props>);

    const serverPaths = readFormFieldServerPaths(el);
    if (serverPaths !== undefined && !this.padTouched) {
      this.signaturePad?.setPaths(serverPaths);
      syncSignatureFormForPhoenix(el, serverPaths, {
        onPadTouched: () => {},
        notifyLiveView: false,
        fieldTouched: isFormFieldUsed(el, this.padTouched),
      });
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & SignaturePadHookState) {
    this.unbindSubmitIntent?.();
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
