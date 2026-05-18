defmodule Mix.Tasks.Corex.ZagApiAudit do
  @shortdoc "Compare Zag.js machine APIs to Corex Elixir/hook exports"

  @moduledoc false

  use Mix.Task

  @requirements ["app.start"]

  @zag_packages %{
    "radio-group" => Corex.RadioGroup,
    "listbox" => Corex.Listbox,
    "select" => Corex.Select,
    "combobox" => Corex.Combobox,
    "checkbox" => Corex.Checkbox,
    "switch" => Corex.Switch,
    "tabs" => Corex.Tabs,
    "pin-input" => Corex.PinInput,
    "tags-input" => Corex.TagsInput,
    "toggle-group" => Corex.ToggleGroup
  }

  @api_methods %{
    "setValue" => ~w(set_value),
    "clearValue" => ~w(clear_value clear),
    "focus" => ~w(focus),
    "value" => ~w(value),
    "setChecked" => ~w(set_checked),
    "toggleChecked" => ~w(toggle_checked)
  }

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info([:cyan, "Corex Zag API audit", :reset])

    for {slug, module} <- @zag_packages do
      zag_methods = zag_api_methods(slug)
      elixir_fns = module.__info__(:functions) |> Enum.map(&elem(&1, 0)) |> MapSet.new()

      missing =
        for zag <- zag_methods,
            candidates = Map.get(@api_methods, zag, [Macro.underscore(zag)]),
            not Enum.any?(candidates, &(&1 in elixir_fns)) do
          zag
        end

      status =
        if missing == [] do
          [:green, "ok"]
        else
          [:yellow, "gaps: #{Enum.join(missing, ", ")}"]
        end

      Mix.shell().info([
        :cyan,
        "  #{slug} (#{module})",
        :reset,
        " ",
        status,
        :reset
      ])
    end
  end

  defp api_block(content) do
    case Regex.run(~r/interface \w+Api<[^>]*>\s*\{([^}]+)\}/s, content) do
      [_, block] -> block
      _ -> ""
    end
  end

  defp slug_to_types_basename("radio-group"), do: "radio-group"
  defp slug_to_types_basename(slug), do: String.replace(slug, "-", "_")

  defp zag_api_methods(slug) do
    path =
      Path.join([
        "node_modules/.pnpm",
        "@zag-js+#{slug}@*",
        "node_modules/@zag-js/#{slug}/dist/#{slug_to_types_basename(slug)}.types.d.ts"
      ])

    case Path.wildcard(path) do
      [file | _] ->
        file
        |> File.read!()
        |> api_block()
        |> then(fn content ->
          ~r/^\s+([a-zA-Z]+):/
          |> Regex.scan(content)
          |> Enum.map(fn [_, name] -> name end)
          |> Enum.reject(&String.starts_with?(&1, "get"))
          |> Enum.filter(&(&1 in Map.keys(@api_methods)))
          |> MapSet.new()
        end)

      _ ->
        MapSet.new()
    end
  end
end
