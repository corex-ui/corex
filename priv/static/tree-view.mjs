import {
  TreeCollection
} from "./chunks/chunk-Q3YPKFFU.mjs";
import {
  performRedirect,
  readDomItemRedirect
} from "./chunks/chunk-FOQSALVP.mjs";
import {
  diffStringValues
} from "./chunks/chunk-JDGMEOQK.mjs";
import {
  contentDatasetValue,
  isJsAnimation,
  prepareJsHeightInitialState,
  runHeightOpenToValues,
  runHeightOpenTransition,
  stripHiddenFromProps
} from "./chunks/chunk-VBYH4ZIZ.mjs";
import {
  createDomEventRegistry,
  createHookHandleEventRegistry
} from "./chunks/chunk-77HPO22C.mjs";
import {
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId
} from "./chunks/chunk-YECC7BC7.mjs";
import {
  Component,
  VanillaMachine,
  add,
  addOrRemove,
  ariaAttr,
  canPushEvent,
  createAnatomy,
  createGuards,
  createMachine,
  dataAttr,
  diff,
  ensure,
  first,
  getBoolean,
  getByTypeahead,
  getDir,
  getEventKey,
  getEventTarget,
  getString,
  getStringList,
  isAnchorElement,
  isArray,
  isComposingEvent,
  isEditableElement,
  isEqual,
  isLeftClick,
  isModifierKey,
  last,
  partition,
  raf,
  remove,
  setElementValue,
  toArray,
  uniq
} from "./chunks/chunk-XGGASIX4.mjs";

// ../node_modules/.pnpm/@zag-js+tree-view@1.40.0/node_modules/@zag-js/tree-view/dist/tree-view.anatomy.mjs
var anatomy = createAnatomy("tree-view").parts(
  "branch",
  "branchContent",
  "branchControl",
  "branchIndentGuide",
  "branchIndicator",
  "branchText",
  "branchTrigger",
  "item",
  "itemIndicator",
  "itemText",
  "label",
  "nodeCheckbox",
  "nodeRenameInput",
  "root",
  "tree"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+tree-view@1.40.0/node_modules/@zag-js/tree-view/dist/tree-view.collection.mjs
var collection = (options) => {
  return new TreeCollection(options);
};
collection.empty = () => {
  return new TreeCollection({ rootNode: { children: [] } });
};

// ../node_modules/.pnpm/@zag-js+tree-view@1.40.0/node_modules/@zag-js/tree-view/dist/tree-view.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `tree:${ctx.id}:root`;
var getLabelId = (ctx) => ctx.ids?.label ?? `tree:${ctx.id}:label`;
var getNodeId = (ctx, value) => ctx.ids?.node?.(value) ?? `tree:${ctx.id}:node:${value}`;
var getTreeId = (ctx) => ctx.ids?.tree ?? `tree:${ctx.id}:tree`;
var focusNode = (ctx, value) => {
  if (value == null) return;
  ctx.getById(getNodeId(ctx, value))?.focus();
};
var getRenameInputId = (ctx, value) => `tree:${ctx.id}:rename-input:${value}`;
var getRenameInputEl = (ctx, value) => {
  return ctx.getById(getRenameInputId(ctx, value));
};

// ../node_modules/.pnpm/@zag-js+tree-view@1.40.0/node_modules/@zag-js/tree-view/dist/utils/checked-state.mjs
function getCheckedState(collection2, node, checkedValue) {
  const value = collection2.getNodeValue(node);
  if (!collection2.isBranchNode(node)) {
    return checkedValue.includes(value);
  }
  const childValues = collection2.getDescendantValues(value);
  const allChecked = childValues.every((v) => checkedValue.includes(v));
  const someChecked = childValues.some((v) => checkedValue.includes(v));
  return allChecked ? true : someChecked ? "indeterminate" : false;
}
function toggleBranchChecked(collection2, value, checkedValue) {
  const childValues = collection2.getDescendantValues(value);
  const allChecked = childValues.every((child) => checkedValue.includes(child));
  return uniq(allChecked ? remove(checkedValue, ...childValues) : add(checkedValue, ...childValues));
}
function getCheckedValueMap(collection2, checkedValue) {
  const map = /* @__PURE__ */ new Map();
  collection2.visit({
    onEnter: (node) => {
      const value = collection2.getNodeValue(node);
      const isBranch = collection2.isBranchNode(node);
      const checked = getCheckedState(collection2, node, checkedValue);
      map.set(value, {
        type: isBranch ? "branch" : "leaf",
        checked
      });
    }
  });
  return map;
}

// ../node_modules/.pnpm/@zag-js+tree-view@1.40.0/node_modules/@zag-js/tree-view/dist/tree-view.connect.mjs
function connect(service, normalize) {
  const { context, scope, computed, prop, send } = service;
  const collection2 = prop("collection");
  const translations = prop("translations");
  const expandedValue = Array.from(context.get("expandedValue"));
  const selectedValue = Array.from(context.get("selectedValue"));
  const checkedValue = Array.from(context.get("checkedValue"));
  const isTypingAhead = computed("isTypingAhead");
  const focusedValue = context.get("focusedValue");
  const loadingStatus = context.get("loadingStatus");
  const renamingValue = context.get("renamingValue");
  const skip = ({ indexPath }) => {
    const paths = collection2.getValuePath(indexPath).slice(0, -1);
    return paths.some((value) => !expandedValue.includes(value));
  };
  const firstNode = collection2.getFirstNode(void 0, { skip });
  const firstNodeValue = firstNode ? collection2.getNodeValue(firstNode) : null;
  function getNodeState(props) {
    const { node, indexPath } = props;
    const value = collection2.getNodeValue(node);
    return {
      id: getNodeId(scope, value),
      value,
      indexPath,
      valuePath: collection2.getValuePath(indexPath),
      disabled: Boolean(node.disabled),
      focused: focusedValue == null ? firstNodeValue === value : focusedValue === value,
      selected: selectedValue.includes(value),
      expanded: expandedValue.includes(value),
      loading: loadingStatus[value] === "loading",
      depth: indexPath.length,
      isBranch: collection2.isBranchNode(node),
      renaming: renamingValue === value,
      get checked() {
        return getCheckedState(collection2, node, checkedValue);
      }
    };
  }
  return {
    collection: collection2,
    expandedValue,
    selectedValue,
    checkedValue,
    toggleChecked(value, isBranch) {
      send({ type: "CHECKED.TOGGLE", value, isBranch });
    },
    setChecked(value) {
      send({ type: "CHECKED.SET", value });
    },
    clearChecked() {
      send({ type: "CHECKED.CLEAR" });
    },
    getCheckedMap() {
      return getCheckedValueMap(collection2, checkedValue);
    },
    expand(value) {
      send({ type: value ? "BRANCH.EXPAND" : "EXPANDED.ALL", value });
    },
    collapse(value) {
      send({ type: value ? "BRANCH.COLLAPSE" : "EXPANDED.CLEAR", value });
    },
    deselect(value) {
      send({ type: value ? "NODE.DESELECT" : "SELECTED.CLEAR", value });
    },
    select(value) {
      send({ type: value ? "NODE.SELECT" : "SELECTED.ALL", value, isTrusted: false });
    },
    getVisibleNodes() {
      return computed("visibleNodes");
    },
    focus(value) {
      focusNode(scope, value);
    },
    selectParent(value) {
      const parentNode = collection2.getParentNode(value);
      if (!parentNode) return;
      const _selectedValue = add(selectedValue, collection2.getNodeValue(parentNode));
      send({ type: "SELECTED.SET", value: _selectedValue, src: "select.parent" });
    },
    expandParent(value) {
      const parentNode = collection2.getParentNode(value);
      if (!parentNode) return;
      const _expandedValue = add(expandedValue, collection2.getNodeValue(parentNode));
      send({ type: "EXPANDED.SET", value: _expandedValue, src: "expand.parent" });
    },
    setExpandedValue(value) {
      const _expandedValue = uniq(value);
      send({ type: "EXPANDED.SET", value: _expandedValue });
    },
    setSelectedValue(value) {
      const _selectedValue = uniq(value);
      send({ type: "SELECTED.SET", value: _selectedValue });
    },
    startRenaming(value) {
      send({ type: "NODE.RENAME", value });
    },
    submitRenaming(value, label) {
      send({ type: "RENAME.SUBMIT", value, label });
    },
    cancelRenaming() {
      send({ type: "RENAME.CANCEL" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        dir: prop("dir")
      });
    },
    getLabelProps() {
      return normalize.element({
        ...parts.label.attrs,
        id: getLabelId(scope),
        dir: prop("dir")
      });
    },
    getTreeProps() {
      return normalize.element({
        ...parts.tree.attrs,
        id: getTreeId(scope),
        dir: prop("dir"),
        role: "tree",
        "aria-label": translations.treeLabel,
        "aria-labelledby": getLabelId(scope),
        "aria-multiselectable": prop("selectionMode") === "multiple" || void 0,
        tabIndex: -1,
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (isComposingEvent(event)) return;
          const target = getEventTarget(event);
          if (isEditableElement(target)) return;
          const node = target?.closest("[data-part=branch-control], [data-part=item]");
          if (!node) return;
          const nodeId = node.dataset.value;
          if (nodeId == null) {
            console.warn(`[zag-js/tree-view] Node id not found for node`, node);
            return;
          }
          const isBranchNode = node.matches("[data-part=branch-control]");
          const keyMap = {
            ArrowDown(event2) {
              if (isModifierKey(event2)) return;
              event2.preventDefault();
              send({ type: "NODE.ARROW_DOWN", id: nodeId, shiftKey: event2.shiftKey });
            },
            ArrowUp(event2) {
              if (isModifierKey(event2)) return;
              event2.preventDefault();
              send({ type: "NODE.ARROW_UP", id: nodeId, shiftKey: event2.shiftKey });
            },
            ArrowLeft(event2) {
              if (isModifierKey(event2) || node.dataset.disabled) return;
              event2.preventDefault();
              send({ type: isBranchNode ? "BRANCH_NODE.ARROW_LEFT" : "NODE.ARROW_LEFT", id: nodeId });
            },
            ArrowRight(event2) {
              if (!isBranchNode || node.dataset.disabled) return;
              event2.preventDefault();
              send({ type: "BRANCH_NODE.ARROW_RIGHT", id: nodeId });
            },
            Home(event2) {
              if (isModifierKey(event2)) return;
              event2.preventDefault();
              send({ type: "NODE.HOME", id: nodeId, shiftKey: event2.shiftKey });
            },
            End(event2) {
              if (isModifierKey(event2)) return;
              event2.preventDefault();
              send({ type: "NODE.END", id: nodeId, shiftKey: event2.shiftKey });
            },
            Space(event2) {
              if (node.dataset.disabled) return;
              if (isTypingAhead) {
                send({ type: "TREE.TYPEAHEAD", key: event2.key });
              } else {
                keyMap.Enter?.(event2);
              }
            },
            Enter(event2) {
              if (node.dataset.disabled) return;
              if (isAnchorElement(target) && isModifierKey(event2)) return;
              send({ type: isBranchNode ? "BRANCH_NODE.CLICK" : "NODE.CLICK", id: nodeId, src: "keyboard" });
              if (!isAnchorElement(target)) {
                event2.preventDefault();
              }
            },
            "*"(event2) {
              if (node.dataset.disabled) return;
              event2.preventDefault();
              send({ type: "SIBLINGS.EXPAND", id: nodeId });
            },
            a(event2) {
              if (!event2.metaKey || node.dataset.disabled) return;
              event2.preventDefault();
              send({ type: "SELECTED.ALL", moveFocus: true });
            },
            F2(event2) {
              if (node.dataset.disabled) return;
              const canRenameFn = prop("canRename");
              if (!canRenameFn) return;
              const indexPath = collection2.getIndexPath(nodeId);
              if (indexPath) {
                const node2 = collection2.at(indexPath);
                if (node2 && !canRenameFn(node2, indexPath)) {
                  return;
                }
              }
              event2.preventDefault();
              send({ type: "NODE.RENAME", value: nodeId });
            }
          };
          const key = getEventKey(event, { dir: prop("dir") });
          const exec = keyMap[key];
          if (exec) {
            exec(event);
            return;
          }
          if (!getByTypeahead.isValidEvent(event)) return;
          send({ type: "TREE.TYPEAHEAD", key: event.key, id: nodeId });
          event.preventDefault();
        }
      });
    },
    getNodeState,
    getItemProps(props) {
      const nodeState = getNodeState(props);
      return normalize.element({
        ...parts.item.attrs,
        id: nodeState.id,
        dir: prop("dir"),
        "data-ownedby": getTreeId(scope),
        "data-path": props.indexPath.join("/"),
        "data-value": nodeState.value,
        tabIndex: nodeState.focused ? 0 : -1,
        "data-focus": dataAttr(nodeState.focused),
        role: "treeitem",
        "aria-current": nodeState.selected ? "true" : void 0,
        "aria-selected": nodeState.disabled ? void 0 : nodeState.selected,
        "data-selected": dataAttr(nodeState.selected),
        "aria-disabled": ariaAttr(nodeState.disabled),
        "data-disabled": dataAttr(nodeState.disabled),
        "data-renaming": dataAttr(nodeState.renaming),
        "data-checked": dataAttr(nodeState.checked === true),
        "data-indeterminate": dataAttr(nodeState.checked === "indeterminate"),
        "aria-level": nodeState.depth,
        "data-depth": nodeState.depth,
        style: {
          "--depth": nodeState.depth
        },
        onFocus(event) {
          event.stopPropagation();
          send({ type: "NODE.FOCUS", id: nodeState.value });
        },
        onClick(event) {
          if (nodeState.disabled) return;
          if (!isLeftClick(event)) return;
          if (isAnchorElement(event.currentTarget) && isModifierKey(event)) return;
          const isMetaKey = event.metaKey || event.ctrlKey;
          send({ type: "NODE.CLICK", id: nodeState.value, shiftKey: event.shiftKey, ctrlKey: isMetaKey });
          event.stopPropagation();
          if (!isAnchorElement(event.currentTarget)) {
            event.preventDefault();
          }
        }
      });
    },
    getItemTextProps(props) {
      const itemState = getNodeState(props);
      return normalize.element({
        ...parts.itemText.attrs,
        "data-disabled": dataAttr(itemState.disabled),
        "data-selected": dataAttr(itemState.selected),
        "data-focus": dataAttr(itemState.focused)
      });
    },
    getItemIndicatorProps(props) {
      const itemState = getNodeState(props);
      return normalize.element({
        ...parts.itemIndicator.attrs,
        "aria-hidden": true,
        "data-disabled": dataAttr(itemState.disabled),
        "data-selected": dataAttr(itemState.selected),
        "data-focus": dataAttr(itemState.focused),
        hidden: !itemState.selected
      });
    },
    getBranchProps(props) {
      const nodeState = getNodeState(props);
      return normalize.element({
        ...parts.branch.attrs,
        "data-depth": nodeState.depth,
        dir: prop("dir"),
        "data-branch": nodeState.value,
        role: "treeitem",
        "data-ownedby": getTreeId(scope),
        "data-value": nodeState.value,
        "aria-level": nodeState.depth,
        "aria-selected": nodeState.disabled ? void 0 : nodeState.selected,
        "data-path": props.indexPath.join("/"),
        "data-selected": dataAttr(nodeState.selected),
        "aria-expanded": nodeState.expanded,
        "data-state": nodeState.expanded ? "open" : "closed",
        "aria-disabled": ariaAttr(nodeState.disabled),
        "data-disabled": dataAttr(nodeState.disabled),
        "data-loading": dataAttr(nodeState.loading),
        "aria-busy": ariaAttr(nodeState.loading),
        style: {
          "--depth": nodeState.depth
        }
      });
    },
    getBranchIndicatorProps(props) {
      const nodeState = getNodeState(props);
      return normalize.element({
        ...parts.branchIndicator.attrs,
        "aria-hidden": true,
        "data-state": nodeState.expanded ? "open" : "closed",
        "data-disabled": dataAttr(nodeState.disabled),
        "data-selected": dataAttr(nodeState.selected),
        "data-focus": dataAttr(nodeState.focused),
        "data-loading": dataAttr(nodeState.loading)
      });
    },
    getBranchTriggerProps(props) {
      const nodeState = getNodeState(props);
      return normalize.element({
        ...parts.branchTrigger.attrs,
        role: "button",
        dir: prop("dir"),
        "data-disabled": dataAttr(nodeState.disabled),
        "data-state": nodeState.expanded ? "open" : "closed",
        "data-value": nodeState.value,
        "data-loading": dataAttr(nodeState.loading),
        disabled: nodeState.loading,
        onClick(event) {
          if (nodeState.disabled || nodeState.loading) return;
          send({ type: "BRANCH_TOGGLE.CLICK", id: nodeState.value });
          event.stopPropagation();
        }
      });
    },
    getBranchControlProps(props) {
      const nodeState = getNodeState(props);
      return normalize.element({
        ...parts.branchControl.attrs,
        role: "button",
        id: nodeState.id,
        dir: prop("dir"),
        tabIndex: nodeState.focused ? 0 : -1,
        "data-path": props.indexPath.join("/"),
        "data-state": nodeState.expanded ? "open" : "closed",
        "data-disabled": dataAttr(nodeState.disabled),
        "data-selected": dataAttr(nodeState.selected),
        "data-focus": dataAttr(nodeState.focused),
        "data-renaming": dataAttr(nodeState.renaming),
        "data-checked": dataAttr(nodeState.checked === true),
        "data-indeterminate": dataAttr(nodeState.checked === "indeterminate"),
        "data-value": nodeState.value,
        "data-depth": nodeState.depth,
        "data-loading": dataAttr(nodeState.loading),
        "aria-busy": ariaAttr(nodeState.loading),
        onFocus(event) {
          send({ type: "NODE.FOCUS", id: nodeState.value });
          event.stopPropagation();
        },
        onClick(event) {
          if (nodeState.disabled) return;
          if (nodeState.loading) return;
          if (!isLeftClick(event)) return;
          if (isAnchorElement(event.currentTarget) && isModifierKey(event)) return;
          const isMetaKey = event.metaKey || event.ctrlKey;
          send({ type: "BRANCH_NODE.CLICK", id: nodeState.value, shiftKey: event.shiftKey, ctrlKey: isMetaKey });
          event.stopPropagation();
        }
      });
    },
    getBranchTextProps(props) {
      const nodeState = getNodeState(props);
      return normalize.element({
        ...parts.branchText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(nodeState.disabled),
        "data-state": nodeState.expanded ? "open" : "closed",
        "data-loading": dataAttr(nodeState.loading)
      });
    },
    getBranchContentProps(props) {
      const nodeState = getNodeState(props);
      return normalize.element({
        ...parts.branchContent.attrs,
        role: "group",
        dir: prop("dir"),
        "data-state": nodeState.expanded ? "open" : "closed",
        "data-depth": nodeState.depth,
        "data-path": props.indexPath.join("/"),
        "data-value": nodeState.value,
        hidden: !nodeState.expanded
      });
    },
    getBranchIndentGuideProps(props) {
      const nodeState = getNodeState(props);
      return normalize.element({
        ...parts.branchIndentGuide.attrs,
        "data-depth": nodeState.depth
      });
    },
    getNodeCheckboxProps(props) {
      const nodeState = getNodeState(props);
      const checkedState = nodeState.checked;
      return normalize.element({
        ...parts.nodeCheckbox.attrs,
        tabIndex: -1,
        role: "checkbox",
        "data-state": checkedState === true ? "checked" : checkedState === false ? "unchecked" : "indeterminate",
        "aria-checked": checkedState === true ? "true" : checkedState === false ? "false" : "mixed",
        "data-disabled": dataAttr(nodeState.disabled),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (nodeState.disabled) return;
          if (!isLeftClick(event)) return;
          send({ type: "CHECKED.TOGGLE", value: nodeState.value, isBranch: nodeState.isBranch });
          event.stopPropagation();
          const node = event.currentTarget.closest("[role=treeitem]");
          node?.focus({ preventScroll: true });
        }
      });
    },
    getNodeRenameInputProps(props) {
      const nodeState = getNodeState(props);
      return normalize.input({
        ...parts.nodeRenameInput.attrs,
        id: getRenameInputId(scope, nodeState.value),
        type: "text",
        "aria-label": translations.renameInputLabel,
        hidden: !nodeState.renaming,
        onKeyDown(event) {
          if (isComposingEvent(event)) return;
          if (event.key === "Escape") {
            send({ type: "RENAME.CANCEL" });
            event.preventDefault();
          }
          if (event.key === "Enter") {
            send({ type: "RENAME.SUBMIT", label: event.currentTarget.value });
            event.preventDefault();
          }
          event.stopPropagation();
        },
        onBlur(event) {
          send({ type: "RENAME.SUBMIT", label: event.currentTarget.value });
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+tree-view@1.40.0/node_modules/@zag-js/tree-view/dist/utils/expand-branch.mjs
function expandBranches(params, values) {
  const { context, prop, refs } = params;
  if (!prop("loadChildren")) {
    context.set("expandedValue", (prev) => uniq(add(prev, ...values)));
    return;
  }
  const loadingStatus = context.get("loadingStatus");
  const [loadedValues, loadingValues] = partition(values, (value) => loadingStatus[value] === "loaded");
  if (loadedValues.length > 0) {
    context.set("expandedValue", (prev) => uniq(add(prev, ...loadedValues)));
  }
  if (loadingValues.length === 0) return;
  const collection2 = prop("collection");
  const [nodeWithChildren, nodeWithoutChildren] = partition(loadingValues, (id) => {
    const node = collection2.findNode(id);
    return collection2.getNodeChildren(node).length > 0;
  });
  if (nodeWithChildren.length > 0) {
    context.set("expandedValue", (prev) => uniq(add(prev, ...nodeWithChildren)));
  }
  if (nodeWithoutChildren.length === 0) return;
  context.set("loadingStatus", (prev) => ({
    ...prev,
    ...nodeWithoutChildren.reduce((acc, id) => ({ ...acc, [id]: "loading" }), {})
  }));
  const nodesToLoad = nodeWithoutChildren.map((id) => {
    const indexPath = collection2.getIndexPath(id);
    const valuePath = collection2.getValuePath(indexPath);
    const node = collection2.findNode(id);
    return { id, indexPath, valuePath, node };
  });
  const pendingAborts = refs.get("pendingAborts");
  const loadChildren = prop("loadChildren");
  ensure(loadChildren, () => "[zag-js/tree-view] `loadChildren` is required for async expansion");
  const proms = nodesToLoad.map(({ id, indexPath, valuePath, node }) => {
    const existingAbort = pendingAborts.get(id);
    if (existingAbort) {
      existingAbort.abort();
      pendingAborts.delete(id);
    }
    const abortController = new AbortController();
    pendingAborts.set(id, abortController);
    return loadChildren({
      valuePath,
      indexPath,
      node,
      signal: abortController.signal
    });
  });
  Promise.allSettled(proms).then((results) => {
    const loadedValues2 = [];
    const nodeWithErrors = [];
    const nextLoadingStatus = context.get("loadingStatus");
    let collection22 = prop("collection");
    results.forEach((result, index) => {
      const { id, indexPath, node, valuePath } = nodesToLoad[index];
      if (result.status === "fulfilled") {
        nextLoadingStatus[id] = "loaded";
        loadedValues2.push(id);
        collection22 = collection22.replace(indexPath, { ...node, children: result.value });
      } else {
        pendingAborts.delete(id);
        Reflect.deleteProperty(nextLoadingStatus, id);
        nodeWithErrors.push({ node, error: result.reason, indexPath, valuePath });
      }
    });
    context.set("loadingStatus", nextLoadingStatus);
    if (loadedValues2.length) {
      context.set("expandedValue", (prev) => uniq(add(prev, ...loadedValues2)));
      prop("onLoadChildrenComplete")?.({ collection: collection22 });
    }
    if (nodeWithErrors.length) {
      prop("onLoadChildrenError")?.({ nodes: nodeWithErrors });
    }
  });
}

// ../node_modules/.pnpm/@zag-js+tree-view@1.40.0/node_modules/@zag-js/tree-view/dist/utils/visit-skip.mjs
function skipFn(params) {
  const { prop, context } = params;
  return function skip({ indexPath }) {
    const paths = prop("collection").getValuePath(indexPath).slice(0, -1);
    return paths.some((value) => !context.get("expandedValue").includes(value));
  };
}

// ../node_modules/.pnpm/@zag-js+tree-view@1.40.0/node_modules/@zag-js/tree-view/dist/tree-view.machine.mjs
var { and } = createGuards();
var machine = createMachine({
  props({ props }) {
    return {
      selectionMode: "single",
      collection: collection.empty(),
      typeahead: true,
      expandOnClick: true,
      defaultExpandedValue: [],
      defaultSelectedValue: [],
      ...props,
      translations: {
        treeLabel: "Tree View",
        renameInputLabel: "Rename tree item",
        ...props.translations
      }
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable, getContext }) {
    return {
      expandedValue: bindable(() => ({
        defaultValue: prop("defaultExpandedValue"),
        value: prop("expandedValue"),
        isEqual,
        onChange(expandedValue) {
          const ctx = getContext();
          const focusedValue = ctx.get("focusedValue");
          prop("onExpandedChange")?.({
            expandedValue,
            focusedValue,
            get expandedNodes() {
              return prop("collection").findNodes(expandedValue);
            }
          });
        }
      })),
      selectedValue: bindable(() => ({
        defaultValue: prop("defaultSelectedValue"),
        value: prop("selectedValue"),
        isEqual,
        onChange(selectedValue) {
          const ctx = getContext();
          const focusedValue = ctx.get("focusedValue");
          prop("onSelectionChange")?.({
            selectedValue,
            focusedValue,
            get selectedNodes() {
              return prop("collection").findNodes(selectedValue);
            }
          });
        }
      })),
      focusedValue: bindable(() => ({
        defaultValue: prop("defaultFocusedValue") || null,
        value: prop("focusedValue"),
        onChange(focusedValue) {
          prop("onFocusChange")?.({
            focusedValue,
            get focusedNode() {
              return focusedValue ? prop("collection").findNode(focusedValue) : null;
            }
          });
        }
      })),
      loadingStatus: bindable(() => ({
        defaultValue: {}
      })),
      checkedValue: bindable(() => ({
        defaultValue: prop("defaultCheckedValue") || [],
        value: prop("checkedValue"),
        isEqual,
        onChange(value) {
          prop("onCheckedChange")?.({ checkedValue: value });
        }
      })),
      renamingValue: bindable(() => ({
        sync: true,
        defaultValue: null
      }))
    };
  },
  refs() {
    return {
      typeaheadState: { ...getByTypeahead.defaultOptions },
      pendingAborts: /* @__PURE__ */ new Map()
    };
  },
  computed: {
    isMultipleSelection: ({ prop }) => prop("selectionMode") === "multiple",
    isTypingAhead: ({ refs }) => refs.get("typeaheadState").keysSoFar.length > 0,
    visibleNodes: ({ prop, context }) => {
      const nodes = [];
      prop("collection").visit({
        skip: skipFn({ prop, context }),
        onEnter: (node, indexPath) => {
          nodes.push({ node, indexPath });
        }
      });
      return nodes;
    }
  },
  on: {
    "EXPANDED.SET": {
      actions: ["setExpanded"]
    },
    "EXPANDED.CLEAR": {
      actions: ["clearExpanded"]
    },
    "EXPANDED.ALL": {
      actions: ["expandAllBranches"]
    },
    "BRANCH.EXPAND": {
      actions: ["expandBranches"]
    },
    "BRANCH.COLLAPSE": {
      actions: ["collapseBranches"]
    },
    "SELECTED.SET": {
      actions: ["setSelected"]
    },
    "SELECTED.ALL": [
      {
        guard: and("isMultipleSelection", "moveFocus"),
        actions: ["selectAllNodes", "focusTreeLastNode"]
      },
      {
        guard: "isMultipleSelection",
        actions: ["selectAllNodes"]
      }
    ],
    "SELECTED.CLEAR": {
      actions: ["clearSelected"]
    },
    "NODE.SELECT": {
      actions: ["selectNode"]
    },
    "NODE.DESELECT": {
      actions: ["deselectNode"]
    },
    "CHECKED.TOGGLE": {
      actions: ["toggleChecked"]
    },
    "CHECKED.SET": {
      actions: ["setChecked"]
    },
    "CHECKED.CLEAR": {
      actions: ["clearChecked"]
    },
    "NODE.FOCUS": {
      actions: ["setFocusedNode"]
    },
    "NODE.ARROW_DOWN": [
      {
        guard: and("isShiftKey", "isMultipleSelection"),
        actions: ["focusTreeNextNode", "extendSelectionToNextNode"]
      },
      {
        actions: ["focusTreeNextNode"]
      }
    ],
    "NODE.ARROW_UP": [
      {
        guard: and("isShiftKey", "isMultipleSelection"),
        actions: ["focusTreePrevNode", "extendSelectionToPrevNode"]
      },
      {
        actions: ["focusTreePrevNode"]
      }
    ],
    "NODE.ARROW_LEFT": {
      actions: ["focusBranchNode"]
    },
    "BRANCH_NODE.ARROW_LEFT": [
      {
        guard: "isBranchExpanded",
        actions: ["collapseBranch"]
      },
      {
        actions: ["focusBranchNode"]
      }
    ],
    "BRANCH_NODE.ARROW_RIGHT": [
      {
        guard: and("isBranchFocused", "isBranchExpanded"),
        actions: ["focusBranchFirstNode"]
      },
      {
        actions: ["expandBranch"]
      }
    ],
    "SIBLINGS.EXPAND": {
      actions: ["expandSiblingBranches"]
    },
    "NODE.HOME": [
      {
        guard: and("isShiftKey", "isMultipleSelection"),
        actions: ["extendSelectionToFirstNode", "focusTreeFirstNode"]
      },
      {
        actions: ["focusTreeFirstNode"]
      }
    ],
    "NODE.END": [
      {
        guard: and("isShiftKey", "isMultipleSelection"),
        actions: ["extendSelectionToLastNode", "focusTreeLastNode"]
      },
      {
        actions: ["focusTreeLastNode"]
      }
    ],
    "NODE.CLICK": [
      {
        guard: and("isCtrlKey", "isMultipleSelection"),
        actions: ["toggleNodeSelection"]
      },
      {
        guard: and("isShiftKey", "isMultipleSelection"),
        actions: ["extendSelectionToNode"]
      },
      {
        actions: ["selectNode"]
      }
    ],
    "BRANCH_NODE.CLICK": [
      {
        guard: and("isCtrlKey", "isMultipleSelection"),
        actions: ["toggleNodeSelection"]
      },
      {
        guard: and("isShiftKey", "isMultipleSelection"),
        actions: ["extendSelectionToNode"]
      },
      {
        guard: "expandOnClick",
        actions: ["selectNode", "toggleBranchNode"]
      },
      {
        actions: ["selectNode"]
      }
    ],
    "BRANCH_TOGGLE.CLICK": {
      actions: ["toggleBranchNode"]
    },
    "TREE.TYPEAHEAD": {
      actions: ["focusMatchedNode"]
    }
  },
  exit: ["clearPendingAborts"],
  states: {
    idle: {
      on: {
        "NODE.RENAME": {
          target: "renaming",
          actions: ["setRenamingValue"]
        }
      }
    },
    renaming: {
      entry: ["syncRenameInput", "focusRenameInput"],
      on: {
        "RENAME.SUBMIT": {
          guard: "isRenameLabelValid",
          target: "idle",
          actions: ["submitRenaming"]
        },
        "RENAME.CANCEL": {
          target: "idle",
          actions: ["cancelRenaming"]
        }
      }
    }
  },
  implementations: {
    guards: {
      isBranchFocused: ({ context, event }) => context.get("focusedValue") === event.id,
      isBranchExpanded: ({ context, event }) => context.get("expandedValue").includes(event.id),
      isShiftKey: ({ event }) => event.shiftKey,
      isCtrlKey: ({ event }) => event.ctrlKey,
      hasSelectedItems: ({ context }) => context.get("selectedValue").length > 0,
      isMultipleSelection: ({ prop }) => prop("selectionMode") === "multiple",
      moveFocus: ({ event }) => !!event.moveFocus,
      expandOnClick: ({ prop }) => !!prop("expandOnClick"),
      isRenameLabelValid: ({ event }) => event.label.trim() !== ""
    },
    actions: {
      selectNode({ context, event }) {
        const value = event.id || event.value;
        context.set("selectedValue", (prev) => {
          if (value == null) return prev;
          if (!event.isTrusted && isArray(value)) return prev.concat(...value);
          return [isArray(value) ? last(value) : value].filter(Boolean);
        });
      },
      deselectNode({ context, event }) {
        const value = toArray(event.id || event.value);
        context.set("selectedValue", (prev) => remove(prev, ...value));
      },
      setFocusedNode({ context, event }) {
        context.set("focusedValue", event.id);
      },
      clearFocusedNode({ context }) {
        context.set("focusedValue", null);
      },
      clearSelectedItem({ context }) {
        context.set("selectedValue", []);
      },
      toggleBranchNode({ context, event, action }) {
        const isExpanded = context.get("expandedValue").includes(event.id);
        action(isExpanded ? ["collapseBranch"] : ["expandBranch"]);
      },
      expandBranch(params) {
        const { event } = params;
        expandBranches(params, [event.id]);
      },
      expandBranches(params) {
        const { context, event } = params;
        const valuesToExpand = toArray(event.value);
        expandBranches(params, diff(valuesToExpand, context.get("expandedValue")));
      },
      collapseBranch({ context, event }) {
        context.set("expandedValue", (prev) => remove(prev, event.id));
      },
      collapseBranches(params) {
        const { context, event } = params;
        const value = toArray(event.value);
        context.set("expandedValue", (prev) => remove(prev, ...value));
      },
      setExpanded({ context, event }) {
        if (!isArray(event.value)) return;
        context.set("expandedValue", event.value);
      },
      clearExpanded({ context }) {
        context.set("expandedValue", []);
      },
      setSelected({ context, event }) {
        if (!isArray(event.value)) return;
        context.set("selectedValue", event.value);
      },
      clearSelected({ context }) {
        context.set("selectedValue", []);
      },
      focusTreeFirstNode(params) {
        const { prop, scope } = params;
        const collection2 = prop("collection");
        const firstNode = collection2.getFirstNode(void 0, { skip: skipFn(params) });
        if (!firstNode) return;
        const firstValue = collection2.getNodeValue(firstNode);
        const scrolled = scrollToNode(params, firstValue);
        if (scrolled) raf(() => focusNode(scope, firstValue));
        else focusNode(scope, firstValue);
      },
      focusTreeLastNode(params) {
        const { prop, scope } = params;
        const collection2 = prop("collection");
        const lastNode = collection2.getLastNode(void 0, { skip: skipFn(params) });
        const lastValue = collection2.getNodeValue(lastNode);
        const scrolled = scrollToNode(params, lastValue);
        if (scrolled) raf(() => focusNode(scope, lastValue));
        else focusNode(scope, lastValue);
      },
      focusBranchFirstNode(params) {
        const { event, prop, scope } = params;
        const collection2 = prop("collection");
        const branchNode = collection2.findNode(event.id);
        const firstNode = collection2.getFirstNode(branchNode, { skip: skipFn(params) });
        if (!firstNode) return;
        const firstValue = collection2.getNodeValue(firstNode);
        const scrolled = scrollToNode(params, firstValue);
        if (scrolled) raf(() => focusNode(scope, firstValue));
        else focusNode(scope, firstValue);
      },
      focusTreeNextNode(params) {
        const { event, prop, scope } = params;
        const collection2 = prop("collection");
        const nextNode = collection2.getNextNode(event.id, { skip: skipFn(params) });
        if (!nextNode) return;
        const nextValue = collection2.getNodeValue(nextNode);
        const scrolled = scrollToNode(params, nextValue);
        if (scrolled) raf(() => focusNode(scope, nextValue));
        else focusNode(scope, nextValue);
      },
      focusTreePrevNode(params) {
        const { event, prop, scope } = params;
        const collection2 = prop("collection");
        const prevNode = collection2.getPreviousNode(event.id, { skip: skipFn(params) });
        if (!prevNode) return;
        const prevValue = collection2.getNodeValue(prevNode);
        const scrolled = scrollToNode(params, prevValue);
        if (scrolled) raf(() => focusNode(scope, prevValue));
        else focusNode(scope, prevValue);
      },
      focusBranchNode(params) {
        const { event, prop, scope } = params;
        const collection2 = prop("collection");
        const parentNode = collection2.getParentNode(event.id);
        const parentValue = parentNode ? collection2.getNodeValue(parentNode) : void 0;
        if (!parentValue) return;
        const scrolled = scrollToNode(params, parentValue);
        if (scrolled) raf(() => focusNode(scope, parentValue));
        else focusNode(scope, parentValue);
      },
      selectAllNodes({ context, prop }) {
        context.set("selectedValue", prop("collection").getValues());
      },
      focusMatchedNode(params) {
        const { context, prop, refs, event, scope, computed } = params;
        const nodes = computed("visibleNodes");
        const elements = nodes.map(({ node: node2 }) => ({
          textContent: prop("collection").stringifyNode(node2),
          id: prop("collection").getNodeValue(node2)
        }));
        const node = getByTypeahead(elements, {
          state: refs.get("typeaheadState"),
          activeId: context.get("focusedValue"),
          key: event.key
        });
        if (!node?.id) return;
        const scrolled = scrollToNode(params, node.id);
        if (scrolled) raf(() => focusNode(scope, node.id));
        else focusNode(scope, node.id);
      },
      toggleNodeSelection({ context, event }) {
        const selectedValue = addOrRemove(context.get("selectedValue"), event.id);
        context.set("selectedValue", selectedValue);
      },
      expandAllBranches(params) {
        const { context, prop } = params;
        const branchValues = prop("collection").getBranchValues();
        const valuesToExpand = diff(branchValues, context.get("expandedValue"));
        expandBranches(params, valuesToExpand);
      },
      expandSiblingBranches(params) {
        const { context, event, prop } = params;
        const collection2 = prop("collection");
        const indexPath = collection2.getIndexPath(event.id);
        if (!indexPath) return;
        const nodes = collection2.getSiblingNodes(indexPath);
        const values = nodes.map((node) => collection2.getNodeValue(node));
        const valuesToExpand = diff(values, context.get("expandedValue"));
        expandBranches(params, valuesToExpand);
      },
      extendSelectionToNode(params) {
        const { context, event, prop, computed } = params;
        const collection2 = prop("collection");
        const anchorValue = first(context.get("selectedValue")) || collection2.getNodeValue(collection2.getFirstNode());
        const targetValue = event.id;
        let values = [anchorValue, targetValue];
        let hits = 0;
        const visibleNodes = computed("visibleNodes");
        visibleNodes.forEach(({ node }) => {
          const nodeValue = collection2.getNodeValue(node);
          if (hits === 1) values.push(nodeValue);
          if (nodeValue === anchorValue || nodeValue === targetValue) hits++;
        });
        context.set("selectedValue", uniq(values));
      },
      extendSelectionToNextNode(params) {
        const { context, event, prop } = params;
        const collection2 = prop("collection");
        const nextNode = collection2.getNextNode(event.id, { skip: skipFn(params) });
        if (!nextNode) return;
        const values = new Set(context.get("selectedValue"));
        const nextValue = collection2.getNodeValue(nextNode);
        if (nextValue == null) return;
        if (values.has(event.id) && values.has(nextValue)) {
          values.delete(event.id);
        } else if (!values.has(nextValue)) {
          values.add(nextValue);
        }
        context.set("selectedValue", Array.from(values));
      },
      extendSelectionToPrevNode(params) {
        const { context, event, prop } = params;
        const collection2 = prop("collection");
        const prevNode = collection2.getPreviousNode(event.id, { skip: skipFn(params) });
        if (!prevNode) return;
        const values = new Set(context.get("selectedValue"));
        const prevValue = collection2.getNodeValue(prevNode);
        if (prevValue == null) return;
        if (values.has(event.id) && values.has(prevValue)) {
          values.delete(event.id);
        } else if (!values.has(prevValue)) {
          values.add(prevValue);
        }
        context.set("selectedValue", Array.from(values));
      },
      extendSelectionToFirstNode(params) {
        const { context, prop } = params;
        const collection2 = prop("collection");
        const currentSelection = first(context.get("selectedValue"));
        const values = [];
        collection2.visit({
          skip: skipFn(params),
          onEnter: (node) => {
            const nodeValue = collection2.getNodeValue(node);
            values.push(nodeValue);
            if (nodeValue === currentSelection) {
              return "stop";
            }
          }
        });
        context.set("selectedValue", values);
      },
      extendSelectionToLastNode(params) {
        const { context, prop } = params;
        const collection2 = prop("collection");
        const currentSelection = first(context.get("selectedValue"));
        const values = [];
        let current = false;
        collection2.visit({
          skip: skipFn(params),
          onEnter: (node) => {
            const nodeValue = collection2.getNodeValue(node);
            if (nodeValue === currentSelection) current = true;
            if (current) values.push(nodeValue);
          }
        });
        context.set("selectedValue", values);
      },
      clearPendingAborts({ refs }) {
        const aborts = refs.get("pendingAborts");
        aborts.forEach((abort) => abort.abort());
        aborts.clear();
      },
      toggleChecked({ context, event, prop }) {
        const collection2 = prop("collection");
        context.set(
          "checkedValue",
          (prev) => event.isBranch ? toggleBranchChecked(collection2, event.value, prev) : addOrRemove(prev, event.value)
        );
      },
      setChecked({ context, event }) {
        context.set("checkedValue", event.value);
      },
      clearChecked({ context }) {
        context.set("checkedValue", []);
      },
      setRenamingValue({ context, event, prop }) {
        context.set("renamingValue", event.value);
        const onRenameStartFn = prop("onRenameStart");
        if (onRenameStartFn) {
          const collection2 = prop("collection");
          const indexPath = collection2.getIndexPath(event.value);
          if (indexPath) {
            const node = collection2.at(indexPath);
            if (node) {
              onRenameStartFn({
                value: event.value,
                node,
                indexPath
              });
            }
          }
        }
      },
      submitRenaming({ context, event, prop, scope }) {
        const renamingValue = context.get("renamingValue");
        if (!renamingValue) return;
        const collection2 = prop("collection");
        const indexPath = collection2.getIndexPath(renamingValue);
        if (!indexPath) return;
        const trimmedLabel = event.label.trim();
        const onBeforeRenameFn = prop("onBeforeRename");
        if (onBeforeRenameFn) {
          const details = {
            value: renamingValue,
            label: trimmedLabel,
            indexPath
          };
          const shouldRename = onBeforeRenameFn(details);
          if (!shouldRename) {
            context.set("renamingValue", null);
            focusNode(scope, renamingValue);
            return;
          }
        }
        prop("onRenameComplete")?.({
          value: renamingValue,
          label: trimmedLabel,
          indexPath
        });
        context.set("renamingValue", null);
        focusNode(scope, renamingValue);
      },
      cancelRenaming({ context, scope }) {
        const renamingValue = context.get("renamingValue");
        context.set("renamingValue", null);
        if (renamingValue) {
          focusNode(scope, renamingValue);
        }
      },
      syncRenameInput({ context, scope, prop }) {
        const renamingValue = context.get("renamingValue");
        if (!renamingValue) return;
        const collection2 = prop("collection");
        const node = collection2.findNode(renamingValue);
        if (!node) return;
        const label = collection2.stringifyNode(node);
        const inputEl = getRenameInputEl(scope, renamingValue);
        setElementValue(inputEl, label);
      },
      focusRenameInput({ context, scope }) {
        const renamingValue = context.get("renamingValue");
        if (!renamingValue) return;
        const inputEl = getRenameInputEl(scope, renamingValue);
        if (!inputEl) return;
        inputEl.focus();
        inputEl.select();
      }
    }
  }
});
function scrollToNode(params, value) {
  const { prop, scope, computed } = params;
  const scrollToIndexFn = prop("scrollToIndexFn");
  if (!scrollToIndexFn) return false;
  const collection2 = prop("collection");
  const visibleNodes = computed("visibleNodes");
  for (let i = 0; i < visibleNodes.length; i++) {
    const { node, indexPath } = visibleNodes[i];
    if (collection2.getNodeValue(node) !== value) continue;
    scrollToIndexFn({
      index: i,
      node,
      indexPath,
      getElement: () => scope.getById(getNodeId(scope, value))
    });
    return true;
  }
  return false;
}

// components/tree-view.ts
function createTreeCollection(rootNode) {
  return collection({
    nodeToValue: (node) => node.value,
    nodeToString: (node) => node.name,
    rootNode
  });
}
var TreeView = class extends Component {
  treeCollection;
  constructor(el, props) {
    const { rootNode, ...rest } = props;
    const treeCollection = createTreeCollection(rootNode);
    super(el, { ...rest, collection: treeCollection });
    this.treeCollection = treeCollection;
  }
  replaceRootNode(rootNode) {
    const treeCollection = createTreeCollection(rootNode);
    this.treeCollection = treeCollection;
    this.updateProps({ collection: treeCollection });
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, { ...props });
  }
  initApi() {
    return this.zagConnect(connect);
  }
  getNodeAt(indexPath) {
    if (indexPath.length === 0) return void 0;
    let current = this.treeCollection.rootNode;
    for (const i of indexPath) {
      current = current?.children?.[i];
      if (!current) return void 0;
    }
    return current;
  }
  updateExistingTree(treeEl) {
    this.spreadProps(treeEl, this.api.getTreeProps());
    const animation = this.el.dataset.animation ?? "instant";
    const isOwnedByTree = (el) => el.closest('[data-scope="tree-view"][data-part="tree"]') === treeEl;
    const branches = treeEl.querySelectorAll(
      '[data-scope="tree-view"][data-part="branch"]'
    );
    for (const branchEl of branches) {
      if (!isOwnedByTree(branchEl)) continue;
      const pathRaw = branchEl.getAttribute("data-path");
      if (pathRaw == null) continue;
      const indexPath = pathRaw.split("/").map((s) => parseInt(s, 10));
      const node = this.getNodeAt(indexPath);
      if (!node) continue;
      const nodeProps = { indexPath, node };
      this.spreadProps(branchEl, this.api.getBranchProps(nodeProps));
      const controlEl = branchEl.querySelector(
        '[data-scope="tree-view"][data-part="branch-control"]'
      );
      if (controlEl) this.spreadProps(controlEl, this.api.getBranchControlProps(nodeProps));
      const textEl = branchEl.querySelector(
        '[data-scope="tree-view"][data-part="branch-text"]'
      );
      if (textEl) this.spreadProps(textEl, this.api.getBranchTextProps(nodeProps));
      const indicatorEl = branchEl.querySelector(
        '[data-scope="tree-view"][data-part="branch-indicator"]'
      );
      if (indicatorEl) this.spreadProps(indicatorEl, this.api.getBranchIndicatorProps(nodeProps));
      const contentEl = branchEl.querySelector(
        '[data-scope="tree-view"][data-part="branch-content"]'
      );
      if (contentEl) {
        const contentPropsRaw = this.api.getBranchContentProps(nodeProps);
        if (animation === "instant") {
          this.spreadProps(contentEl, contentPropsRaw);
        } else if (animation === "js" || animation === "custom") {
          this.spreadProps(
            contentEl,
            stripHiddenFromProps(contentPropsRaw)
          );
          contentEl.removeAttribute("hidden");
        }
      }
      const indentGuideEl = branchEl.querySelector(
        '[data-scope="tree-view"][data-part="branch-indent-guide"]'
      );
      if (indentGuideEl)
        this.spreadProps(indentGuideEl, this.api.getBranchIndentGuideProps(nodeProps));
    }
    const items = treeEl.querySelectorAll(
      '[data-scope="tree-view"][data-part="item"]'
    );
    for (const itemEl of items) {
      if (!isOwnedByTree(itemEl)) continue;
      const pathRaw = itemEl.getAttribute("data-path");
      if (pathRaw == null) continue;
      const indexPath = pathRaw.split("/").map((s) => parseInt(s, 10));
      const node = this.getNodeAt(indexPath);
      if (!node) continue;
      const nodeProps = { indexPath, node };
      this.spreadProps(itemEl, this.api.getItemProps(nodeProps));
      const itemTextEl = itemEl.querySelector(
        '[data-scope="tree-view"][data-part="item-text"]'
      );
      if (itemTextEl) this.spreadProps(itemTextEl, this.api.getItemTextProps(nodeProps));
      const itemIndicatorEl = itemEl.querySelector(
        '[data-scope="tree-view"][data-part="item-indicator"]'
      );
      if (itemIndicatorEl)
        this.spreadProps(itemIndicatorEl, this.api.getItemIndicatorProps(nodeProps));
    }
  }
  syncTree = () => {
    const treeEl = this.el.querySelector('[data-scope="tree-view"][data-part="tree"]');
    if (!treeEl) return;
    this.spreadProps(treeEl, this.api.getTreeProps());
    this.updateExistingTree(treeEl);
  };
  render() {
    const rootEl = this.el.querySelector('[data-scope="tree-view"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const label = this.el.querySelector('[data-scope="tree-view"][data-part="label"]');
    if (label) this.spreadProps(label, this.api.getLabelProps());
    this.syncTree();
  }
};

// hooks/tree-view.ts
function readExpandedAttr(el) {
  return getBoolean(el, "controlled") ? el.getAttribute("data-expanded-value") ?? "" : el.getAttribute("data-default-expanded-value") ?? "";
}
function readSelectedAttr(el) {
  return getBoolean(el, "controlled") ? el.getAttribute("data-selected-value") ?? "" : el.getAttribute("data-default-selected-value") ?? "";
}
function parseRootNode(el) {
  const raw = el.dataset.tree;
  if (raw == null || raw === "") {
    throw new Error("TreeView: missing data-tree");
  }
  return JSON.parse(raw);
}
var BRANCH_CONTENT_SELECTOR = '[data-scope="tree-view"][data-part="branch-content"]';
function readTreeViewInteractionProps(el) {
  return {
    selectionMode: getString(el, "selectionMode") ?? "single",
    typeahead: el.dataset.typeahead !== "false",
    dir: getDir(el)
  };
}
var TreeViewHook = {
  mounted() {
    const el = this.el;
    const self = this;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const rootNode = parseRootNode(el);
    this.lastDataTree = el.dataset.tree;
    const controlled = getBoolean(el, "controlled");
    self.lastExpanded = controlled ? getStringList(el, "expandedValue") ?? [] : getStringList(el, "defaultExpandedValue") ?? [];
    self.lastSelected = controlled ? getStringList(el, "selectedValue") ?? [] : getStringList(el, "defaultSelectedValue") ?? [];
    self.lastExpandedAttr = readExpandedAttr(el);
    self.lastSelectedAttr = readSelectedAttr(el);
    const treeView = new TreeView(el, {
      id: el.id,
      rootNode,
      ...controlled ? {
        expandedValue: getStringList(el, "expandedValue") ?? [],
        selectedValue: getStringList(el, "selectedValue") ?? []
      } : {
        defaultExpandedValue: getStringList(el, "defaultExpandedValue") ?? [],
        defaultSelectedValue: getStringList(el, "defaultSelectedValue") ?? []
      },
      selectionMode: getString(el, "selectionMode") ?? "single",
      typeahead: el.dataset.typeahead !== "false",
      dir: getDir(el),
      onSelectionChange: (details) => {
        const redirectOn = getBoolean(el, "redirect");
        const value = details.selectedValue?.length ? details.selectedValue[0] : void 0;
        const itemEl = value ? el.querySelector(
          `[data-scope="tree-view"][data-part="item"][data-value="${CSS.escape(value)}"]`
        ) : null;
        const isItem = !!itemEl;
        if (redirectOn && isItem) {
          performRedirect(readDomItemRedirect(itemEl, value), { liveSocket: this.liveSocket });
        }
        const next = details.selectedValue ?? [];
        const previousSelectedValue = self.lastSelected ?? [];
        const { added, removed } = diffStringValues(next, previousSelectedValue);
        self.lastSelected = next;
        const payload = {
          id: el.id,
          selectedValue: next,
          previousSelectedValue,
          added,
          removed,
          focusedValue: details.focusedValue,
          isItem
        };
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload,
          serverEventName: getString(el, "onSelectionChange"),
          clientEventName: getString(el, "onSelectionChangeClient")
        });
      },
      onExpandedChange: (details) => {
        const next = details.expandedValue ?? [];
        const previousExpandedValue = self.lastExpanded ?? [];
        const { added, removed } = diffStringValues(next, previousExpandedValue);
        self.lastExpanded = next;
        const payload = {
          id: el.id,
          expandedValue: next,
          previousExpandedValue,
          added,
          removed,
          focusedValue: details.focusedValue
        };
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload,
          serverEventName: getString(el, "onExpandedChange"),
          clientEventName: getString(el, "onExpandedChangeClient")
        });
        runHeightOpenToValues({
          el,
          selector: BRANCH_CONTENT_SELECTOR,
          openValues: next,
          resolveValue: contentDatasetValue
        });
      }
    });
    treeView.init();
    this.treeView = treeView;
    prepareJsHeightInitialState(el, BRANCH_CONTENT_SELECTOR);
    const emitSelectedValue = (respondTo) => {
      const value = treeView.api.selectedValue;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "tree_view_value_response",
        serverPayload: { id: el.id, value },
        el,
        domEventName: "tree-view-value",
        domDetail: { id: el.id, value }
      });
    };
    const emitExpandedValue = (respondTo) => {
      const value = treeView.api.expandedValue;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "tree_view_expanded_value_response",
        serverPayload: { id: el.id, value },
        el,
        domEventName: "tree-view-expanded-value",
        domDetail: { id: el.id, value }
      });
    };
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add(
      "corex:tree-view:set-expanded-value",
      (event) => {
        treeView.api.setExpandedValue(event.detail.value);
      }
    );
    domRegistry.add(
      "corex:tree-view:set-selected-value",
      (event) => {
        treeView.api.setSelectedValue(event.detail.value);
      }
    );
    domRegistry.add("corex:tree-view:value", (event) => {
      emitSelectedValue(parseRespondTo(event.detail));
    });
    domRegistry.add("corex:tree-view:expanded-value", (event) => {
      emitExpandedValue(parseRespondTo(event.detail));
    });
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add(
      "tree_view_set_expanded_value",
      (payload) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        treeView.api.setExpandedValue(payload.value);
      }
    );
    registry.add(
      "tree_view_set_selected_value",
      (payload) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        treeView.api.setSelectedValue(payload.value);
      }
    );
    registry.add("tree_view_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitSelectedValue(parseRespondTo(payload));
    });
    registry.add("tree_view_expanded_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitExpandedValue(parseRespondTo(payload));
    });
  },
  beforeUpdate() {
    const { el } = this;
    if (getBoolean(el, "controlled") && isJsAnimation(el)) {
      this.previousExpanded = getStringList(el, "expandedValue") ?? [];
    }
  },
  updated() {
    const { el } = this;
    const tv = this.treeView;
    if (!tv) return;
    const rawTree = el.dataset.tree;
    if (rawTree != null && rawTree !== this.lastDataTree) {
      this.lastDataTree = rawTree;
      tv.replaceRootNode(parseRootNode(el));
    }
    const controlled = getBoolean(el, "controlled");
    const interaction = readTreeViewInteractionProps(el);
    const selected = controlled ? getStringList(el, "selectedValue") ?? [] : getStringList(el, "defaultSelectedValue") ?? [];
    const expanded = controlled ? getStringList(el, "expandedValue") ?? [] : getStringList(el, "defaultExpandedValue") ?? [];
    const expandedAttr = readExpandedAttr(el);
    const selectedAttr = readSelectedAttr(el);
    const expandedAttrChanged = expandedAttr !== this.lastExpandedAttr;
    const selectedAttrChanged = selectedAttr !== this.lastSelectedAttr;
    this.lastExpandedAttr = expandedAttr;
    this.lastSelectedAttr = selectedAttr;
    if (!controlled) {
      tv.updateProps(interaction);
      if (expandedAttrChanged) tv.api.setExpandedValue(expanded);
      if (selectedAttrChanged) tv.api.setSelectedValue(selected);
      return;
    }
    const prevExpanded = this.previousExpanded ?? this.lastExpanded ?? [];
    this.previousExpanded = void 0;
    if (expandedAttrChanged) this.lastExpanded = expanded;
    if (selectedAttrChanged) this.lastSelected = selected;
    runHeightOpenTransition({
      el,
      selector: BRANCH_CONTENT_SELECTOR,
      prevOpen: prevExpanded,
      nextOpen: expanded,
      resolveValue: contentDatasetValue
    });
    tv.updateProps({
      ...interaction,
      expandedValue: expanded,
      selectedValue: selected
    });
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.treeView?.destroy();
  }
};
export {
  TreeViewHook as TreeView
};
