import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import type { ExpandedChangeDetails, SelectionChangeDetails } from "@zag-js/tree-view";
import { TreeView, type TreeNode } from "../components/tree-view";
import {
  getString,
  getBoolean,
  getStringList,
  getDir,
  canPushEvent,
  safeParseJson,
} from "../lib/util";
import {
  contentDatasetValue,
  prepareJsHeightInitialState,
  runHeightOpenTransition,
} from "../lib/animation";
import { performRedirect, readDomItemRedirect } from "../lib/redirect";
import { createZagLiveHook } from "../lib/zag-live-hook";
import {
  parseRespondTo,
  createValueEmitter,
  idMatches,
  readPayloadId,
  notifyChange,
} from "../lib/respond-to";
import {
  type TreeViewExpandedChangedDetail,
  type TreeViewSelectionChangedDetail,
  diffStringValues,
} from "../lib/event-details";

type TreeViewHookState = {
  treeView?: TreeView;
  lastDataTree?: string;
  lastExpanded?: string[];
  lastSelected?: string[];
  lastExpandedAttr?: string;
  lastSelectedAttr?: string;
};

export function readExpandedAttr(el: HTMLElement): string {
  return el.getAttribute("data-default-expanded-value") ?? "";
}

export function readSelectedAttr(el: HTMLElement): string {
  return el.getAttribute("data-default-selected-value") ?? "";
}

export function parseRootNode(el: HTMLElement): TreeNode {
  const raw = el.dataset.tree;
  const empty: TreeNode = { value: "", name: "", children: [] };
  if (raw == null || raw === "") {
    console.error("TreeView: missing data-tree");
    return empty;
  }
  return safeParseJson<TreeNode>(raw, empty);
}

const BRANCH_CONTENT_SELECTOR = '[data-scope="tree-view"][data-part="branch-content"]';

export function readTreeViewInteractionProps(el: HTMLElement) {
  return {
    selectionMode: getString<"single" | "multiple">(el, "selectionMode") ?? "single",
    typeahead: el.dataset.typeahead !== "false",
    dir: getDir(el),
  };
}

const TreeViewHook = createZagLiveHook<TreeViewHookState, TreeView>({
  key: "treeView",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const self = hook as object & HookInterface<HTMLElement> & TreeViewHookState;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const rootNode = parseRootNode(el);
    hook.lastDataTree = el.dataset.tree;

    self.lastExpanded = getStringList(el, "defaultExpandedValue") ?? [];
    self.lastSelected = getStringList(el, "defaultSelectedValue") ?? [];
    self.lastExpandedAttr = readExpandedAttr(el);
    self.lastSelectedAttr = readSelectedAttr(el);

    const treeView = new TreeView(el, {
      id: el.id,
      rootNode,
      defaultExpandedValue: getStringList(el, "defaultExpandedValue") ?? [],
      defaultSelectedValue: getStringList(el, "defaultSelectedValue") ?? [],
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
          performRedirect(readDomItemRedirect(itemEl, value), { liveSocket: hook.liveSocket });
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

        runHeightOpenTransition({
          el,
          selector: BRANCH_CONTENT_SELECTOR,
          prevOpen: previousExpandedValue,
          nextOpen: next,
          resolveValue: contentDatasetValue,
        });
      },
    });

    prepareJsHeightInitialState(el, BRANCH_CONTENT_SELECTOR);

    const hookApi = { el, pushEvent, canPushServer: canPush };

    const emitSelectedValue = createValueEmitter(hookApi, {
      getValue: () => treeView.api.selectedValue,
      serverEventName: "tree_view_value_response",
      domEventName: "tree-view-value",
    });

    const emitExpandedValue = createValueEmitter(hookApi, {
      getValue: () => treeView.api.expandedValue,
      serverEventName: "tree_view_expanded_value_response",
      domEventName: "tree-view-expanded-value",
    });

    dom.add<CustomEvent<{ value: string[] }>>("corex:tree-view:set-expanded-value", (event) => {
      treeView.api.setExpandedValue(event.detail.value);
    });

    dom.add<CustomEvent<{ value: string[] }>>("corex:tree-view:set-selected-value", (event) => {
      treeView.api.setSelectedValue(event.detail.value);
    });

    dom.add<CustomEvent>("corex:tree-view:value", (event) => {
      emitSelectedValue(parseRespondTo(event.detail));
    });

    dom.add<CustomEvent>("corex:tree-view:expanded-value", (event) => {
      emitExpandedValue(parseRespondTo(event.detail));
    });

    server.add(
      "tree_view_set_expanded_value",
      (payload: { tree_view_id?: string; value: string[] }) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        treeView.api.setExpandedValue(payload.value);
      }
    );

    server.add(
      "tree_view_set_selected_value",
      (payload: { tree_view_id?: string; value: string[] }) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        treeView.api.setSelectedValue(payload.value);
      }
    );

    server.add("tree_view_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitSelectedValue(parseRespondTo(payload));
    });

    server.add("tree_view_expanded_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitExpandedValue(parseRespondTo(payload));
    });

    return treeView;
  },

  update(hook, treeView) {
    const { el } = hook;
    const tv = treeView;
    if (!tv) return;

    const rawTree = el.dataset.tree;
    if (rawTree != null && rawTree !== hook.lastDataTree) {
      hook.lastDataTree = rawTree;
      tv.replaceRootNode(parseRootNode(el));
    }

    const interaction = readTreeViewInteractionProps(el);
    const selected = getStringList(el, "defaultSelectedValue") ?? [];
    const expanded = getStringList(el, "defaultExpandedValue") ?? [];

    const expandedAttr = readExpandedAttr(el);
    const selectedAttr = readSelectedAttr(el);
    const expandedAttrChanged = expandedAttr !== hook.lastExpandedAttr;
    const selectedAttrChanged = selectedAttr !== hook.lastSelectedAttr;
    hook.lastExpandedAttr = expandedAttr;
    hook.lastSelectedAttr = selectedAttr;

    tv.updateProps(interaction);
    if (expandedAttrChanged) tv.api.setExpandedValue(expanded);
    if (selectedAttrChanged) tv.api.setSelectedValue(selected);
  },
});

export { TreeViewHook as TreeView };
