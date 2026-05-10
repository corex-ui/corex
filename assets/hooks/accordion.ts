import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Accordion } from "../components/accordion";
import type { ValueChangeDetails, FocusChangeDetails, Props, ItemProps } from "@zag-js/accordion";
import type { Orientation } from "@zag-js/types";

import { getString, getBoolean, getStringList, getDir, canPushEvent } from "../lib/util";
import {
  readControlledOrDefaultStringList,
  readStringListControlledZagProps,
} from "../lib/read-props";
import {
  readHeightAnimationOptions,
  prepareInitialHeightState,
  runOpenStateTransitionsHeight,
} from "../lib/animation";
import {
  parseRespondTo,
  emitResponse,
  idMatches,
  readPayloadId,
  notifyChange,
  type RespondTo,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import { type AccordionChangedDetail, diffStringValues } from "../lib/event-details";

type AccordionHookState = {
  accordion?: Accordion;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  lastValue?: string[];
  previousValue?: string[];
};

const AccordionHook: Hook<object & AccordionHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & AccordionHookState) {
    const el = this.el;
    const self = this as object & HookInterface<HTMLElement> & AccordionHookState;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    self.lastValue = readControlledOrDefaultStringList(el, "value", "defaultValue");

    const accordion = new Accordion(el, {
      id: el.id,
      ...readStringListControlledZagProps(el, "value", "defaultValue"),
      collapsible: getBoolean(el, "collapsible"),
      multiple: getBoolean(el, "multiple"),
      orientation: getString<Orientation>(el, "orientation"),
      dir: getDir(el),
      onValueChange: (details: ValueChangeDetails) => {
        const next = details.value ?? [];
        const previousValue = self.lastValue ?? [];
        const { added, removed } = diffStringValues(next, previousValue);
        self.lastValue = next;

        const payload: AccordionChangedDetail = {
          id: el.id,
          value: next,
          previousValue,
          added,
          removed,
        };

        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: payload as unknown as Record<string, unknown>,
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
        if (el.dataset.animation === "js" && !getBoolean(el, "controlled")) {
          runOpenStateTransitionsHeight({
            rootEl: el,
            selector: '[data-scope="accordion"][data-part="item-content"]',
            opts: readHeightAnimationOptions(el),
            isOpen: (contentEl) => {
              const itemEl = contentEl.closest<HTMLElement>(
                '[data-scope="accordion"][data-part="item"]'
              );
              const value = itemEl?.dataset.value;
              return !!value && next.includes(value);
            },
          });
        }
      },

      onFocusChange: (details: FocusChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, value: details.value ?? null } as Record<string, unknown>,
          serverEventName: getString(el, "onFocusChange"),
          clientEventName: getString(el, "onFocusChangeClient"),
        });
      },
    } as Props);
    accordion.init();
    this.accordion = accordion;

    if (el.dataset.animation === "js") {
      const opts = readHeightAnimationOptions(el);
      prepareInitialHeightState(el, '[data-scope="accordion"][data-part="item-content"]', opts);
    }

    const emitValue = (respondTo: RespondTo) => {
      const value = accordion.api.value;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "accordion_value_response",
        serverPayload: { id: el.id, value } as Record<string, unknown>,
        el,
        domEventName: "accordion-value",
        domDetail: { id: el.id, value } as Record<string, unknown>,
      });
    };

    const emitFocusedValue = (respondTo: RespondTo) => {
      const value = accordion.api.focusedValue;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "accordion_focused_response",
        serverPayload: { id: el.id, value } as Record<string, unknown>,
        el,
        domEventName: "accordion-focused",
        domDetail: { id: el.id, value } as Record<string, unknown>,
      });
    };

    const emitItemState = (itemValue: string, disabled: boolean, respondTo: RespondTo) => {
      const props: ItemProps = { value: itemValue, disabled };
      const state = accordion.api.getItemState(props);
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "accordion_item_state_response",
        serverPayload: {
          id: el.id,
          value: itemValue,
          state: {
            expanded: state.expanded,
            focused: state.focused,
            disabled: state.disabled,
          },
        } as Record<string, unknown>,
        el,
        domEventName: "accordion-item-state",
        domDetail: { id: el.id, value: itemValue, state } as Record<string, unknown>,
      });
    };

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: string[] }>>("corex:accordion:set-value", (event) => {
      accordion.api.setValue(event.detail.value);
    });

    domRegistry.add<CustomEvent>("corex:accordion:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    domRegistry.add<CustomEvent>("corex:accordion:focused", (event) => {
      emitFocusedValue(parseRespondTo(event.detail));
    });

    domRegistry.add<CustomEvent<{ value?: string; disabled?: boolean }>>(
      "corex:accordion:item-state",
      (event) => {
        const d = event.detail;
        const v = d?.value;
        if (typeof v !== "string" || v === "") return;
        emitItemState(v, d?.disabled === true, parseRespondTo(d));
      }
    );

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("accordion_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      accordion.api.setValue(payload.value);
    });

    registry.add("accordion_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });

    registry.add("accordion_focused", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitFocusedValue(parseRespondTo(payload));
    });

    registry.add(
      "accordion_item_state",
      (payload: { id?: string; value?: string; disabled?: boolean; respond_to?: string }) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        if (typeof payload?.value !== "string" || payload.value === "") return;
        emitItemState(payload.value, payload.disabled === true, parseRespondTo(payload));
      }
    );
  },

  beforeUpdate(this: object & HookInterface<HTMLElement> & AccordionHookState) {
    if (getBoolean(this.el, "controlled") && this.el.dataset.animation === "js") {
      this.previousValue = getStringList(this.el, "value") ?? [];
    }
  },

  updated(this: object & HookInterface<HTMLElement> & AccordionHookState) {
    const controlled = getBoolean(this.el, "controlled");
    if (controlled) {
      const nextValue = getStringList(this.el, "value") ?? [];
      const prevValue = this.previousValue ?? this.lastValue ?? [];
      this.previousValue = undefined;
      this.lastValue = nextValue;
      if (this.el.dataset.animation === "js") {
        runOpenStateTransitionsHeight({
          rootEl: this.el,
          selector: '[data-scope="accordion"][data-part="item-content"]',
          opts: readHeightAnimationOptions(this.el),
          wasOpen: (contentEl) => {
            const itemEl = contentEl.closest<HTMLElement>(
              '[data-scope="accordion"][data-part="item"]'
            );
            const value = itemEl?.dataset.value;
            return !!value && prevValue.includes(value);
          },
          isOpen: (contentEl) => {
            const itemEl = contentEl.closest<HTMLElement>(
              '[data-scope="accordion"][data-part="item"]'
            );
            const value = itemEl?.dataset.value;
            return !!value && nextValue.includes(value);
          },
        });
      }
    }

    this.accordion?.updateProps({
      id: this.el.id,
      ...readStringListControlledZagProps(this.el, "value", "defaultValue"),
      collapsible: getBoolean(this.el, "collapsible"),
      multiple: getBoolean(this.el, "multiple"),
      orientation: getString<Orientation>(this.el, "orientation"),
      dir: getDir(this.el),
    } as Props);
  },

  destroyed(this: object & HookInterface<HTMLElement> & AccordionHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.accordion?.destroy();
  },
};

export { AccordionHook as Accordion };
