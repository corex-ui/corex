import { vi, type Mock } from "vitest";
import type { RedirectContext } from "../../lib/redirect";

type AnyMock = Mock<(...args: unknown[]) => unknown>;

export function mockLiveSocket(connected = true): {
  patch: AnyMock;
  navigate: AnyMock;
  ctx: RedirectContext;
} {
  const patch = vi.fn() as AnyMock;
  const navigate = vi.fn() as AnyMock;
  return {
    patch,
    navigate,
    ctx: {
      liveSocket: {
        getSocket: () => ({ isConnected: () => connected }),
        js: () => ({ patch, navigate }),
      },
    },
  };
}
