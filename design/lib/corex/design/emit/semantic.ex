defmodule Corex.Design.Emit.Semantic do
  @moduledoc false

  alias Corex.Design.Scales
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Write

  @header "/**\n * Do not edit directly, this file was auto-generated.\n */\n\n"

  @doc false
  def color_roles do
    allowed = semantic_role_set()

    Colors.generate()
    |> Map.values()
    |> Enum.flat_map(&Map.keys/1)
    |> Enum.filter(fn role ->
      role_allowed_for_bridge?(role, allowed)
    end)
    |> Enum.uniq()
    |> Enum.sort()
  end

  defp semantic_role_set do
    Corex.Design.Filter.semantics() |> MapSet.new()
  end

  defp role_allowed_for_bridge?(role, allowed) do
    cond do
      role in ~w(root layer ink ink-muted link border focus shadow ui ui-hover ui-active ui-muted) ->
        true

      String.ends_with?(role, "-text") ->
        prefix = String.replace_suffix(role, "-text", "")
        MapSet.member?(allowed, prefix)

      String.ends_with?(role, "-contrast") ->
        prefix = String.replace_suffix(role, "-contrast", "")
        MapSet.member?(allowed, prefix)

      true ->
        MapSet.member?(allowed, role) or String.starts_with?(role, "surface-")
    end
  end

  @doc false
  def write_color_bridge!(output_root) do
    roles = color_roles()

    decls =
      Enum.map_join(roles, "\n", fn role ->
        "  --color-#{role}: var(--color-#{role});"
      end)

    path = Path.join([output_root, "tokens", "semantic", "color.css"])

    Write.atomic!(
      path,
      @header <> "@theme inline {\n" <> decls <> "\n}\n"
    )
  end

  @doc false
  def write_border_bridge!(output_root) do
    static = [
      "  --radius-none: 0px;",
      "  --radius-full: 9999px;"
    ]

    themed =
      Scales.steps(:radius)
      |> Enum.reject(&(&1 in ~w(none full)))
      |> Enum.map(fn step ->
        "  --radius-#{step}: var(--theme-radius-#{step});"
      end)

    path = Path.join([output_root, "tokens", "semantic", "border.css"])

    Write.atomic!(
      path,
      @header <> "@theme inline {\n" <> Enum.join(static ++ themed, "\n") <> "\n}\n"
    )
  end

  @doc false
  def write_dimension_bridge!(output_root) do
    static =
      [
        "  --breakpoint-sm: 40rem;",
        "  --breakpoint-md: 48rem;",
        "  --breakpoint-lg: 64rem;",
        "  --breakpoint-xl: 80rem;",
        "  --breakpoint-2xl: 96rem;",
        "  --spacing: var(--theme-spacing);"
      ] ++
        container_bridge_decls("container") ++
        [
          "  --spacing-space-sm: var(--theme-spacing-space-sm);",
          "  --spacing-space-md: var(--theme-spacing-space-md);",
          "  --spacing-space-lg: var(--theme-spacing-space-lg);",
          "  --spacing-space-xl: var(--theme-spacing-space-xl);",
          "  --spacing-size-sm: var(--theme-spacing-size-sm);",
          "  --spacing-size-md: var(--theme-spacing-size-md);",
          "  --spacing-size-lg: var(--theme-spacing-size-lg);",
          "  --spacing-size-xl: var(--theme-spacing-size-xl);",
          "  --spacing-space: var(--spacing-space-md);",
          "  --spacing-size: var(--spacing-size-md);"
        ]

    path = Path.join([output_root, "tokens", "semantic", "dimension.css"])

    Write.atomic!(
      path,
      @header <> "@theme inline {\n" <> Enum.join(static, "\n") <> "\n}\n"
    )
  end

  @doc false
  def write_font_bridge!(output_root) do
    families =
      Enum.map(~w(sans serif mono code display), fn family ->
        "  --font-#{family}: var(--theme-font-#{family});"
      end)

    weights =
      Enum.map(
        ~w(thin extralight light normal medium semibold bold extrabold black),
        fn weight ->
          "  --font-weight-#{weight}: var(--theme-font-weight-#{weight});"
        end
      )

    path = Path.join([output_root, "tokens", "semantic", "font.css"])

    Write.atomic!(
      path,
      @header <> "@theme inline {\n" <> Enum.join(families ++ weights, "\n") <> "\n}\n"
    )
  end

  defp container_bridge_decls("container") do
    Enum.map(Scales.master_ladder_strings(), fn step ->
      "  --container-#{step}: var(--theme-container-#{step});"
    end)
  end

  defp container_bridge_decls(prefix) do
    Enum.map(Scales.master_ladder_strings(), fn step ->
      "  --#{prefix}-#{step}: var(--container-#{step});"
    end)
  end

  @doc false
  def remove_legacy_color_scope!(output_root) do
    path = Path.join([output_root, "tokens", "semantic", "color-scope.css"])

    if File.exists?(path) do
      File.rm!(path)
    end

    :ok
  end
end
