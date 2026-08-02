defmodule Corex.Component do
  @moduledoc """
  Preludes for component and Connect modules.

  Every component reaches for the same handful of helper sets, and spelling each
  one out as an `import ..., only: [...]` list produced dozens of near-identical
  shapes that drifted as functions were added. `use Corex.Component, :tier` names
  the set instead:

  - `:connect` - the HTML attribute builders a Connect module emits
  - `:list` - normalization for the item collections list components render
  - `:api` - coercions for values arriving from `handle_event` params, plus
    `respond_to_fields/1` for the imperative API
  - `:form` - the `form_control_attrs/1` macro and form field plumbing

  Tiers compose, so `use Corex.Component, [:connect, :list]` is valid.
  """

  @connect [
    presence_attr: 1,
    presence_attr: 2,
    default_presence_attr: 2,
    data_state: 3,
    maybe_put: 3,
    put_dir_attr: 2,
    put_data_dir_attr: 2,
    put_dir_attr_from_assigns: 2,
    put_data_dir_attr_from_assigns: 2,
    visually_hidden_style: 0
  ]

  @list [
    normalize_items: 1,
    has_groups?: 1,
    group_by_group: 1,
    entry_value: 1,
    entry_selected?: 2,
    field_value_list: 1,
    put_disabled_attrs: 2,
    selected_label: 2,
    value_for_hidden_input: 2
  ]

  @value [
    coerce_string_list: 1,
    coerce_string_list: 2,
    parse_string_list: 2,
    parse_string_list: 3,
    coerce_string_value: 2
  ]

  defmacro __using__(tiers) do
    tiers
    |> List.wrap()
    |> Enum.map(&tier/1)
  end

  defp tier(:connect) do
    quote do
      import Corex.Attrs, only: unquote(@connect)
    end
  end

  defp tier(:list) do
    quote do
      import Corex.List.Normalize, only: unquote(@list)
    end
  end

  defp tier(:api) do
    quote do
      import Corex.Api.RespondTo, only: [respond_to_fields: 1]
      import Corex.Value, only: unquote(@value)
    end
  end

  defp tier(:form) do
    quote do
      import Corex.Component, only: [form_control_attrs: 0, form_control_attrs: 1]
    end
  end

  defp tier(other) do
    raise ArgumentError,
          "unknown Corex.Component tier #{inspect(other)}, expected :connect, :list, :api or :form"
  end

  @doc """
  Shared attrs for form-capable components. Expand inside the component module
  after `use Phoenix.Component`.

  Options:

  - `:except` - list of attr names to skip (for example `[:controlled]`)
  - `:docs` - keyword list of per-attr doc overrides
  """
  defmacro form_control_attrs(opts \\ []) do
    except = Keyword.get(opts, :except, [])
    docs = Keyword.get(opts, :docs, [])

    doc = fn key, default ->
      Keyword.get(docs, key, default)
    end

    attrs =
      []
      |> maybe_attr(
        :id,
        except,
        quote do
          attr(:id, :string,
            default: nil,
            doc: unquote(doc.(:id, "Stable id for the component"))
          )
        end
      )
      |> maybe_attr(
        :field,
        except,
        quote do
          attr(:field, Phoenix.HTML.FormField,
            default: nil,
            doc:
              unquote(
                doc.(
                  :field,
                  "A form field struct from the form, for example: @form[:email]"
                )
              )
          )
        end
      )
      |> maybe_attr(
        :name,
        except,
        quote do
          attr(:name, :string,
            default: nil,
            doc: unquote(doc.(:name, "Name attribute for form submission"))
          )
        end
      )
      |> maybe_attr(
        :form,
        except,
        quote do
          attr(:form, :string,
            default: nil,
            doc: unquote(doc.(:form, "Form id to associate the control with"))
          )
        end
      )
      |> maybe_attr(
        :invalid,
        except,
        quote do
          attr(:invalid, :boolean,
            default: nil,
            doc: unquote(doc.(:invalid, "Whether the control has validation errors"))
          )
        end
      )
      |> maybe_attr(
        :auto_invalid,
        except,
        quote do
          attr(:auto_invalid, :boolean,
            default: true,
            doc:
              unquote(
                doc.(
                  :auto_invalid,
                  "When true with `field`, set invalid from visible changeset errors (default true)"
                )
              )
          )
        end
      )
      |> maybe_attr(
        :controlled,
        except,
        quote do
          attr(:controlled, :boolean,
            default: false,
            doc: unquote(doc.(:controlled, "Whether the control is controlled"))
          )
        end
      )
      |> maybe_attr(
        :disabled,
        except,
        quote do
          attr(:disabled, :boolean,
            default: false,
            doc: unquote(doc.(:disabled, "Whether the control is disabled"))
          )
        end
      )
      |> maybe_attr(
        :read_only,
        except,
        quote do
          attr(:read_only, :boolean,
            default: false,
            doc: unquote(doc.(:read_only, "Whether the control is read-only"))
          )
        end
      )
      |> maybe_attr(
        :required,
        except,
        quote do
          attr(:required, :boolean,
            default: false,
            doc: unquote(doc.(:required, "Whether the control is required"))
          )
        end
      )

    {:__block__, [], Enum.reverse(attrs)}
  end

  defp maybe_attr(acc, _name, except, _quoted) when is_list(except) == false, do: acc

  defp maybe_attr(acc, name, except, quoted) do
    if name in except, do: acc, else: [quoted | acc]
  end
end
