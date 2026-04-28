defmodule Mix.Corex.Install.Templates do
  @moduledoc false

  @sub "installer"

  alias Mix.Corex.Install.Config

  def app_level_toast_block, do: read!("toast.heex")

  def corex_starter_index_body, do: corex_starter_index_body([])

  def corex_starter_index_body(opts) when is_list(opts) do
    if Config.design_on?(opts) do
      read!("starter.html.heex")
    else
      read!("starter_no_design.html.heex")
    end
  end

  def design_imports_block do
    read!("design.css")
    |> String.trim()
  end

  def app_css_for_corex(theme) when is_binary(theme) do
    read!("app_corex.css")
    |> String.replace("__THEME__", theme)
    |> String.trim()
    |> Kernel.<>("\n")
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

  def plug_path(web_str) do
    read!("plug_path.eex")
    |> String.replace("__WEB__", web_str)
  end

  defp read!(name) do
    Path.join([:code.priv_dir(:corex), @sub, name]) |> File.read!()
  end
end
