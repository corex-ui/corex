defmodule CorexAdmin do
  @moduledoc """
  Context-first, deny-by-default LiveView admin for Phoenix+Ecto.

  Define an admin hub with `use CorexAdmin`, register resource modules, and mount
  routes with `CorexAdmin.Router.live_corex_admin/2`. Authentication is delegated
  to the host app via required `on_mount` hooks; this package owns authorization
  (`CorexAdmin.Policy`) and the resource/context contract.

  See the [installation](installation.html) and [security](security.html) guides.
  """

  @options_schema [
    otp_app: [
      type: :atom,
      required: true,
      doc: "Host OTP app (for config lookups)."
    ],
    actor_assign: [
      type: :atom,
      required: true,
      doc: "Socket assign holding the actor/scope (e.g. `:current_scope`)."
    ],
    on_mount: [
      type: {:list, {:or, [:atom, :mod_arg]}},
      required: true,
      doc: "Auth (and other) LiveView on_mount hooks. Must not be empty."
    ],
    policy: [
      type: :atom,
      required: true,
      doc: "Module implementing `CorexAdmin.Policy`."
    ],
    layout: [
      type: :mod_arg,
      required: true,
      doc: "LiveView layout `{Module, :function}`."
    ],
    resources: [
      type: {:list, :atom},
      required: true,
      doc: "Explicit list of resource modules. Never auto-detected."
    ],
    live_session: [
      type: :atom,
      default: :corex_admin,
      doc: "Name of the dedicated `live_session`."
    ]
  ]

  @doc "NimbleOptions schema for `use CorexAdmin`."
  def options_schema, do: @options_schema

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @corex_admin_opts CorexAdmin.__validate_opts__(__MODULE__, opts)

      def __corex_admin__, do: CorexAdmin.__expand_config__(__MODULE__, @corex_admin_opts)
    end
  end

  @doc "Validates hub options. Called from `use CorexAdmin`."
  def __validate_opts__(hub, opts) when is_list(opts) do
    opts = NimbleOptions.validate!(opts, @options_schema)

    if opts[:on_mount] == [] do
      raise ArgumentError,
            "#{inspect(hub)} :on_mount must list at least one auth hook; Corex Admin never ships an open admin"
    end

    opts
  end

  @doc "Expands hub options into a runtime config map. Called from `use CorexAdmin`."
  def __expand_config__(hub, opts) do
    resources = opts[:resources]

    slugs =
      Map.new(resources, fn resource ->
        spec = resource.__corex_admin_resource__()
        {spec.slug, resource}
      end)

    if map_size(slugs) != length(resources) do
      raise ArgumentError, "#{inspect(hub)} resource slugs must be unique"
    end

    %{
      hub: hub,
      otp_app: opts[:otp_app],
      actor_assign: opts[:actor_assign],
      on_mount: opts[:on_mount],
      policy: opts[:policy],
      layout: opts[:layout],
      resources: resources,
      slugs: slugs,
      live_session: opts[:live_session]
    }
  end

  @doc "Looks up a registered resource module by URL slug."
  @spec resource_for_slug(module(), String.t()) :: {:ok, module()} | :error
  def resource_for_slug(hub, slug) when is_binary(slug) do
    Map.fetch(hub.__corex_admin__().slugs, slug)
  end

  @doc "Default index page size (`config :corex_admin, :default_page_size`)."
  @spec default_page_size() :: pos_integer()
  def default_page_size do
    Application.get_env(:corex_admin, :default_page_size, 25)
  end

  @doc "Maximum page size (`config :corex_admin, :max_page_size`)."
  @spec max_page_size() :: pos_integer()
  def max_page_size do
    Application.get_env(:corex_admin, :max_page_size, 100)
  end

  @doc "Default per-page choices (`config :corex_admin, :page_size_options`)."
  @spec page_size_options() :: [pos_integer()]
  def page_size_options do
    Application.get_env(:corex_admin, :page_size_options, [10, 25, 50, 100])
  end

  @doc "Per-page choices for a resource, capped by `max_page_size/0`."
  @spec page_size_options(CorexAdmin.Resource.Spec.t()) :: [pos_integer()]
  def page_size_options(%CorexAdmin.Resource.Spec{} = spec) do
    max = max_page_size()

    options =
      (spec.page_size_options || page_size_options())
      |> Enum.filter(&(is_integer(&1) and &1 > 0 and &1 <= max))
      |> Enum.uniq()
      |> Enum.sort()

    if options == [], do: [min(default_page_size(), max)], else: options
  end

  @doc "Whether verbose authorize logging is enabled (`config :corex_admin, :debug`)."
  def debug? do
    Application.get_env(:corex_admin, :debug, false) == true
  end
end
