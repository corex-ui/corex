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

    const trigger = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="trigger"]'
    );
    if (trigger) this.spreadProps(trigger, this.api.getTriggerProps());

    const positioner = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="positioner"]'
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());

    const content = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="content"]'
    );
    if (content) this.spreadProps(content, this.api.getContentProps());

    const hidden = this.el.querySelector<HTMLElement>(
      '[data-scope="cascade-select"][data-part="hidden-input"]'
    );
    if (hidden) this.spreadProps(hidden, this.api.getHiddenInputProps());

    const col = this.api.collection;
    const children = col.getNodeChildren(col.rootNode);
    children.forEach((item, index) => {
      const value = [item.value];
      const indexPath = [index];
      const selector = `[data-scope="cascade-select"][data-part="item"][data-value="${CSS.escape(item.value)}"]`;
      let node = content?.querySelector<HTMLElement>(selector);
      if (!node && content) {
        node = document.createElement("div");
        node.dataset.scope = "cascade-select";
        node.dataset.part = "item";
        node.dataset.value = item.value;
        node.textContent = item.label ?? item.value;
        content.appendChild(node);
      }
      if (node) this.spreadProps(node, this.api.getItemProps({ item, indexPath, value }));
    });
  }
}
