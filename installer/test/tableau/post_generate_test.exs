defmodule Corex.New.Tableau.PostGenerateTest do
  use ExUnit.Case, async: false

  alias Corex.New.Tableau.PostGenerate

  test "next steps include localize.download_locales when lang is true" do
    Corex.New.MixHelper.in_tmp("tableau post generate lang", fn ->
      send(self(), {:mix_shell_input, :yes?, false})

      PostGenerate.run(File.cwd!(), lang: true, design: true, install: false)

      output = shell_info_text()
      assert output =~ "mix localize.download_locales en fr ar"
      assert output =~ "mix setup"
      assert output =~ "mix tableau.server"
    end)
  end

  test "next steps omit localize when lang is false" do
    Corex.New.MixHelper.in_tmp("tableau post generate no lang", fn ->
      send(self(), {:mix_shell_input, :yes?, false})

      PostGenerate.run(File.cwd!(), lang: false, design: true, install: false)

      output = shell_info_text()
      refute output =~ "localize.download_locales"
    end)
  end

  defp shell_info_text(timeout \\ 50) do
    timeout
    |> shell_info_parts([])
    |> Enum.join("\n")
  end

  defp shell_info_parts(timeout, acc) do
    receive do
      {:mix_shell, :info, [msg]} when is_binary(msg) ->
        shell_info_parts(timeout, [msg | acc])

      {:mix_shell, :info, _} ->
        shell_info_parts(timeout, acc)

      _ ->
        shell_info_parts(timeout, acc)
    after
      timeout -> acc
    end
  end
end
