defmodule E2eWeb.Demos.TreeViewDemo do
  use E2eWeb, :html

  # --------------------------------------------------------------------------
  # Shared tree data (runtime)
  # --------------------------------------------------------------------------

  @doc """
  Default repo tree used by anatomy and styling previews.
  """
  def anatomy_items do
    Corex.Tree.new([
      %{
        label: "lib",
        value: "lib",
        children: [
          %{label: "tree_view.ex", value: "lib-tree-view-ex"},
          %{label: "tree_view_demo.ex", value: "lib-tree-view-demo-ex"}
        ]
      },
      %{
        label: "test",
        value: "test",
        children: [
          %{label: "tree_view_test.exs", value: "test-tree-view-test-exs"}
        ]
      },
      %{
        label: "assets",
        value: "assets",
        children: [
          %{label: "tree-view.ts", value: "assets-tree-view-ts"}
        ]
      },
      %{label: "mix.exs", value: "mix-exs"}
    ])
  end

  @doc """
  Repo tree used by the API / Events / Animation previews. Uses `repo-*` ids so
  the code snippets referenced in buttons match the preview items.
  """
  def api_items do
    Corex.Tree.new([
      %{
        label: "corex",
        value: "repo-corex",
        children: [
          %{
            label: "lib",
            value: "repo-lib",
            children: [
              %{label: "tree_view.ex", value: "repo-lib-tree-view-ex"},
              %{label: "tree_view_demo.ex", value: "repo-lib-tree-view-demo-ex"}
            ]
          },
          %{label: "mix.exs", value: "repo-mix-exs"}
        ]
      }
    ])
  end

  @doc """
  Styling preview tree (uses `styling-*` ids so styling sections don't collide
  with the anatomy tree ids in the E2E DOM).
  """
  def styling_items do
    Corex.Tree.new([
      %{
        label: "lib",
        value: "styling-lib",
        children: [
          %{label: "tree_view.ex", value: "styling-lib-tree-view-ex"},
          %{label: "tree_view_demo.ex", value: "styling-lib-tree-view-demo-ex"}
        ]
      },
      %{
        label: "test",
        value: "styling-test",
        children: [
          %{label: "tree_view_test.exs", value: "styling-test-tree-view-test-exs"}
        ]
      },
      %{label: "mix.exs", value: "styling-mix-exs"}
    ])
  end

  defp styling_expanded, do: ["styling-lib", "styling-test"]
  defp styling_value, do: ["styling-lib-tree-view-ex"]

  # --------------------------------------------------------------------------
  # Shared items string (for rendered code panels). Mirrors the accordion
  # `code_items_basic()` pattern – concatenated into each code snippet below so
  # the displayed code is fully self-contained (no `E2e.TreeViewDemo.*` refs).
  # --------------------------------------------------------------------------

  defp code_anatomy_items do
    ~S"""
    Corex.Tree.new([
          %{label: "lib", value: "lib", children: [
            %{label: "tree_view.ex", value: "lib-tree-view-ex"},
            %{label: "tree_view_demo.ex", value: "lib-tree-view-demo-ex"}
          ]},
          %{label: "test", value: "test", children: [
            %{label: "tree_view_test.exs", value: "test-tree-view-test-exs"}
          ]},
          %{label: "assets", value: "assets", children: [
            %{label: "tree-view.ts", value: "assets-tree-view-ts"}
          ]},
          %{label: "mix.exs", value: "mix-exs"}
        ])
    """
    |> String.trim_trailing("\n")
  end

  defp code_api_items do
    ~S"""
    Corex.Tree.new([
          %{label: "corex", value: "repo-corex", children: [
            %{label: "lib", value: "repo-lib", children: [
              %{label: "tree_view.ex", value: "repo-lib-tree-view-ex"},
              %{label: "tree_view_demo.ex", value: "repo-lib-tree-view-demo-ex"}
            ]},
            %{label: "mix.exs", value: "repo-mix-exs"}
          ]}
        ])
    """
    |> String.trim_trailing("\n")
  end

  defp code_styling_items do
    ~S"""
    Corex.Tree.new([
          %{label: "lib", value: "lib", children: [
            %{label: "tree_view.ex", value: "lib-tree-view-ex"},
            %{label: "tree_view_demo.ex", value: "lib-tree-view-demo-ex"}
          ]},
          %{label: "test", value: "test", children: [
            %{label: "tree_view_test.exs", value: "test-tree-view-test-exs"}
          ]},
          %{label: "mix.exs", value: "mix-exs"}
        ])
    """
    |> String.trim_trailing("\n")
  end

  # --------------------------------------------------------------------------
  # Anatomy
  # --------------------------------------------------------------------------

  def anatomy_minimal_code do
    """
    <.tree_view
      id="tree-minimal"
      class="tree-view"
      expanded_value={["lib"]}
      value={["lib-tree-view-ex"]}
      items={#{code_anatomy_items()}}
    />
    """
  end

  def anatomy_minimal_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-minimal"
      class="tree-view"
      expanded_value={["lib"]}
      value={["lib-tree-view-ex"]}
      items={anatomy_items()}
    />
    """
  end

  def anatomy_with_indicator_code do
    """
    <.tree_view
      id="tree-with-indicator"
      class="tree-view"
      expanded_value={["lib"]}
      value={["lib-tree-view-ex"]}
      items={#{code_anatomy_items()}}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.tree_view>
    """
  end

  def anatomy_with_indicator_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-with-indicator"
      class="tree-view"
      expanded_value={["lib"]}
      value={["lib-tree-view-ex"]}
      items={anatomy_items()}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.tree_view>
    """
  end

  def anatomy_custom_slots_code do
    """
    <.tree_view
      id="tree-custom-slots"
      class="tree-view"
      expanded_value={["lib"]}
      value={["lib-tree-view-ex"]}
      items={#{code_anatomy_items()}}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      <:branch :let={branch}><.heroicon name="hero-folder" class="icon" />{branch.label}</:branch>
      <:item :let={item}><.heroicon name="hero-document" class="icon" />{item.label}</:item>
    </.tree_view>
    """
  end

  def anatomy_custom_slots_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-custom-slots"
      class="tree-view"
      expanded_value={["lib"]}
      value={["lib-tree-view-ex"]}
      items={anatomy_items()}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      <:branch :let={branch}><.heroicon name="hero-folder" class="icon" />{branch.label}</:branch>
      <:item :let={item}><.heroicon name="hero-document" class="icon" />{item.label}</:item>
    </.tree_view>
    """
  end

  def anatomy_compound_code do
    """
    <.tree_view
      :let={ctx}
      compound
      id="tree-compound"
      class="tree-view"
      expanded_value={["lib"]}
      value={["lib-tree-view-ex"]}
      items={#{code_anatomy_items()}}
    >
      <.tree_view_root ctx={ctx}>
        <:label>Corex</:label>
        <%= for item <- ctx.items do %>
          <%= if item.children && item.children != [] do %>
            <.tree_view_branch :let={branch} ctx={ctx} item={item}>
              <.tree_view_branch_trigger branch={branch}>
                {String.capitalize(item.label)}
                <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
              </.tree_view_branch_trigger>
              <.tree_view_branch_content branch={branch}>
                <%= for child <- item.children do %>
                  <.tree_view_item ctx={ctx} item={child} />
                <% end %>
              </.tree_view_branch_content>
            </.tree_view_branch>
          <% else %>
            <.tree_view_item ctx={ctx} item={item} />
          <% end %>
        <% end %>
      </.tree_view_root>
    </.tree_view>
    """
  end

  def anatomy_compound_example(assigns) do
    ~H"""
    <.tree_view
      :let={ctx}
      compound
      id="tree-compound"
      class="tree-view"
      expanded_value={["lib"]}
      value={["lib-tree-view-ex"]}
      items={anatomy_items()}
    >
      <.tree_view_root ctx={ctx}>
        <:label>Corex</:label>

        <%= for item <- ctx.items do %>
          <%= if item.children && item.children != [] do %>
            <.tree_view_branch :let={branch} ctx={ctx} item={item}>
              <.tree_view_branch_trigger branch={branch}>
                {String.capitalize(item.label)}
                <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
              </.tree_view_branch_trigger>

              <.tree_view_branch_content branch={branch}>
                <%= for child <- item.children do %>
                  <.tree_view_item ctx={ctx} item={child} />
                <% end %>
              </.tree_view_branch_content>
            </.tree_view_branch>
          <% else %>
            <.tree_view_item ctx={ctx} item={item} />
          <% end %>
        <% end %>
      </.tree_view_root>
    </.tree_view>
    """
  end

  # --------------------------------------------------------------------------
  # Styling
  # --------------------------------------------------------------------------

  def styling_color_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-styling-color-default"
      class="tree-view max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-color-accent"
      class="tree-view tree-view--accent max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-color-brand"
      class="tree-view tree-view--brand max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-color-info"
      class="tree-view tree-view--info max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-color-alert"
      class="tree-view tree-view--alert max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-color-success"
      class="tree-view tree-view--success max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_color_code do
    items = code_styling_items()

    """
    <.tree_view class="tree-view max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--accent max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--brand max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--info max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--alert max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--success max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-styling-size-sm"
      class="tree-view tree-view--sm max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-size-md"
      class="tree-view tree-view--md max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-size-lg"
      class="tree-view tree-view--lg max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-size-xl"
      class="tree-view tree-view--xl max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_size_code do
    items = code_styling_items()

    """
    <.tree_view class="tree-view tree-view--sm max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--md max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--lg max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--xl max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_text_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-styling-text-sm"
      class="tree-view tree-view--text-sm max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-text-md"
      class="tree-view tree-view--text-md max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-text-lg"
      class="tree-view tree-view--text-lg max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-text-xl"
      class="tree-view tree-view--text-xl max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-text-2xl"
      class="tree-view tree-view--text-2xl max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_text_code do
    items = code_styling_items()

    """
    <.tree_view class="tree-view tree-view--text-sm max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--text-md max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--text-lg max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--text-xl max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--text-2xl max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_radius_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-styling-radius-none"
      class="tree-view tree-view--rounded-none max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-sm"
      class="tree-view tree-view--rounded-sm max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-md"
      class="tree-view tree-view--rounded-md max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-lg"
      class="tree-view tree-view--rounded-lg max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-xl"
      class="tree-view tree-view--rounded-xl max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-full"
      class="tree-view tree-view--rounded-full max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_radius_code do
    items = code_styling_items()

    """
    <.tree_view class="tree-view tree-view--rounded-none max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--rounded-sm max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--rounded-md max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--rounded-lg max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--rounded-xl max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--rounded-full max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_max_width_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-styling-max-width-2xs"
      class="tree-view max-w-2xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-max-width-md"
      class="tree-view max-w-md"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-max-width-xl"
      class="tree-view max-w-xl"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-max-width-2xl"
      class="tree-view max-w-2xl"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_max_width_code do
    items = code_styling_items()

    """
    <.tree_view class="tree-view max-w-2xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view max-w-md" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view max-w-xl" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view max-w-2xl" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_mix_modifiers_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-styling-mix-brand"
      class="tree-view tree-view--brand tree-view--sm tree-view--rounded-md max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-mix-alert"
      class="tree-view tree-view--alert tree-view--lg tree-view--text-lg tree-view--rounded-full max-w-sm"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-mix-success"
      class="tree-view tree-view--success tree-view--xl tree-view--text-xl tree-view--rounded-lg max-w-md"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_mix_modifiers_code do
    items = code_styling_items()

    """
    <.tree_view class="tree-view tree-view--brand tree-view--sm tree-view--rounded-md max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--alert tree-view--lg tree-view--text-lg tree-view--rounded-full max-w-sm" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view tree-view--success tree-view--xl tree-view--text-xl tree-view--rounded-lg max-w-md" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  # --------------------------------------------------------------------------
  # API — Set Expanded
  # --------------------------------------------------------------------------

  def api_set_expanded_client_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={Corex.TreeView.set_expanded_value(@id, ["repo-lib"])}
        class="button button--sm"
      >
        Expand lib
      </.action>
      <.action phx-click={Corex.TreeView.set_expanded_value(@id, [])} class="button button--sm">
        Collapse all
      </.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={[]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_expanded_client_heex do
    """
    <.action phx-click={Corex.TreeView.set_expanded_value("tree-api-set-expanded-client", ["repo-lib"])}>Expand lib</.action>
    <.action phx-click={Corex.TreeView.set_expanded_value("tree-api-set-expanded-client", [])}>Collapse all</.action>
    <.tree_view id="tree-api-set-expanded-client" class="tree-view" expanded_value={[]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_expanded_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:tree-view:set-expanded-value",
            to: "##{@id}",
            detail: %{value: ["repo-lib"]},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Expand lib
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:tree-view:set-expanded-value",
            to: "##{@id}",
            detail: %{value: []},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Collapse all
      </.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={[]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_expanded_js_heex do
    """
    <.action phx-click={JS.dispatch("corex:tree-view:set-expanded-value", to: "#tree-api-set-expanded-js", detail: %{value: ["repo-lib"]}, bubbles: false)}>Expand lib</.action>
    <.action phx-click={JS.dispatch("corex:tree-view:set-expanded-value", to: "#tree-api-set-expanded-js", detail: %{value: []}, bubbles: false)}>Collapse all</.action>
    <.tree_view id="tree-api-set-expanded-js" class="tree-view" expanded_value={[]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_expanded_js_js do
    ~S"""
    const el = document.getElementById("tree-api-set-expanded-js");
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:set-expanded-value", {
        bubbles: false,
        detail: { value: ["repo-lib"] },
      })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:set-expanded-value", {
        bubbles: false,
        detail: { value: [] },
      })
    );
    """
  end

  def api_set_expanded_js_ts do
    ~S"""
    const el = document.getElementById("tree-api-set-expanded-js");
    const setExpanded = (value: string[]) =>
      el?.dispatchEvent(
        new CustomEvent("corex:tree-view:set-expanded-value", {
          bubbles: false,
          detail: { value },
        })
      );
    setExpanded(["repo-lib"]);
    setExpanded([]);
    """
  end

  def api_set_expanded_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event} value="repo-lib" class="button button--sm">Expand lib</.action>
      <.action phx-click={@event} value="" class="button button--sm">Collapse all</.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={[]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_expanded_server_heex do
    """
    <.action phx-click="tree_api_set_expanded" value="repo-lib">Expand lib</.action>
    <.action phx-click="tree_api_set_expanded" value="">Collapse all</.action>
    <.tree_view id="tree-api-set-expanded-server" class="tree-view" expanded_value={[]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_expanded_server_elixir do
    ~S"""
    def handle_event("tree_api_set_expanded", %{"value" => raw}, socket) do
      list = if raw == "", do: [], else: String.split(raw, ",", trim: true)
      {:noreply, Corex.TreeView.set_expanded_value(socket, "tree-api-set-expanded-server", list)}
    end
    """
  end

  # --------------------------------------------------------------------------
  # API — Set Selected
  # --------------------------------------------------------------------------

  def api_set_selected_client_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={Corex.TreeView.set_selected_value(@id, ["repo-lib-tree-view-ex"])}
        class="button button--sm"
      >
        Select tree_view.ex
      </.action>
      <.action phx-click={Corex.TreeView.set_selected_value(@id, [])} class="button button--sm">
        Clear
      </.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={["repo-lib"]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_selected_client_heex do
    """
    <.action phx-click={Corex.TreeView.set_selected_value("tree-api-set-selected-client", ["repo-lib-tree-view-ex"])}>Select tree_view.ex</.action>
    <.action phx-click={Corex.TreeView.set_selected_value("tree-api-set-selected-client", [])}>Clear</.action>
    <.tree_view id="tree-api-set-selected-client" class="tree-view" expanded_value={["repo-lib"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_selected_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:tree-view:set-selected-value",
            to: "##{@id}",
            detail: %{value: ["repo-lib-tree-view-ex"]},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Select tree_view.ex
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:tree-view:set-selected-value",
            to: "##{@id}",
            detail: %{value: []},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Clear
      </.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={["repo-lib"]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_selected_js_heex do
    """
    <.action phx-click={JS.dispatch("corex:tree-view:set-selected-value", to: "#tree-api-set-selected-js", detail: %{value: ["repo-lib-tree-view-ex"]}, bubbles: false)}>Select tree_view.ex</.action>
    <.action phx-click={JS.dispatch("corex:tree-view:set-selected-value", to: "#tree-api-set-selected-js", detail: %{value: []}, bubbles: false)}>Clear</.action>
    <.tree_view id="tree-api-set-selected-js" class="tree-view" expanded_value={["repo-lib"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_selected_js_js do
    ~S"""
    const el = document.getElementById("tree-api-set-selected-js");
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:set-selected-value", {
        bubbles: false,
        detail: { value: ["repo-lib-tree-view-ex"] },
      })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:set-selected-value", {
        bubbles: false,
        detail: { value: [] },
      })
    );
    """
  end

  def api_set_selected_js_ts do
    ~S"""
    const el = document.getElementById("tree-api-set-selected-js");
    const setSelected = (value: string[]) =>
      el?.dispatchEvent(
        new CustomEvent("corex:tree-view:set-selected-value", {
          bubbles: false,
          detail: { value },
        })
      );
    setSelected(["repo-lib-tree-view-ex"]);
    setSelected([]);
    """
  end

  def api_set_selected_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event} value="repo-lib-tree-view-ex" class="button button--sm">
        Select tree_view.ex
      </.action>
      <.action phx-click={@event} value="" class="button button--sm">Clear</.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={["repo-lib"]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_selected_server_heex do
    """
    <.action phx-click="tree_api_set_selected" value="repo-lib-tree-view-ex">Select tree_view.ex</.action>
    <.action phx-click="tree_api_set_selected" value="">Clear</.action>
    <.tree_view id="tree-api-set-selected-server" class="tree-view" expanded_value={["repo-lib"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_selected_server_elixir do
    ~S"""
    def handle_event("tree_api_set_selected", %{"value" => raw}, socket) do
      list = if raw == "", do: [], else: String.split(raw, ",", trim: true)
      {:noreply, Corex.TreeView.set_selected_value(socket, "tree-api-set-selected-server", list)}
    end
    """
  end

  # --------------------------------------------------------------------------
  # API — Get Expanded / Selected (server)
  # --------------------------------------------------------------------------

  def api_get_expanded_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event} class="button button--sm">Get expanded</.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={["repo-lib"]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_get_expanded_server_heex do
    """
    <.action phx-click="tree_api_get_expanded">Get expanded</.action>
    <.tree_view id="tree-api-get-expanded-server" class="tree-view" expanded_value={["repo-lib"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_get_expanded_server_elixir do
    ~S"""
    def handle_event("tree_api_get_expanded", _params, socket) do
      {:noreply, push_event(socket, "tree_view_expanded_value", %{})}
    end

    def handle_event("tree_view_expanded_value_response", %{"id" => id, "value" => value}, socket) do
      desc = "#{id}\n#{inspect(value)}"
      {:noreply, Corex.Toast.push_toast(socket, "layout-toast", "tree_expanded", desc, :info, 5000)}
    end
    """
  end

  def api_get_selected_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event} class="button button--sm">Get selected</.action>
    </div>
    <.tree_view
      id={@id}
      class="tree-view"
      expanded_value={["repo-lib"]}
      value={["repo-lib-tree-view-ex"]}
      items={@items}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_get_selected_server_heex do
    """
    <.action phx-click="tree_api_get_selected">Get selected</.action>
    <.tree_view id="tree-api-get-selected-server" class="tree-view" expanded_value={["repo-lib"]} value={["repo-lib-tree-view-ex"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_get_selected_server_elixir do
    ~S"""
    def handle_event("tree_api_get_selected", _params, socket) do
      {:noreply, push_event(socket, "tree_view_selected_value", %{})}
    end

    def handle_event("tree_view_selected_value_response", %{"id" => id, "value" => value}, socket) do
      desc = "#{id}\n#{inspect(value)}"
      {:noreply, Corex.Toast.push_toast(socket, "layout-toast", "tree_selected", desc, :info, 5000)}
    end
    """
  end

  def api_codes do
    %{
      set_expanded_client_heex: api_set_expanded_client_heex(),
      set_expanded_js_heex: api_set_expanded_js_heex(),
      set_expanded_js: api_set_expanded_js_js(),
      set_expanded_js_ts: api_set_expanded_js_ts(),
      set_expanded_server_heex: api_set_expanded_server_heex(),
      set_expanded_server_elixir: api_set_expanded_server_elixir(),
      set_selected_client_heex: api_set_selected_client_heex(),
      set_selected_js_heex: api_set_selected_js_heex(),
      set_selected_js: api_set_selected_js_js(),
      set_selected_js_ts: api_set_selected_js_ts(),
      set_selected_server_heex: api_set_selected_server_heex(),
      set_selected_server_elixir: api_set_selected_server_elixir(),
      get_expanded_heex: api_get_expanded_server_heex(),
      get_expanded_elixir: api_get_expanded_server_elixir(),
      get_selected_heex: api_get_selected_server_heex(),
      get_selected_elixir: api_get_selected_server_elixir()
    }
  end

  # --------------------------------------------------------------------------
  # Events
  # --------------------------------------------------------------------------

  def events_items, do: api_items()

  def events_server_heex do
    """
    <.tree_view
      id="tree-events-server"
      class="tree-view"
      items={#{code_api_items()}}
      on_expanded_change="tree_server_expanded"
      on_selection_change="tree_server_selection"
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def events_server_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, socket |> stream(:server_logs, [])}
    end

    def handle_event("tree_server_expanded", %{"id" => id, "expandedValue" => expanded}, socket) do
      log = new_log("server", id, "expanded", expanded)
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end

    def handle_event("tree_server_selection", %{"id" => id} = payload, socket) do
      log = new_log("server", id, "selection", Map.drop(payload, ["id"]))
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    """
    <.tree_view
      id="tree-events-client"
      class="tree-view"
      expanded_value={["repo-lib"]}
      items={#{code_api_items()}}
      on_expanded_change_client="tree-view-expanded-client"
      on_selection_change_client="tree-view-selection-client"
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("tree-events-client");
    el?.addEventListener("tree-view-expanded-client", (event) => {
      const d = event.detail;
      console.log("expanded", d.id, d.expandedValue, "added:", d.added, "removed:", d.removed);
    });
    el?.addEventListener("tree-view-selection-client", (event) => {
      const d = event.detail;
      console.log("selection", d.id, d.selectedValue, "isItem:", d.isItem);
    });
    """
  end

  def events_client_ts do
    ~S"""
    import type {
      TreeViewExpandedChangedDetail,
      TreeViewSelectionChangedDetail,
    } from "corex";

    const el = document.getElementById("tree-events-client");
    el?.addEventListener("tree-view-expanded-client", (event: Event) => {
      const d = (event as CustomEvent<TreeViewExpandedChangedDetail>).detail;
      console.log("expanded", d.id, d.expandedValue, "added:", d.added, "removed:", d.removed);
    });
    el?.addEventListener("tree-view-selection-client", (event: Event) => {
      const d = (event as CustomEvent<TreeViewSelectionChangedDetail>).detail;
      console.log("selection", d.id, d.selectedValue, "isItem:", d.isItem);
    });
    """
  end

  # --------------------------------------------------------------------------
  # Animation
  # --------------------------------------------------------------------------

  def animation_items, do: api_items()

  def animation_expanded_default, do: ["repo-corex", "repo-lib"]

  def animation_playground_heex do
    """
    <.tree_view
      id="tree-animation-playground"
      class="tree-view"
      animation="js"
      animation_options={
        %Corex.Animation.Height{
          duration: 0.3,
          easing: "ease",
          opacity_start: 0,
          opacity_end: 1
        }
      }
      expanded_value={["repo-corex", "repo-lib"]}
      items={#{code_api_items()}}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def animation_instant_heex do
    """
    <.tree_view
      class="tree-view"
      animation="instant"
      expanded_value={["repo-corex", "repo-lib"]}
      items={#{code_api_items()}}
    />
    """
  end

  def animation_custom_heex do
    """
    <.tree_view
      class="tree-view"
      animation="custom"
      expanded_value={["repo-corex", "repo-lib"]}
      on_expanded_change_client="my-tree-view-changed"
      items={#{code_api_items()}}
    />
    """
  end

  def animation_custom_js do
    ~S"""
    import { animate } from "motion"
    import {
      findTreeBranch,
      animateHeightOpen,
      animateHeightClose,
    } from "corex"

    const reducedMotion = () =>
      window.matchMedia("(prefers-reduced-motion: reduce)").matches

    document.addEventListener("my-tree-view-changed", (e) => {
      const root = document.getElementById(e.detail.id)
      if (!root) return
      e.detail.added.forEach((v) => {
        const el = findTreeBranch(root, v)
        if (!el) return
        animateHeightOpen(el, { animator: animate, duration: 0.5, easing: [0.16, 1, 0.3, 1] })
        if (!reducedMotion()) {
          animate(
            el,
            { filter: ["blur(8px)", "blur(0px)"], y: [-10, 0] },
            { duration: 0.55, easing: [0.16, 1, 0.3, 1] },
          )
        }
      })
      e.detail.removed.forEach((v) => {
        const el = findTreeBranch(root, v)
        if (!el) return
        animateHeightClose(el, { animator: animate, duration: 0.28, easing: "ease-in" })
        if (!reducedMotion()) {
          animate(
            el,
            { filter: ["blur(0px)", "blur(8px)"], y: [0, -8] },
            { duration: 0.26, easing: "ease-in" },
          )
        }
      })
    })
    """
  end

  # --------------------------------------------------------------------------
  # Patterns — Redirect (Navigate)
  # --------------------------------------------------------------------------

  @doc """
  Navigation tree used by the redirect pattern. Node values are built with
  verified routes (`~p"..."`) which automatically include the current locale
  prefix via `path_prefixes` on `Phoenix.VerifiedRoutes` (Gettext locale).
  """
  def patterns_redirect_items do
    Corex.Tree.new([
      %{
        label: "Accordion",
        value: ~p"/accordion/anatomy",
        children: [
          %{label: "Structure", value: ~p"/accordion/anatomy"},
          %{label: "Playground", value: ~p"/accordion/playground"}
        ]
      },
      %{
        label: "Tree view",
        value: ~p"/tree-view/anatomy",
        children: [
          %{label: "Structure", value: ~p"/tree-view/anatomy"},
          %{label: "Playground", value: ~p"/tree-view/playground"}
        ]
      }
    ])
  end

  def patterns_redirect_expanded, do: [~p"/accordion/anatomy"]
  def patterns_redirect_value, do: [~p"/tree-view/anatomy"]

  def patterns_redirect_heex do
    ~S"""
    <.tree_view
      id="patterns-tree-redirect"
      class="tree-view"
      redirect
      on_selection_change="patterns_tree_redirect_nav"
      expanded_value={[~p"/accordion/anatomy"]}
      value={[~p"/tree-view/anatomy"]}
      items={
        Corex.Tree.new([
          %{
            label: "Accordion",
            value: ~p"/accordion/anatomy",
            children: [
              %{label: "Structure", value: ~p"/accordion/anatomy"},
              %{label: "Playground", value: ~p"/accordion/playground"}
            ]
          },
          %{
            label: "Tree view",
            value: ~p"/tree-view/anatomy",
            children: [
              %{label: "Structure", value: ~p"/tree-view/anatomy"},
              %{label: "Playground", value: ~p"/tree-view/playground"}
            ]
          }
        ])
      }
    >
      <:label>Navigate</:label>
      <:branch_indicator :let={_row}>
        <.heroicon name="hero-chevron-right" />
      </:branch_indicator>
    </.tree_view>
    """
  end
end
