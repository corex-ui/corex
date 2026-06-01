import { connect, machine, type Props, type Api } from "@zag-js/date-picker";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";

type ZagDatePickerTranslations = NonNullable<Props["translations"]>;

export type DatePickerMessageMap = {
  content?: string;
  monthSelect?: string;
  yearSelect?: string;
  clearTrigger?: string;
  weekColumnHeader?: string;
  openCalendar?: string;
  closeCalendar?: string;
  viewTriggerYear?: string;
  viewTriggerMonth?: string;
  viewTriggerDay?: string;
  prevTriggerYear?: string;
  prevTriggerMonth?: string;
  prevTriggerDay?: string;
  nextTriggerYear?: string;
  nextTriggerMonth?: string;
  nextTriggerDay?: string;
  weekNumber?: string;
  placeholderDay?: string;
  placeholderMonth?: string;
  placeholderYear?: string;
  input?: string;
  rangeStart?: string;
  rangeEnd?: string;
};

type DatePickerView = "day" | "month" | "year";

const pickViewLabel = <T>(
  view: DatePickerView,
  day: T | undefined,
  month: T | undefined,
  year: T | undefined
): T | "" => (view === "year" ? (year ?? "") : view === "month" ? (month ?? "") : (day ?? ""));

const formatWeek = (template: string, n: number): string => template.split("__N__").join(String(n));

export function buildZagDatePickerTranslations(m: DatePickerMessageMap): ZagDatePickerTranslations {
  const t: Record<string, unknown> = {};
  if (m.content) t.content = m.content;
  if (m.monthSelect) t.monthSelect = m.monthSelect;
  if (m.yearSelect) t.yearSelect = m.yearSelect;
  if (m.clearTrigger) t.clearTrigger = m.clearTrigger;
  if (m.weekColumnHeader) t.weekColumnHeader = m.weekColumnHeader;
  if (m.weekNumber) t.weekNumberCell = (n: number) => formatWeek(m.weekNumber!, n);

  if (m.openCalendar && m.closeCalendar) {
    t.trigger = (open: boolean) => (open ? m.closeCalendar! : m.openCalendar!);
  }

  if (m.viewTriggerDay || m.viewTriggerMonth || m.viewTriggerYear) {
    t.viewTrigger = (view: string) =>
      pickViewLabel(
        view as DatePickerView,
        m.viewTriggerDay,
        m.viewTriggerMonth,
        m.viewTriggerYear
      );
  }
  if (m.prevTriggerDay || m.prevTriggerMonth || m.prevTriggerYear) {
    t.prevTrigger = (view: string) =>
      pickViewLabel(
        view as DatePickerView,
        m.prevTriggerDay,
        m.prevTriggerMonth,
        m.prevTriggerYear
      );
  }
  if (m.nextTriggerDay || m.nextTriggerMonth || m.nextTriggerYear) {
    t.nextTrigger = (view: string) =>
      pickViewLabel(
        view as DatePickerView,
        m.nextTriggerDay,
        m.nextTriggerMonth,
        m.nextTriggerYear
      );
  }

  if (m.placeholderDay && m.placeholderMonth && m.placeholderYear) {
    t.placeholder = () => ({
      day: m.placeholderDay!,
      month: m.placeholderMonth!,
      year: m.placeholderYear!,
    });
  }

  return t as unknown as ZagDatePickerTranslations;
}

export function applyInputAriaIfNeeded(
  el: HTMLElement,
  inputs: HTMLInputElement[],
  selectionMode: string | undefined
): void {
  if (
    selectionMode === "range" ||
    el.querySelector('[data-scope="date-picker"][data-part="label"]')
  ) {
    return;
  }
  let tr: DatePickerMessageMap | null = null;
  const raw = el.dataset.translation;
  if (raw) {
    try {
      tr = JSON.parse(raw) as DatePickerMessageMap;
    } catch {
      tr = null;
    }
  }
  const value = tr?.input;
  if (!value) return;
  for (const input of inputs) {
    if (!input.getAttribute("aria-labelledby")) {
      input.setAttribute("aria-label", value);
    }
  }
}

export class DatePicker extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  private getDayView = () => this.el.querySelector<HTMLElement>('[data-part="day-view"]');
  private getMonthView = () => this.el.querySelector<HTMLElement>('[data-part="month-view"]');
  private getYearView = () => this.el.querySelector<HTMLElement>('[data-part="year-view"]');

  private ensureTableRow(tbody: HTMLElement, rowIndex: number): HTMLElement {
    let tr = tbody.children[rowIndex] as HTMLElement | undefined;
    if (!tr || tr.tagName !== "TR") {
      tr = this.doc.createElement("tr");
      const ref = tbody.children[rowIndex] ?? null;
      tbody.insertBefore(tr, ref);
    }
    return tr;
  }

  private ensureTableCell(
    tr: HTMLElement,
    cellIndex: number,
    cellKey: string
  ): { td: HTMLElement; trigger: HTMLElement } {
    let td = tr.children[cellIndex] as HTMLElement | undefined;
    if (td && (td.tagName !== "TD" || td.dataset.dateCell !== cellKey)) {
      td.remove();
      td = undefined;
    }
    if (!td) {
      td = this.doc.createElement("td");
      td.dataset.dateCell = cellKey;
      const trigger = this.doc.createElement("div");
      td.appendChild(trigger);
      const ref = tr.children[cellIndex] ?? null;
      tr.insertBefore(td, ref);
    }
    const trigger = td.querySelector("div") as HTMLElement;
    return { td, trigger };
  }

  private trimTableRows(tbody: HTMLElement, rowCount: number): void {
    while (tbody.children.length > rowCount) {
      tbody.lastElementChild?.remove();
    }
  }

  private trimTableCells(tr: HTMLElement, cellCount: number): void {
    while (tr.children.length > cellCount) {
      tr.lastElementChild?.remove();
    }
  }

  private renderDayTableHeader = () => {
    const dayView = this.getDayView();
    const thead = dayView?.querySelector<HTMLElement>("thead");
    if (!thead || !this.api.weekDays) return;

    let tr = thead.querySelector("tr");
    if (!tr || tr.children.length !== this.api.weekDays.length) {
      tr = this.doc.createElement("tr");
      thead.replaceChildren(tr);
      this.api.weekDays.forEach(() => {
        const th = this.doc.createElement("th");
        th.scope = "col";
        tr!.appendChild(th);
      });
    }

    this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
    this.api.weekDays.forEach((day, index) => {
      const th = tr!.children[index] as HTMLElement;
      th.setAttribute("aria-label", day.long);
      if (th.textContent !== day.narrow) {
        th.textContent = day.narrow;
      }
    });
  };

  private renderDayTableBody = () => {
    const dayView = this.getDayView();
    const tbody = dayView?.querySelector<HTMLElement>("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "day" }));
    if (!this.api.weeks) {
      tbody.replaceChildren();
      return;
    }

    const weeks = this.api.weeks;
    this.trimTableRows(tbody, weeks.length);

    weeks.forEach((week, weekIndex) => {
      const tr = this.ensureTableRow(tbody, weekIndex);
      this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
      this.trimTableCells(tr, week.length);

      week.forEach((value, cellIndex) => {
        const cellKey = `${value.year}-${value.month}-${value.day}`;
        const { td, trigger } = this.ensureTableCell(tr, cellIndex, cellKey);
        this.spreadProps(td, this.api.getDayTableCellProps({ value }));
        this.spreadProps(trigger, this.api.getDayTableCellTriggerProps({ value }));
        const label = String(value.day);
        if (trigger.textContent !== label) {
          trigger.textContent = label;
        }
      });
    });
  };

  private renderMonthTableBody = () => {
    const monthView = this.getMonthView();
    const tbody = monthView?.querySelector<HTMLElement>("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "month" }));
    const monthsGrid = this.api.getMonthsGrid({ columns: 4, format: "short" });
    this.trimTableRows(tbody, monthsGrid.length);

    monthsGrid.forEach((months, rowIndex) => {
      const tr = this.ensureTableRow(tbody, rowIndex);
      this.spreadProps(tr, this.api.getTableRowProps());
      this.trimTableCells(tr, months.length);

      months.forEach((month, cellIndex) => {
        const cellKey = `${this.api.visibleRange.start.year}-${month.value}`;
        const { td, trigger } = this.ensureTableCell(tr, cellIndex, cellKey);
        this.spreadProps(td, this.api.getMonthTableCellProps({ ...month, columns: 4 }));
        this.spreadProps(trigger, this.api.getMonthTableCellTriggerProps({ ...month, columns: 4 }));
        if (trigger.textContent !== month.label) {
          trigger.textContent = month.label;
        }
      });
    });
  };

  private renderYearTableBody = () => {
    const yearView = this.getYearView();
    const tbody = yearView?.querySelector<HTMLElement>("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps());
    const yearsGrid = this.api.getYearsGrid({ columns: 4 });
    this.trimTableRows(tbody, yearsGrid.length);

    yearsGrid.forEach((years, rowIndex) => {
      const tr = this.ensureTableRow(tbody, rowIndex);
      this.spreadProps(tr, this.api.getTableRowProps({ view: "year" }));
      this.trimTableCells(tr, years.length);

      years.forEach((year, cellIndex) => {
        const cellKey = String(year.value);
        const { td, trigger } = this.ensureTableCell(tr, cellIndex, cellKey);
        this.spreadProps(td, this.api.getYearTableCellProps({ ...year, columns: 4 }));
        this.spreadProps(trigger, this.api.getYearTableCellTriggerProps({ ...year, columns: 4 }));
        if (trigger.textContent !== year.label) {
          trigger.textContent = year.label;
        }
      });
    });
  };

  render(): void {
    const root = this.el.querySelector<HTMLElement>('[data-scope="date-picker"][data-part="root"]');
    if (root) this.spreadProps(root, this.api.getRootProps());

    const label = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="label"]'
    );
    if (label) this.spreadProps(label, this.api.getLabelProps());

    const control = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="control"]'
    );
    if (control) this.spreadProps(control, this.api.getControlProps());

    const inputs = Array.from(
      this.el.querySelectorAll<HTMLInputElement>('[data-scope="date-picker"][data-part="input"]')
    );
    const selectionMode = this.api.selectionMode;
    for (let i = 0; i < inputs.length; i += 1) {
      this.spreadProps(inputs[i]!, this.api.getInputProps({ index: i }));
    }
    if (selectionMode === "multiple" && inputs.length > 0) {
      const input = inputs[0]!;
      const applyMultipleDisplay = () => {
        const vs = this.api.valueAsString;
        const parts = Array.isArray(vs) ? vs : vs == null || vs === "" ? [] : [String(vs)];
        const joined = parts.filter(Boolean).join(", ");
        if (input.value !== joined) {
          input.value = joined;
        }
      };
      applyMultipleDisplay();
      queueMicrotask(() => {
        requestAnimationFrame(applyMultipleDisplay);
      });
    }

    applyInputAriaIfNeeded(this.el, inputs, this.api.selectionMode);

    const trigger = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="trigger"]'
    );
    if (trigger) {
      this.spreadProps(trigger, this.api.getTriggerProps());
    }

    const positioner = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="positioner"]'
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());

    const content = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="content"]'
    );
    if (content) this.spreadProps(content, this.api.getContentProps());

    if (this.api.open) {
      const dayView = this.getDayView();
      const monthView = this.getMonthView();
      const yearView = this.getYearView();
      if (dayView) dayView.hidden = this.api.view !== "day";
      if (monthView) monthView.hidden = this.api.view !== "month";
      if (yearView) yearView.hidden = this.api.view !== "year";

      if (this.api.view === "day" && dayView) {
        const viewControl = dayView.querySelector<HTMLElement>('[data-part="view-control"]');
        if (viewControl)
          this.spreadProps(viewControl, this.api.getViewControlProps({ view: "year" }));
        const prevTrigger = dayView.querySelector<HTMLElement>('[data-part="prev-trigger"]');
        if (prevTrigger) this.spreadProps(prevTrigger, this.api.getPrevTriggerProps());
        const viewTrigger = dayView.querySelector<HTMLElement>('[data-part="view-trigger"]');
        if (viewTrigger) {
          this.spreadProps(viewTrigger, this.api.getViewTriggerProps());
          viewTrigger.textContent = this.api.visibleRangeText.start;
        }
        const nextTrigger = dayView.querySelector<HTMLElement>('[data-part="next-trigger"]');
        if (nextTrigger) this.spreadProps(nextTrigger, this.api.getNextTriggerProps());
        const table = dayView.querySelector<HTMLElement>("table");
        if (table) this.spreadProps(table, this.api.getTableProps({ view: "day" }));
        const thead = dayView.querySelector<HTMLElement>("thead");
        if (thead) this.spreadProps(thead, this.api.getTableHeaderProps({ view: "day" }));
        this.renderDayTableHeader();
        this.renderDayTableBody();
      } else if (this.api.view === "month" && monthView) {
        const viewControl = monthView.querySelector<HTMLElement>('[data-part="view-control"]');
        if (viewControl)
          this.spreadProps(viewControl, this.api.getViewControlProps({ view: "month" }));
        const prevTrigger = monthView.querySelector<HTMLElement>('[data-part="prev-trigger"]');
        if (prevTrigger)
          this.spreadProps(prevTrigger, this.api.getPrevTriggerProps({ view: "month" }));
        const viewTrigger = monthView.querySelector<HTMLElement>('[data-part="view-trigger"]');
        if (viewTrigger) {
          this.spreadProps(viewTrigger, this.api.getViewTriggerProps({ view: "month" }));
          viewTrigger.textContent = String(this.api.visibleRange.start.year);
        }
        const nextTrigger = monthView.querySelector<HTMLElement>('[data-part="next-trigger"]');
        if (nextTrigger)
          this.spreadProps(nextTrigger, this.api.getNextTriggerProps({ view: "month" }));
        const table = monthView.querySelector<HTMLElement>("table");
        if (table) this.spreadProps(table, this.api.getTableProps({ view: "month", columns: 4 }));
        this.renderMonthTableBody();
      } else if (this.api.view === "year" && yearView) {
        const viewControl = yearView.querySelector<HTMLElement>('[data-part="view-control"]');
        if (viewControl)
          this.spreadProps(viewControl, this.api.getViewControlProps({ view: "year" }));
        const prevTrigger = yearView.querySelector<HTMLElement>('[data-part="prev-trigger"]');
        if (prevTrigger)
          this.spreadProps(prevTrigger, this.api.getPrevTriggerProps({ view: "year" }));
        const decadeText = yearView.querySelector<HTMLElement>('[data-part="decade"]');
        if (decadeText) {
          const decade = this.api.getDecade();
          decadeText.textContent = `${decade.start} - ${decade.end}`;
        }
        const nextTrigger = yearView.querySelector<HTMLElement>('[data-part="next-trigger"]');
        if (nextTrigger)
          this.spreadProps(nextTrigger, this.api.getNextTriggerProps({ view: "year" }));
        const table = yearView.querySelector<HTMLElement>("table");
        if (table) this.spreadProps(table, this.api.getTableProps({ view: "year", columns: 4 }));
        this.renderYearTableBody();
      }
    }
  }
}
