defmodule Corex.NestedFieldsTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component, only: [to_form: 2]

  alias Corex.NestedFields

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

  defp form(attrs) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> to_form(as: :profile)
  end

  defp render_nested(form, opts \\ []) do
    empty = Keyword.get(opts, :empty)

    assigns = %{
      field: form[:social_links],
      class: "nested-fields",
      label: [%{inner_block: fn _, _ -> "Social links" end}],
      description: [%{inner_block: fn _, _ -> "Optional profile URLs." end}],
      add_trigger: [%{inner_block: fn _, _ -> "Add link" end}],
      remove_trigger: [%{inner_block: fn _, _ -> "Remove" end}],
      col: [
        %{label: "Label", inner_block: fn _, f -> "label-#{f.index}" end},
        %{label: "URL", inner_block: fn _, f -> "url-#{f.index}" end}
      ],
      empty:
        if empty do
          [%{inner_block: fn _, _ -> empty end}]
        else
          []
        end
    }

    render_component(&NestedFields.nested_fields/1, assigns)
  end

  test "renders legend, headers, add trigger, and empty state" do
    html = render_nested(form(%{}), empty: "No links yet.")

    assert html =~ ~S(data-part="root")
    assert html =~ "Social links"
    assert html =~ "Optional profile URLs."
    assert html =~ "No links yet."
    assert html =~ "Add link"
    assert html =~ ~S(name="profile[social_links_sort][]")
    assert html =~ ~S(name="profile[social_links_drop][]")
    assert html =~ ~S(value="new")
    refute html =~ "label-0"
  end

  test "renders a row per embed with sort and drop params" do
    html =
      render_nested(
        form(%{
          "social_links" => [
            %{"label" => "Docs", "url" => "https://example.test/docs"},
            %{"label" => "Status", "url" => "https://example.test/status"}
          ]
        })
      )

    assert html =~ "label-0"
    assert html =~ "url-1"
    assert html =~ ~S(value="0")
    assert html =~ ~S(value="1")
    assert html =~ "Remove row 1"
    refute html =~ "No links yet."
  end
end
