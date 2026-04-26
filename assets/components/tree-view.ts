import { collection, connect, machine, type Props, type Api } from "@zag-js/tree-view";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { stripHiddenFromProps } from "../lib/animation";

export interface TreeNode {
  id: string;
  name: string;
  children?: TreeNode[];
  to?: string;
  redirect?: "href" | "patch" | "navigate" | false;
  new_tab?: boolean;
  disabled?: boolean;
}

function createTreeCollection(rootNode: TreeNode) {
  return collection<TreeNode>({
    nodeToValue: (node) => node.id,
    nodeToString: (node) => node.name,
    rootNode,
  });
}

export class TreeView extends Component<Props, Api> {
  private treeCollection: ReturnType<typeof collection<TreeNode>>;

  constructor(el: HTMLElement | null, props: Omit<Props, "collection"> & { rootNode: TreeNode }) {
    const { rootNode, ...rest } = props;
    const treeCollection = createTreeCollection(rootNode);
    super(el, { ...rest, collection: treeCollection } as Props);
    this.treeCollection = treeCollection;
  }

  replaceRootNode(rootNode: TreeNode): void {
    const treeCollection = createTreeCollection(rootNode);
    this.treeCollection = treeCollection;
    this.updateProps({ collection: treeCollection });
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, { ...props });
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  private getNodeAt(indexPath: number[]): TreeNode | undefined {
    if (indexPath.length === 0) return undefined;
    let current: TreeNode | undefined = this.treeCollection.rootNode as TreeNode;
    for (const i of indexPath) {
      current = current?.children?.[i];
      if (!current) return undefined;
    }
    return current;
  }

  private updateExistingTree(treeEl: HTMLElement) {
    this.spreadProps(treeEl, this.api.getTreeProps());

    const animation = this.el.dataset.animation ?? "js";

    const isOwnedByTree = (el: Element) =>
      el.closest('[data-scope="tree-view"][data-part="tree"]') === treeEl;

    const branches = treeEl.querySelectorAll<HTMLElement>(
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

      const controlEl = branchEl.querySelector<HTMLElement>(
        '[data-scope="tree-view"][data-part="branch-control"]'
      );
      if (controlEl) this.spreadProps(controlEl, this.api.getBranchControlProps(nodeProps));

      const textEl = branchEl.querySelector<HTMLElement>(
        '[data-scope="tree-view"][data-part="branch-text"]'
      );
      if (textEl) this.spreadProps(textEl, this.api.getBranchTextProps(nodeProps));

      const indicatorEl = branchEl.querySelector<HTMLElement>(
        '[data-scope="tree-view"][data-part="branch-indicator"]'
      );
      if (indicatorEl) this.spreadProps(indicatorEl, this.api.getBranchIndicatorProps(nodeProps));

      const contentEl = branchEl.querySelector<HTMLElement>(
        '[data-scope="tree-view"][data-part="branch-content"]'
      );
      if (contentEl) {
        const contentPropsRaw = this.api.getBranchContentProps(nodeProps);
        if (animation === "instant") {
          this.spreadProps(contentEl, contentPropsRaw);
        } else {
          this.spreadProps(
            contentEl,
            stripHiddenFromProps(contentPropsRaw as Record<string, unknown>)
          );
          contentEl.removeAttribute("hidden");
        }
      }

      const indentGuideEl = branchEl.querySelector<HTMLElement>(
        '[data-scope="tree-view"][data-part="branch-indent-guide"]'
      );
      if (indentGuideEl)
        this.spreadProps(indentGuideEl, this.api.getBranchIndentGuideProps(nodeProps));
    }

    const items = treeEl.querySelectorAll<HTMLElement>(
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

      const itemTextEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="tree-view"][data-part="item-text"]'
      );
      if (itemTextEl) this.spreadProps(itemTextEl, this.api.getItemTextProps(nodeProps));

      const itemIndicatorEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="tree-view"][data-part="item-indicator"]'
      );
      if (itemIndicatorEl)
        this.spreadProps(itemIndicatorEl, this.api.getItemIndicatorProps(nodeProps));
    }
  }

  private syncTree = () => {
    const treeEl = this.el.querySelector<HTMLElement>('[data-scope="tree-view"][data-part="tree"]');
    if (!treeEl) return;

    this.spreadProps(treeEl, this.api.getTreeProps());
    this.updateExistingTree(treeEl);
  };

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="tree-view"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const label = this.el.querySelector<HTMLElement>('[data-scope="tree-view"][data-part="label"]');
    if (label) this.spreadProps(label, this.api.getLabelProps());

    this.syncTree();
  }
}
