defmodule E2eWeb.AvatarTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.AvatarModel, as: Avatar

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Avatar has no A11y violations", %{session: session} do
      session
      |> Avatar.goto(@mode)
      |> Avatar.check_accessibility()
    end
  end
end
