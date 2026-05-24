import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
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
} from "../lib/util";
import {
  idMatches,
  notifyChange,
  readPayloadId,
  readPayloadStringArray,
  readPayloadValue,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import { syncTagsInputFormForPhoenix } from "../lib/tags-input-form";

type TagsInputHookState = {
  tagsInput?: TagsInput;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

export function parseJsonTags(el: HTMLElement, key: "tags" | "defaultTags"): string[] {
  const raw = el.dataset[key];
  if (!raw || raw.trim() === "") return [];
  try {
    const v = JSON.parse(raw) as unknown;
    return Array.isArray(v) && v.every((x) => typeof x === "string") ? (v as string[]) : [];
  } catch {
    return [];
  }
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

const TagsInputHook: Hook<object & TagsInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TagsInputHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const controlled = getBoolean(el, "controlled");
    const blur = blurBehavior(el);
    const max = maxProp(el);
    const delimiter = getString(el, "delimiter");
    const placeholder = readPlaceholderFromMainInput(el);

    const zag = new TagsInput(el, {
      id: el.id,
      ...resolveZagTagsInputTranslations(el),
      ...(controlled
        ? { value: parseJsonTags(el, "tags") }
        : { defaultValue: parseJsonTags(el, "defaultTags") }),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      name: getString(el, "name"),
      form: getString(el, "form"),
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
        syncTagsInputFormForPhoenix(el, details.value);

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

    zag.init();
    this.tagsInput = zag;

    const defaultTags = parseJsonTags(el, "defaultTags");
    if (defaultTags.length > 0) {
      queueMicrotask(() => syncTagsInputFormForPhoenix(el, defaultTags));
    }

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value?: string[] }>>("corex:tags-input:set-value", (event) => {
      const v = event.detail?.value;
      if (Array.isArray(v) && v.every((x) => typeof x === "string"))
        zag.api.setValue(v as string[]);
    });

    domRegistry.add("corex:tags-input:clear-value", () => {
      zag.api.clearValue();
    });

    domRegistry.add<CustomEvent<{ value?: string }>>("corex:tags-input:add-value", (event) => {
      const tag = event.detail?.value;
      if (typeof tag === "string" && tag !== "") zag.api.addValue(tag);
    });

    domRegistry.add<CustomEvent<{ value?: string }>>("corex:tags-input:remove-value", (event) => {
      const tag = event.detail?.value;
      if (typeof tag !== "string" || tag === "") return;
      zag.api.setValue(zag.api.value.filter((t) => t !== tag));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("tags_input_set_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const v = readPayloadStringArray(payload);
      if (v) zag.api.setValue(v);
    });

    registry.add("tags_input_clear_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearValue();
    });

    registry.add("tags_input_add_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const tag = readPayloadValue(payload);
      if (tag !== "") zag.api.addValue(tag);
    });

    registry.add("tags_input_remove_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const tag = readPayloadValue(payload);
      if (tag === "") return;
      zag.api.setValue(zag.api.value.filter((t) => t !== tag));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & TagsInputHookState) {
    const el = this.el;
    const controlled = getBoolean(el, "controlled");
    const blur = blurBehavior(el);
    const max = maxProp(el);
    const delimiter = getString(el, "delimiter");
    const placeholder = readPlaceholderFromMainInput(el);

    this.tagsInput?.updateProps({
      id: el.id,
      ...resolveZagTagsInputTranslations(el),
      ...(controlled ? { value: parseJsonTags(el, "tags") } : {}),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      name: getString(el, "name"),
      form: getString(el, "form"),
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
    } as Partial<Props>);
    this.tagsInput?.render();

    if (this.tagsInput) {
      queueMicrotask(() => syncTagsInputFormForPhoenix(el, this.tagsInput!.api.value as string[]));
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & TagsInputHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.tagsInput?.destroy();
  },
};

export { TagsInputHook as TagsInput };
