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
          label: "Users"

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
          field :inserted_at, :datetime
        end

        filters do
          filter :role, :select
        end
      end

  Context functions receive the Phoenix scope as the first argument when
  `scope/1` is declared. See the [resources](resources.html) guide.
  """

  alias CorexAdmin.Resource.{Field, Filter, Spec}

  @field_types ~w(id text textarea email password number boolean select date datetime url)a
  @required_actions ~w(list get create update delete change_create change_update)a

  @field_schema [
    readable: [type: :boolean],
    writable: [type: :boolean],
    searchable: [type: :boolean, default: false],
    sortable: [type: :boolean, default: false],
    filterable: [type: :boolean, default: false],
    redact: [type: :boolean],
    label: [type: :string],
    options: [type: {:list, :any}]
  ]

  @resource_schema [
    context: [type: :atom, required: true],
    schema: [type: :atom, required: true],
    slug: [type: :string],
    group: [type: :string],
    label: [type: :string],
    page_size: [type: :pos_integer]
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
    quote do
      @corex_admin_fields {unquote(name), unquote(type), unquote(opts)}
    end
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
      actions: actions,
      fields: Enum.map(fields, &build_field(schema, &1)),
      filters: Enum.map(filters, &build_filter/1)
    }
  end

  @doc "Allowed field type atoms for `field/3`."
  def field_types, do: @field_types

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
    opts = NimbleOptions.validate!(opts, @field_schema)
    redact_fields = redact_fields(schema)

    defaults = %{
      readable: default_readable(type),
      writable: default_writable(name, type),
      redact: type == :password or name in redact_fields
    }

    %Field{
      name: name,
      type: type,
      label: opts[:label] || Phoenix.Naming.humanize(Atom.to_string(name)),
      readable: Keyword.get(opts, :readable, defaults.readable),
      writable: Keyword.get(opts, :writable, defaults.writable),
      searchable: opts[:searchable],
      sortable: opts[:sortable],
      filterable: opts[:filterable],
      redact: Keyword.get(opts, :redact, defaults.redact),
      options: opts[:options]
    }
  end

  defp build_field(_schema, {_name, type, _opts}) do
    raise ArgumentError,
          "unknown field type #{inspect(type)}; expected one of #{inspect(@field_types)}"
  end

  defp build_filter({name, type, opts}) do
    opts = Keyword.validate!(opts, label: nil, options: nil)

    %Filter{
      name: name,
      type: type,
      label: opts[:label] || Phoenix.Naming.humanize(Atom.to_string(name)),
      options: opts[:options]
    }
  end

  defp default_readable(:password), do: false
  defp default_readable(_type), do: true

  defp default_writable(_name, :password), do: true
  defp default_writable(_name, :id), do: false
  defp default_writable(name, _type) when name in [:inserted_at, :updated_at, :id], do: false
  defp default_writable(_name, _type), do: true

  defp redact_fields(schema) do
    if function_exported?(schema, :__schema__, 1) do
      schema.__schema__(:redact_fields)
    else
      []
    end
  end
end
