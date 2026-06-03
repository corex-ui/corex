defmodule Corex.Design.Accessibility.LevelTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Accessibility.Level

  test "normalize accepts atoms and strings" do
    assert Level.normalize(:aa) == :aa
    assert Level.normalize("aaa") == :aaa
  end

  test "non-text floor is 3:1 for all levels" do
    for level <- Level.levels() do
      assert Level.non_text_ratio(level) == 3.0
    end
  end

  test "text floors follow WCAG contrast levels" do
    assert Level.text_ratio(:a) == 3.0
    assert Level.text_ratio(:aa) == 4.5
    assert Level.text_ratio(:aaa) == 7.0
  end

  test "text_contrast_target caps at :a and floors at :aa and :aaa" do
    assert Level.text_contrast_target(:a, 8.5) == 3.05
    assert Level.text_contrast_target(:aa, 8.5) == 8.5
    assert Level.text_contrast_target(:aa, 4.0) == 4.55
    assert Level.text_contrast_target(:aaa, 6.0) == 7.05
  end
end
