import { vi } from "vitest";
import type { RedirectContext } from "../../lib/redirect";

export function mockLiveSocket(connected = true) {
  const patch = vi.fn();
  const navigate = vi.fn();
  return {
    patch,
    navigate,
    ctx: {
      liveSocket: {
        main: {
          isDead: false,
          isConnected: () => connected,
        },
        js: () => ({ patch, navigate }),
      },
    } satisfies RedirectContext,
  };
}
