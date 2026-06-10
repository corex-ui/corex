defmodule Corex.Design.Selector do
  @moduledoc false

  def host(id) when is_atom(id) or is_binary(id), do: ".#{class_name(id)}"

  def class_name(id) when is_atom(id) do
    id |> Atom.to_string() |> String.replace("_", "-")
  end

  def class_name(id) when is_binary(id), do: String.replace(id, "_", "-")

  def host_attr(id, attr, value) do
    "#{host(id)}[#{attr}=\"#{value}\"]"
  end

  def part(id, scope, part) do
    ~s(#{host(id)} #{part_node(scope, part)})
  end

  def part_node(scope, part) do
    ~s([data-scope="#{scope}"][data-part="#{part}"])
  end

  def slot(scope, part), do: part_node(scope, part)

  def strip_host_variant(selector, name) do
    case String.split(selector, " ", parts: 2) do
      [host, descendant] ->
        if host_variant?(host, name), do: String.trim(descendant), else: selector

      _ ->
        selector
    end
  end

  defp host_variant?(host, name) do
    base = ".#{class_name(name)}.#{class_name(name)}--"
    String.starts_with?(host, base)
  end
end

defmodule Corex.Design.Rule do
  @moduledoc false

  @enforce_keys [:selector]
  defstruct selector: nil, decls: [], children: []

  @type decl ::
          {atom(), term()}
          | {:include, atom()}
          | {:raw, binary()}
  @type t :: %__MODULE__{
          selector: binary(),
          decls: [decl()],
          children: [t()]
        }

  def new(selector, opts \\ []) when is_binary(selector) do
    %__MODULE__{
      selector: selector,
      decls: Keyword.get(opts, :decls, []),
      children: Keyword.get(opts, :children, [])
    }
  end
end

defmodule Corex.Design.Condition do
  @moduledoc false

  @pseudo %{
    hover: "&:hover",
    visited: "&:visited",
    active: "&:active",
    focus: "&:focus",
    focus_visible: "&:focus-visible",
    focus_within: "&:focus-within",
    disabled: "&:disabled,\n  &[data-disabled],\n  &[disabled]",
    placeholder: "&::placeholder",
    before: "&::before",
    after: "&::after"
  }

  @zag_state %{
    open: ~s(&[data-state="open"]),
    closed: ~s(&[data-state="closed"]),
    checked: ~s(&[data-state="checked"]),
    unchecked: ~s(&[data-state="unchecked"]),
    on: ~s(&[data-state="on"]),
    off: ~s(&[data-state="off"]),
    not_on: ~s'&:not([data-state="on"])',
    indeterminate: ~s(&[data-state="indeterminate"])
  }

  @zag_flags %{
    highlighted: "&[data-highlighted]",
    selected:
      ~s(&[data-selected],\n  &[data-state="checked"],\n  &[data-state="on"],\n  &[data-checked],\n  &[data-indeterminate]),
    invalid: "&[data-invalid]",
    readonly: "&[data-readonly]",
    in_range: "&[data-in-range]",
    checked_flag: "&[data-checked]",
    indeterminate_flag: "&[data-indeterminate]",
    loading: "&[data-loading]",
    async: "&[data-async]"
  }

  @structural %{
    rtl: ~s([dir="rtl"] &),
    ltr: ~s([dir="ltr"] &),
    dark: ~s([data-mode="dark"] &),
    light: ~s([data-mode="light"] &)
  }

  @breakpoints for {step, width} <- Corex.Design.Tokens.Scales.breakpoint(),
                   into: %{},
                   do: {step, "@media (min-width: #{width})"}

  @registry Map.merge(@pseudo, @zag_state)
            |> Map.merge(@zag_flags)
            |> Map.merge(@structural)
            |> Map.merge(@breakpoints)

  def registry, do: @registry

  def condition?(key) when is_atom(key), do: Map.has_key?(@registry, key)

  def condition?(key) when is_list(key) do
    Enum.all?(key, &condition?/1)
  end

  def condition?({:at, _}), do: true
  def condition?(_), do: false

  def selector(atom) when is_atom(atom) do
    case Map.fetch(@registry, atom) do
      {:ok, sel} -> sel
      :error -> raise ArgumentError, "unknown condition #{inspect(atom)}"
    end
  end

  def selector(list) when is_list(list) do
    Enum.map_join(list, ",\n  ", &selector/1)
  end

  def selector({:at, rule}) when is_binary(rule), do: rule

  def keys, do: Map.keys(@registry)
end
