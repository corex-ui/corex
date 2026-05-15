defmodule Corex.Integration.Paths do
  @moduledoc false

  def integration_root do
    Path.expand("../..", __DIR__)
  end

  def corex_repo_root do
    Path.expand("../../..", __DIR__)
  end

  def installer_tmp_root do
    Path.expand("../../../installer/tmp", __DIR__)
  end
end
