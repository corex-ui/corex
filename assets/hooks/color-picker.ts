import { ColorPicker, parse } from "../components/color-picker";
import type {
  Props,
  ValueChangeDetails,
  OpenChangeDetails,
  FormatChangeDetails,
} from "@zag-js/color-picker";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { mountStringBinding, readUpdatedServerString } from "../lib/read-props";
import { readPositioningOptions } from "../lib/positioning";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";
import { notifyPhoenixFormChange } from "../lib/phoenix-form-bridge";

type ParsedColor = ReturnType<typeof parse>;

function tryParseColor(raw: string, label = "color"): ParsedColor | undefined {
  try {
    return parse(raw);
  } catch (error) {
    console.warn(`[corex] color-picker: failed to parse ${label}`, raw, error);
    return undefined;
  }
}

function readColorValueBinding(el: HTMLElement): Pick<Props, "value" | "defaultValue"> {
  const binding = mountStringBinding(el, "value", "defaultValue");
  if ("value" in binding && binding.value) {
    const parsed = tryParseColor(binding.value, "value");
    if (parsed) return { value: parsed };
  }
  if ("defaultValue" in binding && binding.defaultValue) {
    const parsed = tryParseColor(binding.defaultValue, "defaultValue");
    if (parsed) return { defaultValue: parsed };
  }
  return { defaultValue: tryParseColor("#000000", "fallback") };
}

type ColorPickerHookState = {
  colorPicker?: ColorPicker;
};

function syncColorHiddenAndNotify(el: HTMLElement, valueAsString: string | undefined) {
  if (valueAsString === undefined) {
    return;
  }
  const hidden = el.querySelector<HTMLInputElement>(
    '[data-scope="color-picker"][data-part="hidden-input"]'
  );
  if (hidden) {
    notifyPhoenixFormChange(hidden, valueAsString, { force: true });
  }
}

export function readValueProps(el: HTMLElement): Pick<Props, "defaultValue"> {
  const defaultVal = getString(el, "defaultValue");
  return { defaultValue: defaultVal ? tryParseColor(defaultVal, "defaultValue") : undefined };
}

const ColorPickerHook = createZagLiveHook<ColorPickerHookState, ColorPicker>({
  key: "colorPicker",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const valueProps = readColorValueBinding(el);

    const zag = new ColorPicker(el, {
      id: el.id,
      ...valueProps,
      name: getString(el, "name"),
      defaultFormat: "rgba",
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      defaultOpen: false,
      openAutoFocus: getBoolean(el, "openAutoFocus"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      dir: getDir(el),
      positioning: readPositioningOptions(el),
      onValueChange: (details: ValueChangeDetails) => {
        syncColorHiddenAndNotify(el, details.valueAsString);
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: {
            id: el.id,
            valueAsString: details.valueAsString,
          } as Record<string, unknown>,
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },
      onValueChangeEnd: (details: ValueChangeDetails) => {
        syncColorHiddenAndNotify(el, details.valueAsString);
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: {
            id: el.id,
            valueAsString: details.valueAsString,
          } as Record<string, unknown>,
          serverEventName: getString(el, "onValueChangeEnd"),
          clientEventName: getString(el, "onValueChangeEndClient"),
        });
      },
      onOpenChange: (details: OpenChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, open: details.open } as Record<string, unknown>,
          serverEventName: getString(el, "onOpenChange"),
          clientEventName: getString(el, "onOpenChangeClient"),
        });
      },
      onFormatChange: (details: FormatChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, format: details.format } as Record<string, unknown>,
          serverEventName: getString(el, "onFormatChange"),
          clientEventName: getString(el, "onFormatChangeClient"),
        });
      },
      onPointerDownOutside: () => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id } as Record<string, unknown>,
          serverEventName: getString(el, "onPointerDownOutside"),
          clientEventName: getString(el, "onPointerDownOutsideClient"),
        });
      },
      onFocusOutside: () => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id } as Record<string, unknown>,
          serverEventName: getString(el, "onFocusOutside"),
          clientEventName: getString(el, "onFocusOutsideClient"),
        });
      },
      onInteractOutside: () => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id } as Record<string, unknown>,
          serverEventName: getString(el, "onInteractOutside"),
          clientEventName: getString(el, "onInteractOutsideClient"),
        });
      },
    } as unknown as Props);

    dom.add<CustomEvent<{ value: string }>>("corex:color-picker:set-value", (event) => {
      const { value } = event.detail;
      if (typeof value !== "string") return;
      if (!tryParseColor(value, "set-value")) return;
      zag.api.setValue(value);
    });

    server.add("color_picker_set_value", (payload: { value: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof payload.value !== "string") return;
      if (!tryParseColor(payload.value, "set_value")) return;
      zag.api.setValue(payload.value);
    });

    return zag;
  },

  update(hook, zag) {
    const el = hook.el;

    const valuePatch = readUpdatedServerString(el, hook.beforeAttrs);
    const parsedValue =
      valuePatch.value !== undefined && valuePatch.value
        ? tryParseColor(valuePatch.value, "value")
        : undefined;

    zag.updateProps({
      name: getString(el, "name"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      openAutoFocus: getBoolean(el, "openAutoFocus"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      dir: getDir(el),
      positioning: readPositioningOptions(el),
      ...(parsedValue !== undefined ? { value: parsedValue } : {}),
    } as Partial<Props>);

    // Morphdom can clear Zag-owned styles (area-background gradients, thumbs)
    // when the server re-renders after on_value_change; re-spread props.
    zag.render();
  },
});

export { ColorPickerHook as ColorPicker };
