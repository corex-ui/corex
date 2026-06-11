defmodule Corex.Bem.DesignEmitTest do
  use CorexTest.ComponentCase, async: false

  import Phoenix.Component

  @design_config [
    output: "assets/css/corex.tailwind.css"
  ]

  setup do
    original_emit = Application.get_env(:corex, :emit_style_classes)
    original_design = Application.get_env(:corex, Corex.Design)

    on_exit(fn ->
      if is_nil(original_emit) do
        Application.delete_env(:corex, :emit_style_classes)
      else
        Application.put_env(:corex, :emit_style_classes, original_emit)
      end

      if is_nil(original_design) do
        Application.delete_env(:corex, Corex.Design)
      else
        Application.put_env(:corex, Corex.Design, original_design)
      end
    end)

    Application.delete_env(:corex, :emit_style_classes)
    :ok
  end

  test "tier 3 emits bem when Corex.Design is configured without emit_style_classes" do
    Application.put_env(:corex, Corex.Design, @design_config)

    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Badge.badge size="sm" class="badge">Tag</Corex.Badge.badge>
          """
        end,
        %{}
      )

    assert html =~ "badge--size-sm"
  end

  test "tier 3 opt-out with emit_style_classes false" do
    Application.put_env(:corex, Corex.Design, @design_config)
    Application.put_env(:corex, :emit_style_classes, false)

    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Badge.badge size="sm" class="badge">Tag</Corex.Badge.badge>
          """
        end,
        %{}
      )

    refute html =~ "badge--size-sm"
    assert html =~ ~s(class="badge")
  end
end
