import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { TreeView } from "../components/tree-view";
import { getString, getBoolean, getStringList, getDir } from "../lib/util";

type TreeViewHookState = {
  treeView?: TreeView;
  handlers?: Array<CallbackRef>;
  onSetExpandedValue?: (event: Event) => void;
  onSetSelectedValue?: (event: Event) => void;
};

const TreeViewHook: Hook<object & TreeViewHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TreeViewHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const treeView = new TreeView(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? {
            expandedValue: getStringList(el, "expandedValue"),
            selectedValue: getStringList(el, "selectedValue"),
          }
        : {
            defaultExpandedValue: getStringList(el, "defaultExpandedValue"),
            defaultSelectedValue: getStringList(el, "defaultSelectedValue"),
          }),
      selectionMode:
        getString<"single" | "multiple">(el, "selectionMode", ["single", "multiple"]) ?? "single",
      dir: getDir(el),
      onSelectionChange: (details) => {
        const redirect = getBoolean(el, "redirect");
        const value = details.selectedValue?.length ? details.selectedValue[0] : undefined;
        const itemEl = [
          ...el.querySelectorAll<HTMLElement>(
            '[data-scope="tree-view"][data-part="item"], [data-scope="tree-view"][data-part="branch"]'
          ),
        ].find((node) => node.getAttribute("data-value") === value);
        const isItem = itemEl?.getAttribute("data-part") === "item";
        const itemRedirect = itemEl?.getAttribute("data-redirect");
        const itemNewTab = itemEl?.hasAttribute("data-new-tab");
        const doRedirect =
          redirect && value && isItem && this.liveSocket.main.isDead && itemRedirect !== "false";
        if (doRedirect) {
          if (itemNewTab) {
            window.open(value, "_blank", "noopener,noreferrer");
          } else {
            window.location.href = value;
          }
        }
        const eventName = getString(el, "onSelectionChange");
        if (eventName && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            value: { ...details, isItem: isItem ?? false },
          });
        }
      },
      onExpandedChange: (details) => {
        const eventName = getString(el, "onExpandedChange");
        if (eventName && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            value: details,
          });
        }
      },
    });
    treeView.init();
    this.treeView = treeView;

    this.onSetExpandedValue = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: string[] }>).detail;
      treeView.api.setExpandedValue(value);
    };
    el.addEventListener("phx:tree-view:set-expanded-value", this.onSetExpandedValue);

    this.onSetSelectedValue = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: string[] }>).detail;
      treeView.api.setSelectedValue(value);
    };
    el.addEventListener("phx:tree-view:set-selected-value", this.onSetSelectedValue);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent(
        "tree_view_set_expanded_value",
        (payload: { tree_view_id?: string; value: string[] }) => {
          const targetId = payload.tree_view_id;
          if (targetId && el.id !== targetId && el.id !== `tree-view:${targetId}`) return;
          treeView.api.setExpandedValue(payload.value);
        }
      )
    );

    this.handlers.push(
      this.handleEvent(
        "tree_view_set_selected_value",
        (payload: { tree_view_id?: string; value: string[] }) => {
          const targetId = payload.tree_view_id;
          if (targetId && el.id !== targetId && el.id !== `tree-view:${targetId}`) return;
          treeView.api.setSelectedValue(payload.value);
        }
      )
    );

    this.handlers.push(
      this.handleEvent("tree_view_expanded_value", () => {
        pushEvent("tree_view_expanded_value_response", {
          value: treeView.api.expandedValue,
        });
      })
    );

    this.handlers.push(
      this.handleEvent("tree_view_selected_value", () => {
        pushEvent("tree_view_selected_value_response", {
          value: treeView.api.selectedValue,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & TreeViewHookState) {
    // if (!getBoolean(this.el, "controlled")) return;
    // this.treeView?.updateProps({
    //   expandedValue: getStringList(this.el, "expandedValue"),
    //   selectedValue: getStringList(this.el, "selectedValue"),
    // });
  },

  destroyed(this: object & HookInterface<HTMLElement> & TreeViewHookState) {
    if (this.onSetExpandedValue) {
      this.el.removeEventListener("phx:tree-view:set-expanded-value", this.onSetExpandedValue);
    }
    if (this.onSetSelectedValue) {
      this.el.removeEventListener("phx:tree-view:set-selected-value", this.onSetSelectedValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.treeView?.destroy();
  },
};

export { TreeViewHook as TreeView };
