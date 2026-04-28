defmodule E2eWeb.Demos.EditableDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.editable id="editable-anatomy-minimal" class="editable" value="My custom value" placeholder="Enter value">
      <:label>Name</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.editable
      id="editable-anatomy-minimal"
      class="editable"
      value="My custom value"
      placeholder="Enter value"
    >
      <:label>Name</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def with_triggers_code do
    ~S"""
    <.editable
      id="editable-anatomy-triggers"
      class="editable"
      value="Double click to edit"
      activation_mode="dblclick"
      select_on_focus
    >
      <:label>Name</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def with_triggers_example(assigns) do
    ~H"""
    <.editable
      id="editable-anatomy-triggers"
      class="editable"
      value="Double click to edit"
      activation_mode="dblclick"
      select_on_focus
    >
      <:label>Name</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def styling_size_code do
    ~S"""
    <.editable id="editable-style-sm" class="editable editable--sm" value="SM">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    <.editable id="editable-style-lg" class="editable editable--lg" value="LG">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-sm">
      <.editable id="editable-style-sm" class="editable editable--sm" value="SM">
        <:label>Label</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.editable id="editable-style-lg" class="editable editable--lg" value="LG">
        <:label>Label</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
    </div>
    """
  end

  def api_overview_code do
    minimal_code()
  end

  def api_overview_example(assigns) do
    minimal_example(assigns)
  end

  def events_server_heex do
    ~S"""
    <.editable
      id="editable-events-server"
      class="editable"
      default_value="Edit me"
      on_value_change="editable_changed"
    >
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("editable_changed", %{"id" => id, "value" => value}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(value)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.editable
      id="editable-events-client"
      class="editable"
      default_value="Edit me"
      on_value_change_client="editable-changed"
    >
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("editable-events-client");
    el?.addEventListener("editable-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("editable-events-client");
    el?.addEventListener("editable-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_code do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/editable/form"}
      method="post"
      id={@form.id}
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.editable
        field={f[:text]}
        placeholder="Enter text"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
      >
        <:label>Text</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-form-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end
end
