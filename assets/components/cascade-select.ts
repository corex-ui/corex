import { collection, connect, machine, type Props, type Api } from "@zag-js/cascade-select";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

export interface CascadeNode {
  value: string;
  label?: string;
  name?: string;
  children?: CascadeNode[];
}

function createCollection(rootNode: CascadeNode) {
  return collection<CascadeNode>({
    nodeToValue: (node) => node.value,
    nodeToString: (node) => node.label ?? node.name ?? node.value,
    rootNode,
  });
}

type Schema = SchemaOf<typeof machine>;

export class CascadeSelect extends Component<Props<CascadeNode>, Api, Schema> {
  constructor(
    el: HTMLElement | null,
    props: Omit<Props<CascadeNode>, "collection"> & { rootNode: CascadeNode }
  ) {
    const { rootNode, ...rest } = props;
    super(el, { ...rest, collection: createCollection(rootNode) } as Props<CascadeNode>);
  }

  updateProps(props: Partial<Props<CascadeNode>> & { rootNode?: CascadeNode }): boolean {
    const { rootNode, ...rest } = props;
    if (rootNode) {
      return super.updateProps({ ...rest, collection: createCollection(rootNode) });
    }
    return super.updateProps(rest);
  }

  initMachine(props: Props<CascadeNode>): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="cascade-select"][data-part="root"]') ??
      this.el;
    this.spreadProps(root, this.api.getRootProps());

    const label = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="label"]'
    );
    if (label) this.spreadProps(label, this.api.getLabelProps());

    const control = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="control"]'
    );
    if (control) this.spreadProps(control, this.api.getControlProps());

    const trigger = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="trigger"]'
    );
    if (trigger) this.spreadProps(trigger, this.api.getTriggerProps());

    const indicator = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="indicator"]'
    );
    if (indicator) this.spreadProps(indicator, this.api.getIndicatorProps());

    const clear = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="clear-trigger"]'
    );
    if (clear) this.spreadProps(clear, this.api.getClearTriggerProps());

    const valueText = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="value-text"]'
    );
    if (valueText) {
      this.spreadProps(valueText, this.api.getValueTextProps());
      const placeholder = this.el.dataset.placeholder || "Select";
      valueText.textContent = this.api.valueAsString || placeholder;
    }

    const positioner = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="positioner"]'
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());

    const content = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="content"]'
    );
    if (content) {
      this.spreadProps(content, this.api.getContentProps());
      this.renderColumns(content);
    }

    const hidden = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="hidden-input"]'
    );
    if (hidden) this.spreadProps(hidden, this.api.getHiddenInputProps());
  }

  private renderColumns(content: HTMLElement): void {
    const col = this.api.collection;
    content.replaceChildren();

    const walk = (node: CascadeNode, indexPath: number[], value: string[]) => {
      const children = col.getNodeChildren(node);
      const list = document.createElement("ul");
      list.dataset.scope = "cascade-select";
      list.dataset.part = "list";
      const parentProps = { item: node, indexPath, value };
      this.spreadProps(list, this.api.getListProps(parentProps));

      children.forEach((item, index) => {
        const itemValue = [...value, col.getNodeValue(item)];
        const itemIndexPath = [...indexPath, index];
        const itemProps = { item, indexPath: itemIndexPath, value: itemValue };
        const itemState = this.api.getItemState(itemProps);

        const li = document.createElement("li");
        li.dataset.scope = "cascade-select";
        li.dataset.part = "item";
        this.spreadProps(li, this.api.getItemProps(itemProps));

        const text = document.createElement("span");
        text.dataset.scope = "cascade-select";
        text.dataset.part = "item-text";
        this.spreadProps(text, this.api.getItemTextProps(itemProps));
        text.textContent = item.label ?? item.name ?? item.value;
        li.appendChild(text);

        if (itemState.hasChildren) {
          const branch = document.createElement("span");
          branch.dataset.scope = "cascade-select";
          branch.dataset.part = "item-branch";
          branch.setAttribute("aria-hidden", "true");
          branch.textContent = "›";
          li.appendChild(branch);
        }

        const indicator = document.createElement("span");
        indicator.dataset.scope = "cascade-select";
        indicator.dataset.part = "item-indicator";
        this.spreadProps(indicator, this.api.getItemIndicatorProps(itemProps));
        indicator.textContent = "✓";
        li.appendChild(indicator);

        list.appendChild(li);
      });

      content.appendChild(list);

      const nodeState = this.api.getItemState(parentProps);
      if (nodeState.highlightedChild && col.isBranchNode(nodeState.highlightedChild)) {
        const childIndex = nodeState.highlightedIndex ?? 0;
        walk(nodeState.highlightedChild, [...indexPath, childIndex], [
          ...value,
          col.getNodeValue(nodeState.highlightedChild),
        ]);
      }
    };

    walk(col.rootNode, [], []);
  }
}
