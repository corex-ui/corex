defmodule E2eWeb.Demos.DocExamples do
  def content_items do
    Corex.Content.new([
      %{
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end

  def content_items_with_values do
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        value: "duis",
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        value: "donec",
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end

  def content_items_with_meta do
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
      },
      %{
        value: "duis",
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
      },
      %{
        value: "donec",
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
      }
    ])
  end

  def list_items do
    Corex.List.new([
      %{label: "Apple", value: "apple"},
      %{label: "Banana", value: "banana"},
      %{label: "Cherry", value: "cherry"}
    ])
  end

  def list_items_grouped do
    Corex.List.new([
      %{label: "Apple", value: "apple", group: "Fruit"},
      %{label: "Banana", value: "banana", group: "Fruit"},
      %{label: "Carrot", value: "carrot", group: "Vegetable"}
    ])
  end

  def pagination_defaults do
    %{count: 100, page_size: 10, page: 1}
  end

  def tree_items do
    Corex.Tree.new([
      %{
        label: "Components",
        value: "components",
        children: [
          %{label: "Accordion", value: "accordion"},
          %{label: "Checkbox", value: "checkbox"},
          %{label: "Tree view", value: "tree-view"}
        ]
      },
      %{label: "Form", value: "form"},
      %{label: "Tree", value: "tree", children: [%{label: "Tree.Item", value: "tree-item"}]}
    ])
  end

  def radio_items do
    [
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
    ]
  end
end
