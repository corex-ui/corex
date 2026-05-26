import {
  buildCollection,
  collection,
  connect,
  itemValue,
  machine,
  zagListCollectionConfig
} from "./chunks/chunk-OAGPTRUC.mjs";
import "./chunks/chunk-4PIYPYVK.mjs";
import {
  performRedirect,
  readDomItemRedirect
} from "./chunks/chunk-FOQSALVP.mjs";
import "./chunks/chunk-V4PB2O2G.mjs";
import {
  readStringListControlledZagProps,
  readStringListControlledZagUpdate
} from "./chunks/chunk-VL4ETB3G.mjs";
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
} from "./chunks/chunk-2WCNJX5P.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  getBoolean,
  getDir,
  getString
} from "./chunks/chunk-EWT2BP2N.mjs";

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
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
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
      const firstValue = details.value.length > 0 ? String(details.value[0]) : null;
      if (redirectOn && firstValue) {
        const itemEl = el.querySelector(
          `[data-scope="listbox"][data-part="item"][data-value="${CSS.escape(firstValue)}"]`
        );
        performRedirect(readDomItemRedirect(itemEl, firstValue), { liveSocket });
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
var ListboxHook = {
  mounted() {
    const el = this.el;
    const allItems = JSON.parse(el.dataset.items ?? "[]");
    const hasGroups = allItems.some((item) => Boolean(item.group));
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const zag = new Listbox(el, {
      ...listboxZagPropsBase(el, this.liveSocket, pushEvent),
      collection: buildCollection(allItems, hasGroups),
      ...readStringListControlledZagProps(el, "value", "defaultValue")
    });
    zag.hasGroups = hasGroups;
    zag.setOptions(allItems);
    zag.init();
    this.listbox = zag;
    const emitValue = (respondTo) => {
      const value = zag.api.value;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "listbox_value_response",
        serverPayload: { id: el.id, value },
        el,
        domEventName: "listbox-value",
        domDetail: { id: el.id, value }
      });
    };
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:listbox:set-value", (event) => {
      zag.api.setValue(event.detail.value);
    });
    domRegistry.add("corex:listbox:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("listbox_set_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(payload.value);
    });
    registry.add("listbox_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });
  },
  updated() {
    if (!this.listbox) return;
    const newItems = JSON.parse(this.el.dataset.items ?? "[]");
    const hasGroups = newItems.some((item) => Boolean(item.group));
    this.listbox.hasGroups = hasGroups;
    this.listbox.setOptions(newItems);
    this.listbox.updateProps({
      ...listboxZagPropsBase(this.el, this.liveSocket, this.pushEvent.bind(this)),
      collection: this.listbox.getCollection(),
      ...readStringListControlledZagUpdate(this.el, "value", "defaultValue")
    });
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.listbox?.destroy();
  }
};
export {
  ListboxHook as Listbox,
  buildCollection
};
