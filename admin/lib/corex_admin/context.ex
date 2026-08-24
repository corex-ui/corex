defmodule CorexAdmin.Context do
  @moduledoc false

  require Logger

  alias CorexAdmin.ListOpts
  alias CorexAdmin.Page
  alias CorexAdmin.Resource.Spec
  alias CorexAdmin.Telemetry

  @spec list(Spec.t(), term(), ListOpts.t()) :: {:ok, Page.t()} | {:error, term()}
  def list(%Spec{} = spec, scope, %ListOpts{} = opts) do
    Telemetry.span(spec.slug, :list, fn ->
      case call(spec, :list, scope, [opts]) do
        {:ok, %Page{} = page} -> {:ok, page}
        {:error, _} = error -> error
        other -> {:error, {:invalid_list_result, other}}
      end
    end)
  end

  @spec get!(Spec.t(), term(), term()) :: term()
  def get!(%Spec{} = spec, scope, id) do
    Telemetry.span(spec.slug, :get, fn ->
      call(spec, :get, scope, [id])
    end)
  end

  @doc "Like `get!/3` but returns `{:error, :not_found}` instead of raising."
  @spec fetch(Spec.t(), term(), term()) :: {:ok, term()} | {:error, :not_found}
  def fetch(%Spec{} = spec, scope, id) do
    {:ok, get!(spec, scope, id)}
  rescue
    error in [Ecto.NoResultsError] ->
      Logger.debug(Exception.message(error))
      {:error, :not_found}
  end

  @spec create(Spec.t(), term(), map()) :: {:ok, term()} | {:error, term()}
  def create(%Spec{} = spec, scope, attrs) when is_map(attrs) do
    Telemetry.span(spec.slug, :create, fn ->
      call(spec, :create, scope, [attrs])
    end)
  end

  @spec update(Spec.t(), term(), term(), map()) :: {:ok, term()} | {:error, term()}
  def update(%Spec{} = spec, scope, record, attrs) when is_map(attrs) do
    Telemetry.span(spec.slug, :update, fn ->
      call(spec, :update, scope, [record, attrs])
    end)
  end

  @spec delete(Spec.t(), term(), term()) :: {:ok, term()} | {:error, term()}
  def delete(%Spec{} = spec, scope, record) do
    Telemetry.span(spec.slug, :delete, fn ->
      call(spec, :delete, scope, [record])
    end)
  end

  @spec change_create(Spec.t(), term(), map()) :: Ecto.Changeset.t()
  def change_create(%Spec{} = spec, scope, attrs) when is_map(attrs) do
    call(spec, :change_create, scope, [struct(spec.schema), attrs])
  end

  @spec change_update(Spec.t(), term(), term(), map()) :: Ecto.Changeset.t()
  def change_update(%Spec{} = spec, scope, record, attrs) when is_map(attrs) do
    call(spec, :change_update, scope, [record, attrs])
  end

  defp call(%Spec{} = spec, action, scope, args) do
    fun = Map.fetch!(spec.actions, action)
    args = if spec.scope, do: [scope | args], else: args
    apply(spec.context, fun, args)
  end
end
