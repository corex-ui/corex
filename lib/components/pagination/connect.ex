defmodule Corex.Pagination.Connect do
  @moduledoc false
  alias Corex.Pagination.Anatomy.{NextTrigger, PrevTrigger, Props, Root, SsrEllipsis, SsrPageItem}
  alias Corex.Pagination.Translation, as: PaginationTranslation
  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  import Corex.Helpers,
    only: [get_boolean: 1, maybe_put_data_dir_from: 2, maybe_put_dir_from: 2]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-count" => to_string(assigns.count),
      "data-page" => if(assigns.controlled, do: to_string(assigns.page), else: nil),
      "data-default-page" => if(assigns.controlled, do: nil, else: to_string(assigns.page)),
      "data-page-size" =>
        if(assigns.controlled_page_size, do: to_string(assigns.page_size), else: nil),
      "data-default-page-size" =>
        if(assigns.controlled_page_size, do: nil, else: to_string(assigns.page_size)),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-controlled-page-size" => get_boolean(assigns.controlled_page_size),
      "data-sibling-count" => to_string(assigns.sibling_count),
      "data-boundary-count" => to_string(assigns.boundary_count),
      "data-type" => assigns.type,
      "data-to" => assigns.to,
      "data-page-param" => assigns.page_param,
      "data-page-size-param" => assigns.page_size_param,
      "data-redirect" => assigns.redirect,
      "data-on-page-change" => assigns.on_page_change,
      "data-on-page-change-client" => assigns.on_page_change_client,
      "data-on-page-size-change" => assigns.on_page_size_change,
      "data-on-page-size-change-client" => assigns.on_page_size_change_client,
      "data-translation" => translation_json(assigns)
    }
    |> maybe_put_data_dir_from(assigns)
  end

  defp translation_json(assigns) do
    case Map.get(assigns, :translation) do
      %PaginationTranslation{} = t ->
        t
        |> PaginationTranslation.to_camel_map()
        |> Enum.reject(fn {_, v} -> v in [nil, ""] end)
        |> Map.new()
        |> then(fn
          m when map_size(m) == 0 -> nil
          m -> Corex.Dataset.encode_json(m)
        end)

      _ ->
        nil
    end
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "pagination",
      "data-part" => "root",
      "id" => "pagination:#{assigns.id}"
    }
    |> maybe_put_dir_from(assigns)
    |> maybe_put_aria_label(root_aria_label(assigns.id, assigns.aria_label))
  end

  def ignore_root(%Root{} = assigns) do
    JS.ignore_attributes(Root.ignored_attrs(), to: Selectors.css_id("pagination:#{assigns.id}"))
  end

  @spec prev_trigger(PrevTrigger.t()) :: map()
  def prev_trigger(assigns) do
    %{
      "data-scope" => "pagination",
      "data-part" => "prev-trigger",
      "data-pagination-part" => "prev",
      "type" => if(assigns.tag == "link", do: nil, else: "button"),
      "id" => "pagination:#{assigns.id}:prev"
    }
    |> maybe_put_dir_from(assigns)
    |> maybe_put_trigger_aria_label(assigns.aria_label, assigns.disabled, assigns.tag)
    |> maybe_put_data_disabled(assigns.disabled)
    |> maybe_put_disabled(assigns.disabled and assigns.tag == "button")
    |> maybe_put_href(assigns.href)
    |> maybe_put_phx_link(assigns.tag, assigns.redirect)
  end

  def ignore_prev_trigger(%PrevTrigger{} = assigns) do
    JS.ignore_attributes(PrevTrigger.ignored_attrs(),
      to: Selectors.css_id("pagination:#{assigns.id}:prev")
    )
  end

  @spec next_trigger(NextTrigger.t()) :: map()
  def next_trigger(assigns) do
    %{
      "data-scope" => "pagination",
      "data-part" => "next-trigger",
      "data-pagination-part" => "next",
      "type" => if(assigns.tag == "link", do: nil, else: "button"),
      "id" => "pagination:#{assigns.id}:next"
    }
    |> maybe_put_dir_from(assigns)
    |> maybe_put_trigger_aria_label(assigns.aria_label, assigns.disabled, assigns.tag)
    |> maybe_put_data_disabled(assigns.disabled)
    |> maybe_put_disabled(assigns.disabled and assigns.tag == "button")
    |> maybe_put_href(assigns.href)
    |> maybe_put_phx_link(assigns.tag, assigns.redirect)
  end

  def ignore_next_trigger(%NextTrigger{} = assigns) do
    JS.ignore_attributes(NextTrigger.ignored_attrs(),
      to: Selectors.css_id("pagination:#{assigns.id}:next")
    )
  end

  @spec ssr_page_item(SsrPageItem.t()) :: map()
  def ssr_page_item(%SsrPageItem{} = a) do
    %{
      "data-scope" => "pagination",
      "data-part" => "item",
      "data-pagination-part" => "page",
      "data-index" => to_string(a.page),
      "id" => "pagination:#{a.id}:item:#{a.page}",
      "type" => if(a.tag == "link", do: nil, else: "button")
    }
    |> maybe_put_dir_from(a)
    |> maybe_put_data_selected(a.selected)
    |> maybe_put_aria_current(a.selected)
    |> maybe_put_aria_label(a.aria_label)
    |> maybe_put_href(a.href)
    |> maybe_put_phx_link(a.tag, a.redirect)
  end

  def ignore_ssr_page_item(%SsrPageItem{} = a) do
    JS.ignore_attributes(SsrPageItem.ignored_attrs(),
      to: Selectors.css_id("pagination:#{a.id}:item:#{a.page}")
    )
  end

  @spec ssr_ellipsis(SsrEllipsis.t()) :: map()
  def ssr_ellipsis(%SsrEllipsis{} = a) do
    %{
      "data-scope" => "pagination",
      "data-part" => "ellipsis",
      "data-pagination-part" => "page",
      "id" => "pagination:#{a.id}:ellipsis:#{a.index}"
    }
    |> maybe_put_dir_from(a)
  end

  def ignore_ssr_ellipsis(%SsrEllipsis{} = a) do
    JS.ignore_attributes(SsrEllipsis.ignored_attrs(),
      to: Selectors.css_id("pagination:#{a.id}:ellipsis:#{a.index}")
    )
  end

  defp maybe_put_aria_label(attrs, nil), do: attrs
  defp maybe_put_aria_label(attrs, label), do: Map.put(attrs, "aria-label", label)

  defp maybe_put_trigger_aria_label(attrs, _label, true, "link"), do: attrs
  defp maybe_put_trigger_aria_label(attrs, label, _, _), do: maybe_put_aria_label(attrs, label)

  defp root_aria_label(id, label) when is_binary(label) and label != "", do: "#{label} (#{id})"
  defp root_aria_label(id, _), do: "Pagination (#{id})"

  defp maybe_put_data_disabled(attrs, true), do: Map.put(attrs, "data-disabled", "")
  defp maybe_put_data_disabled(attrs, false), do: attrs

  defp maybe_put_disabled(attrs, true), do: Map.put(attrs, "disabled", "")
  defp maybe_put_disabled(attrs, false), do: attrs

  defp maybe_put_href(attrs, nil), do: attrs
  defp maybe_put_href(attrs, href), do: Map.put(attrs, "href", href)

  defp maybe_put_data_selected(attrs, true), do: Map.put(attrs, "data-selected", "")
  defp maybe_put_data_selected(attrs, false), do: attrs

  defp maybe_put_aria_current(attrs, true), do: Map.put(attrs, "aria-current", "page")
  defp maybe_put_aria_current(attrs, false), do: attrs

  defp maybe_put_phx_link(attrs, "link", "patch") do
    attrs
    |> Map.put("data-phx-link", "patch")
    |> Map.put("data-phx-link-state", "push")
  end

  defp maybe_put_phx_link(attrs, "link", "navigate") do
    attrs
    |> Map.put("data-phx-link", "redirect")
    |> Map.put("data-phx-link-state", "push")
  end

  defp maybe_put_phx_link(attrs, _tag, _redirect), do: attrs
end
