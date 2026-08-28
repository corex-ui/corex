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
          selectable: true,
          default_filters: %{role: "admin"}

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
          filter :role, :select, options: ~w(admin editor viewer), pin: true
          filter :email, :text
          filter :priority, :number, operators: [:eq, :gte, :lte]
          filter :tags, :tags, pin: false
          filter :bio, :presence, pin: false
          filter :id, :id, pin: false
          filter :created, :relative_date, field: :inserted_at, pin: false
          filter :inserted_at, :date_range
        end
      end

  Filters are per resource. The generic index LiveView only renders `filters do`.
  Context functions receive the Phoenix scope as the first argument when
  `scope/1` is declared. See the [resources](resources.html) guide.
  """

  alias CorexAdmin.Resource.{Field, Filter, Section, Spec}

  @field_types ~w(id text textarea email password number boolean select date datetime url embeds_many)a
  @filter_types ~w(select multi_select date_range datetime_range number_range number boolean text presence tags id relative_date)a
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
    selectable: [type: :boolean, default: true],
    filters_open: [type: :boolean, default: false],
    default_filters: [type: :map, default: %{}],
    singular: [type: :string],
    live: [
      type: :keyword_list,
      keys: [
        index: [type: :atom],
        show: [type: :atom],
        form: [type: :atom]
      ],
      default: []
    ],
    history: [type: {:or, [:atom, nil]}, default: nil],
    history_opts: [type: :keyword_list, default: []],
    collection_actions: [type: {:or, [{:list, :atom}, nil]}],
    bulk_actions: [type: {:or, [{:list, :atom}, nil]}],
    record_actions: [type: {:or, [{:list, :atom}, nil]}]
  ]

  defmacro __using__(opts) do
    quote do
      Module.register_attribute(__MODULE__, :corex_admin_fields, accumulate: true)
      Module.register_attribute(__MODULE__, :corex_admin_filters, accumulate: true)
      Module.register_attribute(__MODULE__, :corex_admin_actions, accumulate: true)
      Module.register_attribute(__MODULE__, :corex_admin_collection_actions, accumulate: true)
      Module.register_attribute(__MODULE__, :corex_admin_bulk_actions, accumulate: true)
      Module.register_attribute(__MODULE__, :corex_admin_record_actions, accumulate: true)
      Module.register_attribute(__MODULE__, :corex_admin_form_sections, accumulate: true)
      Module.register_attribute(__MODULE__, :corex_admin_show_sections, accumulate: true)

      @corex_admin_scope nil
      @corex_admin_action_target nil
      @corex_admin_section_target nil
      @corex_admin_collection_defined false
      @corex_admin_bulk_defined false
      @corex_admin_record_defined false
      @corex_admin_resource_opts unquote(opts)

      import CorexAdmin.Resource,
        only: [
          scope: 1,
          actions: 1,
          fields: 1,
          filters: 1,
          form: 1,
          show: 1,
          section: 2,
          collection_actions: 1,
          bulk_actions: 1,
          record_actions: 1,
          action: 1,
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

  defmacro form(do: block) do
    quote do
      @corex_admin_section_target :form
      unquote(block)
      @corex_admin_section_target nil
    end
  end

  defmacro show(do: block) do
    quote do
      @corex_admin_section_target :show
      unquote(block)
      @corex_admin_section_target nil
    end
  end

  defmacro section(label, fields) when is_list(fields) do
    quote do
      CorexAdmin.Resource.__push_section__(__MODULE__, unquote(label), unquote(fields))
    end
  end

  defmacro collection_actions(do: block) do
    quote do
      @corex_admin_collection_defined true
      @corex_admin_action_target :collection
      unquote(block)
      @corex_admin_action_target nil
    end
  end

  defmacro bulk_actions(do: block) do
    quote do
      @corex_admin_bulk_defined true
      @corex_admin_action_target :bulk
      unquote(block)
      @corex_admin_action_target nil
    end
  end

  defmacro record_actions(do: block) do
    quote do
      @corex_admin_record_defined true
      @corex_admin_action_target :record
      unquote(block)
      @corex_admin_action_target nil
    end
  end

  defmacro action(mod) do
    quote do
      CorexAdmin.Resource.__push_ui_action__(__MODULE__, unquote(mod))
    end
  end

  @doc "Records a form/show section while compiling a resource module."
  def __push_section__(mod, label, fields) do
    section = {label, List.wrap(fields)}

    case Module.get_attribute(mod, :corex_admin_section_target) do
      :form -> Module.put_attribute(mod, :corex_admin_form_sections, section)
      :show -> Module.put_attribute(mod, :corex_admin_show_sections, section)
      _ -> raise ArgumentError, "section/2 must be inside form do or show do"
    end
  end

  @doc "Records a collection/bulk/record action module while compiling a resource."
  def __push_ui_action__(mod, action_mod) do
    case Module.get_attribute(mod, :corex_admin_action_target) do
      :collection ->
        Module.put_attribute(mod, :corex_admin_collection_actions, action_mod)

      :bulk ->
        Module.put_attribute(mod, :corex_admin_bulk_actions, action_mod)

      :record ->
        Module.put_attribute(mod, :corex_admin_record_actions, action_mod)

      _ ->
        raise ArgumentError,
              "action/1 must be inside collection_actions, bulk_actions, or record_actions"
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

  @doc "Records a field definition while compiling a resource module."
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

  @doc "Collects nested field definitions for an embeds_many block."
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

    ui_actions = %{
      collection_defined: Module.get_attribute(env.module, :corex_admin_collection_defined),
      bulk_defined: Module.get_attribute(env.module, :corex_admin_bulk_defined),
      record_defined: Module.get_attribute(env.module, :corex_admin_record_defined),
      collection:
        Module.get_attribute(env.module, :corex_admin_collection_actions)
        |> List.wrap()
        |> Enum.reverse(),
      bulk:
        Module.get_attribute(env.module, :corex_admin_bulk_actions)
        |> List.wrap()
        |> Enum.reverse(),
      record:
        Module.get_attribute(env.module, :corex_admin_record_actions)
        |> List.wrap()
        |> Enum.reverse()
    }

    form_sections =
      Module.get_attribute(env.module, :corex_admin_form_sections)
      |> List.wrap()
      |> Enum.reverse()

    show_sections =
      Module.get_attribute(env.module, :corex_admin_show_sections)
      |> List.wrap()
      |> Enum.reverse()

    title_def =
      unless Module.defines?(env.module, {:title, 1}, :def) do
        quote do
          def title(record) do
            CorexAdmin.Resource.default_title(__corex_admin_resource__(), record)
          end
        end
      end

    query_def =
      unless Module.defines?(env.module, {:query, 2}, :def) do
        quote do
          def query(scope, list_opts) do
            CorexAdmin.Context.list(__corex_admin_resource__(), scope, list_opts)
          end
        end
      end

    canned_def =
      unless Module.defines?(env.module, {:canned_filters, 0}, :def) do
        quote do
          def canned_filters, do: []
        end
      end

    quote do
      unquote(title_def)
      unquote(query_def)
      unquote(canned_def)

      def __corex_admin_resource__ do
        CorexAdmin.Resource.build_spec(
          __MODULE__,
          unquote(Macro.escape(opts)),
          unquote(Macro.escape(fields)),
          unquote(Macro.escape(filters)),
          unquote(Macro.escape(actions)),
          unquote(scope),
          %{
            ui_actions: unquote(Macro.escape(ui_actions)),
            form_sections: unquote(Macro.escape(form_sections)),
            show_sections: unquote(Macro.escape(show_sections))
          }
        )
      end
    end
  end

  @doc "Builds a resource spec from compiled field, filter, and action attributes."
  def build_spec(module, opts, fields, filters, actions, scope, extra \\ %{}) do
    extra =
      Map.merge(%{ui_actions: %{}, form_sections: [], show_sections: []}, extra)

    ui_actions = extra.ui_actions
    form_sections = extra.form_sections
    show_sections = extra.show_sections

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
    singular = opts[:singular] || schema_singular(schema)
    built_fields = Enum.map(fields, &build_field(schema, &1))

    spec = %Spec{
      module: module,
      context: opts[:context],
      schema: schema,
      slug: slug,
      group: opts[:group],
      label: label,
      singular: singular,
      scope: scope,
      primary_key: primary_key(schema),
      page_size: opts[:page_size],
      page_size_options: opts[:page_size_options],
      default_sort: opts[:default_sort],
      title_field: opts[:title_field],
      selectable: opts[:selectable],
      filters_open: opts[:filters_open],
      default_filters: %{},
      live: Map.new(opts[:live] || []),
      history: opts[:history],
      history_opts: opts[:history_opts] || [],
      actions: actions,
      collection_actions:
        ui_action_list(ui_actions, :collection, opts[:collection_actions], [
          CorexAdmin.Action.Export
        ]),
      bulk_actions:
        ui_action_list(ui_actions, :bulk, opts[:bulk_actions], [
          CorexAdmin.Action.BulkDelete,
          CorexAdmin.Action.Export
        ]),
      record_actions:
        ui_action_list(ui_actions, :record, opts[:record_actions], [CorexAdmin.Action.Delete]),
      fields: built_fields,
      filters: Enum.map(filters, &build_filter/1),
      form_sections: build_sections(form_sections, built_fields),
      show_sections: build_sections(show_sections, built_fields)
    }

    %{spec | default_filters: normalize_default_filters(opts[:default_filters], spec.filters)}
  end

  @doc "Default `title/1` from `title_field` or the primary key."
  def default_title(%Spec{title_field: field} = spec, record) when is_atom(field) do
    case Map.get(record, field) do
      value when value in [nil, ""] -> default_title_id(spec, record)
      value -> to_string(value)
    end
  end

  def default_title(%Spec{} = spec, record), do: default_title_id(spec, record)

  defp default_title_id(%Spec{primary_key: key}, record) do
    record |> Map.fetch!(key) |> to_string()
  end

  @doc "Allowed field type atoms for `field/3`."
  def field_types, do: @field_types

  @doc "Allowed filter type atoms for `filter/3`."
  def filter_types, do: @filter_types

  defp normalize_default_filters(map, filters) when is_map(map) do
    allowed = Map.new(filters, fn filter -> {filter.name, filter.field} end)

    Enum.reduce(map, %{}, fn {key, value}, acc ->
      name = default_filter_name(key, Map.keys(allowed))

      case name && Map.get(allowed, name) do
        nil -> acc
        field -> Map.put(acc, field, value)
      end
    end)
  end

  defp normalize_default_filters(_, _), do: %{}

  defp default_filter_name(key, _names) when is_atom(key), do: key

  defp default_filter_name(key, names) when is_binary(key) do
    Enum.find(names, &(Atom.to_string(&1) == key))
  end

  defp default_filter_name(_, _), do: nil

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

  defp build_field(schema, {name, type, opts}) do
    {mod, type_atom} = resolve_field_type(type)
    {children, opts} = Keyword.pop(opts, :fields, [])
    {embed_schema, opts} = Keyword.pop(opts, :schema)
    opts = NimbleOptions.validate!(opts, @field_schema)
    redact_fields = redact_fields(schema)
    embed_schema = embed_schema || embed_schema(schema, name)

    defaults = %{
      readable: default_readable(type_atom),
      writable: default_writable(name, type_atom),
      redact: type_atom == :password or name in redact_fields
    }

    readable = Keyword.get(opts, :readable, defaults.readable)
    redact = Keyword.get(opts, :redact, defaults.redact)

    %Field{
      name: name,
      type: type_atom,
      mod: mod,
      label: opts[:label] || Phoenix.Naming.humanize(Atom.to_string(name)),
      readable: readable,
      writable: Keyword.get(opts, :writable, defaults.writable),
      searchable: opts[:searchable],
      sortable: opts[:sortable],
      filterable: opts[:filterable],
      redact: redact,
      index: Keyword.get(opts, :index, default_index(type_atom, readable, redact)),
      show: Keyword.get(opts, :show, readable and not redact),
      options: opts[:options],
      schema: embed_schema,
      fields: Enum.map(List.wrap(children), &build_field(embed_schema || schema, &1))
    }
  end

  defp resolve_field_type(type) when type in @field_types do
    {Map.fetch!(CorexAdmin.Field.builtins(), type), type}
  end

  defp resolve_field_type(type) when is_atom(type) do
    {type, :custom}
  end

  defp resolve_field_type(type) do
    raise ArgumentError,
          "unknown field type #{inspect(type)}; expected one of #{inspect(@field_types)} or a field module"
  end

  defp schema_singular(schema) do
    schema
    |> Module.split()
    |> List.last()
    |> Phoenix.Naming.humanize()
  end

  defp ui_action_list(ui_actions, kind, opt_list, default) do
    defined_key =
      case kind do
        :collection -> :collection_defined
        :bulk -> :bulk_defined
        :record -> :record_defined
      end

    list_key = kind

    cond do
      ui_actions[defined_key] -> Enum.reject(List.wrap(ui_actions[list_key]), &is_nil/1)
      is_list(opt_list) -> opt_list
      true -> default
    end
  end

  defp build_sections([], _fields), do: []

  defp build_sections(sections, fields) do
    allowed = MapSet.new(Enum.map(fields, & &1.name))

    sections
    |> Enum.with_index()
    |> Enum.map(fn {{label, names}, index} ->
      kept = Enum.filter(names, &MapSet.member?(allowed, &1))

      %Section{
        name: Integer.to_string(index),
        label: label,
        fields: kept
      }
    end)
  end

  defp build_filter({name, type, opts}) when type in @filter_types do
    opts =
      Keyword.validate!(opts,
        label: nil,
        options: nil,
        field: nil,
        pin: true,
        min: nil,
        max: nil,
        operators: nil,
        default_operator: nil
      )

    field = opts[:field] || name

    %Filter{
      name: name,
      type: type,
      label: opts[:label] || Phoenix.Naming.humanize(Atom.to_string(name)),
      options: opts[:options],
      field: field,
      pin: opts[:pin] != false,
      min: opts[:min],
      max: opts[:max],
      operators: opts[:operators],
      default_operator: opts[:default_operator]
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
