defmodule E2eWeb.AccordionModel do
  use E2eWeb.Model, component: "accordion"

  def click_item(session, trigger_text) do
    # Click button by text - Wallaby will find it within the page
    click(session, button(trigger_text))
  end

  def see_content(session, content_text) do
    # Wait for accordion animation/transition to complete
    session = wait(session, 1000)

    # Check if content is visible using JavaScript to check computed styles
    # This works around CSS-based hiding that Wallaby might not detect
    content_visible =
      execute_script(session, """
        const contentElements = Array.from(document.querySelectorAll('[data-scope="accordion"][data-part="item-content"]'));
        return contentElements.some(el => {
          const text = el.textContent || '';
          const style = window.getComputedStyle(el);
          const ariaHidden = el.getAttribute('aria-hidden');
          return text.includes('#{content_text}') && 
                 style.display !== 'none' && 
                 style.visibility !== 'hidden' &&
                 (ariaHidden === null || ariaHidden === 'false');
        });
      """)

    if content_visible do
      session
    else
      # Fallback to Wallaby's text visibility check
      see(session, content_text)
    end
  end

  def dont_see_content(session, content_text) do
    dont_see(session, content_text)
  end

  def content_visible?(session, content_text) do
    session
    |> has?(Wallaby.Query.text(content_text))
  end
end
