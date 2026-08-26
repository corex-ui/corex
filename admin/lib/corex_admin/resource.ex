defmodule CorexAdmin.Resource do
  @moduledoc """
  Resource configuration for Corex Admin.

  A resource is **not** a LiveView. It describes how the admin talks to a Phoenix
  context: which functions to call, which fields are visible or writable, and
  which query params are allowlisted.

      defmodule MyAppWeb.Admin.UserResource do
        use CorexAdmin.Resource,
          context: MyApp.Accounts,
          schema: MyApp.Accounts.User,
          slug: "users",
          group: "Accounts",
          label: "Users",
          page_size: 25,
          page_size_options: [10, 25, 50, 100],
          default_sort: {:inserted_at, :desc},
          title_field: :email,
          selectable: true

        scope :current_scope

        actions do
          list :list_users
          get :get_user!
          create :create_user
          update :update_user
          delete :delete_user
          change_create :change_user
          change_update :change_user
        end

        fields do
          field :id, :id
          field :email, :email, searchable: true, sortable: true
          field :role, :select, options: ~w(admin editor viewer)
          field :password, :password
          field :inserted_at, :datetime, sortable: true
        end

        filters do
          filter :role, :select, options: ~w(admin editor viewer)
          filter :inserted_at, :date_range
        end
      end

  Filters are per resource. The generic index LiveView only renders `filters do`.
  Context functions receive the Phoenix scope as the first argument when
  `scope/1` is declared. See the [resources](resources.html) guide.
  """

  alias CorexAdmin.Resource.{Field, Filter, Spec}

  @field_types ~w(id text textarea email password number boolean select date datetime url embeds_many)a
  @filter_types ~w(select multi_select date_range datetime_range number_range boolean)a
  @required_actions ~w(list get create update delete change_create change_update)a

  @field_schema [
    readable: [type: :boolean],
    writable: [type: :boolean],
    searchable: [type: :boolean, default: false],
    sortable: [type: :boolean, default: false],
    filterable: [type: :boolean, default: false],
    redact: [type: :boolean],
    index: [type: :boolean],
    show: [type: :boolean],
    label: [type: :string],
    options: [type: {:list, :any}]
  ]

  @resource_schema [
    context: [type: :atom, required: true],
    schema: [type: :atom, required: true],
    slug: [type: :string],
    group: [type: :string],
    label: [type: :string],
    page_size: [type: :pos_integer],
    page_size_options: [type: {:list, :pos_integer}],
    default_sort: [type: {:or, [nil, {:tuple, [:atom, {:in, [:asc, :desc]}]}]}],
    title_field: [type: :atom],
    selectable: [type: :boolean, default: true]
  ]

  defmacro __using__(opts) do
    quote do
      Module.register_attribute(__MODULE__, :corex_admin_fields, accumulate: true)
      Module.register_attribute(__MODULE__, :corex_admin_filters, accumulate: true)
      Module.register_attribute(__MODULE__, :corex_admin_actions, accumulate: true)

      @corex_admin_scope nil
      @corex_admin_resource_opts unquote(opts)

      import CorexAdmin.Resource,
        only: [
          scope: 1,
          actions: 1,
          fields: 1,
          filters: 1,
          field: 2,
          field: 3,
          field: 4,
          filter: 2,
          filter: 3,
          list: 1,
          get: 1,
          create: 1,
          update: 1,
          delete: 1,
          change_create: 1,
          change_update: 1
        ]

      @before_compile CorexAdmin.Resource
    end
  end

  defmacro scope(name) when is_atom(name) do
    quote do
      @corex_admin_scope unquote(name)
    end
  end

  defmacro actions(do: block) do
    quote do
      unquote(block)
    end
  end

  defmacro fields(do: block) do
    quote do
      unquote(block)
    end
  end

  defmacro filters(do: block) do
    quote do
      unquote(block)
    end
  end

  defmacro field(name, type, opts \\ []) do
    {block, opts} = Keyword.pop(opts, :do)

    if block do
      quote do
        nested =
          CorexAdmin.Resource.__collect_nested__(__MODULE__, fn ->
            unquote(block)
          end)

        CorexAdmin.Resource.__push_field__(
          __MODULE__,
          unquote(name),
          unquote(type),
          Keyword.put(unquote(opts), :fields, nested)
        )
      end
    else
      quote do
        CorexAdmin.Resource.__push_field__(
          __MODULE__,
          unquote(name),
          unquote(type),
          unquote(opts)
        )
      end
    end
  end

  defmacro field(name, type, opts, do: block) do
    quote do
      nested =
        CorexAdmin.Resource.__collect_nested__(__MODULE__, fn ->
          unquote(block)
        end)

      CorexAdmin.Resource.__push_field__(
        __MODULE__,
        unquote(name),
        unquote(type),
        Keyword.put(unquote(opts), :fields, nested)
      )
    end
  end

  @doc false
  def __push_field__(mod, name, type, opts) do
    case Module.get_attribute(mod, :corex_admin_field_stack) do
      [current | rest] ->
        Module.put_attribute(mod, :corex_admin_field_stack, [
          [{name, type, opts} | current] | rest
        ])

      _ ->
        Module.put_attribute(mod, :corex_admin_fields, {name, type, opts})
    end
  end

  @doc false
  def __collect_nested__(mod, fun) do
    stack = Module.get_attribute(mod, :corex_admin_field_stack) || []
    Module.put_attribute(mod, :corex_admin_field_stack, [[] | stack])
    fun.()
    [current | rest] = Module.get_attribute(mod, :corex_admin_field_stack)

    case rest do
      [] -> Module.delete_attribute(mod, :corex_admin_field_stack)
      _ -> Module.put_attribute(mod, :corex_admin_field_stack, rest)
    end

    Enum.reverse(current)
  end

  defmacro filter(name, type, opts \\ []) do
    quote do
      @corex_admin_filters {unquote(name), unquote(type), unquote(opts)}
    end
  end

  for action <- @required_actions do
    defmacro unquote(action)(fun) when is_atom(fun) do
      action = unquote(action)

      quote do
        @corex_admin_actions {unquote(action), unquote(fun)}
      end
    end
  end

  defmacro __before_compile__(env) do
    opts = Module.get_attribute(env.module, :corex_admin_resource_opts) || []

    fields =
      Module.get_attribute(env.module, :corex_admin_fields) |> List.wrap() |> Enum.reverse()

    filters =
      Module.get_attribute(env.module, :corex_admin_filters) |> List.wrap() |> Enum.reverse()

    actions =
      Module.get_attribute(env.module, :corex_admin_actions) |> List.wrap() |> Enum.reverse()

    scope = Module.get_attribute(env.module, :corex_admin_scope)

    quote do
      def __corex_admin_resource__ do
        CorexAdmin.Resource.build_spec(
          __MODULE__,
          unquote(Macro.escape(opts)),
          unquote(Macro.escape(fields)),
          unquote(Macro.escape(filters)),
          unquote(Macro.escape(actions)),
          unquote(scope)
        )
      end
    end
  end

  @doc false
  def build_spec(module, opts, fields, filters, actions, scope) do
    opts = NimbleOptions.validate!(opts, @resource_schema)
    schema = opts[:schema]
    actions = Map.new(actions)

    missing = Enum.reject(@required_actions, &Map.has_key?(actions, &1))

    if missing != [] do
      raise ArgumentError,
            "#{inspect(module)} is missing actions: #{Enum.map_join(missing, ", ", &inspect/1)}"
    end

    slug = opts[:slug] || schema_source(schema)
    label = opts[:label] || Phoenix.Naming.humanize(slug)

    %Spec{
      module: module,
      context: opts[:context],
      schema: schema,
      slug: slug,
      group: opts[:group],
      label: label,
      scope: scope,
      primary_key: primary_key(schema),
      page_size: opts[:page_size],
      page_size_options: opts[:page_size_options],
      default_sort: opts[:default_sort],
      title_field: opts[:title_field],
      selectable: opts[:selectable],
      actions: actions,
      fields: Enum.map(fields, &build_field(schema, &1)),
      filters: Enum.map(filters, &build_filter/1)
    }
  end

  @doc "Allowed field type atoms for `field/3`."
  def field_types, do: @field_types

  @doc "Allowed filter type atoms for `filter/3`."
  def filter_types, do: @filter_types

  defp schema_source(schema) do
    if function_exported?(schema, :__schema__, 1) do
      schema.__schema__(:source) |> to_string()
    else
      schema
      |> Module.split()
      |> List.last()
      |> Macro.underscore()
      |> Kernel.<>("s")
    end
  end

  defp primary_key(schema) do
    if function_exported?(schema, :__schema__, 1) do
      case schema.__schema__(:primary_key) do
        [key | _] -> key
        _ -> :id
      end
    else
      :id
    end
  end

  defp build_field(schema, {name, type, opts}) when type in @field_types do
    {children, opts} = Keyword.pop(opts, :fields, [])
    {embed_schema, opts} = Keyword.pop(opts, :schema)
    opts = NimbleOptions.validate!(opts, @field_schema)
    redact_fields = redact_fields(schema)
    embed_schema = embed_schema || embed_schema(schema, name)

    defaults = %{
      readable: default_readable(type),
      writable: default_writable(name, type),
      redact: type == :password or name in redact_fields
    }

    readable = Keyword.get(opts, :readable, defaults.readable)
    redact = Keyword.get(opts, :redact, defaults.redact)

    %Field{
      name: name,
      type: type,
      label: opts[:label] || Phoenix.Naming.humanize(Atom.to_string(name)),
      readable: readable,
      writable: Keyword.get(opts, :writable, defaults.writable),
      searchable: opts[:searchable],
      sortable: opts[:sortable],
      filterable: opts[:filterable],
      redact: redact,
      index: Keyword.get(opts, :index, default_index(type, readable, redact)),
      show: Keyword.get(opts, :show, readable and not redact),
      options: opts[:options],
      schema: embed_schema,
      fields: Enum.map(List.wrap(children), &build_field(embed_schema || schema, &1))
    }
  end

  defp build_field(_schema, {_name, type, _opts}) do
    raise ArgumentError,
          "unknown field type #{inspect(type)}; expected one of #{inspect(@field_types)}"
  end

  defp build_filter({name, type, opts}) when type in @filter_types do
    opts = Keyword.validate!(opts, label: nil, options: nil, field: nil)
    field = opts[:field] || name

    %Filter{
      name: name,
      type: type,
      label: opts[:label] || Phoenix.Naming.humanize(Atom.to_string(name)),
      options: opts[:options],
      field: field
    }
  end

  defp build_filter({_name, type, _opts}) do
    raise ArgumentError,
          "unknown filter type #{inspect(type)}; expected one of #{inspect(@filter_types)}"
  end

  defp default_readable(:password), do: false
  defp default_readable(_type), do: true

  defp default_writable(_name, :password), do: true
  defp default_writable(_name, :id), do: false
  defp default_writable(name, _type) when name in [:inserted_at, :updated_at, :id], do: false
  defp default_writable(_name, _type), do: true

  defp default_index(:textarea, _readable, _redact), do: false
  defp default_index(:password, _readable, _redact), do: false
  defp default_index(:embeds_many, _readable, _redact), do: false
  defp default_index(_type, readable, redact), do: readable and not redact

  defp redact_fields(schema) do
    if function_exported?(schema, :__schema__, 1) do
      schema.__schema__(:redact_fields)
    else
      []
    end
  end

  defp embed_schema(schema, name) do
    if function_exported?(schema, :__schema__, 2) do
      case schema.__schema__(:embed, name) do
        %{related: related} -> related
        _ -> nil
      end
    end
  end
end
