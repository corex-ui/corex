import { describe, expect, it, afterEach } from "vitest";
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
});
