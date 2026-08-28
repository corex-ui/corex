defmodule CorexAdmin.UI.Labels do
  @moduledoc """
  Human-readable labels for operators, rolling windows, and range bounds.

  Kept apart from the components so the vocabulary is translated in one place
  and can be reused by a host that renders its own filter chrome.
  """

  alias CorexAdmin.Gettext
  alias CorexAdmin.Resource.Filter

  @doc "Label for a comparison operator."
  @spec operator(atom()) :: String.t()
  def operator(:contains), do: Gettext.t("Contains")
  def operator(:equals), do: Gettext.t("Is")
  def operator(:starts_with), do: Gettext.t("Starts with")
  def operator(:ends_with), do: Gettext.t("Ends with")
  def operator(:not_contains), do: Gettext.t("Does not contain")
  def operator(:in), do: Gettext.t("Is")
  def operator(:not_in), do: Gettext.t("Is not")
  def operator(:eq), do: Gettext.t("Equals")
  def operator(:gte), do: Gettext.t("At least")
  def operator(:lte), do: Gettext.t("At most")
  def operator(op), do: Phoenix.Naming.humanize(to_string(op))

  @doc "`{label, value}` pairs for a list of operators."
  @spec operator_options([atom()]) :: [{String.t(), String.t()}]
  def operator_options(ops) do
    Enum.map(ops, fn op -> {operator(op), Atom.to_string(op)} end)
  end

  @doc "Label for a named rolling window."
  @spec window(atom() | String.t()) :: String.t()
  def window(name) when is_binary(name) do
    case Filter.parse_atom(name) do
      nil -> Phoenix.Naming.humanize(name)
      atom -> window(atom)
    end
  end

  def window(:today), do: Gettext.t("Today")
  def window(:yesterday), do: Gettext.t("Yesterday")
  def window(:last_7), do: Gettext.t("Last 7 days")
  def window(:last_30), do: Gettext.t("Last 30 days")
  def window(:last_90), do: Gettext.t("Last 90 days")
  def window(:this_week), do: Gettext.t("This week")
  def window(:this_month), do: Gettext.t("This month")
  def window(:this_quarter), do: Gettext.t("This quarter")
  def window(:ytd), do: Gettext.t("YTD")
  def window(other), do: Phoenix.Naming.humanize(to_string(other))

  @doc "Every named window as `{label, id}` pairs, for preset buttons."
  @spec window_options() :: [{String.t(), String.t()}]
  def window_options do
    Enum.map(Filter.relative_window_ids(), fn id -> {window(id), Atom.to_string(id)} end)
  end

  @doc """
  Short summary of a filter's current value, for a compact trigger.

  Returns `nil` when the filter is not active, so the caller can fall back to
  the filter's label.
  """
  @spec summary(Filter.t(), term()) :: String.t() | nil
  def summary(_filter, nil), do: nil
  def summary(_filter, %{relative: window}), do: window(window)

  def summary(_filter, %{from: from, to: to}), do: "#{short_date(from)} – #{short_date(to)}"
  def summary(_filter, %{from: from}), do: Gettext.t("From %{date}", date: short_date(from))
  def summary(_filter, %{to: to}), do: Gettext.t("Until %{date}", date: short_date(to))

  def summary(_filter, %{min: min, max: max}), do: "#{min} – #{max}"
  def summary(_filter, %{min: min}), do: "≥ #{min}"
  def summary(_filter, %{max: max}), do: "≤ #{max}"

  def summary(filter, %{op: op, value: value}) do
    case summary(filter, value) do
      nil -> nil
      text -> "#{operator(op)} #{text}"
    end
  end

  def summary(_filter, %{op: _}), do: nil
  def summary(filter, %{contains: value}), do: summary(filter, value)

  def summary(_filter, list) when is_list(list) do
    case Enum.reject(list, &(to_string(&1) == "")) do
      [] -> nil
      [one] -> to_string(one)
      many -> Gettext.t("%{count} selected", count: length(many))
    end
  end

  def summary(_filter, :empty), do: Gettext.t("Is empty")
  def summary(_filter, :set), do: Gettext.t("Has value")
  def summary(_filter, true), do: Gettext.t("Yes")
  def summary(_filter, false), do: Gettext.t("No")
  def summary(_filter, ""), do: nil
  def summary(_filter, value), do: to_string(value)

  defp short_date(%Date{} = date), do: Calendar.strftime(date, "%d %b %Y")
  defp short_date(%DateTime{} = dt), do: Calendar.strftime(dt, "%d %b %Y %H:%M")
  defp short_date(%NaiveDateTime{} = dt), do: Calendar.strftime(dt, "%d %b %Y %H:%M")
  defp short_date(other), do: to_string(other)
end
