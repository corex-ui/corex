import type { Time } from "@zag-js/timer";

export function timerTime(
  partial: Pick<Time<number>, "days" | "hours" | "minutes" | "seconds"> &
    Partial<Pick<Time<number>, "milliseconds">>
): Time<number> {
  return {
    days: partial.days,
    hours: partial.hours,
    minutes: partial.minutes,
    seconds: partial.seconds,
    milliseconds: partial.milliseconds ?? 0,
  };
}
