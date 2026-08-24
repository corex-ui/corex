defmodule Mix.Tasks.Corex.Admin.Gen.Resource do
  @shortdoc "Generates a Corex Admin resource module from a context and schema"

  @moduledoc """
  Generates a resource module that points at an existing Phoenix context.

      $ mix corex.admin.gen.resource Accounts User

  The generator inspects the schema when it is compiled, maps field types, and
  wires context function names to `phx.gen.context` / `corex.gen.context`
  conventions (`list_users`, `get_user!`, `create_user`, ...).

  Add the module to your admin hub `resources:` list after generating.

  Pass `--no-scope` to skip the `scope :current_scope` declaration.
  """

  use Mix.Task

  import Mix.Phoenix, only: [otp_app: 0, base: 0, web_module: 1, web_path: 1]

  @impl Mix.Task
  def run(args) do
    {opts, argv, _} = OptionParser.parse(args, switches: [scope: :boolean])

    case argv do
      [context, schema] ->
        Mix.Task.run("compile")
        generate(context, schema, Keyword.get(opts, :scope, true))

      _ ->
        Mix.raise("expected mix corex.admin.gen.resource Context Schema")
    end
  end

  defp generate(context_name, schema_name, with_scope?) do
    app = otp_app()
    app_base = base()
    web = web_module(app_base)
    path = web_path(app)

    context_module = Module.concat([app_base, context_name])
    schema_module = Module.concat([context_module, schema_name])
    resource_module = Module.concat([web, "Admin", schema_name <> "Resource"])

    singular = Macro.underscore(schema_name)
    plural = singular <> "s"

    binding = [
      resource_module: resource_module,
      context_module: context_module,
      schema_module: schema_module,
      slug: schema_source(schema_module, plural),
      group: context_name,
      label: Phoenix.Naming.humanize(plural),
      with_scope?: with_scope?,
      singular: singular,
      plural: plural,
      fields: schema_fields(schema_module)
    ]

    target = Path.join([path, "admin", "#{singular}_resource.ex"])
    Mix.Generator.create_directory(Path.dirname(target))

    Mix.Generator.create_file(
      target,
      EEx.eval_file(template("resource.ex"), binding)
    )

    Mix.shell().info("""

    Add #{inspect(resource_module)} to the `resources:` list in #{inspect(web)}.Admin.
    Ensure #{inspect(context_module)} implements list/get/create/update/delete/change
    for #{singular} as declared in the generated resource.
    """)
  end

  defp schema_source(schema_module, fallback) do
    if function_exported?(schema_module, :__schema__, 1) do
      schema_module.__schema__(:source) |> to_string()
    else
      fallback
    end
  end

  defp schema_fields(schema_module) do
    if function_exported?(schema_module, :__schema__, 1) do
      redact = MapSet.new(schema_module.__schema__(:redact_fields) || [])

      Enum.map(schema_module.__schema__(:fields), fn name ->
        ecto_type = schema_module.__schema__(:type, name)
        type = map_type(name, ecto_type)
        {name, type, field_opts(name, type, MapSet.member?(redact, name))}
      end)
    else
      [{:id, :id, "writable: false"}]
    end
  end

  defp map_type(name, ecto_type) do
    cond do
      name == :id -> :id
      name in [:inserted_at, :updated_at] -> :datetime
      name == :email -> :email
      name in [:password, :password_hash, :hashed_password] -> :password
      name in [:url, :website] -> :url
      true -> ecto_to_admin(ecto_type)
    end
  end

  defp ecto_to_admin(:id), do: :id
  defp ecto_to_admin(:binary_id), do: :id
  defp ecto_to_admin(:string), do: :text
  defp ecto_to_admin(:integer), do: :number
  defp ecto_to_admin(:float), do: :number
  defp ecto_to_admin(:decimal), do: :number
  defp ecto_to_admin(:boolean), do: :boolean
  defp ecto_to_admin(:date), do: :date
  defp ecto_to_admin(:utc_datetime), do: :datetime
  defp ecto_to_admin(:utc_datetime_usec), do: :datetime
  defp ecto_to_admin(:naive_datetime), do: :datetime
  defp ecto_to_admin(:naive_datetime_usec), do: :datetime
  defp ecto_to_admin(_), do: :text

  defp field_opts(name, type, redact?) do
    []
    |> maybe_put(type == :id or name in [:inserted_at, :updated_at], "writable: false")
    |> maybe_put(
      type in [:email, :text] and name not in [:id],
      "searchable: true, sortable: true"
    )
    |> maybe_put(redact?, "redact: true")
    |> Enum.join(", ")
  end

  defp maybe_put(list, true, opt), do: list ++ [opt]
  defp maybe_put(list, false, _opt), do: list

  defp template(name) do
    Path.join([
      Application.app_dir(:corex_admin, "priv/templates/corex.admin.gen.resource"),
      name
    ])
  end
end
