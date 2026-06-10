defmodule E2eWeb.AuthoringSnippetTest do
  use ExUnit.Case, async: true

  alias E2eWeb.AuthoringSnippet

  test "attr form keeps style attrs and omits bem class" do
    %{attr: attr, class: class, markup: markup} =
      AuthoringSnippet.snippets(:accordion,
        id: "my-accordion",
        semantic: "info",
        text: "4xl",
        radius: "md",
        variant: "subtle",
        value: "lorem"
      )

    assert attr =~ ~s(semantic="info")
    assert attr =~ ~s(text="4xl")
    assert attr =~ ~s(radius="md")
    assert attr =~ ~s(variant="subtle")
    refute attr =~ ~s(class="accordion)

    assert class =~ ~s(class="accordion accordion--semantic-info)
    assert class =~ "accordion--text-4xl"
    assert class =~ "accordion--rounded-md"
    refute class =~ "accordion--subtle"
    refute class =~ ~s(semantic="info")
    refute class =~ ~s(text="4xl")

    refute markup =~ ~s(class="accordion)
    refute markup =~ ~s(semantic="info")
    refute markup =~ ~s(variant="subtle")
    assert markup =~ ~s(id="my-accordion")
    assert markup =~ ~s(value="lorem")
  end

  test "default accordion attrs emit class=\"accordion\" only" do
    %{class: class, markup: markup} =
      AuthoringSnippet.accordion_anatomy_snippets([],
        slots: ~s( items={@items})
      )

    assert class =~ ~s(class="accordion")
    refute class =~ "accordion--"
    refute class =~ ~s(variant="subtle")

    refute markup =~ ~s(class="accordion")
    refute markup =~ ~s(variant=)
    assert markup =~ ~s(items={@items})
  end

  test "accordion items attr stays on the opening tag" do
    %{attr: attr} =
      AuthoringSnippet.accordion_anatomy_snippets([],
        inner: ~s(<:indicator><.heroicon name="hero-chevron-right" /></:indicator>),
        slots: AuthoringSnippet.items_attr()
      )

    assert attr =~ ~r/<\.accordion\n  items=\{Corex\.Content\.new\(\[/
    refute attr =~ ~r/<:indicator>[\s\S]*items=\{Corex\.Content/
  end

  test "substitute_app_name replaces my_app placeholders" do
    code = ~s(defmodule MyAppWeb.AccordionLive do\n  otp_app: :my_app\nend)

    assert AuthoringSnippet.substitute_app_name(code, "acme") =~ "AcmeWeb"
    assert AuthoringSnippet.substitute_app_name(code, "acme") =~ ":acme"
    refute AuthoringSnippet.substitute_app_name(code, "acme") =~ "MyApp"
  end

  test "substitute_app_name leaves default app unchanged" do
    code = "MyAppWeb.my_app"
    assert AuthoringSnippet.substitute_app_name(code, "my_app") == code
  end

  test "action playground snippets at defaults emit class=\"button\" only" do
    %{attr: attr, class: class} =
      AuthoringSnippet.playground_snippets(:action, [], inner: "Preview")

    refute attr =~ ~s(as=)
    refute attr =~ ~s(variant=)
    refute attr =~ ~s(size=)
    assert class =~ ~s(class="button")
    refute class =~ "button--"
  end

  test "playground snippets omit id and value" do
    %{attr: attr, class: class, markup: markup} =
      AuthoringSnippet.playground_snippets(:accordion,
        id: "my-accordion",
        value: "lorem",
        variant: "solid",
        size: "lg"
      )

    refute attr =~ ~s(id=)
    refute attr =~ ~s(value=)
    assert attr =~ ~s(variant="solid")
    assert attr =~ ~s(size="lg")
    assert class =~ ~s(class="accordion)
    refute markup =~ ~s(id=)
    refute markup =~ ~s(value=)
  end

  test "playground_heex_snippets omit id and value from accordion tags" do
    code = """
    <.accordion id="my-accordion" value={~W(lorem)} variant="subtle" items={@items}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """

    %{attr: attr, markup: markup} = AuthoringSnippet.playground_heex_snippets(code)

    refute attr =~ ~s(id=)
    refute attr =~ ~s(value=)
    assert attr =~ ~s(variant="subtle")
    refute markup =~ ~s(id=)
    refute markup =~ ~s(value=)
  end

  test "items_attr formats multiline items without orphan closing brace" do
    attr =
      AuthoringSnippet.accordion_anatomy_snippets([],
        slots: AuthoringSnippet.items_attr()
      )
      |> Map.fetch!(:attr)

    assert attr =~ ~r/<\.accordion\n  items=\{Corex\.Content\.new\(\[\n    %\{/
    assert attr =~ ~r/\n  \]\)\}\n\/>/
    refute attr =~ ~r/\n\]\)\n\}\n\} \/>/
  end

  test "heex_snippets adds accordion class and unstyled markup variants" do
    code = """
    <.accordion id="demo" items={@items}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """

    %{attr: attr, class: class, markup: markup} = AuthoringSnippet.heex_snippets(code)

    refute attr =~ ~s(class="accordion")
    assert class =~ ~s(<.accordion class="accordion" id="demo")
    assert markup =~ ~s(<.accordion unstyled id="demo")
    refute markup =~ ~s(class="accordion")
  end
end
