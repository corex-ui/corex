import { SignaturePad } from "../components/signature-pad";
import type { Props } from "@zag-js/signature-pad";

import { getBoolean, getDir, getNumber, getString } from "../lib/util";
import { getJsonStringList, readFormFieldServerPaths } from "../lib/read-props";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";
import {
  bindArrayFieldSubmitIntent,
  isFormFieldUsed,
  setArrayValues,
  syncFormInput,
} from "../lib/phoenix-form-bridge";

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
    setArrayValues(el, paths, {
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

  syncFormInput(input, () => (paths.length > 0 ? paths.join("\n") : ""), opts.onPadTouched);
}

type SignaturePadHookState = {
  signaturePad?: SignaturePad;
  padTouched: boolean;
  unbindSubmitIntent?: () => void;
};

const SignaturePadHook = createZagLiveHook<SignaturePadHookState, SignaturePad>({
  key: "signaturePad",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
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
          if (eventName && hook.liveSocket.main.isConnected()) {
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

    if (!hook.padTouched) {
      syncForm(defaultPaths, { notifyLiveView: false, fieldTouched: false });
    }

    hook.unbindSubmitIntent = bindArrayFieldSubmitIntent(el, () => {
      hook.padTouched = true;
      const paths = signaturePad.api.paths ?? [];
      syncForm(paths.length > 0 ? paths : [], { notifyLiveView: false, fieldTouched: true });
    });

    const clearPad = () => {
      signaturePad.api.clear();
      syncSignatureFormForPhoenix(el, [], {
        onPadTouched: markTouched,
        notifyLiveView: true,
        fieldTouched: true,
      });
    };

    dom.add<CustomEvent<{ id: string }>>("corex:signature-pad:clear", (event) => {
      const { id: targetId } = event.detail;
      if (targetId && targetId !== el.id) return;
      clearPad();
    });

    server.add("signature_pad_clear", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      clearPad();
    });

    return signaturePad;
  },

  update(hook, signaturePad) {
    const el = hook.el;

    signaturePad.updateProps({
      id: el.id,
      name: zagNameForForm(el),
      dir: getDir(el),
      drawing: buildDrawingOptions(el),
    } as Partial<Props>);

    const serverPaths = readFormFieldServerPaths(el);
    if (serverPaths !== undefined && !hook.padTouched) {
      signaturePad.setPaths(serverPaths);
      syncSignatureFormForPhoenix(el, serverPaths, {
        onPadTouched: () => {},
        notifyLiveView: false,
        fieldTouched: isFormFieldUsed(el, hook.padTouched),
      });
    }
  },

  destroy(hook) {
    hook.unbindSubmitIntent?.();
  },
});

export { SignaturePadHook as SignaturePad };
