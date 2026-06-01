import { describe, expect, it, afterEach } from "vitest";
import type { ActionOptions } from "@zag-js/toast";
import {
  actionClassTokens,
  createToast,
  createToastGroup,
  disposeToastGroup,
  dismissToast,
  getToastStore,
  removeToast,
  updateToast,
} from "../../components/toast";

describe("actionClassTokens", () => {
  it("splits className on action", () => {
    expect(actionClassTokens({ className: "button button--sm" })).toEqual(["button", "button--sm"]);
  });

  it("returns empty for invalid action", () => {
    expect(actionClassTokens(null)).toEqual([]);
    expect(actionClassTokens({})).toEqual([]);
  });
});

describe("toast group API", () => {
  const groupId = "toast-test-group";

  afterEach(() => {
    disposeToastGroup(groupId);
  });

  it("createToastGroup registers store and dataset", () => {
    const container = document.createElement("div");
    container.id = groupId;
    const { store } = createToastGroup(container, { id: groupId });
    expect(store).toBeTruthy();
    expect(container.dataset.toastGroup).toBe("true");
    expect(getToastStore(groupId)).toBe(store);
  });

  it("createToast and lifecycle helpers use the store", () => {
    const container = document.createElement("div");
    container.id = groupId;
    createToastGroup(container, { id: groupId });
    createToast({ id: "t1", title: "Hi", groupId });
    const store = getToastStore(groupId);
    expect(store?.getCount()).toBe(1);
    updateToast("t1", { title: "Updated" }, groupId);
    dismissToast("t1", groupId);
    removeToast("t1", groupId);
    expect(store?.getCount()).toBe(0);
  });

  it("createToast throws without a store", () => {
    expect(() => createToast({ id: "orphan", title: "X" })).toThrow(/No toast store/);
  });

  it("disposeToastGroup clears dataset markers", () => {
    const container = document.createElement("div");
    container.id = "toast-dispose";
    createToastGroup(container, { id: "toast-dispose" });
    disposeToastGroup("toast-dispose");
    expect(container.dataset.toastGroup).toBeUndefined();
    expect(container.dataset.toastGroupId).toBeUndefined();
  });

  it("renders action label as text without HTML injection", () => {
    const container = document.createElement("div");
    container.id = groupId;
    container.setAttribute("phx-hook", "Toast");
    document.body.appendChild(container);

    const { group, store } = createToastGroup(container, { id: groupId });
    const malicious = '<img src=x onerror="window.__toastXss=1">';
    store.create({
      id: "t-xss",
      title: "Title",
      type: "info",
      action: { label: malicious, onClick: () => {} },
    });
    group.render();

    const action = container.querySelector<HTMLElement>(
      '[data-scope="toast"][data-part="action-trigger"]'
    );
    expect(action).toBeTruthy();
    expect(action!.textContent).toBe(malicious);
    expect(action!.querySelector("img")).toBeNull();

    document.body.removeChild(container);
  });

  it("renders html action labels when labelHtml is true", () => {
    const container = document.createElement("div");
    container.id = groupId;
    container.setAttribute("phx-hook", "Toast");
    document.body.appendChild(container);

    const { group, store } = createToastGroup(container, { id: groupId });
    store.create({
      id: "t-html-label",
      title: "Title",
      type: "info",
      action: {
        label: '<span data-testid="custom-label">Open</span>',
        labelHtml: true,
        onClick: () => {},
      } as ActionOptions & { labelHtml?: boolean },
    });
    group.render();

    const action = container.querySelector<HTMLElement>(
      '[data-scope="toast"][data-part="action-trigger"]'
    );
    expect(action?.querySelector('[data-testid="custom-label"]')).toBeTruthy();

    document.body.removeChild(container);
  });

  it("clones close and loading icons from templates", () => {
    const container = document.createElement("div");
    container.id = groupId;
    container.setAttribute("phx-hook", "Toast");

    const closeTemplate = document.createElement("div");
    closeTemplate.id = `${groupId}-close-icon`;
    closeTemplate.setAttribute("data-close-icon-template", "");
    const closeSvg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    closeSvg.setAttribute("data-testid", "close-icon");
    closeTemplate.appendChild(closeSvg);

    const loadingTemplate = document.createElement("div");
    loadingTemplate.id = `${groupId}-loading-icon`;
    loadingTemplate.setAttribute("data-loading-icon-template", "");
    const loadingSvg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    loadingSvg.setAttribute("data-testid", "loading-icon");
    loadingTemplate.appendChild(loadingSvg);

    container.append(closeTemplate, loadingTemplate);
    document.body.appendChild(container);

    const { group, store } = createToastGroup(container, { id: groupId });
    store.create({
      id: "t-icons",
      title: "Title",
      type: "info",
      meta: { loading: true },
    });
    group.render();

    const close = container.querySelector<HTMLElement>(
      '[data-scope="toast"][data-part="close-trigger"]'
    );
    const loading = container.querySelector<HTMLElement>(
      '[data-scope="toast"][data-part="loading-spinner"]'
    );

    expect(close?.querySelector("svg[data-testid='close-icon']")).toBeTruthy();
    expect(loading?.querySelector("svg[data-testid='loading-icon']")).toBeTruthy();
    expect(closeTemplate.querySelector("svg")).toBeTruthy();

    document.body.removeChild(container);
  });
});
