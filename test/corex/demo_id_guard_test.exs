defmodule Corex.DemoIdGuardTest do
  use ExUnit.Case, async: true

  @demos_dir Path.expand("../../e2e/lib/e2e_web/demos", __DIR__)

  @form_components ~w(
    angle_slider checkbox color_picker combobox date_picker editable
    file_upload file_upload_live native_input number_input password_input
    pin_input radio_group select signature_pad switch tags_input
  )

  test "form *_example openings include id or field" do
    violations =
      @demos_dir
      |> File.ls!()
      |> Enum.filter(&String.ends_with?(&1, "_demo.ex"))
      |> Enum.flat_map(&scan_demo/1)

    assert violations == [], """
    Form demo examples must pass id= or field= (require_id!):

    #{Enum.map_join(violations, "\n", fn {file, fn_name, tag} -> "  #{file} #{fn_name}: <.#{tag}>" end)}
    """
  end

  defp scan_demo(filename) do
    path = Path.join(@demos_dir, filename)
    source = File.read!(path)

    ~r/def\s+([a-z0-9_]+_example)\s+do\s+~H"""(.*?)"""/s
    |> Regex.scan(source)
    |> Enum.flat_map(fn [_, fn_name, body] ->
      scan_example_body(filename, fn_name, body)
    end)
  end

  defp scan_example_body(filename, fn_name, body) do
    pattern =
      ~r/<\.(#{Enum.join(@form_components, "|")})\b((?:[^>]|"[^"]*"|'[^']*'|\{[^}]*\})*)>/s

    pattern
    |> Regex.scan(body)
    |> Enum.filter(fn [_, _tag, attrs] ->
      not (String.match?(attrs, ~r/\bid\s*=/) or String.match?(attrs, ~r/\bfield\s*=/))
    end)
    |> Enum.map(fn [_, tag, _] -> {filename, fn_name, tag} end)
  end
end
