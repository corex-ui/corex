defmodule E2eWeb.FormDemoDocsTest do
  use ExUnit.Case, async: true

  alias E2eWeb.Demos.{AngleSliderDemo, CheckboxDemo, NativeInputDemo}

  test "form doc live elixir snippets use MyAppWeb module names" do
    assert CheckboxDemo.form_doc_live_phoenix_elixir() =~ "defmodule MyAppWeb.CheckboxFormLive"
    assert CheckboxDemo.form_doc_live_ecto_elixir() =~ "MyApp.Forms.Terms"
    assert AngleSliderDemo.form_doc_live_phoenix_elixir() =~ "defmodule MyAppWeb."

    assert NativeInputDemo.form_doc_live_phoenix_elixir() =~
             "defmodule MyAppWeb.NativeInputFormLive"

    assert NativeInputDemo.form_doc_live_ecto_elixir() =~ "profile_ecto"
  end

  test "form doc controller elixir snippets stay minimal without e2e assigns" do
    phoenix = CheckboxDemo.form_doc_controller_phoenix_elixir()
    ecto = CheckboxDemo.form_doc_controller_ecto_elixir()

    refute phoenix =~ "assign(:form_ecto"
    refute phoenix =~ "E2e.Form."
    refute ecto =~ "terms_phoenix"
    assert ecto =~ "MyApp.Forms.Terms"

    native_phoenix = NativeInputDemo.form_doc_controller_phoenix_elixir()
    native_ecto = NativeInputDemo.form_doc_controller_validate_elixir()

    refute native_phoenix =~ "E2e.Form."
    refute native_ecto =~ "assign(:form_ecto"
    assert native_ecto =~ "MyApp.Forms.NativeInputProfile"
  end
end
