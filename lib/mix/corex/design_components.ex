defmodule Mix.Corex.DesignComponents do
  @moduledoc false

  alias Mix.Task

  @gen_hosts ~W(
    data-table data-list number-input date-picker password-input
    dialog checkbox native-input select
    layout-heading button link icon
  )a

  @live_hosts @gen_hosts
  @html_hosts @gen_hosts

  def live_hosts, do: @live_hosts
  def html_hosts, do: @html_hosts

  def ensure_for_live!(opts \\ []) do
    ensure!(@live_hosts, opts)
  end

  def ensure_for_html!(opts \\ []) do
    ensure!(@html_hosts, opts)
  end

  def ensure!(hosts, opts \\ []) when is_list(hosts) do
    path = Path.join("config", "config.exs")

    with true <- File.exists?(path),
         content = File.read!(path),
         true <- String.contains?(content, "config :corex_design"),
         missing when missing != [] <- missing_hosts(content, hosts) do
      apply_missing_hosts!(path, content, missing, opts)
    else
      _ -> :ok
    end
  end

  defp apply_missing_hosts!(path, content, missing, opts) do
    updated = insert_hosts(content, missing)

    if updated == content do
      Mix.shell().info("""

      Add these Corex Design components to config :corex_design, components: and run mix corex.design.build:
        #{Enum.map_join(missing, ", ", &inspect/1)}
      """)
    else
      File.write!(path, updated)
      format_elixir_source!(path)

      Mix.shell().info([
        :green,
        "* updating ",
        :reset,
        "config/config.exs (design components: #{Enum.map_join(missing, ", ", &Atom.to_string/1)})"
      ])

      maybe_build!(missing, opts)
    end

    :ok
  end

  defp format_elixir_source!(path) do
    original = File.read!(path)

    formatted =
      original
      |> Code.format_string!()
      |> IO.iodata_to_binary()
      |> then(fn source ->
        if String.ends_with?(source, "\n"), do: source, else: source <> "\n"
      end)

    if formatted != original do
      File.write!(path, formatted)
    end

    :ok
  end

  defp maybe_build!(missing, opts) do
    if Keyword.get(opts, :build, true) do
      merge_components_env!(missing)

      if Task.get("corex.design.build") do
        Task.reenable("corex.design.build")
        Task.run("corex.design.build", [])
      else
        Mix.shell().info("""

        Run mix corex.design.build to emit CSS for the new components.
        """)
      end
    end
  end

  defp merge_components_env!(missing) do
    case Application.get_env(:corex_design, :components) do
      current when is_list(current) ->
        Application.put_env(:corex_design, :components, Enum.uniq(current ++ missing))

      _other ->
        :ok
    end
  end

  defp missing_hosts(content, hosts) do
    Enum.reject(hosts, fn host ->
      name = Atom.to_string(host)
      String.contains?(content, ~s(:"#{name}")) or String.contains?(content, ":#{name}")
    end)
  end

  defp insert_hosts(content, missing) do
    case Regex.run(~r/components:\s*\[([^\]]*)\]/s, content) do
      nil ->
        content

      [_full, inner] ->
        existing = parse_component_atoms(inner)
        to_add = host_atoms(missing) |> Enum.reject(&(&1 in existing))
        rebuilt = "components: [#{Enum.join(existing ++ to_add, ", ")}]"
        Regex.replace(~r/components:\s*\[[^\]]*\]/s, content, rebuilt, global: false)
    end
  end

  defp parse_component_atoms(inner) do
    inner
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp host_atoms(hosts) do
    Enum.map(hosts, fn host ->
      name = Atom.to_string(host)
      if String.contains?(name, "-"), do: ~s(:"#{name}"), else: ":#{name}"
    end)
  end
end
