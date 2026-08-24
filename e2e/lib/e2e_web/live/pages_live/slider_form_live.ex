defmodule E2eWeb.SliderFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.SliderForm
  alias E2eWeb.Demos.SliderDemo

  @phoenix_form_id "slider-live-form-phoenix"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Slider · Live Form")
     |> assign(:form_ecto, SliderDemo.form_ecto())
     |> assign(:live_phoenix_heex, SliderDemo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, SliderDemo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, SliderDemo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, SliderDemo.form_doc_live_ecto_elixir())
     |> assign(:live_ecto_invalid_heex, SliderDemo.form_doc_live_ecto_invalid_heex())
     |> assign(:live_ecto_invalid_elixir, SliderDemo.form_doc_live_ecto_invalid_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"volume" => "0"},
        as: :slider_phoenix,
        id: @phoenix_form_id
      )

    validate_form =
      %SliderForm{}
      |> SliderForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :slider_validate,
        id: "slider-validate-form-live"
      )

    validate_invalid_form =
      %SliderForm{}
      |> SliderForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :slider_validate_invalid,
        id: "slider-validate-form-live-invalid"
      )

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:validate_form, validate_form)
    |> assign(:validate_invalid_form, validate_invalid_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"slider_phoenix" => params}, socket) do
    volume = params["volume"] || ""

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "Submitted: volume=#{volume}", :info,
       duration: 5000
     )
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"volume" => volume},
         as: :slider_phoenix,
         id: @phoenix_form_id
       )
     )}
  end

  @impl true
  def handle_event("validate_validate", params, socket) do
    validate_ecto(
      socket,
      Map.get(params, "slider_validate", %{}),
      :validate_form,
      :slider_validate,
      "slider-validate-form-live"
    )
    |> then(&{:noreply, &1})
  end

  def handle_event("validate_invalid", params, socket) do
    {:noreply,
     validate_ecto(
       socket,
       Map.get(params, "slider_validate_invalid", %{}),
       :validate_invalid_form,
       :slider_validate_invalid,
       "slider-validate-form-live-invalid"
     )}
  end

  @impl true
  def handle_event("save_validate", params, socket) do
    save_ecto(
      socket,
      Map.get(params, "slider_validate", %{}),
      :validate_form,
      :slider_validate,
      "slider-validate-form-live"
    )
  end

  def handle_event("save_invalid", params, socket) do
    save_ecto(
      socket,
      Map.get(params, "slider_validate_invalid", %{}),
      :validate_invalid_form,
      :slider_validate_invalid,
      "slider-validate-form-live-invalid"
    )
  end

  defp validate_ecto(socket, params, form_key, form_as, form_id) do
    changeset =
      %SliderForm{}
      |> SliderForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    assign(
      socket,
      form_key,
      Phoenix.Component.to_form(changeset,
        action: :validate,
        as: form_as,
        id: form_id
      )
    )
  end

  defp save_ecto(socket, params, form_key, form_as, form_id) do
    case SliderForm.changeset_validate(%SliderForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: volume=#{data.volume}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           form_key,
           Phoenix.Component.to_form(
             SliderForm.changeset_validate(%SliderForm{}, params),
             as: form_as,
             id: form_id
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           form_key,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: form_as,
             id: form_id
           )
         )}
    end
  end

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:validate_volume_value, get_volume_from_form(assigns.validate_form))
      |> assign(
        :validate_invalid_volume_value,
        get_volume_from_form(assigns.validate_invalid_form)
      )

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="slider-form-live-page"
        title={~t"Slider · Live Form"}
      >
        <.demo_section
          id="slider-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <SliderDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="slider-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SliderDemo.form_preview_live_validate
              form={@validate_form}
              volume_value={@validate_volume_value}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="slider-live-form-ecto-invalid-section"
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
            <SliderDemo.form_preview_live_validate_invalid
              form={@validate_invalid_form}
              volume_value={@validate_invalid_volume_value}
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp get_volume_from_form(form) do
    raw =
      form.params["volume"] ||
        Ecto.Changeset.get_change(form.source, :volume) ||
        Ecto.Changeset.get_field(form.source, :volume)

    case raw do
      nil ->
        0.0

      "" ->
        0.0

      val when is_binary(val) ->
        case Float.parse(val) do
          {num, _} -> num
          :error -> 0.0
        end

      val when is_number(val) ->
        val * 1.0
    end
  end
end
