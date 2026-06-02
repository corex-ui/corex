defmodule Corex.Pagination.Utils do
  @moduledoc false

  @type page_entry :: %{type: :page, value: pos_integer()} | %{type: :ellipsis}

  @spec pages(pos_integer(), pos_integer(), pos_integer(), pos_integer()) :: [page_entry()]
  def pages(page, total_pages, sibling_count, boundary_count) do
    page
    |> get_range(total_pages, sibling_count, boundary_count)
    |> transform()
  end

  defp get_range(_page, total_pages, _sibling_count, _boundary_count) when total_pages <= 0,
    do: []

  defp get_range(_page, 1, _sibling_count, _boundary_count), do: [1]

  defp get_range(page, total_pages, sibling_count, boundary_count) do
    max_visible = sibling_count * 2 + 3 + boundary_count * 2

    if total_pages <= max_visible do
      range(1, total_pages)
    else
      page
      |> sparse_pages(total_pages, sibling_count, boundary_count, max_visible)
      |> collapse_adjacent_ellipsis(total_pages)
    end
  end

  defp sparse_pages(page, total_pages, sibling_count, boundary_count, max_visible) do
    first = 1
    last = total_pages
    left_sibling = max(page - sibling_count, first)
    right_sibling = min(page + sibling_count, last)
    item_count = max_visible - 1 - boundary_count

    show_left? = show_left_ellipsis?(left_sibling, first, boundary_count)
    show_right? = show_right_ellipsis?(right_sibling, last, boundary_count)

    build_sparse_pages(
      first,
      last,
      left_sibling,
      right_sibling,
      boundary_count,
      item_count,
      show_left?,
      show_right?
    )
  end

  defp show_left_ellipsis?(left_sibling, first, boundary_count) do
    left_sibling > first + boundary_count + 1 and
      abs(left_sibling - first) > boundary_count + 1
  end

  defp show_right_ellipsis?(right_sibling, last, boundary_count) do
    right_sibling < last - boundary_count - 1 and abs(last - right_sibling) > boundary_count + 1
  end

  defp build_sparse_pages(
         first,
         last,
         left_sibling,
         right_sibling,
         boundary_count,
         item_count,
         show_left?,
         show_right?
       ) do
    cond do
      not show_left? and show_right? ->
        range(1, item_count) ++ [:ellipsis] ++ range(last - boundary_count + 1, last)

      show_left? and not show_right? ->
        range(first, first + boundary_count - 1) ++
          [:ellipsis] ++ range(last - item_count + 1, last)

      show_left? and show_right? ->
        range(first, first + boundary_count - 1) ++
          [:ellipsis] ++
          range(left_sibling, right_sibling) ++
          [:ellipsis] ++ range(last - boundary_count + 1, last)

      true ->
        range(first, last)
    end
  end

  defp collapse_adjacent_ellipsis(pages, total_pages) do
    Enum.map(Enum.with_index(pages), fn
      {:ellipsis, index} -> collapse_ellipsis(pages, index, total_pages)
      {value, _index} -> value
    end)
  end

  defp collapse_ellipsis(pages, index, total_pages) do
    prev_page = pages |> Enum.at(index - 1) |> page_number(0)
    next_page = pages |> Enum.at(index + 1) |> page_number(total_pages + 1)

    if next_page - prev_page == 2, do: prev_page + 1, else: :ellipsis
  end

  defp page_number(page, _fallback) when is_integer(page), do: page
  defp page_number(_entry, fallback), do: fallback

  defp range(start, finish) when start <= finish, do: Enum.to_list(start..finish)
  defp range(_start, _finish), do: []

  defp transform(items) do
    Enum.map(items, fn
      value when is_integer(value) -> %{type: :page, value: value}
      :ellipsis -> %{type: :ellipsis}
    end)
  end

  @spec format_item_label(String.t() | nil, pos_integer(), pos_integer()) :: String.t() | nil
  def format_item_label(nil, _, _), do: nil

  def format_item_label(template, page, total_pages) when is_binary(template) do
    template
    |> String.replace("%{page}", to_string(page))
    |> String.replace("%{total_pages}", to_string(total_pages))
  end

  @spec page_href(String.t(), String.t(), String.t(), pos_integer(), pos_integer()) ::
          String.t() | nil
  def page_href(base, page_param, page_size_param, page, page_size) do
    if Corex.Url.allowed_href?(base) do
      sep = if String.contains?(base, "?"), do: "&", else: "?"
      encoded_page = URI.encode_www_form(page_param)
      encoded_size = URI.encode_www_form(page_size_param)
      "#{base}#{sep}#{encoded_page}=#{page}&#{encoded_size}=#{page_size}"
    end
  end
end
