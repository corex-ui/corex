defmodule Mix.Corex.Install.LayoutsBodyTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Layouts

  test "merge_body_typo_layout_class adds class on bare body" do
    html = "<html><head></head>\n<body>\n</body>\n</html>"
    assert Layouts.merge_body_typo_layout_class(html) =~ ~s(<body class="typo layout">)
  end

  test "merge_body_typo_layout_class merges into existing class attribute" do
    html = ~s(<body class="bg-white antialiased">)
    out = Layouts.merge_body_typo_layout_class(html)
    assert out =~ ~s(class="bg-white antialiased typo layout")
  end

  test "merge_body_typo_layout_class is idempotent when typo layout already present" do
    html = ~s(<body class="typo layout">)
    assert Layouts.merge_body_typo_layout_class(html) == html
  end

  test "merge_body_typo_layout_class leaves dynamic HEEx class alone" do
    html = ~s(<body class={@some}>content</body>)
    assert Layouts.merge_body_typo_layout_class(html) == html
  end
end
