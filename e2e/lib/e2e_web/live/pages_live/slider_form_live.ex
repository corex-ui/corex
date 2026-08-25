defmodule E2eWeb.SliderFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.SliderForm
  alias E2e.Form.SliderRangeForm
  alias E2eWeb.Demos.SliderDemo

  @phoenix_form_id "slider-live-form-phoenix"
  @phoenix_range_form_id "slider-live-form-phoenix-range"
  @default_range [20.0, 80.0]

  @impl true
  def mount(_params, _session, socket) do
    demo = SliderDemo

    {:ok,
     socket
     |> assign(:page_title, "Slider · Live Form")
     |> assign(:form_ecto, demo.form_ecto())
     |> assign(:form_ecto_range, demo.form_ecto_range())
     |> assign(:live_phoenix_heex, demo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, demo.form_doc_live_phoenix_elixir())
     |> assign(:live_phoenix_range_heex, demo.form_doc_live_phoenix_range_heex())
     |> assign(:live_phoenix_range_elixir, demo.form_doc_live_phoenix_range_elixir())
     |> assign(:live_ecto_heex, demo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, demo.form_doc_live_ecto_elixir())
     |> assign(:live_ecto_range_heex, demo.form_doc_live_ecto_range_heex())
     |> assign(:live_ecto_range_elixir, demo.form_doc_live_ecto_range_elixir())
     |> assign(:live_ecto_invalid_heex, demo.form_doc_live_ecto_invalid_heex())
     |> assign(:live_ecto_invalid_elixir, demo.form_doc_live_ecto_invalid_elixir())
     |> assign(:live_ecto_invalid_range_heex, demo.form_doc_live_ecto_invalid_range_heex())
     |> assign(:live_ecto_invalid_range_elixir, demo.form_doc_live_ecto_invalid_range_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"volume" => "0"},
        as: :slider_phoenix,
        id: @phoenix_form_id
      )

    phoenix_range_form =
      Phoenix.Component.to_form(%{"volume" => ["20", "80"]},
        as: :slider_phoenix_range,
        id: @phoenix_range_form_id
      )

    validate_form =
      %SliderForm{}
      |> SliderForm.changeset_validate(%{"volume" => "0"})
      |> Phoenix.Component.to_form(
        as: :slider_validate,
        id: "slider-validate-form-live"
      )

    validate_range_form =
      %SliderRangeForm{}
      |> SliderRangeForm.changeset_validate(%{"volume" => ["20", "80"]})
      |> Phoenix.Component.to_form(
        as: :slider_validate_range,
        id: "slider-validate-range-form-live"
      )

    validate_invalid_form =
      %SliderForm{}
      |> SliderForm.changeset_validate(%{"volume" => "0"})
      |> Phoenix.Component.to_form(
        as: :slider_validate_invalid,
        id: "slider-validate-form-live-invalid"
      )

    validate_invalid_range_form =
      %SliderRangeForm{}
      |> SliderRangeForm.changeset_validate(%{"volume" => ["20", "80"]})
      |> Phoenix.Component.to_form(
        as: :slider_validate_invalid_range,
        id: "slider-validate-form-live-invalid-range"
      )

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:phoenix_range_form, phoenix_range_form)
    |> assign(:validate_form, validate_form)
    |> assign(:validate_range_form, validate_range_form)
    |> assign(:validate_invalid_form, validate_invalid_form)
    |> assign(:validate_invalid_range_form, validate_invalid_range_form)
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

  def handle_event("save_phoenix_range", %{"slider_phoenix_range" => params}, socket) do
    volume = params["volume"] || []

    {:noreply,
     socket
     |> Toast.create(
       "layout-toast",
       "Submitted",
       "Submitted: volume=#{inspect(volume)}",
       :info,
       duration: 5000
     )
     |> assign(
       :phoenix_range_form,
       Phoenix.Component.to_form(%{"volume" => List.wrap(volume)},
         as: :slider_phoenix_range,
         id: @phoenix_range_form_id
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
      "slider-validate-form-live",
      &SliderForm.changeset_validate/2,
      SliderForm
    )
    |> then(&{:noreply, &1})
  end

  def handle_event("validate_validate_range", params, socket) do
    validate_ecto(
      socket,
      Map.get(params, "slider_validate_range", %{}),
      :validate_range_form,
      :slider_validate_range,
      "slider-validate-range-form-live",
      &SliderRangeForm.changeset_validate/2,
      SliderRangeForm
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
       "slider-validate-form-live-invalid",
       &SliderForm.changeset_validate/2,
       SliderForm
     )}
  end

  def handle_event("validate_invalid_range", params, socket) do
    {:noreply,
     validate_ecto(
       socket,
       Map.get(params, "slider_validate_invalid_range", %{}),
       :validate_invalid_range_form,
       :slider_validate_invalid_range,
       "slider-validate-form-live-invalid-range",
       &SliderRangeForm.changeset_validate/2,
       SliderRangeForm
     )}
  end

  @impl true
  def handle_event("save_validate", params, socket) do
    save_ecto(
      socket,
      Map.get(params, "slider_validate", %{}),
      :validate_form,
      :slider_validate,
      "slider-validate-form-live",
      &SliderForm.changeset_validate/2,
      SliderForm
    )
  end

  def handle_event("save_validate_range", params, socket) do
    save_ecto(
      socket,
      Map.get(params, "slider_validate_range", %{}),
      :validate_range_form,
      :slider_validate_range,
      "slider-validate-range-form-live",
      &SliderRangeForm.changeset_validate/2,
      SliderRangeForm
    )
  end

  def handle_event("save_invalid", params, socket) do
    save_ecto(
      socket,
      Map.get(params, "slider_validate_invalid", %{}),
      :validate_invalid_form,
      :slider_validate_invalid,
      "slider-validate-form-live-invalid",
      &SliderForm.changeset_validate/2,
      SliderForm
    )
  end

  def handle_event("save_invalid_range", params, socket) do
    save_ecto(
      socket,
      Map.get(params, "slider_validate_invalid_range", %{}),
      :validate_invalid_range_form,
      :slider_validate_invalid_range,
      "slider-validate-form-live-invalid-range",
      &SliderRangeForm.changeset_validate/2,
      SliderRangeForm
    )
  end

  defp validate_ecto(socket, params, form_key, form_as, form_id, changeset_fun, schema) do
    changeset =
      struct(schema)
      |> changeset_fun.(params)
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

  defp save_ecto(socket, params, form_key, form_as, form_id, changeset_fun, schema) do
    case changeset_fun.(struct(schema), params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: volume=#{inspect(data.volume)}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           form_key,
           Phoenix.Component.to_form(
             changeset_fun.(struct(schema), params),
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
        :validate_range_volume_value,
        get_volume_range_from_form(assigns.validate_range_form)
      )
      |> assign(
        :validate_invalid_volume_value,
        get_volume_from_form(assigns.validate_invalid_form)
      )
      |> assign(
        :validate_invalid_range_volume_value,
        get_volume_range_from_form(assigns.validate_invalid_range_form)
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
          id="slider-live-form-phoenix-range-section"
          title={~t"Phoenix Form · Range"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_range_heex},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @live_phoenix_range_elixir
            }
          ]}
        >
          <:preview>
            <SliderDemo.form_preview_live_phoenix_range form={@phoenix_range_form} />
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
          id="slider-live-form-ecto-range-section"
          title={~t"Phoenix Form + Ecto · Range"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_range_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_range_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto_range}
          ]}
        >
          <:preview>
            <SliderDemo.form_preview_live_validate_range
              form={@validate_range_form}
              volume_value={@validate_range_volume_value}
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

        <.demo_section
          id="slider-live-form-ecto-invalid-range-section"
          title={~t"Phoenix Form + Ecto + Invalid · Range"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @live_ecto_invalid_range_heex
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @live_ecto_invalid_range_elixir
            },
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto_range}
          ]}
        >
          <:preview>
            <SliderDemo.form_preview_live_validate_invalid_range
              form={@validate_invalid_range_form}
              volume_value={@validate_invalid_range_volume_value}
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

      _ ->
        0.0
    end
  end

  defp get_volume_range_from_form(form) do
    raw =
      form.params["volume"] ||
        Ecto.Changeset.get_change(form.source, :volume) ||
        Ecto.Changeset.get_field(form.source, :volume)

    case raw do
      [lo, hi] ->
        [to_float(lo), to_float(hi)]

      _ ->
        @default_range
    end
  end

  defp to_float(value) when is_float(value), do: value
  defp to_float(value) when is_integer(value), do: value * 1.0

  defp to_float(value) when is_binary(value) do
    case Float.parse(value) do
      {num, _} -> num
      :error -> 0.0
    end
  end

  defp to_float(_), do: 0.0
end
