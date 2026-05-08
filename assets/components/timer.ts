import { connect, machine, type Props, type Api } from "@zag-js/timer";
import type { ItemProps, ActionTriggerProps, Time } from "@zag-js/timer";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getStringList } from "../lib/util";

function collapseStartIndex(vals: number[]): number {
  const rec = (idx: number): number => {
    if (idx > 2) return idx;
    const restAfter = vals.length - idx;
    if (idx < 3 && vals[idx] === 0 && restAfter > 2) {
      return rec(idx + 1);
    }
    return idx;
  };
  return rec(0);
}

function computeItemHidden(root: HTMLElement, time: Time<number>): boolean[] {
  const types = ["days", "hours", "minutes", "seconds"] as const;
  const vals = [time.days, time.hours, time.minutes, time.seconds].map(Number);
  const segments = getStringList(root, "segments");
  const countdown = root.dataset.countdown === "true";
  const collapseRaw = root.dataset.collapseLeadingZeros;

  if (segments && segments.length > 0) {
    return types.map((t) => !segments.includes(t));
  }
  if (collapseRaw === "false") {
    return [false, false, false, false];
  }
  if (collapseRaw === "true" || (collapseRaw !== "false" && countdown)) {
    const start = collapseStartIndex(vals);
    return types.map((_, i) => i < start);
  }
  return [false, false, false, false];
}

function applyTimerItemVisibility(root: HTMLElement, api: Api): void {
  const hidden = computeItemHidden(root, api.time);
  const types = ["days", "hours", "minutes", "seconds"] as const;
  const hostId = root.id;

  types.forEach((type, i) => {
    const segmentEl = root.querySelector<HTMLElement>(`[data-timer-segment][data-type="${type}"]`);
    if (segmentEl) {
      if (hidden[i]) {
        segmentEl.setAttribute("hidden", "");
      } else {
        segmentEl.removeAttribute("hidden");
      }
    }

    const itemEl = root.querySelector<HTMLElement>(
      `[data-scope="timer"][data-part="item"][data-type="${type}"]`
    );
    if (itemEl) {
      if (hidden[i]) {
        itemEl.setAttribute("hidden", "");
        itemEl.setAttribute("aria-hidden", "true");
      } else {
        itemEl.removeAttribute("hidden");
        itemEl.setAttribute("aria-hidden", "false");
      }
    }
  });

  for (let k = 0; k < 3; k++) {
    const sepId = `timer:${hostId}:sep:${k}`;
    const sepEl = root.querySelector<HTMLElement>(`[id="${CSS.escape(sepId)}"]`);
    if (sepEl) {
      if (hidden[k]) {
        sepEl.setAttribute("hidden", "");
      } else {
        sepEl.removeAttribute("hidden");
      }
    }
  }
}

export class Timer extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  init = (): void => {
    this.machine.subscribe(() => {
      (this as { api: Api }).api = this.initApi();
      this.render();
    });
    this.machine.start();
    (this as { api: Api }).api = this.initApi();
    this.render();
  };

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="timer"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const areaEl = this.el.querySelector<HTMLElement>('[data-scope="timer"][data-part="area"]');
    if (areaEl) this.spreadProps(areaEl, this.api.getAreaProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="timer"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const timeParts = ["days", "hours", "minutes", "seconds"] as const;
    timeParts.forEach((type) => {
      const itemEl = this.el.querySelector<HTMLElement>(
        `[data-scope="timer"][data-part="item"][data-type="${type}"]`
      );
      if (itemEl) {
        this.spreadProps(itemEl, this.api.getItemProps({ type } as ItemProps));
      }
      const labelEl = this.el.querySelector<HTMLElement>(
        `[data-scope="timer"][data-part="item-label"][data-type="${type}"]`
      );
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getItemLabelProps({ type } as ItemProps));
      }
    });

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="timer"][data-part="separator"]')
      .forEach((separatorEl) => {
        this.spreadProps(separatorEl, this.api.getSeparatorProps());
      });

    const actions = ["start", "pause", "resume", "reset"] as const;
    actions.forEach((action) => {
      const triggerEl = this.el.querySelector<HTMLElement>(
        `[data-scope="timer"][data-part="action-trigger"][data-action="${action}"]`
      );
      if (triggerEl)
        this.spreadProps(
          triggerEl,
          this.api.getActionTriggerProps({ action } as ActionTriggerProps)
        );
    });

    applyTimerItemVisibility(this.el, this.api);
  }
}
