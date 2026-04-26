defmodule Mix.Corex.Install.Templates do
  @moduledoc false

  @sub "installer"

  def app_level_toast_block, do: read!("app_level_toast_block.heex")

  def corex_layout, do: read!("corex_layout.html.heex")

  def corex_starter_index, do: read!("corex_starter_index.html.heex")

  def design_imports_block do
    read!("design_imports_block.css")
    |> String.trim()
  end

  def plug_mode(web_str) do
    read!("plug_mode.eex")
    |> String.replace("__WEB__", web_str)
  end

  def plug_theme(web_str, app_str) do
    read!("plug_theme.eex")
    |> String.replace("__WEB__", web_str)
    |> String.replace("__APP__", app_str)
  end

  defp read!(name) do
    Path.join([:code.priv_dir(:corex), @sub, name]) |> File.read!()
  end
end
