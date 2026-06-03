defmodule E2eWeb.Demos.DocExamples do
  def code_content_items do
    ~S"""
    Corex.Content.new([
      %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])
    """
  end

  def code_content_items_with_values do
    ~S"""
    Corex.Content.new([
      %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])
    """
  end

  def code_content_items_with_values_long do
    ~S"""
    Corex.Content.new([
      %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin vel sapien at urna volutpat luctus. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur."},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus. Maecenas faucibus mollis interdum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh. Etiam porta sem malesuada magna mollis euismod. Praesent commodo cursus magna, vel scelerisque nisl consectetur et."},
      %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus. Vestibulum id ligula porta felis euismod semper. Curabitur blandit tempus porttitor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."}
    ])
    """
  end

  def code_tabs_items do
    ~S"""
    Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])
    """
  end

  def code_carousel_gallery_items do
    ~S"""
    [
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall"),
      Corex.Image.new("/images/sand.jpg", alt: "Sand"),
      Corex.Image.new("/images/star.jpg", alt: "Star"),
      Corex.Image.new("/images/winter.jpg", alt: "Winter")
    ]
    """
  end

  def code_list_items do
    ~S"""
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])
    """
  end

  def code_list_items_grouped do
    ~S"""
    Corex.List.new([
      %{label: "Apple", value: "apple", group: "Fruit"},
      %{label: "Banana", value: "banana", group: "Fruit"},
      %{label: "Carrot", value: "carrot", group: "Vegetable"}
    ])
    """
  end

  def code_radio_items do
    ~S"""
    [
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
    ]
    """
  end

  def code_tree_items do
    ~S"""
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
    """
  end

  def code_form_changeset_stub do
    ~S"""
    defmodule MyApp.Profile do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :accepted, :boolean, default: false
      end

      def changeset(profile, attrs) do
        profile
        |> cast(attrs, [:accepted])
        |> validate_required([:accepted])
      end
    end
    """
  end

  def code_carousel_posts do
    ~S"""
    [
      %{title: "Lorem ipsum dolor sit amet", description: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{title: "Duis dictum gravida odio ac pharetra?", description: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{title: "Donec condimentum ex mi", description: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ]
    """
  end

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

  def content_items_with_values_long do
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem ipsum dolor sit amet",
        content:
          "Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin vel sapien at urna volutpat luctus. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur."
      },
      %{
        value: "duis",
        label: "Duis dictum gravida odio ac pharetra?",
        content:
          "Nullam eget vestibulum ligula, at interdum tellus. Maecenas faucibus mollis interdum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh. Etiam porta sem malesuada magna mollis euismod. Praesent commodo cursus magna, vel scelerisque nisl consectetur et."
      },
      %{
        value: "donec",
        label: "Donec condimentum ex mi",
        content:
          "Congue molestie ipsum gravida a. Sed ac eros luctus. Vestibulum id ligula porta felis euismod semper. Curabitur blandit tempus porttitor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."
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

  def event_handler_snippet(event, param_clause \\ "params") do
    """
    def handle_event("#{event}", #{param_clause}, socket) do
      IO.inspect(params, label: "#{event}")
      {:noreply, socket}
    end
    """
    |> String.trim()
  end

  def event_handlers_snippet(handlers) when is_list(handlers) do
    Enum.map_join(handlers, "\n\n", fn {event, param_clause} ->
      event_handler_snippet(event, param_clause)
    end)
  end
end
