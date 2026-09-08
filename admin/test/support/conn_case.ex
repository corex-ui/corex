defmodule CorexAdmin.ConnCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest
      import Plug.Conn

      @endpoint CorexAdmin.Test.Endpoint
    end
  end

  setup do
    CorexAdmin.Test.Store.reset()
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
