export type AccordionChangedDetail = {
  id: string;
  value: string[];
  previousValue: string[];
  added: string[];
  removed: string[];
};

export type TreeViewExpandedChangedDetail = {
  id: string;
  expandedValue: string[];
  previousExpandedValue: string[];
  added: string[];
  removed: string[];
  focusedValue: string | null;
};

export type TreeViewSelectionChangedDetail = {
  id: string;
  selectedValue: string[];
  previousSelectedValue: string[];
  added: string[];
  removed: string[];
  focusedValue: string | null;
  isItem: boolean;
};

export type DialogOpenChangedDetail = {
  id: string;
  open: boolean;
  previousOpen: boolean;
};

export function diffStringValues(
  next: readonly string[],
  previous: readonly string[]
): { added: string[]; removed: string[] } {
  const added = next.filter((v) => !previous.includes(v));
  const removed = previous.filter((v) => !next.includes(v));
  return { added, removed };
}
