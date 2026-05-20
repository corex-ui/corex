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
  closestPartValue,
  isJsAnimation,
  prepareJsHeightInitialState,
  runHeightOpenToValues,
  runHeightOpenTransition,
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

const ITEM_CONTENT_SELECTOR = '[data-scope="accordion"][data-part="item-content"]';
const ITEM_SELECTOR = '[data-scope="accordion"][data-part="item"]';
const resolveAccordionValue = closestPartValue(ITEM_SELECTOR);

export function readAccordionLayoutProps(el: HTMLElement) {
  return {
    id: el.id,
    collapsible: getBoolean(el, "collapsible"),
    multiple: getBoolean(el, "multiple"),
    orientation: getString<Orientation>(el, "orientation"),
    dir: getDir(el),
  };
}

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

        if (isJsAnimation(el) && !getBoolean(el, "controlled")) {
          runHeightOpenToValues({
            el,
            selector: ITEM_CONTENT_SELECTOR,
            openValues: next,
            resolveValue: resolveAccordionValue,
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

    prepareJsHeightInitialState(el, ITEM_CONTENT_SELECTOR);

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
    const { el } = this;
    if (getBoolean(el, "controlled") && isJsAnimation(el)) {
      this.previousValue = getStringList(el, "value") ?? [];
    }
  },

  updated(this: object & HookInterface<HTMLElement> & AccordionHookState) {
    const { el } = this;
    const layout = readAccordionLayoutProps(el);

    if (!getBoolean(el, "controlled")) {
      this.accordion?.updateProps(layout as Props);
      return;
    }

    const nextValue = getStringList(el, "value") ?? [];
    const prevValue = this.previousValue ?? this.lastValue ?? [];

    this.previousValue = undefined;
    this.lastValue = nextValue;

    runHeightOpenTransition({
      el,
      selector: ITEM_CONTENT_SELECTOR,
      prevOpen: prevValue,
      nextOpen: nextValue,
      resolveValue: resolveAccordionValue,
    });

    this.accordion?.updateProps({ ...layout, value: nextValue } as Props);
  },

  destroyed(this: object & HookInterface<HTMLElement> & AccordionHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.accordion?.destroy();
  },
};

export { AccordionHook as Accordion };
