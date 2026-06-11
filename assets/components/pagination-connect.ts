import { connect, type Api } from "@zag-js/pagination";
import type { normalizeProps } from "@zag-js/vanilla";

type PaginationService = Parameters<typeof connect>[0];
type Normalize = typeof normalizeProps;

export function adjustDeadLinkTriggerProps(
  props: Record<string, unknown>
): Record<string, unknown> {
  if (props.href != null && props.href !== "") return props;
  if (props.type === "button") return props;
  return { ...props, "aria-label": undefined };
}

export function corexPaginationConnect(service: PaginationService, normalize: Normalize): Api {
  const api = connect(service, normalize);

  return {
    ...api,
    getPrevTriggerProps() {
      return adjustDeadLinkTriggerProps(api.getPrevTriggerProps() as Record<string, unknown>);
    },
    getNextTriggerProps() {
      return adjustDeadLinkTriggerProps(api.getNextTriggerProps() as Record<string, unknown>);
    },
  };
}
