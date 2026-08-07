import { TagsInput, resolveZagTagsInputTranslations } from "../components/tags-input";
import type {
  Props,
  ValueChangeDetails,
  InputValueChangeDetails,
  HighlightChangeDetails,
  ValidityChangeDetails,
} from "@zag-js/tags-input";
import {
  getString,
  getBoolean,
  getBooleanValue,
  getDir,
  getNumber,
  canPushEvent,
  parseJsonStringList,
} from "../lib/util";
import {
  idMatches,
  notifyChange,
  readPayloadId,
  readPayloadStringArray,
  readPayloadValue,
} from "../lib/respond-to";
import { bindArrayFieldSubmitIntent, isFormFieldUsed } from "../lib/phoenix-form-bridge";
import { syncTagsInputFormForPhoenix } from "../lib/tags-input-form";
import { datasetKeyChanged, type DatasetSnapshot } from "../lib/controlled-attr-snapshot";
import { isZagValueControlled, mountTagsBinding } from "../lib/read-props";
import { createZagLiveHook } from "../lib/zag-live-hook";

type TagsInputHookState = {
  tagsInput?: TagsInput;
  fieldTouched?: boolean;
  unbindSubmitIntent?: () => void;
};

function readUpdatedServerTags(
  el: HTMLElement,
  before?: DatasetSnapshot
): { value: string[] } | Record<string, never> {
  if (!isZagValueControlled(el)) {
    return {};
  }

  if (!datasetKeyChanged(before, el, "tags")) {
    return {};
  }

  return { value: parseJsonTags(el, "tags") };
}

function sameStringList(a: ReadonlyArray<string>, b: ReadonlyArray<string>): boolean {
  return a.length === b.length && a.every((v, i) => v === b[i]);
}

export function parseJsonTags(el: HTMLElement, key: "tags" | "defaultTags"): string[] {
  return parseJsonStringList(el.dataset[key]);
}

export function blurBehavior(el: HTMLElement): "add" | "clear" | undefined {
  return getString<"add" | "clear">(el, "blurBehavior", ["add", "clear"] as const);
}

export function maxProp(el: HTMLElement): number | undefined {
  const n = getNumber(el, "max");
  if (n === undefined) return undefined;
  if (!Number.isFinite(n) || n <= 0) return undefined;
  return n;
}

export function readPlaceholderFromMainInput(hookEl: HTMLElement): string | undefined {
  const input = hookEl.querySelector<HTMLInputElement>(
    '[data-scope="tags-input"][data-part="input"]'
  );
  const v = input?.getAttribute("placeholder");
  return typeof v === "string" && v !== "" ? v : undefined;
}

function zagNameForForm(el: HTMLElement): string | undefined {
  if (getString(el, "submitName")) return undefined;
  return getString(el, "name");
}

const TagsInputHook = createZagLiveHook<TagsInputHookState, TagsInput>({
  key: "tagsInput",
  controlledKeys: ["tags"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    hook.fieldTouched = false;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const blur = blurBehavior(el);
    const max = maxProp(el);
    const delimiter = getString(el, "delimiter");
    const placeholder = readPlaceholderFromMainInput(el);
    const valueBinding = mountTagsBinding(el);
    const initialValues = "value" in valueBinding ? valueBinding.value : valueBinding.defaultValue;

    const zag = new TagsInput(el, {
      id: el.id,
      ...resolveZagTagsInputTranslations(el),
      ...valueBinding,
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      name: zagNameForForm(el),
      form: getString(el, "submitName") ? undefined : getString(el, "form"),
      dir: getDir(el),
      addOnPaste: getBoolean(el, "addOnPaste"),
      allowDuplicates: getBoolean(el, "allowDuplicates"),
      allowOverflow: getBoolean(el, "allowOverflow"),
      ...(getBooleanValue(el, "editable") === undefined
        ? {}
        : { editable: getBooleanValue(el, "editable") === true }),
      autoFocus: getBoolean(el, "autoFocus"),
      ...(blur !== undefined ? { blurBehavior: blur } : {}),
      ...(max !== undefined ? { max } : {}),
      ...(delimiter !== undefined && delimiter !== "" ? { delimiter } : {}),
      ...(placeholder !== undefined ? { placeholder } : {}),
      onValueChange: (details: ValueChangeDetails) => {
        const isMountEcho =
          hook.fieldTouched !== true && sameStringList(details.value, initialValues);
        if (!isMountEcho) {
          hook.fieldTouched = true;
        }
        syncTagsInputFormForPhoenix(el, details.value, undefined, {
          notifyLiveView: !isMountEcho,
          fieldTouched: !isMountEcho,
        });

        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, value: details.value } as Record<string, unknown>,
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },
      onInputValueChange: (details: InputValueChangeDetails) => {
        hook.fieldTouched = true;
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, inputValue: details.inputValue } as Record<string, unknown>,
          serverEventName: getString(el, "onInputValueChange"),
          clientEventName: getString(el, "onInputValueChangeClient"),
        });
      },
      onHighlightChange: (details: HighlightChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, highlightedValue: details.highlightedValue } as Record<
            string,
            unknown
          >,
          serverEventName: getString(el, "onHighlightChange"),
          clientEventName: getString(el, "onHighlightChangeClient"),
        });
      },
      onValueInvalid: (details: ValidityChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, reason: details.reason } as Record<string, unknown>,
          serverEventName: getString(el, "onValueInvalid"),
          clientEventName: getString(el, "onValueInvalidClient"),
        });
      },
    } as Props);

    const syncForm = (values: string[], opts: { notifyLiveView?: boolean } = {}) => {
      syncTagsInputFormForPhoenix(el, values, undefined, {
        notifyLiveView: opts.notifyLiveView,
        fieldTouched: isFormFieldUsed(el, Boolean(hook.fieldTouched)),
      });
    };

    if (!isFormFieldUsed(el, Boolean(hook.fieldTouched))) {
      syncForm(zag.api.value, { notifyLiveView: false });
    }

    hook.unbindSubmitIntent = bindArrayFieldSubmitIntent(el, () => {
      hook.fieldTouched = true;
      syncForm(zag.api.value, { notifyLiveView: false });
    });

    dom.add<CustomEvent<{ value?: string[] }>>("corex:tags-input:set-value", (event) => {
      const v = event.detail?.value;
      if (Array.isArray(v) && v.every((x) => typeof x === "string"))
        zag.api.setValue(v as string[]);
    });

    dom.add("corex:tags-input:clear-value", () => {
      zag.api.clearValue();
    });

    dom.add<CustomEvent<{ value?: string }>>("corex:tags-input:add-value", (event) => {
      const tag = event.detail?.value;
      if (typeof tag === "string" && tag !== "") zag.api.addValue(tag);
    });

    dom.add<CustomEvent<{ value?: string }>>("corex:tags-input:remove-value", (event) => {
      const tag = event.detail?.value;
      if (typeof tag !== "string" || tag === "") return;
      zag.api.setValue(zag.api.value.filter((t) => t !== tag));
    });

    server.add("tags_input_set_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const v = readPayloadStringArray(payload);
      if (v) zag.api.setValue(v);
    });

    server.add("tags_input_clear_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearValue();
    });

    server.add("tags_input_add_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const tag = readPayloadValue(payload);
      if (tag !== "") zag.api.addValue(tag);
    });

    server.add("tags_input_remove_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const tag = readPayloadValue(payload);
      if (tag === "") return;
      zag.api.setValue(zag.api.value.filter((t) => t !== tag));
    });

    return zag;
  },

  update(hook, zag) {
    const el = hook.el;

    const blur = blurBehavior(el);
    const max = maxProp(el);
    const delimiter = getString(el, "delimiter");
    const placeholder = readPlaceholderFromMainInput(el);
    const valuePatch = readUpdatedServerTags(el, hook.beforeAttrs);

    zag.updateProps({
      id: el.id,
      ...resolveZagTagsInputTranslations(el),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      name: zagNameForForm(el),
      form: getString(el, "submitName") ? undefined : getString(el, "form"),
      dir: getDir(el),
      addOnPaste: getBoolean(el, "addOnPaste"),
      allowDuplicates: getBoolean(el, "allowDuplicates"),
      allowOverflow: getBoolean(el, "allowOverflow"),
      ...(getBooleanValue(el, "editable") === undefined
        ? {}
        : { editable: getBooleanValue(el, "editable") === true }),
      autoFocus: getBoolean(el, "autoFocus"),
      ...(blur !== undefined ? { blurBehavior: blur } : {}),
      ...(max !== undefined ? { max } : {}),
      ...(delimiter !== undefined && delimiter !== "" ? { delimiter } : {}),
      ...(placeholder !== undefined ? { placeholder } : {}),
      ...(valuePatch.value !== undefined ? { value: valuePatch.value } : {}),
    } as Partial<Props>);
  },

  destroy(hook) {
    hook.unbindSubmitIntent?.();
  },
});

export { TagsInputHook as TagsInput };
