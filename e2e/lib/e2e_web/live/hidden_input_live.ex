defmodule E2eWeb.HiddenInputLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    form = Phoenix.Component.to_form(%{"id" => "123", "name" => ""}, as: :user)
    {:ok, assign(socket, form: form)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <div class="layout__row">
        <h1>Hidden Input</h1>
        <h2>Live View</h2>
      </div>
      <.form for={@form} id="hidden-input-form">
        <.hidden_input name="user[id]" value="123" />
        <.text_input id="my-text-input" name="user[name]" class="text-input">
          <:label>Name</:label>
        </.text_input>
      </.form>
    </Layouts.app>
    """
  end
end
