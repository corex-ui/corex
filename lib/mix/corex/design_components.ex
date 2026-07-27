defmodule Mix.Corex.DesignComponents do
  @moduledoc false

  @gen_hosts ~w(
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

    if not File.exists?(path) do
      :ok
    else
      content = File.read!(path)

      if not String.contains?(content, "config :corex_design") do
        :ok
      else
        case missing_hosts(content, hosts) do
          [] ->
            :ok

          missing ->
            updated = insert_hosts(content, missing)

            if updated == content do
              Mix.shell().info("""

              Add these Corex Design components to config :corex_design, components: and run mix corex.design.build:
                #{Enum.map_join(missing, ", ", &inspect/1)}
              """)

              :ok
            else
              File.write!(path, updated)

              Mix.shell().info([
                :green,
                "* updating ",
                :reset,
                "config/config.exs (design components: #{Enum.map_join(missing, ", ", &Atom.to_string/1)})"
              ])

              maybe_build!(missing, opts)

              :ok
            end
        end
      end
    end
  end

  defp maybe_build!(missing, opts) do
    if Keyword.get(opts, :build, true) do
      merge_components_env!(missing)

      if Mix.Task.get("corex.design.build") do
        Mix.Task.reenable("corex.design.build")
        Mix.Task.run("corex.design.build", [])
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
    Enum.reduce(missing, content, fn host, acc ->
      name = Atom.to_string(host)
      atom_src = if String.contains?(name, "-"), do: ~s(:"#{name}"), else: ":#{name}"

      cond do
        Regex.match?(~r/components:\s*\[([^\]]*)\]/s, acc) ->
          Regex.replace(
            ~r/components:\s*\[([^\]]*)\]/s,
            acc,
            fn full, inner ->
              trimmed = String.trim(inner)

              if trimmed == "" do
                String.replace(full, "[]", "[#{atom_src}]", global: false)
              else
                String.replace(full, "]", ", #{atom_src}]", global: false)
              end
            end,
            global: false
          )

        true ->
          acc
      end
    end)
  end
end
