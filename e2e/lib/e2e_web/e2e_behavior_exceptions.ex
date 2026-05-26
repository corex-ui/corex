defmodule E2eWeb.E2eBehaviorExceptions do
  @moduledoc false

  def wallaby_interaction_skip_slugs do
    ~W(
      action
      code
      navigate
      layout_heading
      data_list
      data_table
      heroicon
      hidden_input
      native_input
      file_upload_live
    )
  end
end
