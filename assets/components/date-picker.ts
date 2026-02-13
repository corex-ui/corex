import * as datePicker from "@zag-js/date-picker";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class DatePicker extends Component<datePicker.Props, datePicker.Api> {

  initMachine(props: datePicker.Props): VanillaMachine<any> {
    return new VanillaMachine(datePicker.machine, {
      ...props,
    });
  }

  initApi(): datePicker.Api {
    return datePicker.connect(this.machine.service, normalizeProps);
  }

  private getDayView = () =>
    this.el.querySelector<HTMLElement>('[data-part="day-view"]');
  private getMonthView = () =>
    this.el.querySelector<HTMLElement>('[data-part="month-view"]');
  private getYearView = () =>
    this.el.querySelector<HTMLElement>('[data-part="year-view"]');

  private renderDayTableHeader = () => {
    const dayView = this.getDayView();
    const thead = dayView?.querySelector<HTMLElement>("thead");
    if (!thead || !this.api.weekDays) return;
    const tr = this.doc.createElement("tr");
    this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
    this.api.weekDays.forEach((day) => {
      const th = this.doc.createElement("th");
      th.scope = "col";
      th.setAttribute("aria-label", day.long);
      th.textContent = day.narrow;
      tr.appendChild(th);
    });
    thead.innerHTML = "";
    thead.appendChild(tr);
  };

  private renderDayTableBody = () => {
    const dayView = this.getDayView();
    const tbody = dayView?.querySelector<HTMLElement>("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "day" }));
    if (!this.api.weeks) return;
    tbody.innerHTML = "";
    this.api.weeks.forEach((week) => {
      const tr = this.doc.createElement("tr");
      this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
      week.forEach((value) => {
        const td = this.doc.createElement("td");
        this.spreadProps(td, this.api.getDayTableCellProps({ value }));
        const trigger = this.doc.createElement("div");
        this.spreadProps(
          trigger,
          this.api.getDayTableCellTriggerProps({ value }),
        );
        trigger.textContent = String(value.day);
        td.appendChild(trigger);
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
  };

  private renderMonthTableBody = () => {
    const monthView = this.getMonthView();
    const tbody = monthView?.querySelector<HTMLElement>("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "month" }));
    const monthsGrid = this.api.getMonthsGrid({ columns: 4, format: "short" });
    tbody.innerHTML = "";
    monthsGrid.forEach((months) => {
      const tr = this.doc.createElement("tr");
      this.spreadProps(tr, this.api.getTableRowProps());
      months.forEach((month) => {
        const td = this.doc.createElement("td");
        this.spreadProps(
          td,
          this.api.getMonthTableCellProps({ ...month, columns: 4 }),
        );
        const trigger = this.doc.createElement("div");
        this.spreadProps(
          trigger,
          this.api.getMonthTableCellTriggerProps({ ...month, columns: 4 }),
        );
        trigger.textContent = month.label;
        td.appendChild(trigger);
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
  };

  private renderYearTableBody = () => {
    const yearView = this.getYearView();
    const tbody = yearView?.querySelector<HTMLElement>("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps());
    const yearsGrid = this.api.getYearsGrid({ columns: 4 });
    tbody.innerHTML = "";
    yearsGrid.forEach((years) => {
      const tr = this.doc.createElement("tr");
      this.spreadProps(tr, this.api.getTableRowProps({ view: "year" }));
      years.forEach((year) => {
        const td = this.doc.createElement("td");
        this.spreadProps(
          td,
          this.api.getYearTableCellProps({ ...year, columns: 4 }),
        );
        const trigger = this.doc.createElement("div");
        this.spreadProps(
          trigger,
          this.api.getYearTableCellTriggerProps({ ...year, columns: 4 }),
        );
        trigger.textContent = year.label;
        td.appendChild(trigger);
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
  };

  render(): void {
    const root = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="root"]',
    );
    if (root) this.spreadProps(root, this.api.getRootProps());

    const label = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="label"]',
    );
    if (label) this.spreadProps(label, this.api.getLabelProps());

    const control = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="control"]',
    );
    if (control) this.spreadProps(control, this.api.getControlProps());

    const input = this.el.querySelector<HTMLInputElement>(
      '[data-scope="date-picker"][data-part="input"]',
    );
    if (input) {
      this.spreadProps(input, this.api.getInputProps());
    }

    const trigger = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="trigger"]',
    );
    if (trigger) {
      this.spreadProps(trigger, this.api.getTriggerProps());
    }

    const positioner = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="positioner"]',
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());

    const content = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="content"]',
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
        const viewControl = dayView.querySelector<HTMLElement>(
          '[data-part="view-control"]',
        );
        if (viewControl)
          this.spreadProps(
            viewControl,
            this.api.getViewControlProps({ view: "year" }),
          );
        const prevTrigger = dayView.querySelector<HTMLElement>(
          '[data-part="prev-trigger"]',
        );
        if (prevTrigger)
          this.spreadProps(prevTrigger, this.api.getPrevTriggerProps());
        const viewTrigger = dayView.querySelector<HTMLElement>(
          '[data-part="view-trigger"]',
        );
        if (viewTrigger) {
          this.spreadProps(viewTrigger, this.api.getViewTriggerProps());
          viewTrigger.textContent = this.api.visibleRangeText.start;
        }
        const nextTrigger = dayView.querySelector<HTMLElement>(
          '[data-part="next-trigger"]',
        );
        if (nextTrigger)
          this.spreadProps(nextTrigger, this.api.getNextTriggerProps());
        const table = dayView.querySelector<HTMLElement>("table");
        if (table)
          this.spreadProps(table, this.api.getTableProps({ view: "day" }));
        const thead = dayView.querySelector<HTMLElement>("thead");
        if (thead)
          this.spreadProps(
            thead,
            this.api.getTableHeaderProps({ view: "day" }),
          );
        this.renderDayTableHeader();
        this.renderDayTableBody();
      } else if (this.api.view === "month" && monthView) {
        const viewControl = monthView.querySelector<HTMLElement>(
          '[data-part="view-control"]',
        );
        if (viewControl)
          this.spreadProps(
            viewControl,
            this.api.getViewControlProps({ view: "month" }),
          );
        const prevTrigger = monthView.querySelector<HTMLElement>(
          '[data-part="prev-trigger"]',
        );
        if (prevTrigger)
          this.spreadProps(
            prevTrigger,
            this.api.getPrevTriggerProps({ view: "month" }),
          );
        const viewTrigger = monthView.querySelector<HTMLElement>(
          '[data-part="view-trigger"]',
        );
        if (viewTrigger) {
          this.spreadProps(
            viewTrigger,
            this.api.getViewTriggerProps({ view: "month" }),
          );
          viewTrigger.textContent = String(this.api.visibleRange.start.year);
        }
        const nextTrigger = monthView.querySelector<HTMLElement>(
          '[data-part="next-trigger"]',
        );
        if (nextTrigger)
          this.spreadProps(
            nextTrigger,
            this.api.getNextTriggerProps({ view: "month" }),
          );
        const table = monthView.querySelector<HTMLElement>("table");
        if (table)
          this.spreadProps(
            table,
            this.api.getTableProps({ view: "month", columns: 4 }),
          );
        this.renderMonthTableBody();
      } else if (this.api.view === "year" && yearView) {
        const viewControl = yearView.querySelector<HTMLElement>(
          '[data-part="view-control"]',
        );
        if (viewControl)
          this.spreadProps(
            viewControl,
            this.api.getViewControlProps({ view: "year" }),
          );
        const prevTrigger = yearView.querySelector<HTMLElement>(
          '[data-part="prev-trigger"]',
        );
        if (prevTrigger)
          this.spreadProps(
            prevTrigger,
            this.api.getPrevTriggerProps({ view: "year" }),
          );
        const decadeText = yearView.querySelector<HTMLElement>(
          '[data-part="decade"]',
        );
        if (decadeText) {
          const decade = this.api.getDecade();
          decadeText.textContent = `${decade.start} - ${decade.end}`;
        }
        const nextTrigger = yearView.querySelector<HTMLElement>(
          '[data-part="next-trigger"]',
        );
        if (nextTrigger)
          this.spreadProps(
            nextTrigger,
            this.api.getNextTriggerProps({ view: "year" }),
          );
        const table = yearView.querySelector<HTMLElement>("table");
        if (table)
          this.spreadProps(
            table,
            this.api.getTableProps({ view: "year", columns: 4 }),
          );
        this.renderYearTableBody();
      }
    }
  }
}
