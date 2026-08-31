import {
  idMatches,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  canPushEvent,
  createMachine,
  createZagLiveHook,
  dataAttr,
  dispatchInputValueEvent,
  getBoolean,
  getDir,
  getEventKey,
  getEventPoint,
  getNumber,
  getRelativePoint,
  getString,
  isLeftClick,
  mergeWithDefault,
  query,
  raf,
  trackFormControl
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+rating-group@1.43.3/node_modules/@zag-js/rating-group/dist/rating-group.anatomy.mjs
var anatomy = createAnatomy("rating-group").parts("root", "label", "item", "control");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+rating-group@1.43.3/node_modules/@zag-js/rating-group/dist/rating-group.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `rating:${ctx.id}`;
var getLabelId = (ctx) => ctx.ids?.label ?? `rating:${ctx.id}:label`;
var getHiddenInputId = (ctx) => ctx.ids?.hiddenInput ?? `rating:${ctx.id}:input`;
var getControlId = (ctx) => ctx.ids?.control ?? `rating:${ctx.id}:control`;
var getItemId = (ctx, id) => ctx.ids?.item?.(id) ?? `rating:${ctx.id}:item:${id}`;
var getControlEl = (ctx) => ctx.getById(getControlId(ctx));
var getRadioEl = (ctx, value) => {
  const selector = `[role=radio][aria-posinset='${Math.ceil(value)}']`;
  return query(getControlEl(ctx), selector);
};
var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
var dispatchChangeEvent = (ctx, value) => {
  const inputEl = getHiddenInputEl(ctx);
  if (!inputEl) return;
  dispatchInputValueEvent(inputEl, { value });
};

// ../node_modules/.pnpm/@zag-js+rating-group@1.43.3/node_modules/@zag-js/rating-group/dist/rating-group.connect.mjs
var defaultTranslations = {
  ratingValueText: (index) => `${index} stars`
};
function connect(service, normalize) {
  const { context, send, prop, scope, computed } = service;
  const interactive = computed("isInteractive");
  const disabled = computed("isDisabled");
  const readOnly = !!prop("readOnly");
  const required = !!prop("required");
  const value = context.get("value");
  const hoveredValue = context.get("hoveredValue");
  const translations = mergeWithDefault(defaultTranslations, prop("translations"));
  function getItemState(props) {
    const currentValue = computed("isHovering") ? hoveredValue : value;
    const equal = Math.ceil(currentValue) === props.index;
    const highlighted = props.index <= currentValue || equal;
    const half = equal && Math.abs(currentValue - props.index) === 0.5;
    return {
      highlighted,
      half,
      checked: equal || value <= 0 && props.index === 1
    };
  }
  return {
    hovering: computed("isHovering"),
    value,
    hoveredValue,
    count: prop("count"),
    items: Array.from({ length: prop("count") }).map((_, index) => index + 1),
    setValue(value2) {
      send({ type: "SET_VALUE", value: value2 });
    },
    clearValue() {
      send({ type: "CLEAR_VALUE" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        id: getRootId(scope)
      });
    },
    getHiddenInputProps() {
      return normalize.input({
        name: prop("name"),
        form: prop("form"),
        type: "text",
        hidden: true,
        disabled,
        readOnly,
        required: prop("required"),
        id: getHiddenInputId(scope),
        defaultValue: value
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        dir: prop("dir"),
        id: getLabelId(scope),
        "data-disabled": dataAttr(disabled),
        "data-required": dataAttr(required),
        htmlFor: getHiddenInputId(scope),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          event.preventDefault();
          const radioEl = getRadioEl(scope, Math.max(1, context.get("value")));
          radioEl?.focus({ preventScroll: true });
        }
      });
    },
    getControlProps() {
      return normalize.element({
        id: getControlId(scope),
        ...parts.control.attrs,
        dir: prop("dir"),
        role: "radiogroup",
        "aria-orientation": "horizontal",
        "aria-labelledby": getLabelId(scope),
        "aria-readonly": ariaAttr(readOnly),
        "data-readonly": dataAttr(readOnly),
        "data-disabled": dataAttr(disabled),
        onPointerMove(event) {
          if (!interactive) return;
          if (event.pointerType === "touch") return;
          send({ type: "GROUP_POINTER_OVER" });
        },
        onPointerLeave(event) {
          if (!interactive) return;
          if (event.pointerType === "touch") return;
          send({ type: "GROUP_POINTER_LEAVE" });
        }
      });
    },
    getItemState,
    getItemProps(props) {
      const { index } = props;
      const itemState = getItemState(props);
      const valueText = translations.ratingValueText(index);
      return normalize.element({
        ...parts.item.attrs,
        dir: prop("dir"),
        id: getItemId(scope, index.toString()),
        role: "radio",
        tabIndex: (() => {
          if (readOnly) return itemState.checked ? 0 : void 0;
          if (disabled) return void 0;
          return itemState.checked ? 0 : -1;
        })(),
        "aria-roledescription": "rating",
        "aria-label": valueText,
        "aria-disabled": disabled,
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "aria-setsize": prop("count"),
        "aria-checked": itemState.checked,
        "data-checked": dataAttr(itemState.checked),
        "aria-posinset": index,
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-half": dataAttr(itemState.half),
        onPointerDown(event) {
          if (!interactive) return;
          if (!isLeftClick(event)) return;
          event.preventDefault();
        },
        onPointerMove(event) {
          if (!interactive) return;
          const point = getEventPoint(event);
          const relativePoint = getRelativePoint(point, event.currentTarget);
          const percentX = relativePoint.getPercentValue({
            orientation: "horizontal",
            dir: prop("dir")
          });
          const isMidway = percentX < 0.5;
          send({ type: "POINTER_OVER", index, isMidway });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          const keyMap = {
            ArrowLeft() {
              send({ type: "ARROW_LEFT" });
            },
            ArrowRight() {
              send({ type: "ARROW_RIGHT" });
            },
            ArrowUp() {
              send({ type: "ARROW_LEFT" });
            },
            ArrowDown() {
              send({ type: "ARROW_RIGHT" });
            },
            Space() {
              send({ type: "SPACE", value: index });
            },
            Home() {
              send({ type: "HOME" });
            },
            End() {
              send({ type: "END" });
            }
          };
          const key = getEventKey(event, { dir: prop("dir") });
          const exec = keyMap[key];
          if (exec) {
            event.preventDefault();
            exec(event);
          }
        },
        onClick() {
          if (!interactive) return;
          send({ type: "CLICK", value: index });
        },
        onFocus() {
          if (!interactive) return;
          send({ type: "FOCUS" });
        },
        onBlur() {
          if (!interactive) return;
          send({ type: "BLUR" });
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+rating-group@1.43.3/node_modules/@zag-js/rating-group/dist/rating-group.machine.mjs
var machine = createMachine({
  props({ props }) {
    return {
      name: "rating",
      count: 5,
      dir: "ltr",
      defaultValue: -1,
      ...props
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable }) {
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        onChange(value) {
          prop("onValueChange")?.({ value });
        }
      })),
      hoveredValue: bindable(() => ({
        defaultValue: -1,
        onChange(value) {
          prop("onHoverChange")?.({ hoveredValue: value });
        }
      })),
      fieldsetDisabled: bindable(() => ({
        defaultValue: false
      }))
    };
  },
  watch({ track, action, prop, context }) {
    track([() => prop("allowHalf")], () => {
      action(["roundValueIfNeeded"]);
    });
    track([() => context.get("value")], () => {
      action(["dispatchChangeEvent"]);
    });
  },
  computed: {
    isDisabled: ({ context, prop }) => !!prop("disabled") || context.get("fieldsetDisabled"),
    isInteractive: ({ computed, prop }) => !(computed("isDisabled") || prop("readOnly")),
    isHovering: ({ context }) => context.get("hoveredValue") > -1
  },
  effects: ["trackFormControlState"],
  on: {
    SET_VALUE: {
      actions: ["setValue"]
    },
    CLEAR_VALUE: {
      actions: ["clearValue"]
    }
  },
  states: {
    idle: {
      entry: ["clearHoveredValue"],
      on: {
        GROUP_POINTER_OVER: {
          target: "hover"
        },
        FOCUS: {
          target: "focus"
        },
        CLICK: {
          actions: ["setValue", "focusActiveRadio"]
        }
      }
    },
    focus: {
      on: {
        POINTER_OVER: {
          actions: ["setHoveredValue"]
        },
        GROUP_POINTER_LEAVE: {
          actions: ["clearHoveredValue"]
        },
        BLUR: {
          target: "idle"
        },
        SPACE: {
          guard: "isValueEmpty",
          actions: ["setValue"]
        },
        CLICK: {
          actions: ["setValue", "focusActiveRadio"]
        },
        ARROW_LEFT: {
          actions: ["setPrevValue", "focusActiveRadio"]
        },
        ARROW_RIGHT: {
          actions: ["setNextValue", "focusActiveRadio"]
        },
        HOME: {
          actions: ["setValueToMin", "focusActiveRadio"]
        },
        END: {
          actions: ["setValueToMax", "focusActiveRadio"]
        }
      }
    },
    hover: {
      on: {
        POINTER_OVER: {
          actions: ["setHoveredValue"]
        },
        GROUP_POINTER_LEAVE: [
          {
            guard: "isRadioFocused",
            target: "focus",
            actions: ["clearHoveredValue"]
          },
          {
            target: "idle",
            actions: ["clearHoveredValue"]
          }
        ],
        CLICK: {
          actions: ["setValue", "focusActiveRadio"]
        }
      }
    }
  },
  implementations: {
    guards: {
      isInteractive: ({ prop }) => !(prop("disabled") || prop("readOnly")),
      isHoveredValueEmpty: ({ context }) => context.get("hoveredValue") === -1,
      isValueEmpty: ({ context }) => context.get("value") <= 0,
      isRadioFocused: ({ scope }) => !!getControlEl(scope)?.contains(scope.getActiveElement())
    },
    effects: {
      trackFormControlState({ context, scope }) {
        return trackFormControl(getHiddenInputEl(scope), {
          onFieldsetDisabledChange(disabled) {
            context.set("fieldsetDisabled", disabled);
          },
          onFormReset() {
            context.set("value", context.initial("value"));
          }
        });
      }
    },
    actions: {
      clearHoveredValue({ context }) {
        context.set("hoveredValue", -1);
      },
      focusActiveRadio({ scope, context }) {
        raf(() => getRadioEl(scope, context.get("value"))?.focus());
      },
      setPrevValue({ context, prop }) {
        const factor = prop("allowHalf") ? 0.5 : 1;
        context.set("value", Math.max(0, context.get("value") - factor));
      },
      setNextValue({ context, prop }) {
        const factor = prop("allowHalf") ? 0.5 : 1;
        const value = context.get("value") === -1 ? 0 : context.get("value");
        context.set("value", Math.min(prop("count"), value + factor));
      },
      setValueToMin({ context }) {
        context.set("value", 1);
      },
      setValueToMax({ context, prop }) {
        context.set("value", prop("count"));
      },
      setValue({ context, event }) {
        const hoveredValue = context.get("hoveredValue");
        const value = hoveredValue === -1 ? event.value : hoveredValue;
        context.set("value", value);
      },
      clearValue({ context }) {
        context.set("value", -1);
      },
      setHoveredValue({ context, prop, event }) {
        const half = prop("allowHalf") && event.isMidway;
        const factor = half ? 0.5 : 0;
        context.set("hoveredValue", event.index - factor);
      },
      roundValueIfNeeded({ context, prop }) {
        if (prop("allowHalf")) return;
        context.set("value", Math.round(context.get("value")));
      },
      dispatchChangeEvent({ context, scope }) {
        dispatchChangeEvent(scope, context.get("value"));
      }
    }
  }
});

// components/rating-group.ts
var RatingGroup = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const root = this.el.querySelector('[data-scope="rating-group"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    const control = this.el.querySelector('[data-part="control"]');
    if (control) this.spreadProps(control, this.api.getControlProps());
    this.el.querySelectorAll('[data-part="item"]').forEach((item) => {
      const index = Number(item.dataset.index);
      this.spreadProps(item, this.api.getItemProps({ index }));
    });
    const hidden = this.el.querySelector('[data-part="hidden-input"]');
    if (hidden) this.spreadProps(hidden, this.api.getHiddenInputProps());
  }
};

// hooks/rating-group.ts
function ratingGroupProps(el, hook) {
  const onValueChange = (details) => {
    const eventName = getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.value });
    }
    const client = getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, { bubbles: true, detail: { id: el.id, value: details.value } })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    name: getString(el, "name"),
    count: getNumber(el, "count") ?? 5,
    defaultValue: getNumber(el, "value"),
    allowHalf: getBoolean(el, "allowHalf"),
    disabled: getBoolean(el, "disabled"),
    readOnly: getBoolean(el, "readonly"),
    onValueChange
  };
}
var RatingGroupHook = createZagLiveHook({
  key: "rating-group",
  mount(hook, { dom, server }) {
    const inst = new RatingGroup(hook.el, ratingGroupProps(hook.el, hook));
    dom.add("corex:rating-group:set-value", (event) => {
      inst.api.setValue(event.detail.value);
    });
    server.add("rating_group_set_value", (payload) => {
      if (!idMatches(hook.el.id, readPayloadId(payload))) return;
      inst.api.setValue(payload.value);
    });
    return inst;
  },
  update(hook, inst) {
    inst.updateProps(ratingGroupProps(hook.el, hook));
  }
});
export {
  RatingGroupHook as RatingGroup
};
