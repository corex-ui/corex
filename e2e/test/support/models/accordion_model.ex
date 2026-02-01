defmodule E2eWeb.AccordionModel do
  use E2eWeb.Model, component: "accordion"

  import Wallaby.Element

  def get_item(id) do
    css("[data-scope='accordion'][data-part='item'][data-value='#{id}']")
  end

  def get_trigger(id) do
    css(
      "[data-scope='accordion'][data-part='item'][data-value='#{id}'] [data-part='item-trigger']"
    )
  end

  def get_content_visible(id) do
    css(
      "[data-scope='accordion'][data-part='item'][data-value='#{id}'] [data-part='item-content']:not([hidden])"
    )
  end

  def click_trigger(session, id) do
    session
    |> find(get_trigger(id))
    |> click()

    session
  end

  def see_content(session, id) do
    assert_has(session, get_content_visible(id))
    session
  end

  def dont_see_content(session, id) do
    refute_has(session, get_content_visible(id))
    session
  end
end
