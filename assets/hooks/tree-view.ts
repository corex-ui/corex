import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import type { ExpandedChangeDetails, SelectionChangeDetails } from "@zag-js/tree-view";
import { TreeView, type TreeNode } from "../components/tree-view";
import { getString, getBoolean, getStringList, getDir, canPushEvent } from "../lib/util";
import {
  readHeightAnimationOptions,
  prepareInitialHeightState,
  runOpenStateTransitionsHeight,
} from "../lib/animation";
import { performRedirect, readDomItemRedirect } from "../lib/redirect";
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
import {
  type TreeViewExpandedChangedDetail,
  type TreeViewSelectionChangedDetail,
  diffStringValues,
} from "../lib/event-details";

type TreeViewHookState = {
  treeView?: TreeView;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  lastDataTree?: string;
  lastExpanded?: string[];
  lastSelected?: string[];
  lastExpandedAttr?: string;
  lastSelectedAttr?: string;
  previousExpanded?: string[];
};

function readExpandedAttr(el: HTMLElement): string {
  return getBoolean(el, "controlled")
    ? (el.getAttribute("data-expanded-value") ?? "")
    : (el.getAttribute("data-default-expanded-value") ?? "");
}

function readSelectedAttr(el: HTMLElement): string {
  return getBoolean(el, "controlled")
    ? (el.getAttribute("data-selected-value") ?? "")
    : (el.getAttribute("data-default-selected-value") ?? "");
}

function parseRootNode(el: HTMLElement): TreeNode {
  const raw = el.dataset.tree;
  if (raw == null || raw === "") {
    throw new Error("TreeView: missing data-tree");
  }
  return JSON.parse(raw) as TreeNode;
}

const TreeViewHook: Hook<object & TreeViewHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TreeViewHookState) {
    const el = this.el;
    const self = this as object & HookInterface<HTMLElement> & TreeViewHookState;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const rootNode = parseRootNode(el);
    this.lastDataTree = el.dataset.tree;

    const controlled = getBoolean(el, "controlled");
    self.lastExpanded = controlled
      ? (getStringList(el, "expandedValue") ?? [])
      : (getStringList(el, "defaultExpandedValue") ?? []);
    self.lastSelected = controlled
      ? (getStringList(el, "selectedValue") ?? [])
      : (getStringList(el, "defaultSelectedValue") ?? []);
    self.lastExpandedAttr = readExpandedAttr(el);
    self.lastSelectedAttr = readSelectedAttr(el);

    const treeView = new TreeView(el, {
      id: el.id,
      rootNode,
      ...(controlled
        ? {
            expandedValue: getStringList(el, "expandedValue") ?? [],
            selectedValue: getStringList(el, "selectedValue") ?? [],
          }
        : {
            defaultExpandedValue: getStringList(el, "defaultExpandedValue") ?? [],
            defaultSelectedValue: getStringList(el, "defaultSelectedValue") ?? [],
          }),
      selectionMode: getString<"single" | "multiple">(el, "selectionMode") ?? "single",
      typeahead: el.dataset.typeahead !== "false",
      dir: getDir(el),
      onSelectionChange: (details: SelectionChangeDetails) => {
        const redirectOn = getBoolean(el, "redirect");
        const value = details.selectedValue?.length ? details.selectedValue[0] : undefined;
        const itemEl = value
          ? el.querySelector<HTMLElement>(
              `[data-scope="tree-view"][data-part="item"][data-value="${CSS.escape(value)}"]`
            )
          : null;
        const isItem = !!itemEl;

        if (redirectOn && isItem) {
          performRedirect(readDomItemRedirect(itemEl, value), { liveSocket: this.liveSocket });
        }

        const next = details.selectedValue ?? [];
        const previousSelectedValue = self.lastSelected ?? [];
        const { added, removed } = diffStringValues(next, previousSelectedValue);
        self.lastSelected = next;

        const payload: TreeViewSelectionChangedDetail = {
          id: el.id,
          selectedValue: next,
          previousSelectedValue,
          added,
          removed,
          focusedValue: details.focusedValue,
          isItem,
        };

        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: payload as unknown as Record<string, unknown>,
          serverEventName: getString(el, "onSelectionChange"),
          clientEventName: getString(el, "onSelectionChangeClient"),
        });
      },
      onExpandedChange: (details: ExpandedChangeDetails) => {
        const next = details.expandedValue ?? [];
        const previousExpandedValue = self.lastExpanded ?? [];
        const { added, removed } = diffStringValues(next, previousExpandedValue);
        self.lastExpanded = next;

        const payload: TreeViewExpandedChangedDetail = {
          id: el.id,
          expandedValue: next,
          previousExpandedValue,
          added,
          removed,
          focusedValue: details.focusedValue,
        };

        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: payload as unknown as Record<string, unknown>,
          serverEventName: getString(el, "onExpandedChange"),
          clientEventName: getString(el, "onExpandedChangeClient"),
        });

        if (el.dataset.animation === "js") {
          runOpenStateTransitionsHeight({
            rootEl: el,
            selector: '[data-scope="tree-view"][data-part="branch-content"]',
            opts: readHeightAnimationOptions(el),
            isOpen: (contentEl) => {
              const value = contentEl.dataset.value;
              return !!value && next.includes(value);
            },
          });
        }
      },
    });
    treeView.init();
    this.treeView = treeView;

    if (el.dataset.animation === "js") {
      const opts = readHeightAnimationOptions(el);
      prepareInitialHeightState(el, '[data-scope="tree-view"][data-part="branch-content"]', opts);
    }

    const emitSelectedValue = (respondTo: RespondTo) => {
      const value = treeView.api.selectedValue;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "tree_view_value_response",
        serverPayload: { id: el.id, value } as Record<string, unknown>,
        el,
        domEventName: "tree-view-value",
        domDetail: { id: el.id, value } as Record<string, unknown>,
      });
    };

    const emitExpandedValue = (respondTo: RespondTo) => {
      const value = treeView.api.expandedValue;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "tree_view_expanded_value_response",
        serverPayload: { id: el.id, value } as Record<string, unknown>,
        el,
        domEventName: "tree-view-expanded-value",
        domDetail: { id: el.id, value } as Record<string, unknown>,
      });
    };

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: string[] }>>(
      "corex:tree-view:set-expanded-value",
      (event) => {
        treeView.api.setExpandedValue(event.detail.value);
      }
    );

    domRegistry.add<CustomEvent<{ value: string[] }>>(
      "corex:tree-view:set-selected-value",
      (event) => {
        treeView.api.setSelectedValue(event.detail.value);
      }
    );

    domRegistry.add<CustomEvent>("corex:tree-view:value", (event) => {
      emitSelectedValue(parseRespondTo(event.detail));
    });

    domRegistry.add<CustomEvent>("corex:tree-view:expanded-value", (event) => {
      emitExpandedValue(parseRespondTo(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add(
      "tree_view_set_expanded_value",
      (payload: { tree_view_id?: string; value: string[] }) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        treeView.api.setExpandedValue(payload.value);
      }
    );

    registry.add(
      "tree_view_set_selected_value",
      (payload: { tree_view_id?: string; value: string[] }) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        treeView.api.setSelectedValue(payload.value);
      }
    );

    registry.add("tree_view_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitSelectedValue(parseRespondTo(payload));
    });

    registry.add("tree_view_expanded_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitExpandedValue(parseRespondTo(payload));
    });
  },

  beforeUpdate(this: object & HookInterface<HTMLElement> & TreeViewHookState) {
    if (getBoolean(this.el, "controlled") && this.el.dataset.animation === "js") {
      this.previousExpanded = getStringList(this.el, "expandedValue") ?? [];
    }
  },

  updated(this: object & HookInterface<HTMLElement> & TreeViewHookState) {
    const el = this.el;
    const tv = this.treeView;
    if (!tv) return;

    const rawTree = el.dataset.tree;
    if (rawTree != null && rawTree !== this.lastDataTree) {
      this.lastDataTree = rawTree;
      tv.replaceRootNode(parseRootNode(el));
    }

    const controlled = getBoolean(el, "controlled");
    const selected = controlled
      ? (getStringList(el, "selectedValue") ?? [])
      : (getStringList(el, "defaultSelectedValue") ?? []);
    const expanded = controlled
      ? (getStringList(el, "expandedValue") ?? [])
      : (getStringList(el, "defaultExpandedValue") ?? []);

    const selectionMode = getString<"single" | "multiple">(el, "selectionMode") ?? "single";
    const typeahead = el.dataset.typeahead !== "false";
    const dir = getDir(el);

    const expandedAttr = readExpandedAttr(el);
    const selectedAttr = readSelectedAttr(el);
    const expandedAttrChanged = expandedAttr !== this.lastExpandedAttr;
    const selectedAttrChanged = selectedAttr !== this.lastSelectedAttr;
    this.lastExpandedAttr = expandedAttr;
    this.lastSelectedAttr = selectedAttr;

    if (controlled) {
      const prevExpanded = this.previousExpanded ?? this.lastExpanded ?? [];
      this.previousExpanded = undefined;
      if (expandedAttrChanged) this.lastExpanded = expanded;
      if (selectedAttrChanged) this.lastSelected = selected;
      if (el.dataset.animation === "js") {
        runOpenStateTransitionsHeight({
          rootEl: el,
          selector: '[data-scope="tree-view"][data-part="branch-content"]',
          opts: readHeightAnimationOptions(el),
          wasOpen: (contentEl) => {
            const value = contentEl.dataset.value;
            return !!value && prevExpanded.includes(value);
          },
          isOpen: (contentEl) => {
            const value = contentEl.dataset.value;
            return !!value && expanded.includes(value);
          },
        });
      }
      tv.updateProps({
        expandedValue: expanded,
        selectedValue: selected,
        selectionMode,
        typeahead,
        dir,
      });
    } else {
      tv.updateProps({
        selectionMode,
        typeahead,
        dir,
      });
      if (expandedAttrChanged) tv.api.setExpandedValue(expanded);
      if (selectedAttrChanged) tv.api.setSelectedValue(selected);
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & TreeViewHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.treeView?.destroy();
  },
};

export { TreeViewHook as TreeView };
