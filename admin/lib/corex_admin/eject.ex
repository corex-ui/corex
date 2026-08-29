defmodule CorexAdmin.Eject do
  @moduledoc """
  Bookkeeping for chrome you have copied into your own app.

  Copying framework views into a host app is the customization path that always
  works and always ages badly: the copy stops receiving upstream fixes, and
  nothing tells you which copies have fallen behind. Administrate and Torch both
  hit this.

  `mix corex.admin.gen.admin` therefore records what it copied and from which
  version, and `mix corex.admin.doctor` compares that record against the
  installed package. Neither can merge for you — nobody can — but a listed
  divergence is a fixable problem, and a silent one is not.

  The manifest lives at `priv/corex_admin/ejected.exs` in the host app.

  See the [eject](eject.html) guide.
  """

  @manifest_path Path.join(["priv", "corex_admin", "ejected.exs"])

  @ejectable [
    CorexAdmin.UI.Index,
    CorexAdmin.UI.Form,
    CorexAdmin.UI.Show,
    CorexAdmin.UI.Home,
    CorexAdmin.UI.Nav,
    CorexAdmin.UI.Filters,
    CorexAdmin.UI.Dialogs,
    CorexAdmin.UI.Fields
  ]

  @doc """
  Blocks `gen.admin` can copy.

  `CorexAdmin.UI` itself and `CorexAdmin.UI.Labels` are deliberately not
  ejectable: the first is only imports, the second is translated vocabulary.
  Leaving them upstream keeps an ejected app on the same shared idiom.
  """
  @spec ejectable() :: [module()]
  def ejectable, do: @ejectable

  @doc "Path of the host manifest, relative to the app root."
  @spec manifest_path() :: String.t()
  def manifest_path, do: @manifest_path

  @doc """
  Absolute path to a module's source in the installed package.

  Read from the module's own compile info, which points at the real file on this
  machine whether the package came from Hex, a path, or a git checkout.
  """
  @spec source_path(module()) :: {:ok, String.t()} | {:error, String.t()}
  def source_path(mod) do
    with true <- Code.ensure_loaded?(mod),
         info when is_list(info) <- mod.module_info(:compile),
         source when not is_nil(source) <- Keyword.get(info, :source),
         path = to_string(source),
         true <- File.exists?(path) do
      {:ok, path}
    else
      _ ->
        {:error,
         "cannot locate the source of #{inspect(mod)}. " <>
           "Ejection needs the package sources on disk (deps/corex_admin/lib)."}
    end
  end

  @doc "Digest of a source file, used to detect upstream changes."
  @spec digest(String.t()) :: String.t()
  def digest(path) do
    :crypto.hash(:sha256, File.read!(path)) |> Base.encode16(case: :lower)
  end

  @doc "Installed `corex_admin` version."
  @spec version() :: String.t()
  def version do
    case :application.get_key(:corex_admin, :vsn) do
      {:ok, vsn} -> to_string(vsn)
      _ -> "unknown"
    end
  end

  @doc "Reads the host manifest, or an empty map when nothing has been ejected."
  @spec read_manifest(String.t()) :: map()
  def read_manifest(root \\ File.cwd!()) do
    path = Path.join(root, @manifest_path)

    if File.exists?(path) do
      {manifest, _} = Code.eval_file(path)
      if is_map(manifest), do: manifest, else: %{}
    else
      %{}
    end
  end

  @doc "Serializes a manifest for writing."
  @spec render_manifest(map()) :: String.t()
  def render_manifest(manifest) do
    entries =
      manifest
      |> Enum.sort_by(fn {key, _} -> key end)
      |> Enum.map_join(",\n", fn {key, entry} ->
        ~s(  "#{key}" => %{version: "#{entry.version}", sha256: "#{entry.sha256}"})
      end)

    """
    # Written by mix corex.admin.gen.admin.
    #
    # Each entry records the corex_admin version a block was copied from.
    # Run `mix corex.admin.doctor` to see which copies have fallen behind.
    %{
    #{entries}
    }
    """
  end

  @doc """
  Compares a manifest against the installed package.

  Returns one result per ejected block: `:current` when the upstream source is
  unchanged since it was copied, `{:stale, from, to}` when it has moved on, and
  `{:unknown, reason}` when the source cannot be read.
  """
  @spec audit(map()) :: [
          {String.t(), :current | {:stale, String.t(), String.t()} | {:unknown, String.t()}}
        ]
  def audit(manifest) do
    manifest
    |> Enum.sort_by(fn {key, _} -> key end)
    |> Enum.map(fn {key, entry} ->
      {key, audit_entry(key, entry)}
    end)
  end

  defp audit_entry(key, entry) do
    with {:ok, mod} <- resolve_module(key),
         {:ok, path} <- source_path(mod) do
      current = digest(path)

      if current == Map.get(entry, :sha256) do
        :current
      else
        {:stale, Map.get(entry, :version, "unknown"), version()}
      end
    else
      {:error, reason} -> {:unknown, reason}
    end
  end

  defp resolve_module(key) do
    mod = Module.concat([key])
    if mod in @ejectable, do: {:ok, mod}, else: {:error, "#{key} is not an ejectable block"}
  rescue
    ArgumentError -> {:error, "#{key} is not a module name"}
  end

  @doc """
  Rewrites a block's source so it belongs to the host namespace.

  Only the ejected block names are rewritten. `use CorexAdmin.UI` and
  `CorexAdmin.UI.Labels` are left pointing at the package, so an ejected app
  keeps the shared imports and the translated operator vocabulary.
  """
  @spec rewrite(String.t(), module()) :: String.t()
  def rewrite(source, target_namespace) do
    Enum.reduce(@ejectable, source, fn mod, acc ->
      from = inspect(mod)
      to = inspect(Module.concat(target_namespace, block_name(mod)))
      String.replace(acc, from, to)
    end)
  end

  @doc "Last segment of a block module name, for example `Index`."
  @spec block_name(module()) :: String.t()
  def block_name(mod), do: mod |> Module.split() |> List.last()

  @doc "Relative file name a block is written to, for example `index.ex`."
  @spec file_name(module()) :: String.t()
  def file_name(mod), do: Macro.underscore(block_name(mod)) <> ".ex"
end
