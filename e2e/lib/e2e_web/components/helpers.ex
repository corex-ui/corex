defmodule E2eWeb.Helpers do
  @moduledoc false

  defdelegate flat_navigation_items(items), to: E2eWeb.DocsNav
  defdelegate ancestor_ids_for_path(items, full_path), to: E2eWeb.DocsNav
  defdelegate flat_navigation_list(), to: E2eWeb.DocsNav
  defdelegate prev_next_page(path, direction), to: E2eWeb.DocsNav
  defdelegate components_menu_items(), to: E2eWeb.DocsNav
  defdelegate form_menu_items(), to: E2eWeb.DocsNav
  defdelegate hexdocs_url(), to: E2eWeb.DocsNav
  defdelegate site_nav_menu_items(), to: E2eWeb.DocsNav
end
