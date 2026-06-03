defmodule E2eWeb.DocAuthoring do
  @moduledoc false

  @process_key {__MODULE__, :context}
  @authoring_values ~w(attr class markup)
  @default_authoring "attr"
  @default_app_name "my_app"

  def default_authoring, do: @default_authoring
  def default_app_name, do: @default_app_name

  def put(authoring) do
    Process.put(@process_key, %{
      authoring: normalize_authoring(authoring),
      app_name: @default_app_name
    })
  end

  def get do
    Process.get(@process_key, %{
      authoring: @default_authoring,
      app_name: @default_app_name
    })
  end

  def normalize_authoring(authoring) when authoring in @authoring_values, do: authoring
  def normalize_authoring("class"), do: "class"
  def normalize_authoring("markup"), do: "markup"
  def normalize_authoring(_), do: @default_authoring

  def normalize_app_name(nil), do: @default_app_name

  def normalize_app_name(app_name) when is_binary(app_name) do
    app_name
    |> String.trim()
    |> String.downcase()
    |> case do
      "" -> @default_app_name
      name -> name
    end
  end

  def normalize_app_name(_), do: @default_app_name

  def module_name(app_name) do
    app_name
    |> normalize_app_name()
    |> Macro.camelize()
  end

  def web_module_name(app_name), do: module_name(app_name) <> "Web"
end
