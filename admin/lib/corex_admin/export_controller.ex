defmodule CorexAdmin.ExportController do
  @moduledoc false

  use Phoenix.Controller, formats: [:html, :json]

  alias CorexAdmin.Context
  alias CorexAdmin.Export
  alias CorexAdmin.ListOpts
  alias CorexAdmin.Live.Helpers
  alias CorexAdmin.Page
  alias CorexAdmin.Policy

  plug(:require_export_auth)

  def create(conn, params) do
    payload = conn.assigns.export_payload

    with {:ok, resource_mod} <- fetch_resource(payload.hub, payload.slug),
         spec <- Helpers.spec(resource_mod),
         :ok <-
           Policy.authorize(
             payload.hub.__corex_admin__().policy,
             payload.actor,
             :export,
             resource_mod,
             nil
           ) do
      format = Export.parse_format(params["format"])
      fields = export_fields(spec, payload, params)
      records = load_records(spec, payload)

      conn
      |> put_resp_content_type(Export.content_type(format))
      |> put_resp_header(
        "content-disposition",
        ~s(attachment; filename="#{Export.filename(spec, format)}")
      )
      |> send_chunked(200)
      |> stream_body(Export.encode(format, fields, records))
    else
      _ ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "export_denied"})
    end
  end

  defp require_export_auth(conn, _opts) do
    case verify_token(conn, conn.params["token"]) do
      {:ok, payload} ->
        assign(conn, :export_payload, payload)

      :error ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "export_denied"})
        |> halt()
    end
  end

  defp verify_token(conn, token) when is_binary(token) do
    case Phoenix.Token.verify(conn, Export.token_salt(), token, max_age: Export.token_max_age()) do
      {:ok, payload} when is_map(payload) -> {:ok, atomize_payload(payload)}
      _ -> :error
    end
  end

  defp verify_token(_, _), do: :error

  defp atomize_payload(payload) do
    %{
      hub: Map.fetch!(payload, :hub),
      slug: Map.fetch!(payload, :slug),
      actor: Map.get(payload, :actor),
      params: Map.get(payload, :params, %{}),
      ids: Map.get(payload, :ids, [])
    }
  end

  defp fetch_resource(hub, slug) when is_atom(hub) and is_binary(slug) do
    CorexAdmin.resource_for_slug(hub, slug)
  end

  defp fetch_resource(_, _), do: :error

  defp export_fields(spec, payload, params) do
    requested = List.wrap(params["fields"] || params["fields[]"])
    allowed = allowed_fields(spec, payload)

    if requested == [] do
      allowed
    else
      wanted = MapSet.new(Enum.map(requested, &to_string/1))
      Enum.filter(allowed, &(Atom.to_string(&1.name) in wanted))
    end
  end

  defp allowed_fields(spec, payload) do
    config = payload.hub.__corex_admin__()
    policy = config.policy
    actor = payload.actor
    resource_mod = spec.module

    Enum.filter(spec.fields, fn field ->
      field.readable and not field.redact and field.type != :password and
        Policy.authorize_field(policy, actor, :export, resource_mod, nil, field.name) == :ok
    end)
  end

  defp load_records(spec, payload) do
    scope = payload.actor
    ids = payload.ids |> List.wrap() |> Enum.map(&to_string/1) |> Enum.reject(&(&1 == ""))

    if ids != [] do
      Enum.flat_map(ids, fn id ->
        case Context.fetch(spec, scope, id) do
          {:ok, record} -> [record]
          _ -> []
        end
      end)
    else
      list_opts = ListOpts.from_params(spec, stringify_keys(payload.params))
      stream_pages(spec, scope, %{list_opts | page: 1}, [], 0)
    end
  end

  defp stream_pages(_spec, _scope, _opts, acc, count) when count >= 10_000, do: acc

  defp stream_pages(spec, scope, list_opts, acc, count) do
    case spec.module.query(scope, list_opts) do
      {:ok, %Page{entries: []} = _page} ->
        acc

      {:ok, %Page{} = page} ->
        remaining = Export.max_rows() - count
        taken = Enum.take(page.entries, remaining)
        acc = acc ++ taken
        last = Page.last_page(page)

        if list_opts.page >= last or length(taken) < remaining do
          acc
        else
          stream_pages(
            spec,
            scope,
            %{list_opts | page: list_opts.page + 1},
            acc,
            count + length(taken)
          )
        end

      _ ->
        acc
    end
  end

  defp stringify_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), stringify_keys(value)}
      {key, value} -> {key, stringify_keys(value)}
    end)
  end

  defp stringify_keys(list) when is_list(list), do: Enum.map(list, &stringify_keys/1)
  defp stringify_keys(other), do: other

  defp stream_body(conn, chunks) do
    Enum.reduce_while(chunks, conn, fn chunk, conn ->
      case chunk(conn, chunk) do
        {:ok, conn} -> {:cont, conn}
        {:error, :closed} -> {:halt, conn}
      end
    end)
  end
end
