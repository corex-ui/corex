import type { TreeNode } from "../../components/tree-view";
import { scopeTree } from "./component-fixture";

export const smokeId = "corex-smoke";

export function withId(el: HTMLElement, id = smokeId): HTMLElement {
  el.id = id;
  return el;
}

export function toggleInputTree(scope: "checkbox" | "switch"): HTMLElement {
  return withId(
    scopeTree(scope, [
      {
        part: "root",
        children: [
          { part: "control", children: [{ part: scope === "checkbox" ? "indicator" : "thumb" }] },
          { part: "label", text: "Label" },
          { part: "hidden-input" },
        ],
      },
    ])
  );
}

export function accordionTree(): HTMLElement {
  return withId(
    scopeTree("accordion", [
      {
        part: "root",
        children: [
          {
            part: "item",
            attrs: { "data-value": "one" },
            children: [
              { part: "item-trigger" },
              { part: "item-indicator" },
              { part: "item-content" },
            ],
          },
        ],
      },
    ])
  );
}

export function carouselTree(slides = 1): HTMLElement {
  const el = withId(
    scopeTree("carousel", [
      {
        part: "root",
        children: [
          { part: "control" },
          { part: "item-group" },
          { part: "prev-trigger" },
          { part: "next-trigger" },
        ],
      },
    ])
  );
  el.dataset.slideCount = String(slides);
  for (let i = 0; i < slides; i++) {
    const item = document.createElement("div");
    item.dataset.scope = "carousel";
    item.dataset.part = "item";
    item.dataset.index = String(i);
    el.appendChild(item);
  }
  return el;
}

export function collapsibleTree(): HTMLElement {
  return withId(
    scopeTree("collapsible", [
      {
        part: "root",
        children: [{ part: "trigger" }, { part: "content" }],
      },
    ])
  );
}

export function colorPickerTree(): HTMLElement {
  const el = withId(document.createElement("div"));
  for (const part of ["root", "label", "hidden-input", "control", "trigger"]) {
    const node = document.createElement("div");
    node.dataset.part = part;
    el.appendChild(node);
  }
  return el;
}

export function comboboxTree(): HTMLElement {
  const el = withId(
    scopeTree("combobox", [
      {
        part: "root",
        children: [{ part: "control" }, { part: "input" }, { part: "list" }],
      },
    ])
  );
  const hidden = document.createElement("input");
  hidden.dataset.scope = "combobox";
  hidden.dataset.part = "hidden-input";
  el.prepend(hidden);
  return el;
}

export function selectTree(): HTMLElement {
  return withId(
    scopeTree("select", [
      {
        part: "root",
        children: [
          { part: "label" },
          { part: "control" },
          { part: "trigger" },
          { part: "indicator" },
          {
            part: "content",
            children: [
              {
                part: "item",
                attrs: { "data-value": "a" },
                children: [{ part: "item-text" }, { part: "item-indicator" }],
              },
            ],
          },
        ],
      },
    ])
  );
}

export function listboxTree(): HTMLElement {
  return withId(
    scopeTree("listbox", [
      {
        part: "root",
        children: [
          {
            part: "content",
            children: [
              {
                part: "item",
                attrs: { "data-value": "a" },
                children: [{ part: "item-text" }, { part: "item-indicator" }],
              },
            ],
          },
        ],
      },
    ])
  );
}

export function menuTree(): HTMLElement {
  return withId(
    scopeTree("menu", [
      {
        part: "root",
        children: [{ part: "trigger" }, { part: "content" }],
      },
    ])
  );
}

export function numberInputTree(): HTMLElement {
  return withId(
    scopeTree("number-input", [
      {
        part: "root",
        children: [{ part: "label" }, { part: "control" }, { part: "input" }],
      },
    ])
  );
}

export function passwordInputTree(): HTMLElement {
  return withId(
    scopeTree("password-input", [
      {
        part: "root",
        children: [
          { part: "label" },
          { part: "control" },
          { part: "input" },
          { part: "visibility-trigger" },
          { part: "indicator" },
        ],
      },
    ])
  );
}

export function pinInputTree(count = 4): HTMLElement {
  const el = withId(
    scopeTree("pin-input", [
      {
        part: "root",
        children: [{ part: "control" }],
      },
    ])
  );
  const control = el.querySelector('[data-part="control"]')!;
  for (let i = 0; i < count; i++) {
    const input = document.createElement("input");
    input.dataset.scope = "pin-input";
    input.dataset.part = "input";
    control.appendChild(input);
  }
  return el;
}

export function radioGroupTree(): HTMLElement {
  return withId(
    scopeTree("radio-group", [
      {
        part: "root",
        children: [
          { part: "label" },
          { part: "indicator" },
          {
            part: "item",
            attrs: { "data-value": "a" },
            children: [{ part: "item-text" }],
          },
        ],
      },
    ])
  );
}

export function tabsTree(): HTMLElement {
  return withId(
    scopeTree("tabs", [
      {
        part: "root",
        children: [
          { part: "list" },
          {
            part: "trigger",
            attrs: { "data-value": "home" },
          },
          {
            part: "content",
            attrs: { "data-value": "home" },
          },
        ],
      },
    ])
  );
}

export function tagsInputTree(): HTMLElement {
  return withId(
    scopeTree("tags-input", [
      {
        part: "root",
        children: [{ part: "control" }, { part: "input" }],
      },
    ])
  );
}

export function timerTree(): HTMLElement {
  const el = withId(
    scopeTree("timer", [
      {
        part: "root",
        children: [{ part: "area" }, { part: "control" }],
      },
    ])
  );
  el.dataset.segments = "minutes,seconds";
  for (const type of ["minutes", "seconds"]) {
    const item = document.createElement("div");
    item.dataset.scope = "timer";
    item.dataset.part = "item";
    item.dataset.type = type;
    el.appendChild(item);
    const label = document.createElement("div");
    label.dataset.scope = "timer";
    label.dataset.part = "item-label";
    label.dataset.type = type;
    el.appendChild(label);
  }
  return el;
}

export function toggleTree(): HTMLElement {
  return withId(
    scopeTree("toggle", [
      {
        part: "root",
        children: [{ part: "control" }, { part: "indicator" }],
      },
    ])
  );
}

export function toggleGroupTree(): HTMLElement {
  return withId(
    scopeTree("toggle-group", [
      {
        part: "root",
        children: [
          {
            part: "item",
            attrs: { "data-value": "a" },
          },
        ],
      },
    ])
  );
}

export function tooltipTree(): HTMLElement {
  return withId(
    scopeTree("tooltip", [
      {
        part: "root",
        children: [
          { part: "trigger" },
          { part: "positioner", children: [{ part: "content" }, { part: "arrow" }] },
        ],
      },
    ])
  );
}

export function treeViewTree(): HTMLElement {
  return withId(
    scopeTree("tree-view", [
      {
        part: "root",
        children: [{ part: "tree" }],
      },
    ])
  );
}

export function fileUploadTree(): HTMLElement {
  return withId(
    scopeTree("file-upload", [
      {
        part: "root",
        children: [
          { part: "label" },
          { part: "dropzone" },
          { part: "trigger" },
          { part: "hidden-input" },
        ],
      },
    ])
  );
}

export function dialogTree(): HTMLElement {
  return withId(
    scopeTree("dialog", [
      {
        part: "root",
        children: [
          { part: "trigger" },
          { part: "backdrop" },
          { part: "positioner", children: [{ part: "content" }] },
        ],
      },
    ])
  );
}

export function editableTree(): HTMLElement {
  return withId(
    scopeTree("editable", [
      {
        part: "root",
        children: [
          { part: "area" },
          { part: "preview" },
          { part: "input" },
          { part: "edit-trigger" },
          { part: "submit-trigger" },
          { part: "cancel-trigger" },
        ],
      },
    ])
  );
}

export function floatingPanelTree(): HTMLElement {
  return withId(
    scopeTree("floating-panel", [
      {
        part: "root",
        children: [{ part: "trigger" }, { part: "content" }],
      },
    ])
  );
}

export function angleSliderTree(): HTMLElement {
  return withId(
    scopeTree("angle-slider", [
      {
        part: "root",
        children: [{ part: "control" }, { part: "thumb" }, { part: "hidden-input" }],
      },
    ])
  );
}

export function avatarTree(): HTMLElement {
  return withId(
    scopeTree("avatar", [
      {
        part: "root",
        children: [{ part: "fallback" }],
      },
    ])
  );
}

export function clipboardTree(): HTMLElement {
  return withId(document.createElement("div"));
}

export function marqueeTree(): HTMLElement {
  return withId(
    scopeTree("marquee", [
      {
        part: "root",
        children: [
          { part: "edge", attrs: { "data-side": "start" } },
          { part: "viewport", children: [{ part: "content", children: [{ part: "item" }] }] },
          { part: "edge", attrs: { "data-side": "end" } },
        ],
      },
    ])
  );
}

export function signaturePadTree(): HTMLElement {
  return withId(
    scopeTree("signature-pad", [
      {
        part: "root",
        children: [
          { part: "label" },
          { part: "control", children: [{ part: "segment" }, { part: "guide" }] },
          { part: "clear-trigger" },
          { part: "hidden-input" },
        ],
      },
    ])
  );
}

export function paginationTree(): HTMLElement {
  const el = withId(
    scopeTree("pagination", [
      {
        part: "root",
        children: [{ part: "prev-trigger" }, { part: "next-trigger" }],
      },
    ])
  );
  const li = document.createElement("li");
  const item = document.createElement("a");
  item.dataset.scope = "pagination";
  item.dataset.part = "item";
  li.appendChild(item);
  el.querySelector('[data-part="root"]')?.appendChild(li);
  return el;
}

export const sampleTreeRoot: TreeNode = {
  value: "root",
  name: "Root",
  children: [{ value: "child", name: "Child" }],
};
