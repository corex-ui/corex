defmodule Corex.Bem.VariantsTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component

  test "tier 1 default emits only user class without emit_style_classes" do
    original = Application.get_env(:corex, :emit_style_classes)

    on_exit(fn ->
      if is_nil(original) do
        Application.delete_env(:corex, :emit_style_classes)
      else
        Application.put_env(:corex, :emit_style_classes, original)
      end
    end)

    Application.put_env(:corex, :emit_style_classes, false)

    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Badge.badge size="sm" class="my-badge">Tag</Corex.Badge.badge>
          """
        end,
        %{}
      )

    assert html =~ ~s(class="my-badge")
    refute html =~ "badge--size-sm"
  end

  test "style attrs merge bem modifiers without styling data attributes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Badge.badge size="sm">Tag</Corex.Badge.badge>
          """
        end,
        %{}
      )

    assert html =~ "badge--size-sm"
    refute html =~ "data-badge"
    refute html =~ "data-badge-size"
  end

  test "polymorphic known look uses looks alias" do
    class =
      Corex.Action.corex_style_class(%{
        as: "link",
        semantic: "accent",
        variant: "solid"
      })

    assert class =~ "link"
    assert class =~ "link--semantic-accent"
    assert class =~ "link--variant-solid"
    refute class =~ "button--"
  end

  test "polymorphic unknown as uses as string as bem base" do
    class = Corex.Action.corex_style_class(%{as: "custom", semantic: "accent"})

    assert class =~ "custom--semantic-accent"
    refute class =~ "button--"
  end

  test "polymorphic default as uses default look base" do
    class = Corex.Action.corex_style_class(%{semantic: "accent", size: "lg"})

    assert class =~ "button--semantic-accent"
    assert class =~ "button--size-lg"
  end
end
