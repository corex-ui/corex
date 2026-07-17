defmodule E2eWeb.SelectFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.SelectForm
  alias E2eWeb.Demos.SelectDemo, as: SelectDemo

  @phoenix_form_id "select-live-form-phoenix"
  @ecto_form_id "select-live-form-ecto"
  @ecto_controlled_form_id "select-live-form-ecto-controlled"
  @ecto_invalid_form_id "select-live-form-ecto-invalid"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Select · Form")
     |> assign(:form_ecto, SelectDemo.form_ecto())
     |> assign(:live_phoenix_heex, SelectDemo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, SelectDemo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, SelectDemo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, SelectDemo.form_doc_live_ecto_elixir())
     |> assign(:live_ecto_controlled_heex, SelectDemo.form_doc_live_ecto_controlled_heex())
     |> assign(:live_ecto_controlled_elixir, SelectDemo.form_doc_live_ecto_controlled_elixir())
     |> assign(:live_ecto_invalid_heex, SelectDemo.form_doc_live_ecto_invalid_heex())
     |> assign(:live_ecto_invalid_elixir, SelectDemo.form_doc_live_ecto_invalid_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"country" => ""}, as: :select_phoenix, id: @phoenix_form_id)

    ecto_form =
      change_select(%{})
      |> Phoenix.Component.to_form(as: :select_ecto, id: @ecto_form_id)

    ecto_controlled_form =
      change_select(%{})
      |> Phoenix.Component.to_form(as: :select_ecto_controlled, id: @ecto_controlled_form_id)

    ecto_invalid_form =
      change_select(%{})
      |> Phoenix.Component.to_form(as: :select_ecto_invalid, id: @ecto_invalid_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:ecto_form, ecto_form)
    |> assign(:ecto_controlled_form, ecto_controlled_form)
    |> assign(:ecto_invalid_form, ecto_invalid_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"select_phoenix" => params}, socket) do
    country = params["country"] || ""

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "country=#{country}", :info, duration: 5000)
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"country" => country},
         as: :select_phoenix,
         id: @phoenix_form_id
       )
     )}
  end

  @impl true
  def handle_event("validate", %{"select_ecto" => params}, socket) do
    {:noreply, validate_form(socket, params, :ecto_form, :select_ecto, @ecto_form_id)}
  end

  @impl true
  def handle_event("validate_controlled", %{"select_ecto_controlled" => params}, socket) do
    {:noreply,
     validate_form(
       socket,
       params,
       :ecto_controlled_form,
       :select_ecto_controlled,
       @ecto_controlled_form_id
     )}
  end

  @impl true
  def handle_event("validate_invalid", %{"select_ecto_invalid" => params}, socket) do
    {:noreply,
     validate_form(
       socket,
       params,
       :ecto_invalid_form,
       :select_ecto_invalid,
       @ecto_invalid_form_id
     )}
  end

  @impl true
  def handle_event("save", %{"select_ecto" => params}, socket) do
    save_form(socket, params, :ecto_form, :select_ecto, @ecto_form_id)
  end

  @impl true
  def handle_event("save_controlled", %{"select_ecto_controlled" => params}, socket) do
    save_form(
      socket,
      params,
      :ecto_controlled_form,
      :select_ecto_controlled,
      @ecto_controlled_form_id
    )
  end

  @impl true
  def handle_event("save_invalid", %{"select_ecto_invalid" => params}, socket) do
    save_form(socket, params, :ecto_invalid_form, :select_ecto_invalid, @ecto_invalid_form_id)
  end

  defp change_select(attrs), do: SelectForm.changeset(%SelectForm{}, attrs)

  defp validate_form(socket, params, form_key, form_as, form_id) do
    assign(
      socket,
      form_key,
      Phoenix.Component.to_form(change_select(params),
        action: :validate,
        as: form_as,
        id: form_id
      )
    )
  end

  defp save_form(socket, params, form_key, form_as, form_id) do
    case change_select(params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", "country=#{data.country}", :info,
           duration: 5000
         )
         |> assign(
           form_key,
           Phoenix.Component.to_form(change_select(params), as: form_as, id: form_id)
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           form_key,
           Phoenix.Component.to_form(changeset, action: :insert, as: form_as, id: form_id)
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="select-form-live-page" title={~t"Select · Form"}>
        <.demo_section
          id="select-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <SelectDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="select-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SelectDemo.form_preview_live_ecto form={@ecto_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="select-live-form-ecto-controlled-section"
          title={~t"Phoenix Form + Ecto + Controlled"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @live_ecto_controlled_heex
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @live_ecto_controlled_elixir
            },
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SelectDemo.form_preview_live_ecto_controlled form={@ecto_controlled_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="select-live-form-ecto-invalid-section"
          title={~t"Phoenix Form + Ecto + Invalid"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @live_ecto_invalid_heex
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @live_ecto_invalid_elixir
            },
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SelectDemo.form_preview_live_ecto_invalid form={@ecto_invalid_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
