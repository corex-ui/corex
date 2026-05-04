import { createLazyHook, type HookModule } from "./lazy-hook";

function everyEntryIsLazyFactory(named: Record<string, unknown>): boolean {
  const values = Object.values(named);
  return values.length > 0 && values.every((v) => typeof v === "function");
}

export function hooks<const T extends Record<string, unknown>>(named: T): T {
  const record = named as Record<string, unknown>;
  if (everyEntryIsLazyFactory(record)) {
    return Object.fromEntries(
      Object.keys(record).map((name) => [
        name,
        createLazyHook(record[name] as () => Promise<HookModule>, name),
      ])
    ) as T;
  }
  return named;
}
