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

  private syncWeekDays = () => {
    const dayView = this.getDayView();
    if (!dayView) return;

    const headerRow = dayView.querySelector<HTMLElement>("thead tr");
    if (!headerRow) return;

    this.spreadProps(headerRow, this.api.getTableRowProps({ view: "day" }));

    const existingCells = Array.from(headerRow.querySelectorAll("th"));

    while (existingCells.length > this.api.weekDays.length) {
      const cell = existingCells.pop();
      if (cell) headerRow.removeChild(cell);
    }

    this.api.weekDays.forEach((day, index) => {
      let cellEl = existingCells[index];

      if (!cellEl) {
        cellEl = this.doc.createElement("th");
        cellEl.scope = "col";
        headerRow.appendChild(cellEl);
      }

      cellEl.setAttribute("aria-label", day.long);
      cellEl.textContent = day.narrow;
    });
  };

  private syncDayGrid = () => {
    const dayView = this.getDayView();
    if (!dayView) return;

    const tbody = dayView.querySelector<HTMLElement>("tbody");
    if (!tbody) return;

    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "day" }));

    if (!this.api.weeks) return;

    const existingRows = Array.from(tbody.querySelectorAll("tr"));

    while (existingRows.length > this.api.weeks.length) {
      const row = existingRows.pop();
      if (row) tbody.removeChild(row);
    }

    this.api.weeks.forEach((week, rowIndex) => {
      let rowEl = existingRows[rowIndex];

      if (!rowEl) {
        rowEl = this.doc.createElement("tr");
        tbody.appendChild(rowEl);
      }

      this.spreadProps(rowEl, this.api.getTableRowProps({ view: "day" }));

      const existingCells = Array.from(rowEl.querySelectorAll("td"));

      while (existingCells.length > week.length) {
        const cell = existingCells.pop();
        if (cell) rowEl.removeChild(cell);
      }

      week.forEach((value, cellIndex) => {
        let cellEl = existingCells[cellIndex];

        if (!cellEl) {
          cellEl = this.doc.createElement("td");
          const triggerEl = this.doc.createElement("div");
          cellEl.appendChild(triggerEl);
          rowEl.appendChild(cellEl);
        }

        this.spreadProps(cellEl, this.api.getDayTableCellProps({ value }));

        const triggerEl = cellEl.querySelector<HTMLElement>("div");
        if (triggerEl) {
          this.spreadProps(
            triggerEl,
            this.api.getDayTableCellTriggerProps({ value }),
          );
          triggerEl.textContent = String(value.day);
        }
      });
    });
  };

  private syncMonthGrid = () => {
    const monthView = this.getMonthView();
    if (!monthView) return;

    const tbody = monthView.querySelector<HTMLElement>("tbody");
    if (!tbody) return;

    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "month" }));

    const monthsGrid = this.api.getMonthsGrid({ columns: 4, format: "short" });
    const existingRows = Array.from(tbody.querySelectorAll("tr"));

    while (existingRows.length > monthsGrid.length) {
      const row = existingRows.pop();
      if (row) tbody.removeChild(row);
    }

    monthsGrid.forEach((months, rowIndex) => {
      let rowEl = existingRows[rowIndex];

      if (!rowEl) {
        rowEl = this.doc.createElement("tr");
        tbody.appendChild(rowEl);
      }

      this.spreadProps(rowEl, this.api.getTableRowProps());

      const existingCells = Array.from(rowEl.querySelectorAll("td"));

      while (existingCells.length > months.length) {
        const cell = existingCells.pop();
        if (cell) rowEl.removeChild(cell);
      }

      months.forEach((month, cellIndex) => {
        let cellEl = existingCells[cellIndex];

        if (!cellEl) {
          cellEl = this.doc.createElement("td");
          const triggerEl = this.doc.createElement("div");
          cellEl.appendChild(triggerEl);
          rowEl.appendChild(cellEl);
        }

        this.spreadProps(
          cellEl,
          this.api.getMonthTableCellProps({ ...month, columns: 4 }),
        );

        const triggerEl = cellEl.querySelector<HTMLElement>("div");
        if (triggerEl) {
          this.spreadProps(
            triggerEl,
            this.api.getMonthTableCellTriggerProps({ ...month, columns: 4 }),
          );
          triggerEl.textContent = month.label;
        }
      });
    });
  };

  private syncYearGrid = () => {
    const yearView = this.getYearView();
    if (!yearView) return;

    const tbody = yearView.querySelector<HTMLElement>("tbody");
    if (!tbody) return;

    this.spreadProps(tbody, this.api.getTableBodyProps());

    const yearsGrid = this.api.getYearsGrid({ columns: 4 });
    const existingRows = Array.from(tbody.querySelectorAll("tr"));

    while (existingRows.length > yearsGrid.length) {
      const row = existingRows.pop();
      if (row) tbody.removeChild(row);
    }

    yearsGrid.forEach((years, rowIndex) => {
      let rowEl = existingRows[rowIndex];

      if (!rowEl) {
        rowEl = this.doc.createElement("tr");
        tbody.appendChild(rowEl);
      }

      this.spreadProps(rowEl, this.api.getTableRowProps({ view: "year" }));

      const existingCells = Array.from(rowEl.querySelectorAll("td"));

      while (existingCells.length > years.length) {
        const cell = existingCells.pop();
        if (cell) rowEl.removeChild(cell);
      }

      years.forEach((year, cellIndex) => {
        let cellEl = existingCells[cellIndex];

        if (!cellEl) {
          cellEl = this.doc.createElement("td");
          const triggerEl = this.doc.createElement("div");
          cellEl.appendChild(triggerEl);
          rowEl.appendChild(cellEl);
        }

        this.spreadProps(
          cellEl,
          this.api.getYearTableCellProps({ ...year, columns: 4 }),
        );

        const triggerEl = cellEl.querySelector<HTMLElement>("div");
        if (triggerEl) {
          this.spreadProps(
            triggerEl,
            this.api.getYearTableCellTriggerProps({ ...year, columns: 4 }),
          );
          triggerEl.textContent = year.label;
        }
      });
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
      const inputProps = { ...this.api.getInputProps() };
      const inputAriaLabel = this.el.dataset.inputAriaLabel;
      if (inputAriaLabel) {
        inputProps["aria-label"] = inputAriaLabel;
      }
      this.spreadProps(input, inputProps);
    }

    const trigger = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="trigger"]',
    );
    if (trigger) {
      const triggerProps = { ...this.api.getTriggerProps() };
      const ariaLabel = this.el.dataset.triggerAriaLabel;
      if (ariaLabel) {
        triggerProps["aria-label"] = ariaLabel;
      }
      this.spreadProps(trigger, triggerProps);
    }

    const positioner = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="positioner"]',
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());

    const content = this.el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="content"]',
    );
    if (content) this.spreadProps(content, this.api.getContentProps());

    const dayView = this.getDayView();
    if (dayView) {
      dayView.hidden = this.api.view !== "day";

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
        this.spreadProps(thead, this.api.getTableHeaderProps({ view: "day" }));
    }

    this.syncWeekDays();
    this.syncDayGrid();

    const monthView = this.getMonthView();
    if (monthView) {
      monthView.hidden = this.api.view !== "month";

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
    }

    this.syncMonthGrid();

    const yearView = this.getYearView();
    if (yearView) {
      yearView.hidden = this.api.view !== "year";

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
    }

    this.syncYearGrid();
  }
}
