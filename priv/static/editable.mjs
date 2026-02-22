import {
  trackInteractOutside
} from "./chunk-EBQGC3XC.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  contains,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  getBoolean,
  getDir,
  getString,
  isApple,
  isComposingEvent,
  normalizeProps,
  raf,
  setElementValue
} from "./chunk-RUWIVFVB.mjs";

// ../node_modules/.pnpm/@zag-js+editable@1.34.1/node_modules/@zag-js/editable/dist/index.mjs
var anatomy = createAnatomy("editable").parts(
  "root",
  "area",
  "label",
  "preview",
  "input",
  "editTrigger",
  "submitTrigger",
  "cancelTrigger",
  "control"
);
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `editable:${ctx.id}`;
var getAreaId = (ctx) => ctx.ids?.area ?? `editable:${ctx.id}:area`;
var getLabelId = (ctx) => ctx.ids?.label ?? `editable:${ctx.id}:label`;
var getPreviewId = (ctx) => ctx.ids?.preview ?? `editable:${ctx.id}:preview`;
var getInputId = (ctx) => ctx.ids?.input ?? `editable:${ctx.id}:input`;
var getControlId = (ctx) => ctx.ids?.control ?? `editable:${ctx.id}:control`;
var getSubmitTriggerId = (ctx) => ctx.ids?.submitTrigger ?? `editable:${ctx.id}:submit`;
var getCancelTriggerId = (ctx) => ctx.ids?.cancelTrigger ?? `editable:${ctx.id}:cancel`;
var getEditTriggerId = (ctx) => ctx.ids?.editTrigger ?? `editable:${ctx.id}:edit`;
var getInputEl = (ctx) => ctx.getById(getInputId(ctx));
var getPreviewEl = (ctx) => ctx.getById(getPreviewId(ctx));
var getSubmitTriggerEl = (ctx) => ctx.getById(getSubmitTriggerId(ctx));
var getCancelTriggerEl = (ctx) => ctx.getById(getCancelTriggerId(ctx));
var getEditTriggerEl = (ctx) => ctx.getById(getEditTriggerId(ctx));
function connect(service, normalize) {
  const { state, context, send, prop, scope, computed } = service;
  const disabled = !!prop("disabled");
  const interactive = computed("isInteractive");
  const readOnly = !!prop("readOnly");
  const required = !!prop("required");
  const invalid = !!prop("invalid");
  const autoResize = !!prop("autoResize");
  const translations = prop("translations");
  const editing = state.matches("edit");
  const placeholderProp = prop("placeholder");
  const placeholder = typeof placeholderProp === "string" ? { edit: placeholderProp, preview: placeholderProp } : placeholderProp;
  const value = context.get("value");
  const empty = value.trim() === "";
  const valueText = empty ? placeholder?.preview ?? "" : value;
  return {
    editing,
    empty,
    value,
    valueText,
    setValue(value2) {
      send({ type: "VALUE.SET", value: value2, src: "setValue" });
    },
    clearValue() {
      send({ type: "VALUE.SET", value: "", src: "clearValue" });
    },
    edit() {
      if (!interactive) return;
      send({ type: "EDIT" });
    },
    cancel() {
      if (!interactive) return;
      send({ type: "CANCEL" });
    },
    submit() {
      if (!interactive) return;
      send({ type: "SUBMIT" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        dir: prop("dir")
      });
    },
    getAreaProps() {
      return normalize.element({
        ...parts.area.attrs,
        id: getAreaId(scope),
        dir: prop("dir"),
        style: autoResize ? { display: "inline-grid" } : void 0,
        "data-focus": dataAttr(editing),
        "data-disabled": dataAttr(disabled),
        "data-placeholder-shown": dataAttr(empty)
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        id: getLabelId(scope),
        dir: prop("dir"),
        htmlFor: getInputId(scope),
        "data-focus": dataAttr(editing),
        "data-invalid": dataAttr(invalid),
        "data-required": dataAttr(required),
        onClick() {
          if (editing) return;
          const previewEl = getPreviewEl(scope);
          previewEl?.focus({ preventScroll: true });
        }
      });
    },
    getInputProps() {
      return normalize.input({
        ...parts.input.attrs,
        dir: prop("dir"),
        "aria-label": translations?.input,
        name: prop("name"),
        form: prop("form"),
        id: getInputId(scope),
        hidden: autoResize ? void 0 : !editing,
        placeholder: placeholder?.edit,
        maxLength: prop("maxLength"),
        required: prop("required"),
        disabled,
        "data-disabled": dataAttr(disabled),
        readOnly,
        "data-readonly": dataAttr(readOnly),
        "aria-invalid": ariaAttr(invalid),
        "data-invalid": dataAttr(invalid),
        "data-autoresize": dataAttr(autoResize),
        defaultValue: value,
        size: autoResize ? 1 : void 0,
        onChange(event) {
          send({
            type: "VALUE.SET",
            src: "input.change",
            value: event.currentTarget.value
          });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (isComposingEvent(event)) return;
          const keyMap = {
            Escape() {
              send({ type: "CANCEL" });
              event.preventDefault();
            },
            Enter(event2) {
              if (!computed("submitOnEnter")) return;
              const { localName } = event2.currentTarget;
              if (localName === "textarea") {
                const submitMod = isApple() ? event2.metaKey : event2.ctrlKey;
                if (!submitMod) return;
                send({ type: "SUBMIT", src: "keydown.enter" });
                return;
              }
              if (localName === "input" && !event2.shiftKey && !event2.metaKey) {
                send({ type: "SUBMIT", src: "keydown.enter" });
                event2.preventDefault();
              }
            }
          };
          const exec = keyMap[event.key];
          if (exec) {
            exec(event);
          }
        },
        style: autoResize ? {
          gridArea: "1 / 1 / auto / auto",
          visibility: !editing ? "hidden" : void 0
        } : void 0
      });
    },
    getPreviewProps() {
      return normalize.element({
        id: getPreviewId(scope),
        ...parts.preview.attrs,
        dir: prop("dir"),
        "data-placeholder-shown": dataAttr(empty),
        "aria-readonly": ariaAttr(readOnly),
        "data-readonly": dataAttr(disabled),
        "data-disabled": dataAttr(disabled),
        "aria-disabled": ariaAttr(disabled),
        "aria-invalid": ariaAttr(invalid),
        "data-invalid": dataAttr(invalid),
        "aria-label": translations?.edit,
        "data-autoresize": dataAttr(autoResize),
        children: valueText,
        hidden: autoResize ? void 0 : editing,
        tabIndex: interactive ? 0 : void 0,
        onClick() {
          if (!interactive) return;
          if (prop("activationMode") !== "click") return;
          send({ type: "EDIT", src: "click" });
        },
        onFocus() {
          if (!interactive) return;
          if (prop("activationMode") !== "focus") return;
          send({ type: "EDIT", src: "focus" });
        },
        onDoubleClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          if (prop("activationMode") !== "dblclick") return;
          send({ type: "EDIT", src: "dblclick" });
        },
        style: autoResize ? {
          whiteSpace: "pre",
          gridArea: "1 / 1 / auto / auto",
          visibility: editing ? "hidden" : void 0,
          // in event the preview overflow's the parent element
          overflow: "hidden",
          textOverflow: "ellipsis"
        } : void 0
      });
    },
    getEditTriggerProps() {
      return normalize.button({
        ...parts.editTrigger.attrs,
        id: getEditTriggerId(scope),
        dir: prop("dir"),
        "aria-label": translations?.edit,
        hidden: editing,
        type: "button",
        disabled,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "EDIT", src: "edit.click" });
        }
      });
    },
    getControlProps() {
      return normalize.element({
        id: getControlId(scope),
        ...parts.control.attrs,
        dir: prop("dir")
      });
    },
    getSubmitTriggerProps() {
      return normalize.button({
        ...parts.submitTrigger.attrs,
        dir: prop("dir"),
        id: getSubmitTriggerId(scope),
        "aria-label": translations?.submit,
        hidden: !editing,
        disabled,
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "SUBMIT", src: "submit.click" });
        }
      });
    },
    getCancelTriggerProps() {
      return normalize.button({
        ...parts.cancelTrigger.attrs,
        dir: prop("dir"),
        "aria-label": translations?.cancel,
        id: getCancelTriggerId(scope),
        hidden: !editing,
        type: "button",
        disabled,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "CANCEL", src: "cancel.click" });
        }
      });
    }
  };
}
var machine = createMachine({
  props({ props: props2 }) {
    return {
      activationMode: "focus",
      submitMode: "both",
      defaultValue: "",
      selectOnFocus: true,
      ...props2,
      translations: {
        input: "editable input",
        edit: "edit",
        submit: "submit",
        cancel: "cancel",
        ...props2.translations
      }
    };
  },
  initialState({ prop }) {
    const edit = prop("edit") || prop("defaultEdit");
    return edit ? "edit" : "preview";
  },
  entry: ["focusInputIfNeeded"],
  context: ({ bindable, prop }) => {
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        onChange(value) {
          return prop("onValueChange")?.({ value });
        }
      })),
      previousValue: bindable(() => ({
        defaultValue: ""
      }))
    };
  },
  watch({ track, action, context, prop }) {
    track([() => context.get("value")], () => {
      action(["syncInputValue"]);
    });
    track([() => prop("edit")], () => {
      action(["toggleEditing"]);
    });
  },
  computed: {
    submitOnEnter({ prop }) {
      const submitMode = prop("submitMode");
      return submitMode === "both" || submitMode === "enter";
    },
    submitOnBlur({ prop }) {
      const submitMode = prop("submitMode");
      return submitMode === "both" || submitMode === "blur";
    },
    isInteractive({ prop }) {
      return !(prop("disabled") || prop("readOnly"));
    }
  },
  on: {
    "VALUE.SET": {
      actions: ["setValue"]
    }
  },
  states: {
    preview: {
      entry: ["blurInput"],
      on: {
        "CONTROLLED.EDIT": {
          target: "edit",
          actions: ["setPreviousValue", "focusInput"]
        },
        EDIT: [
          {
            guard: "isEditControlled",
            actions: ["invokeOnEdit"]
          },
          {
            target: "edit",
            actions: ["setPreviousValue", "focusInput", "invokeOnEdit"]
          }
        ]
      }
    },
    edit: {
      effects: ["trackInteractOutside"],
      entry: ["syncInputValue"],
      on: {
        "CONTROLLED.PREVIEW": [
          {
            guard: "isSubmitEvent",
            target: "preview",
            actions: ["setPreviousValue", "restoreFocus", "invokeOnSubmit"]
          },
          {
            target: "preview",
            actions: ["revertValue", "restoreFocus", "invokeOnCancel"]
          }
        ],
        CANCEL: [
          {
            guard: "isEditControlled",
            actions: ["invokeOnPreview"]
          },
          {
            target: "preview",
            actions: ["revertValue", "restoreFocus", "invokeOnCancel", "invokeOnPreview"]
          }
        ],
        SUBMIT: [
          {
            guard: "isEditControlled",
            actions: ["invokeOnPreview"]
          },
          {
            target: "preview",
            actions: ["setPreviousValue", "restoreFocus", "invokeOnSubmit", "invokeOnPreview"]
          }
        ]
      }
    }
  },
  implementations: {
    guards: {
      isEditControlled: ({ prop }) => prop("edit") != void 0,
      isSubmitEvent: ({ event }) => event.previousEvent?.type === "SUBMIT"
    },
    effects: {
      trackInteractOutside({ send, scope, prop, computed }) {
        return trackInteractOutside(getInputEl(scope), {
          exclude(target) {
            const ignore = [getCancelTriggerEl(scope), getSubmitTriggerEl(scope)];
            return ignore.some((el) => contains(el, target));
          },
          onFocusOutside: prop("onFocusOutside"),
          onPointerDownOutside: prop("onPointerDownOutside"),
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
            if (event.defaultPrevented) return;
            const { focusable } = event.detail;
            send({
              type: computed("submitOnBlur") ? "SUBMIT" : "CANCEL",
              src: "interact-outside",
              focusable
            });
          }
        });
      }
    },
    actions: {
      restoreFocus({ event, scope, prop }) {
        if (event.focusable) return;
        raf(() => {
          const finalEl = prop("finalFocusEl")?.() ?? getEditTriggerEl(scope);
          finalEl?.focus({ preventScroll: true });
        });
      },
      clearValue({ context }) {
        context.set("value", "");
      },
      focusInputIfNeeded({ action, prop }) {
        const edit = prop("edit") || prop("defaultEdit");
        if (!edit) return;
        action(["focusInput"]);
      },
      focusInput({ scope, prop }) {
        raf(() => {
          const inputEl = getInputEl(scope);
          if (!inputEl) return;
          if (prop("selectOnFocus")) {
            inputEl.select();
          } else {
            inputEl.focus({ preventScroll: true });
          }
        });
      },
      invokeOnCancel({ prop, context }) {
        const prev = context.get("previousValue");
        prop("onValueRevert")?.({ value: prev });
      },
      invokeOnSubmit({ prop, context }) {
        const value = context.get("value");
        prop("onValueCommit")?.({ value });
      },
      invokeOnEdit({ prop }) {
        prop("onEditChange")?.({ edit: true });
      },
      invokeOnPreview({ prop }) {
        prop("onEditChange")?.({ edit: false });
      },
      toggleEditing({ prop, send, event }) {
        send({
          type: prop("edit") ? "CONTROLLED.EDIT" : "CONTROLLED.PREVIEW",
          previousEvent: event
        });
      },
      syncInputValue({ context, scope }) {
        const inputEl = getInputEl(scope);
        if (!inputEl) return;
        setElementValue(inputEl, context.get("value"));
      },
      setValue({ context, prop, event }) {
        const max = prop("maxLength");
        const value = max != null ? event.value.slice(0, max) : event.value;
        context.set("value", value);
      },
      setPreviousValue({ context }) {
        context.set("previousValue", context.get("value"));
      },
      revertValue({ context }) {
        const value = context.get("previousValue");
        if (!value) return;
        context.set("value", value);
      },
      blurInput({ scope }) {
        getInputEl(scope)?.blur();
      }
    }
  }
});
var props = createProps()([
  "activationMode",
  "autoResize",
  "dir",
  "disabled",
  "finalFocusEl",
  "form",
  "getRootNode",
  "id",
  "ids",
  "invalid",
  "maxLength",
  "name",
  "onEditChange",
  "onFocusOutside",
  "onInteractOutside",
  "onPointerDownOutside",
  "onValueChange",
  "onValueCommit",
  "onValueRevert",
  "placeholder",
  "readOnly",
  "required",
  "selectOnFocus",
  "edit",
  "defaultEdit",
  "submitMode",
  "translations",
  "defaultValue",
  "value"
]);
var splitProps = createSplitProps(props);

// components/editable.ts
var Editable = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="editable"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const areaEl = this.el.querySelector('[data-scope="editable"][data-part="area"]');
    if (areaEl) this.spreadProps(areaEl, this.api.getAreaProps());
    const labelEl = this.el.querySelector(
      '[data-scope="editable"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const inputEl = this.el.querySelector(
      '[data-scope="editable"][data-part="input"]'
    );
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());
    const previewEl = this.el.querySelector(
      '[data-scope="editable"][data-part="preview"]'
    );
    if (previewEl) this.spreadProps(previewEl, this.api.getPreviewProps());
    const editTriggerEl = this.el.querySelector(
      '[data-scope="editable"][data-part="edit-trigger"]'
    );
    if (editTriggerEl) this.spreadProps(editTriggerEl, this.api.getEditTriggerProps());
    const submitTriggerEl = this.el.querySelector(
      '[data-scope="editable"][data-part="submit-trigger"]'
    );
    if (submitTriggerEl) this.spreadProps(submitTriggerEl, this.api.getSubmitTriggerProps());
    const cancelTriggerEl = this.el.querySelector(
      '[data-scope="editable"][data-part="cancel-trigger"]'
    );
    if (cancelTriggerEl) this.spreadProps(cancelTriggerEl, this.api.getCancelTriggerProps());
  }
};

// hooks/editable.ts
var EditableHook = {
  mounted() {
    const el = this.el;
    const value = getString(el, "value");
    const defaultValue = getString(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const placeholder = getString(el, "placeholder");
    const activationMode = getString(el, "activationMode");
    const selectOnFocus = getBoolean(el, "selectOnFocus");
    const zag = new Editable(el, {
      id: el.id,
      ...controlled && value !== void 0 ? { value } : { defaultValue: defaultValue ?? "" },
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      dir: getDir(el),
      ...placeholder !== void 0 ? { placeholder } : {},
      ...activationMode !== void 0 ? { activationMode } : {},
      ...selectOnFocus !== void 0 ? { selectOnFocus } : {},
      ...getBoolean(el, "controlledEdit") ? { edit: getBoolean(el, "edit") } : { defaultEdit: getBoolean(el, "defaultEdit") },
      onValueChange: (details) => {
        const inputEl = el.querySelector('[data-scope="editable"][data-part="input"]');
        if (inputEl) {
          inputEl.value = details.value;
          inputEl.dispatchEvent(new Event("input", { bubbles: true }));
          inputEl.dispatchEvent(new Event("change", { bubbles: true }));
        }
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { value: details.value, id: el.id });
        }
        const clientName = getString(el, "onValueChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      }
    });
    zag.init();
    this.editable = zag;
    this.handlers = [];
  },
  updated() {
    const value = getString(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");
    this.editable?.updateProps({
      id: this.el.id,
      ...controlled && value !== void 0 ? { value } : {},
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      required: getBoolean(this.el, "required"),
      invalid: getBoolean(this.el, "invalid"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form")
    });
  },
  destroyed() {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.editable?.destroy();
  }
};
export {
  EditableHook as Editable
};
