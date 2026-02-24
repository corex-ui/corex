import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { ColorPicker, parse } from "../components/color-picker";
import type {
  Props,
  ValueChangeDetails,
  OpenChangeDetails,
  FormatChangeDetails,
  ColorFormat,
} from "@zag-js/color-picker";
import { getString, getBoolean, getDir } from "../lib/util";

type ColorPickerHookState = {
  colorPicker?: ColorPicker;
  handlers?: Array<CallbackRef>;
  onSetOpen?: (event: Event) => void;
  onSetValue?: (event: Event) => void;
  onSetFormat?: (event: Event) => void;
};

function parsePositioning(val: string | undefined): Props["positioning"] | undefined {
  if (!val) return undefined;
  try {
    return JSON.parse(val) as Props["positioning"];
  } catch {
    return undefined;
  }
}

const ColorPickerHook: Hook<object & ColorPickerHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ColorPickerHookState) {
    const el = this.el;
    const controlled = getBoolean(el, "controlled");
    const defaultVal = getString(el, "defaultValue");
    const valueVal = getString(el, "value");

    const zag = new ColorPicker(el, {
      id: el.id,
      ...(controlled
        ? { value: valueVal ? parse(valueVal) : undefined }
        : { defaultValue: defaultVal ? parse(defaultVal) : undefined }),
      name: getString(el, "name") ?? el.id,
      format:
        getString<"rgba" | "hsla" | "hsba" | "hex">(el, "format", [
          "rgba",
          "hsla",
          "hsba",
          "hex",
        ]) ?? "rgba",
      defaultFormat: getString<"rgba" | "hsla" | "hsba" | "hex">(el, "defaultFormat", [
        "rgba",
        "hsla",
        "hsba",
        "hex",
      ]),
      closeOnSelect: getBoolean(el, "closeOnSelect") !== false,
      ...(controlled
        ? { open: getBoolean(el, "open") }
        : { defaultOpen: getBoolean(el, "defaultOpen") }),
      openAutoFocus: getBoolean(el, "openAutoFocus") !== false,
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      dir: getDir(el),
      positioning: parsePositioning(el.dataset.positioning),
      onValueChange: (details: ValueChangeDetails) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            valueAsString: details.valueAsString,
            id: el.id,
          });
        }
        const eventNameClient = getString(el, "onValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { value: details, id: el.id },
            })
          );
        }
      },
      onValueChangeEnd: (details: ValueChangeDetails) => {
        const eventName = getString(el, "onValueChangeEnd");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            valueAsString: details.valueAsString,
            id: el.id,
          });
        }
        const eventNameClient = getString(el, "onValueChangeEndClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { value: details, id: el.id },
            })
          );
        }
      },
      onOpenChange: (details: OpenChangeDetails) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { open: details.open, id: el.id });
        }
        const eventNameClient = getString(el, "onOpenChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { open: details.open, id: el.id },
            })
          );
        }
      },
      onFormatChange: (details: FormatChangeDetails) => {
        const eventName = getString(el, "onFormatChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { format: details.format, id: el.id });
        }
      },
      onPointerDownOutside: () => {
        const eventName = getString(el, "onPointerDownOutside");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { id: el.id });
        }
      },
      onFocusOutside: () => {
        const eventName = getString(el, "onFocusOutside");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { id: el.id });
        }
      },
      onInteractOutside: () => {
        const eventName = getString(el, "onInteractOutside");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { id: el.id });
        }
      },
    } as unknown as Props);
    zag.init();
    this.colorPicker = zag;
    this.handlers = [];

    this.onSetOpen = (event: Event) => {
      const { open } = (event as CustomEvent<{ open: boolean }>).detail;
      zag.api.setOpen(open);
    };
    el.addEventListener("phx:color-picker:set-open", this.onSetOpen);

    this.onSetValue = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: string }>).detail;
      zag.api.setValue(value);
    };
    el.addEventListener("phx:color-picker:set-value", this.onSetValue);

    this.onSetFormat = (event: Event) => {
      const { format } = (event as CustomEvent<{ format: string }>).detail;
      zag.api.setFormat(format as ColorFormat);
    };
    el.addEventListener("phx:color-picker:set-format", this.onSetFormat);

    this.handlers.push(
      this.handleEvent(
        "color_picker_set_open",
        (payload: { color_picker_id?: string; open: boolean }) => {
          const targetId = payload.color_picker_id;
          if (targetId) {
            const matches = el.id === targetId || el.id === `color-picker:${targetId}`;
            if (!matches) return;
          }
          zag.api.setOpen(payload.open);
        }
      )
    );

    this.handlers.push(
      this.handleEvent(
        "color_picker_set_value",
        (payload: { color_picker_id?: string; value: string }) => {
          const targetId = payload.color_picker_id;
          if (targetId) {
            const matches = el.id === targetId || el.id === `color-picker:${targetId}`;
            if (!matches) return;
          }
          zag.api.setValue(payload.value);
        }
      )
    );

    this.handlers.push(
      this.handleEvent(
        "color_picker_set_format",
        (payload: { color_picker_id?: string; format: string }) => {
          const targetId = payload.color_picker_id;
          if (targetId) {
            const matches = el.id === targetId || el.id === `color-picker:${targetId}`;
            if (!matches) return;
          }
          zag.api.setFormat(payload.format as ColorFormat);
        }
      )
    );
  },

  updated(this: object & HookInterface<HTMLElement> & ColorPickerHookState) {
    const el = this.el;
    const controlled = getBoolean(el, "controlled");
    const defaultVal = getString(el, "defaultValue");
    const valueVal = getString(el, "value");

    this.colorPicker?.updateProps({
      ...(controlled
        ? { value: valueVal ? parse(valueVal) : undefined }
        : { defaultValue: defaultVal ? parse(defaultVal) : undefined }),
      name: getString(el, "name") ?? el.id,
      format:
        getString<"rgba" | "hsla" | "hsba" | "hex">(el, "format", [
          "rgba",
          "hsla",
          "hsba",
          "hex",
        ]) ?? "rgba",
      defaultFormat: getString<"rgba" | "hsla" | "hsba" | "hex">(el, "defaultFormat", [
        "rgba",
        "hsla",
        "hsba",
        "hex",
      ]),
      closeOnSelect: getBoolean(el, "closeOnSelect") !== false,
      ...(controlled
        ? { open: getBoolean(el, "open") }
        : { defaultOpen: getBoolean(el, "defaultOpen") }),
      openAutoFocus: getBoolean(el, "openAutoFocus") !== false,
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      dir: getDir(el),
      positioning: parsePositioning(el.dataset.positioning),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & ColorPickerHookState) {
    if (this.onSetOpen) {
      this.el.removeEventListener("phx:color-picker:set-open", this.onSetOpen);
    }
    if (this.onSetValue) {
      this.el.removeEventListener("phx:color-picker:set-value", this.onSetValue);
    }
    if (this.onSetFormat) {
      this.el.removeEventListener("phx:color-picker:set-format", this.onSetFormat);
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
