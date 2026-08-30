defmodule E2eWeb.Demos.NestedFieldsDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.nested_fields field={@form[:social_links]} class="nested-fields">
      <:label>Social links</:label>
      <:description>Optional profile URLs for this ticket.</:description>
      <:col :let={f} label="Label">
        <.native_input field={f[:label]} type="text" class="native-input">
          <:label>Label</:label>
        </.native_input>
      </:col>
      <:col :let={f} label="URL">
        <.native_input field={f[:url]} type="url" class="native-input">
          <:label>URL</:label>
        </.native_input>
      </:col>
      <:add_trigger>Add link</:add_trigger>
      <:remove_trigger><.heroicon name="hero-trash" class="icon" /></:remove_trigger>
    </.nested_fields>
    """
  end

  def empty_code do
    ~S"""
    <.nested_fields field={@form[:social_links]} class="nested-fields">
      <:label>Social links</:label>
      <:empty>No links yet.</:empty>
      <:col :let={f} label="Label">
        <.native_input field={f[:label]} type="text" class="native-input">
          <:label>Label</:label>
        </.native_input>
      </:col>
      <:col :let={f} label="URL">
        <.native_input field={f[:url]} type="url" class="native-input">
          <:label>URL</:label>
        </.native_input>
      </:col>
      <:add_trigger>Add link</:add_trigger>
      <:remove_trigger><.heroicon name="hero-trash" class="icon" /></:remove_trigger>
    </.nested_fields>
    """
  end

  def minimal_example(assigns) do
    assigns = assign_new(assigns, :form, &demo_form/0)

    ~H"""
    <.form for={@form} id="nested-fields-anatomy-minimal-form">
      <.nested_fields field={@form[:social_links]} class="nested-fields">
        <:label>Social links</:label>
        <:description>Optional profile URLs for this ticket.</:description>
        <:col :let={f} label="Label">
          <.native_input field={f[:label]} type="text" class="native-input">
            <:label>Label</:label>
          </.native_input>
        </:col>
        <:col :let={f} label="URL">
          <.native_input field={f[:url]} type="url" class="native-input">
            <:label>URL</:label>
          </.native_input>
        </:col>
        <:add_trigger>Add link</:add_trigger>
        <:remove_trigger><.heroicon name="hero-trash" class="icon" /></:remove_trigger>
      </.nested_fields>
    </.form>
    """
  end

  def empty_example(assigns) do
    assigns = assign_new(assigns, :form, &empty_form/0)

    ~H"""
    <.form for={@form} id="nested-fields-anatomy-empty-form">
      <.nested_fields field={@form[:social_links]} class="nested-fields">
        <:label>Social links</:label>
        <:empty>No links yet.</:empty>
        <:col :let={f} label="Label">
          <.native_input field={f[:label]} type="text" class="native-input">
            <:label>Label</:label>
          </.native_input>
        </:col>
        <:col :let={f} label="URL">
          <.native_input field={f[:url]} type="url" class="native-input">
            <:label>URL</:label>
          </.native_input>
        </:col>
        <:add_trigger>Add link</:add_trigger>
        <:remove_trigger><.heroicon name="hero-trash" class="icon" /></:remove_trigger>
      </.nested_fields>
    </.form>
    """
  end

  defmodule Link do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field(:label, :string)
      field(:url, :string)
    end

    def changeset(link, attrs) do
      link
      |> cast(attrs, [:label, :url])
      |> validate_required([:label, :url])
    end
  end

  defmodule Profile do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      embeds_many(:social_links, Link, on_replace: :delete)
    end

    def changeset(profile, attrs) do
      profile
      |> cast(attrs, [])
      |> cast_embed(:social_links,
        with: &Link.changeset/2,
        sort_param: :social_links_sort,
        drop_param: :social_links_drop
      )
    end
  end

  defp demo_form do
    %Profile{}
    |> Profile.changeset(%{
      "social_links" => [
        %{"label" => "Docs", "url" => "https://example.test/docs"},
        %{"label" => "Status", "url" => "https://example.test/status"}
      ]
    })
    |> to_form(as: :profile)
  end

  defp empty_form do
    %Profile{}
    |> Profile.changeset(%{})
    |> to_form(as: :profile)
  end
end
