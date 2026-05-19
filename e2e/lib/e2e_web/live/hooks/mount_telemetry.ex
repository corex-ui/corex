defmodule E2eWeb.MountTelemetry do
  @moduledoc false

  def on_mount(:default, _params, _session, socket) do
    :telemetry.execute(
      [:e2e, :live_view, :mount],
      %{},
      %{module: socket.view}
    )

    {:cont, socket}
  end
end
