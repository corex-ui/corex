import {
  applyItems,
  buildCollection,
  collection,
  connect,
  firstSelectedValue,
  initCollectionItems,
  itemValue,
  machine,
  redirectCollectionItem,
  refreshItemsIfChanged,
  zagListCollectionConfig
} from "./chunks/chunk-ZTFT76Y7.mjs";
import "./chunks/chunk-FMAG5SZY.mjs";
import "./chunks/chunk-WRPL7YFW.mjs";
import "./chunks/chunk-PXE4MUCM.mjs";
import {
  readStringListControlledZagProps,
  readStringListControlledZagUpdate
} from "./chunks/chunk-6RACHWND.mjs";
import {
  createValueEmitter,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createZagLiveHook,
  getBoolean,
  getDir,
  getString
} from "./chunks/chunk-HMQI4LDM.mjs";

// components/listbox.ts
var Listbox = class extends Component {
  _options = [];
  hasGroups = false;
  constructor(el, props) {
    super(el, props);
    const collectionFromProps = props.collection;
    this._options = collectionFromProps?.items ?? [];
  }
  get options() {
    return Array.isArray(this._options) ? this._options : [];
  }
  setOptions(options) {
    this._options = Array.isArray(options) ? options : [];
  }
  getCollection() {
    return collection(zagListCollectionConfig(this.options, this.hasGroups));
  }
  initMachine(props) {
    const getCollection = this.getCollection.bind(this);
    return new VanillaMachine(machine, {
      ...props,
      get collection() {
        return getCollection();
      }
    });
  }
  initApi() {
    return this.zagConnect(connect);
  }
  applyItemProps() {
    const contentEl = this.el.querySelector(
      '[data-scope="listbox"][data-part="content"]'
    );
    if (!contentEl) return;
    const isOwnedByContent = (el) => el.closest('[data-scope="listbox"][data-part="content"]') === contentEl;
    contentEl.querySelectorAll('[data-scope="listbox"][data-part="item-group"]').forEach((groupEl) => {
      if (!isOwnedByContent(groupEl)) return;
      const groupId = groupEl.dataset.id ?? "";
      this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
      const labelEl = groupEl.querySelector(
        '[data-scope="listbox"][data-part="item-group-label"]'
      );
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
      }
    });
    contentEl.querySelectorAll('[data-scope="listbox"][data-part="item"]').forEach((itemEl) => {
      if (!isOwnedByContent(itemEl)) return;
      const value = itemEl.dataset.value ?? "";
      const item = this.options.find((i) => String(itemValue(i)) === String(value));
      if (!item) return;
      this.spreadProps(itemEl, this.api.getItemProps({ item }));
      const textEl = itemEl.querySelector(
        '[data-scope="listbox"][data-part="item-text"]'
      );
      if (textEl) {
        this.spreadProps(textEl, this.api.getItemTextProps({ item }));
      }
      const indicatorEl = itemEl.querySelector(
        '[data-scope="listbox"][data-part="item-indicator"]'
      );
      if (indicatorEl) {
        this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
      }
    });
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="listbox"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector('[data-scope="listbox"][data-part="label"]');
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const inputEl = this.el.querySelector('[data-scope="listbox"][data-part="input"]');
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());
    const contentEl = this.el.querySelector(
      '[data-scope="listbox"][data-part="content"]'
    );
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.applyItemProps();
    }
  }
};

// hooks/listbox.ts
function listboxZagPropsBase(el, liveSocket, pushEvent) {
  const redirectOn = getBoolean(el, "redirect");
  return {
    id: el.id,
    disabled: getBoolean(el, "disabled"),
    dir: getDir(el),
    orientation: getString(el, "orientation"),
    loopFocus: getBoolean(el, "loopFocus"),
    selectionMode: redirectOn ? "single" : getString(el, "selectionMode"),
    selectOnHighlight: getBoolean(el, "selectOnHighlight"),
    deselectable: getBoolean(el, "deselectable"),
    typeahead: getBoolean(el, "typeahead"),
    onValueChange: (details) => {
      if (redirectOn) {
        redirectCollectionItem(el, "listbox", firstSelectedValue(details.value), liveSocket);
      }
      notifyChange({
        el,
        canPushServer: canPushEvent(liveSocket),
        pushEvent,
        payload: {
          id: el.id,
          value: details.value,
          items: details.items
        },
        serverEventName: getString(el, "onValueChange"),
        clientEventName: getString(el, "onValueChangeClient")
      });
    }
  };
}
var ListboxHook = createZagLiveHook({
  key: "listbox",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const { items: allItems, hasGroups } = initCollectionItems(el, hook);
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const zag = new Listbox(el, {
      ...listboxZagPropsBase(el, hook.liveSocket, pushEvent),
      collection: buildCollection(allItems, hasGroups),
      ...readStringListControlledZagProps(el, "value", "defaultValue")
    });
    applyItems(zag, allItems, hasGroups);
    const emitValue = createValueEmitter(
      { el, pushEvent, canPushServer: canPush },
      {
        getValue: () => zag.api.value,
        serverEventName: "listbox_value_response",
        domEventName: "listbox-value"
      }
    );
    dom.add("corex:listbox:set-value", (event) => {
      zag.api.setValue(event.detail.value);
    });
    dom.add("corex:listbox:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });
    server.add("listbox_set_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(payload.value);
    });
    server.add("listbox_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });
    return zag;
  },
  update(hook, zag) {
    const itemsChanged = refreshItemsIfChanged(hook.el, hook, zag);
    const propsApplied = zag.updateProps(
      {
        ...listboxZagPropsBase(hook.el, hook.liveSocket, hook.pushEvent.bind(hook)),
        collection: zag.getCollection(),
        ...readStringListControlledZagUpdate(hook.el, "value", "defaultValue", hook.beforeAttrs)
      },
      { force: itemsChanged }
    );
    if (!propsApplied || itemsChanged) {
      zag.render();
    }
  }
});
export {
  ListboxHook as Listbox,
  buildCollection
};
