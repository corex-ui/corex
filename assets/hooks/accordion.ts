import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Accordion } from "../components/accordion";
import type { ValueChangeDetails, FocusChangeDetails, Props, ItemProps } from "@zag-js/accordion";
import type { Orientation } from "@zag-js/types";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import {
  parseDatasetValueList,
  readControlledOrDefaultStringList,
  readStringListControlledZagProps,
  readStringListControlledZagUpdate,
} from "../lib/read-props";
import {
  closestPartValue,
  isJsAnimation,
  prepareJsHeightInitialState,
  runHeightOpenTransition,
} from "../lib/animation";
import {
  parseRespondTo,
  createValueEmitter,
  emitResponse,
  idMatches,
  readPayloadId,
  notifyChange,
  type RespondTo,
} from "../lib/respond-to";
import { type AccordionChangedDetail, diffStringValues } from "../lib/event-details";
import { createZagLiveHook } from "../lib/zag-live-hook";

type AccordionHookState = {
  accordion?: Accordion;
  lastValue?: string[];
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

const AccordionHook = createZagLiveHook<AccordionHookState, Accordion>({
  key: "accordion",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const self = hook as object & HookInterface<HTMLElement> & AccordionHookState;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

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
          runHeightOpenTransition({
            el,
            selector: ITEM_CONTENT_SELECTOR,
            prevOpen: previousValue,
            nextOpen: next,
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

    prepareJsHeightInitialState(el, ITEM_CONTENT_SELECTOR);

    const hookApi = { el, pushEvent, canPushServer: canPush };

    const emitValue = createValueEmitter(hookApi, {
      getValue: () => accordion.api.value,
      serverEventName: "accordion_value_response",
      domEventName: "accordion-value",
    });

    const emitFocusedValue = createValueEmitter(hookApi, {
      getValue: () => accordion.api.focusedValue,
      serverEventName: "accordion_focused_response",
      domEventName: "accordion-focused",
    });

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

    dom.add<CustomEvent<{ value: string[] }>>("corex:accordion:set-value", (event) => {
      accordion.api.setValue(event.detail.value);
    });

    dom.add<CustomEvent>("corex:accordion:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    dom.add<CustomEvent>("corex:accordion:focused", (event) => {
      emitFocusedValue(parseRespondTo(event.detail));
    });

    dom.add<CustomEvent<{ value?: string; disabled?: boolean }>>(
      "corex:accordion:item-state",
      (event) => {
        const d = event.detail;
        const v = d?.value;
        if (typeof v !== "string" || v === "") return;
        emitItemState(v, d?.disabled === true, parseRespondTo(d));
      }
    );

    server.add("accordion_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      accordion.api.setValue(payload.value);
    });

    server.add("accordion_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });

    server.add("accordion_focused", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitFocusedValue(parseRespondTo(payload));
    });

    server.add(
      "accordion_item_state",
      (payload: { id?: string; value?: string; disabled?: boolean; respond_to?: string }) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        if (typeof payload?.value !== "string" || payload.value === "") return;
        emitItemState(payload.value, payload.disabled === true, parseRespondTo(payload));
      }
    );

    return accordion;
  },

  update(hook, accordion) {
    const { el } = hook;
    const layout = readAccordionLayoutProps(el);
    const valuePatch = readStringListControlledZagUpdate(
      el,
      "value",
      "defaultValue",
      hook.beforeAttrs
    );

    if ("value" in valuePatch) {
      const nextValue = valuePatch.value ?? [];
      const prevValue = parseDatasetValueList(hook.beforeAttrs?.value);
      runHeightOpenTransition({
        el,
        selector: ITEM_CONTENT_SELECTOR,
        prevOpen: prevValue,
        nextOpen: nextValue,
        resolveValue: resolveAccordionValue,
      });
      hook.lastValue = nextValue;
    }

    const propsApplied = accordion.updateProps({
      ...layout,
      ...valuePatch,
    } as Props);

    if (!propsApplied) {
      accordion.render();
    }
  },
});

export { AccordionHook as Accordion };
