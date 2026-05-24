defmodule E2eWeb.FormDemoDocsTest do
  use ExUnit.Case, async: true

  alias E2eWeb.Demos.AngleSliderDemo
  alias E2eWeb.Demos.CheckboxDemo

  test "form doc live elixir snippets use MyAppWeb module names" do
    assert CheckboxDemo.form_doc_live_phoenix_elixir() =~ "defmodule MyAppWeb.CheckboxFormLive"
    assert CheckboxDemo.form_doc_live_ecto_elixir() =~ "MyApp.Form.Terms"
    assert AngleSliderDemo.form_doc_live_phoenix_elixir() =~ "defmodule MyAppWeb."
  end

  test "form doc controller elixir snippets stay minimal without e2e assigns" do
    phoenix = CheckboxDemo.form_doc_controller_phoenix_elixir()
    ecto = CheckboxDemo.form_doc_controller_ecto_elixir()

    refute phoenix =~ "assign(:form_ecto"
    refute phoenix =~ "E2e.Form."
    refute ecto =~ "terms_phoenix"
    assert ecto =~ "MyApp.Form.Terms"
  end
end
