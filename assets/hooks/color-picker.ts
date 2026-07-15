import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { ColorPicker, parse } from "../components/color-picker";
import type {
  Props,
  ValueChangeDetails,
  OpenChangeDetails,
  FormatChangeDetails,
} from "@zag-js/color-picker";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { mountStringBinding } from "../lib/read-props";

function readColorValueBinding(el: HTMLElement): Pick<Props, "value" | "defaultValue"> {
  const binding = mountStringBinding(el, "value", "defaultValue");
  if ("value" in binding && binding.value) {
    return { value: parse(binding.value) };
  }
  if ("defaultValue" in binding && binding.defaultValue) {
    return { defaultValue: parse(binding.defaultValue) };
  }
  return {};
}
import { readPositioningOptions } from "../lib/positioning";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";

type ColorPickerHookState = {
  colorPicker?: ColorPicker;
  handlers?: Array<CallbackRef>;
  onSetValue?: (event: Event) => void;
};

function syncColorHiddenAndNotify(el: HTMLElement, valueAsString: string | undefined) {
  if (valueAsString === undefined) {
    return;
  }
  const hidden = el.querySelector<HTMLInputElement>(
    '[data-scope="color-picker"][data-part="hidden-input"]'
  );
  if (hidden) {
    hidden.value = valueAsString;
    hidden.dispatchEvent(new Event("input", { bubbles: true }));
    hidden.dispatchEvent(new Event("change", { bubbles: true }));
  }
}

export function readValueProps(el: HTMLElement): Pick<Props, "defaultValue"> {
  const defaultVal = getString(el, "defaultValue");
  return { defaultValue: defaultVal ? parse(defaultVal) : undefined };
}

const ColorPickerHook: Hook<object & ColorPickerHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ColorPickerHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
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
    zag.init();
    this.colorPicker = zag;
    this.handlers = [];

    this.onSetValue = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: string }>).detail;
      zag.api.setValue(value);
    };
    el.addEventListener("corex:color-picker:set-value", this.onSetValue);

    this.handlers.push(
      this.handleEvent("color_picker_set_value", (payload: { value: string }) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        zag.api.setValue(payload.value);
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & ColorPickerHookState) {
    const el = this.el;
    const zag = this.colorPicker;

    zag?.updateProps({
      name: getString(el, "name"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      openAutoFocus: getBoolean(el, "openAutoFocus"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      dir: getDir(el),
      positioning: readPositioningOptions(el),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & ColorPickerHookState) {
    if (this.onSetValue) {
      this.el.removeEventListener("corex:color-picker:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const h of this.handlers) {
        this.removeHandleEvent(h);
      }
    }
    this.colorPicker?.destroy();
  },
};

export { ColorPickerHook as ColorPicker };
