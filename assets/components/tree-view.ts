import * as tree from "@zag-js/tree-view";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export interface TreeNode {
  id: string;
  name: string;
  children?: TreeNode[];
  redirect?: boolean;
  new_tab?: boolean;
}

function buildTreeFromDOM(rootEl: HTMLElement): TreeNode {
  const selector =
    '[data-scope="tree-view"][data-part="branch"], [data-scope="tree-view"][data-part="item"]';
  const elements = rootEl.querySelectorAll<HTMLElement>(selector);
  const nodes: Array<{
    pathArr: number[];
    id: string;
    name: string;
    isBranch: boolean;
  }> = [];
  for (const el of elements) {
    const pathRaw = el.getAttribute("data-path");
    const value = el.getAttribute("data-value");
    if (pathRaw == null || value == null) continue;
    const pathArr = pathRaw.split("/").map((s) => parseInt(s, 10));
    if (pathArr.some(Number.isNaN)) continue;
    const name = el.getAttribute("data-name") ?? value;
    const isBranch = el.getAttribute("data-part") === "branch";
    nodes.push({ pathArr, id: value, name, isBranch });
  }
  nodes.sort((a, b) => {
    const len = Math.min(a.pathArr.length, b.pathArr.length);
    for (let i = 0; i < len; i++) {
      if (a.pathArr[i] !== b.pathArr[i]) return a.pathArr[i] - b.pathArr[i];
    }
    return a.pathArr.length - b.pathArr.length;
  });
  const root: TreeNode = { id: "ROOT", name: "", children: [] };
  for (const { pathArr, id, name, isBranch } of nodes) {
    let parent: TreeNode = root;
    for (let i = 0; i < pathArr.length - 1; i++) {
      const idx = pathArr[i];
      if (!parent.children) parent.children = [];
      parent = parent.children[idx] as TreeNode;
    }
    const lastIdx = pathArr[pathArr.length - 1]!;
    if (!parent.children) parent.children = [];
    parent.children[lastIdx] = isBranch
      ? { id, name, children: [] }
      : { id, name };
  }
  return root;
}

export class TreeView extends Component<tree.Props, tree.Api> {
  private collection: ReturnType<typeof tree.collection<TreeNode>>;

  constructor(
    el: HTMLElement | null,
    props: Omit<tree.Props, "collection"> & { treeData?: TreeNode }
  ) {
    const treeData = props.treeData ?? buildTreeFromDOM(el as HTMLElement);
    const collection = tree.collection<TreeNode>({
      nodeToValue: (node) => node.id,
      nodeToString: (node) => node.name,
      rootNode: treeData,
    });
    super(el, { ...props, collection } as tree.Props);
    this.collection = collection;
  }

  initMachine(props: tree.Props): VanillaMachine<any> {
    return new VanillaMachine(tree.machine, { ...props });
  }

  initApi(): tree.Api {
    return tree.connect(this.machine.service, normalizeProps);
  }

  private getNodeAt(indexPath: number[]): TreeNode | undefined {
    if (indexPath.length === 0) return undefined;
    let current: TreeNode | undefined = this.collection.rootNode as TreeNode;
    for (const i of indexPath) {
      current = current?.children?.[i];
      if (!current) return undefined;
    }
    return current;
  }

  private updateExistingTree(treeEl: HTMLElement) {
    this.spreadProps(treeEl, this.api.getTreeProps());

    const branches = treeEl.querySelectorAll<HTMLElement>(
      '[data-scope="tree-view"][data-part="branch"]'
    );
    for (const branchEl of branches) {
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
      if (indicatorEl)
        this.spreadProps(indicatorEl, this.api.getBranchIndicatorProps(nodeProps));

      const contentEl = branchEl.querySelector<HTMLElement>(
        '[data-scope="tree-view"][data-part="branch-content"]'
      );
      if (contentEl) this.spreadProps(contentEl, this.api.getBranchContentProps(nodeProps));

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
      const pathRaw = itemEl.getAttribute("data-path");
      if (pathRaw == null) continue;
      const indexPath = pathRaw.split("/").map((s) => parseInt(s, 10));
      const node = this.getNodeAt(indexPath);
      if (!node) continue;
      const nodeProps = { indexPath, node };
      this.spreadProps(itemEl, this.api.getItemProps(nodeProps));
    }
  }

  private syncTree = () => {
    const treeEl = this.el.querySelector<HTMLElement>(
      '[data-scope="tree-view"][data-part="tree"]'
    );
    if (!treeEl) return;

    this.spreadProps(treeEl, this.api.getTreeProps());
    this.updateExistingTree(treeEl);
  };

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>(
        '[data-scope="tree-view"][data-part="root"]'
      ) ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const label = this.el.querySelector<HTMLElement>(
      '[data-scope="tree-view"][data-part="label"]'
    );
    if (label) this.spreadProps(label, this.api.getLabelProps());

    this.syncTree();
  }
}
