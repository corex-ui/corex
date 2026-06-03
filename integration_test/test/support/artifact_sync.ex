defmodule Corex.Integration.ArtifactSync do
  @moduledoc false

  @names ~w(mix.lock deps _build/dev)

  def copy_hex_artifacts_from_integration!(integration_root, app_root) do
    integration_root = Path.expand(integration_root)
    app_root = Path.expand(app_root)

    for name <- @names do
      src = Path.join(integration_root, name)
      dst = Path.join(app_root, name)

      if File.exists?(src) do
        case name do
          "mix.lock" ->
            File.cp!(src, dst)

          "deps" ->
            if File.exists?(dst), do: File.rm_rf!(dst)
            File.cp_r!(src, dst)

          "_build/dev" ->
            if File.exists?(dst), do: File.rm_rf!(dst)
            File.mkdir_p!(Path.dirname(dst))
            File.cp_r!(src, dst)
        end
      end
    end

    :ok
  end
end
