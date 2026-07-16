defmodule E2eWeb.Demos.TreeViewDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

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
    ~S"""
    <.tree_view
      class="tree-view"
      items={
        Corex.Tree.new([
          %{label: "Components", value: "components", children: [
            %{label: "Accordion", value: "accordion"},
            %{label: "Checkbox", value: "checkbox"},
            %{label: "Tree view", value: "tree-view"}
          ]},
          %{label: "Form", value: "form"},
          %{label: "Tree", value: "tree", children: [%{label: "Tree.Item", value: "tree-item"}]}
        ])
      }
    />
    """
  end

  def anatomy_with_label_code do
    ~S"""
    <.tree_view
      class="tree-view"
      items={
        Corex.Tree.new([
          %{label: "Guides", value: "guides"},
          %{label: "Reference", value: "reference"}
        ])
      }
    >
      <:label>My Documents</:label>
    </.tree_view>
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
    ~S"""
    <.tree_view
      class="tree-view"
      items={
        Corex.Tree.new([
          %{label: "src", value: "src", children: [
            %{label: "components", value: "components"},
            %{label: "index.ts", value: "index.ts"}
          ]},
          %{label: "README.md", value: "readme"}
        ])
      }
    >
      <:branch_indicator :let={item}>
        <.heroicon :if={item.children && item.children != []} name="hero-chevron-right" />
      </:branch_indicator>
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
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
    ~S"""
    <.tree_view
      class="tree-view"
      items={
        Corex.Tree.new([
          %{label: "src", value: "src", children: [
            %{label: "components", value: "components", children: [%{label: "tree-view.tsx", value: "tree-view.tsx"}]},
            %{label: "main.ts", value: "main.ts"}
          ]},
          %{label: "README.md", value: "readme"}
        ])
      }
    >
      <:label>Project</:label>
      <:branch :let={item}>
        <.heroicon name="hero-folder" /> {item.label}
      </:branch>
      <:item :let={item}>
        <.heroicon name="hero-document" /> {item.label}
      </:item>
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
    ~S"""
    <.tree_view
      :let={ctx}
      compound
      class="tree-view"
      items={
        Corex.Tree.new([
          %{label: "Components", value: "components", children: [
            %{label: "Accordion", value: "accordion"},
            %{label: "Checkbox", value: "checkbox"}
          ]},
          %{label: "Form", value: "form"}
        ])
      }
    >
      <.tree_view_root ctx={ctx}>
        <:label>Project</:label>
        <.tree_view_branch :let={branch} :for={item <- ctx.items} ctx={ctx} item={item}>
          <.tree_view_branch_trigger branch={branch}>
            {item.label}
            <:indicator>
              <.heroicon name="hero-chevron-right" />
            </:indicator>
          </.tree_view_branch_trigger>
          <.tree_view_branch_content branch={branch}>
            <.tree_view_item :for={child <- item.children || []} ctx={ctx} item={child}>
              {child.label}
            </.tree_view_item>
          </.tree_view_branch_content>
        </.tree_view_branch>
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
      class="tree-view ui-accent max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-color-brand"
      class="tree-view ui-brand max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-color-info"
      class="tree-view ui-info max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-color-alert"
      class="tree-view ui-alert max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-color-success"
      class="tree-view ui-success max-w-xs"
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
    <.tree_view class="tree-view ui-accent max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-brand max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-info max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-alert max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-success max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-styling-size-sm"
      class="tree-view ui-size-sm max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-size-md"
      class="tree-view ui-size-md max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-size-lg"
      class="tree-view ui-size-lg max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-size-xl"
      class="tree-view ui-size-xl max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_variant_code do
    ~S"""
    <.tree_view class="tree-view max-w-xs" expanded_value={styling_expanded()} value={styling_value()} items={styling_items()}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-solid max-w-xs" expanded_value={styling_expanded()} value={styling_value()} items={styling_items()}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>

    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <.tree_view
      id="tree-style-variant-subtle"
      class="tree-view max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-style-variant-solid"
      class="tree-view ui-solid max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_variant_matrix_code do
    for {semantic, semantic_index} <- DemoScales.styling_semantic_axis_steps("tree-view") |> Enum.with_index(),
        {variant, variant_index} <- DemoScales.styling_variant_axis_steps("tree-view") |> Enum.with_index() do
      class = DemoScales.join_matrix_modifiers("tree-view", semantic.modifier, variant.modifier)

      """
      <.tree_view id="tree-matrix-#{semantic_index}-#{variant_index}" class="#{class} max-w-xs" expanded_value={[]} value={[]} items={
        Corex.Tree.new([
          %{label: "#{semantic.label}", value: "matrix-#{semantic_index}-#{variant_index}", children: [
            %{label: "Nested", value: "matrix-#{semantic_index}-#{variant_index}-nested"}
          ]}
        ])
      }>
        <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
      </.tree_view>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("tree-view"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("tree-view"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={{semantic, semantic_index} <- Enum.with_index(@matrix_semantics)} class="contents">
          <.tree_view
            :for={{variant, variant_index} <- Enum.with_index(@matrix_variants)}
            id={"tree-matrix-#{semantic_index}-#{variant_index}"}
            class={DemoScales.join_matrix_modifiers("tree-view", semantic.modifier, variant.modifier) <> " max-w-xs"}
            expanded_value={[]}
            value={[]}
            items={styling_matrix_items(semantic_index, variant_index, semantic.label)}
          >
            <:branch_indicator>
              <.heroicon name="hero-chevron-right" class="icon" />
            </:branch_indicator>
          </.tree_view>
        </div>
      </div>
    </div>
    """
  end

  defp styling_matrix_items(semantic_index, variant_index, label) do
    root = "matrix-#{semantic_index}-#{variant_index}"

    Corex.Tree.new([
      %{
        label: label,
        value: root,
        children: [
          %{label: "Nested", value: "#{root}-nested"}
        ]
      }
    ])
  end

  def styling_size_code do
    items = code_styling_items()

    """
    <.tree_view class="tree-view ui-size-sm max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-size-md max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-size-lg max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-size-xl max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_radius_example(assigns) do
    ~H"""
    <.tree_view
      id="tree-styling-radius-none"
      class="tree-view ui-rounded-none max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-sm"
      class="tree-view ui-rounded-sm max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-md"
      class="tree-view ui-rounded-md max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-lg"
      class="tree-view ui-rounded-lg max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-xl"
      class="tree-view ui-rounded-xl max-w-xs"
      expanded_value={styling_expanded()}
      value={styling_value()}
      items={styling_items()}
    >
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view
      id="tree-styling-radius-full"
      class="tree-view ui-rounded-full max-w-xs"
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
    <.tree_view class="tree-view ui-rounded-none max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-rounded-sm max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-rounded-md max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-rounded-lg max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-rounded-xl max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    <.tree_view class="tree-view ui-rounded-full max-w-xs" items={#{items}}>
      <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
    </.tree_view>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("tree-view"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.tree_view
          id={"tree-styling-max-width-#{variant.id}"}
          class={DemoScales.join_modifiers("tree-view", variant.modifier)}
          expanded_value={styling_expanded()}
          value={styling_value()}
          items={styling_items()}
        >
          <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
        </.tree_view>
      </div>
    </div>
    """
  end

  def styling_max_width_code do
    items = code_styling_items()

    DemoScales.max_width_variants("tree-view")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("tree-view", modifier)

      """
      <.tree_view class="#{class}" items={#{items}}>
        <:branch_indicator><.heroicon name="hero-chevron-right" class="icon" /></:branch_indicator>
      </.tree_view>
      """
    end)
    |> DemoScales.join_code()
  end

  # --------------------------------------------------------------------------
  # API  -  Set Expanded
  # --------------------------------------------------------------------------

  defp api_expanded_lib, do: ["repo-corex", "repo-lib"]

  def api_set_expanded_client_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={Corex.TreeView.set_expanded_value(@id, api_expanded_lib())}
        class="button ui-size-sm"
      >
        Expand lib
      </.action>
      <.action phx-click={Corex.TreeView.set_expanded_value(@id, [])} class="button ui-size-sm">
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
    <.action phx-click={Corex.TreeView.set_expanded_value("tree-api-set-expanded-client", ["repo-corex", "repo-lib"])}>Expand lib</.action>
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
            detail: %{value: ["repo-corex", "repo-lib"]},
            bubbles: false
          )
        }
        class="button ui-size-sm"
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
        class="button ui-size-sm"
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
    <.action phx-click={JS.dispatch("corex:tree-view:set-expanded-value", to: "#tree-api-set-expanded-js", detail: %{value: ["repo-corex", "repo-lib"]}, bubbles: false)}>Expand lib</.action>
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
        detail: { value: ["repo-corex", "repo-lib"] },
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
    const el: HTMLElement | null = document.getElementById("tree-api-set-expanded-js");
    const setExpanded = (value: string[]) =>
      el?.dispatchEvent(
        new CustomEvent("corex:tree-view:set-expanded-value", {
          bubbles: false,
          detail: { value },
        })
      );
    setExpanded(["repo-corex", "repo-lib"]);
    setExpanded([]);
    """
  end

  def api_set_expanded_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event} value="repo-corex,repo-lib" class="button ui-size-sm">
        Expand lib
      </.action>
      <.action phx-click={@event} value="" class="button ui-size-sm">Collapse all</.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={[]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_expanded_server_heex do
    """
    <.action phx-click="tree_api_set_expanded" value="repo-corex,repo-lib">Expand lib</.action>
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
  # API  -  Set Selected
  # --------------------------------------------------------------------------

  def api_set_selected_client_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={Corex.TreeView.set_selected_value(@id, ["repo-lib-tree-view-ex"])}
        class="button ui-size-sm"
      >
        Select tree_view.ex
      </.action>
      <.action phx-click={Corex.TreeView.set_selected_value(@id, [])} class="button ui-size-sm">
        Clear
      </.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={["repo-corex", "repo-lib"]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_selected_client_heex do
    """
    <.action phx-click={Corex.TreeView.set_selected_value("tree-api-set-selected-client", ["repo-lib-tree-view-ex"])}>Select tree_view.ex</.action>
    <.action phx-click={Corex.TreeView.set_selected_value("tree-api-set-selected-client", [])}>Clear</.action>
    <.tree_view id="tree-api-set-selected-client" class="tree-view" expanded_value={["repo-corex", "repo-lib"]} items={#{code_api_items()}}>
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
        class="button ui-size-sm"
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
        class="button ui-size-sm"
      >
        Clear
      </.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={["repo-corex", "repo-lib"]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_selected_js_heex do
    """
    <.action phx-click={JS.dispatch("corex:tree-view:set-selected-value", to: "#tree-api-set-selected-js", detail: %{value: ["repo-lib-tree-view-ex"]}, bubbles: false)}>Select tree_view.ex</.action>
    <.action phx-click={JS.dispatch("corex:tree-view:set-selected-value", to: "#tree-api-set-selected-js", detail: %{value: []}, bubbles: false)}>Clear</.action>
    <.tree_view id="tree-api-set-selected-js" class="tree-view" expanded_value={["repo-corex", "repo-lib"]} items={#{code_api_items()}}>
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
    const el: HTMLElement | null = document.getElementById("tree-api-set-selected-js");
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
      <.action phx-click={@event} value="repo-lib-tree-view-ex" class="button ui-size-sm">
        Select tree_view.ex
      </.action>
      <.action phx-click={@event} value="" class="button ui-size-sm">Clear</.action>
    </div>
    <.tree_view id={@id} class="tree-view" expanded_value={["repo-corex", "repo-lib"]} items={@items}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_set_selected_server_heex do
    """
    <.action phx-click="tree_api_set_selected" value="repo-lib-tree-view-ex">Select tree_view.ex</.action>
    <.action phx-click="tree_api_set_selected" value="">Clear</.action>
    <.tree_view id="tree-api-set-selected-server" class="tree-view" expanded_value={["repo-corex", "repo-lib"]} items={#{code_api_items()}}>
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
  # API  -  Read Expanded / Selected
  # --------------------------------------------------------------------------

  defp api_read_expanded_value, do: ["repo-corex", "repo-lib"]
  defp api_read_selected_value, do: ["repo-lib-tree-view-ex"]

  def api_client_read_listener(assigns) do
    ~H"""
    <div
      id={"tree-view-api-read-listener-#{@id}"}
      phx-hook=".TreeViewApiClientReadListener"
      phx-update="ignore"
      data-tree-view-id={@id}
      hidden
    >
      <script :type={Phoenix.LiveView.ColocatedHook} name=".TreeViewApiClientReadListener">
        export default {
          mounted() {
            const treeViewId = this.el.dataset.treeViewId;
            const el = document.getElementById(treeViewId);
            if (!el) return;
            const layoutToast = (title, description) => {
              document.querySelector("#layout-toast")?.dispatchEvent(
                new CustomEvent("corex:toast:create", {
                  bubbles: true,
                  detail: { title, description, type: "info", duration: 5000 },
                })
              );
            };
            el.addEventListener("tree-view-expanded-value", (e) => {
              layoutToast(
                "tree-view-expanded-value",
                `${e.detail.id}\n${JSON.stringify(e.detail.value)}`
              );
            });
            el.addEventListener("tree-view-value", (e) => {
              layoutToast(
                "tree-view-value",
                `${e.detail.id}\n${JSON.stringify(e.detail.value)}`
              );
            });
          },
        };
      </script>
    </div>
    """
  end

  def api_expanded_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.TreeView.expanded_value(@id)} class="button ui-size-sm">
        Expanded
      </.action>
      <.action
        phx-click={Corex.TreeView.expanded_value(@id, respond_to: :client)}
        class="button ui-size-sm"
      >
        Expanded (client only)
      </.action>
    </div>
    <.tree_view
      id={@id}
      class="tree-view"
      expanded_value={api_read_expanded_value()}
      items={@items}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    <.api_client_read_listener id={@id} />
    """
  end

  def api_expanded_client_binding_heex do
    """
    <.action phx-click={Corex.TreeView.expanded_value("tree-api-expanded-client")}>Expanded</.action>
    <.action phx-click={Corex.TreeView.expanded_value("tree-api-expanded-client", respond_to: :client)}>Expanded (client only)</.action>
    <.tree_view id="tree-api-expanded-client" class="tree-view" expanded_value={["repo-corex", "repo-lib"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_expanded_client_binding_js do
    ~S"""
    const layoutToast = (title, description) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el = document.getElementById("tree-api-expanded-client");
    el?.addEventListener("tree-view-expanded-value", (e) => {
      layoutToast(
        "tree-view-expanded-value",
        `${e.detail.id}\n${JSON.stringify(e.detail.value)}`
      );
    });
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:expanded-value", { bubbles: false, detail: {} })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:expanded-value", {
        bubbles: false,
        detail: { respond_to: "client" },
      })
    );
    """
  end

  def api_expanded_client_binding_ts do
    ~S"""
    const layoutToast = (title: string, description: string) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el: HTMLElement | null = document.getElementById("tree-api-expanded-client");
    el?.addEventListener("tree-view-expanded-value", (e: Event) => {
      const d = (e as CustomEvent<{ id: string; value: string[] | null }>).detail;
      layoutToast("tree-view-expanded-value", `${d.id}\n${JSON.stringify(d.value)}`);
    });
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:expanded-value", { bubbles: false, detail: {} })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:expanded-value", {
        bubbles: false,
        detail: { respond_to: "client" },
      })
    );
    """
  end

  def api_expanded_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:tree-view:expanded-value",
            to: "##{@id}",
            detail: %{},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Expanded
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:tree-view:expanded-value",
            to: "##{@id}",
            detail: %{respond_to: "client"},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Expanded (client only)
      </.action>
    </div>
    <.tree_view
      id={@id}
      class="tree-view"
      expanded_value={api_read_expanded_value()}
      items={@items}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    <.api_client_read_listener id={@id} />
    """
  end

  def api_expanded_client_js_heex do
    """
    <.action phx-click={JS.dispatch("corex:tree-view:expanded-value", to: "#tree-api-expanded-js", detail: %{}, bubbles: false)}>Expanded</.action>
    <.action phx-click={JS.dispatch("corex:tree-view:expanded-value", to: "#tree-api-expanded-js", detail: %{respond_to: "client"}, bubbles: false)}>Expanded (client only)</.action>
    <.tree_view id="tree-api-expanded-js" class="tree-view" expanded_value={["repo-corex", "repo-lib"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_expanded_client_js_js do
    ~S"""
    const layoutToast = (title, description) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el = document.getElementById("tree-api-expanded-js");
    el?.addEventListener("tree-view-expanded-value", (e) => {
      layoutToast(
        "tree-view-expanded-value",
        `${e.detail.id}\n${JSON.stringify(e.detail.value)}`
      );
    });
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:expanded-value", { bubbles: false, detail: {} })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:expanded-value", {
        bubbles: false,
        detail: { respond_to: "client" },
      })
    );
    """
  end

  def api_expanded_client_js_ts do
    ~S"""
    const layoutToast = (title: string, description: string) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el: HTMLElement | null = document.getElementById("tree-api-expanded-js");
    el?.addEventListener("tree-view-expanded-value", (e: Event) => {
      const d = (e as CustomEvent<{ id: string; value: string[] | null }>).detail;
      layoutToast("tree-view-expanded-value", `${d.id}\n${JSON.stringify(d.value)}`);
    });
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:expanded-value", { bubbles: false, detail: {} })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:expanded-value", {
        bubbles: false,
        detail: { respond_to: "client" },
      })
    );
    """
  end

  def api_expanded_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_expanded} class="button ui-size-sm">Expanded</.action>
      <.action phx-click={@event_expanded_client_only} class="button ui-size-sm">
        Expanded (client only)
      </.action>
    </div>
    <.tree_view
      id={@id}
      class="tree-view"
      expanded_value={api_read_expanded_value()}
      items={@items}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    <.api_client_read_listener id={@id} />
    """
  end

  def api_expanded_server_heex do
    """
    <.action phx-click="tree_api_get_expanded">Expanded</.action>
    <.action phx-click="tree_api_get_expanded_client_only">Expanded (client only)</.action>
    <.tree_view id="tree-api-get-expanded-server" class="tree-view" expanded_value={["repo-corex", "repo-lib"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_expanded_server_elixir do
    ~S"""
    def handle_event("tree_api_get_expanded", _params, socket) do
      {:noreply, Corex.TreeView.expanded_value(socket, "tree-api-get-expanded-server")}
    end

    def handle_event("tree_api_get_expanded_client_only", _params, socket) do
      {:noreply, Corex.TreeView.expanded_value(socket, "tree-api-get-expanded-server", respond_to: :client)}
    end

    def handle_event("tree_view_expanded_value_response", %{"id" => id, "value" => value}, socket) do
      desc = "#{id}\n#{inspect(value)}"

      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "tree_view_expanded_value_response", desc, :info,
         duration: 5000
       )}
    end
    """
  end

  def api_expanded_server_js do
    ~S"""
    const layoutToast = (title, description) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el = document.getElementById("tree-api-get-expanded-server");
    el?.addEventListener("tree-view-expanded-value", (e) => {
      layoutToast(
        "tree-view-expanded-value",
        `${e.detail.id}\n${JSON.stringify(e.detail.value)}`
      );
    });
    """
  end

  def api_expanded_server_ts do
    ~S"""
    const layoutToast = (title: string, description: string) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el: HTMLElement | null = document.getElementById("tree-api-get-expanded-server");
    el?.addEventListener("tree-view-expanded-value", (e: Event) => {
      const d = (e as CustomEvent<{ id: string; value: string[] | null }>).detail;
      layoutToast("tree-view-expanded-value", `${d.id}\n${JSON.stringify(d.value)}`);
    });
    """
  end

  def api_selected_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.TreeView.value(@id)} class="button ui-size-sm">Selected</.action>
      <.action phx-click={Corex.TreeView.value(@id, respond_to: :client)} class="button ui-size-sm">
        Selected (client only)
      </.action>
    </div>
    <.tree_view
      id={@id}
      class="tree-view"
      expanded_value={api_read_expanded_value()}
      value={api_read_selected_value()}
      items={@items}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    <.api_client_read_listener id={@id} />
    """
  end

  def api_selected_client_binding_heex do
    """
    <.action phx-click={Corex.TreeView.value("tree-api-selected-client")}>Selected</.action>
    <.action phx-click={Corex.TreeView.value("tree-api-selected-client", respond_to: :client)}>Selected (client only)</.action>
    <.tree_view id="tree-api-selected-client" class="tree-view" expanded_value={["repo-corex", "repo-lib"]} value={["repo-lib-tree-view-ex"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_selected_client_binding_js do
    ~S"""
    const layoutToast = (title, description) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el = document.getElementById("tree-api-selected-client");
    el?.addEventListener("tree-view-value", (e) => {
      layoutToast(
        "tree-view-value",
        `${e.detail.id}\n${JSON.stringify(e.detail.value)}`
      );
    });
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:value", { bubbles: false, detail: {} })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:value", {
        bubbles: false,
        detail: { respond_to: "client" },
      })
    );
    """
  end

  def api_selected_client_binding_ts do
    ~S"""
    const layoutToast = (title: string, description: string) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el: HTMLElement | null = document.getElementById("tree-api-selected-client");
    el?.addEventListener("tree-view-value", (e: Event) => {
      const d = (e as CustomEvent<{ id: string; value: string[] | null }>).detail;
      layoutToast("tree-view-value", `${d.id}\n${JSON.stringify(d.value)}`);
    });
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:value", { bubbles: false, detail: {} })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:value", {
        bubbles: false,
        detail: { respond_to: "client" },
      })
    );
    """
  end

  def api_selected_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={JS.dispatch("corex:tree-view:value", to: "##{@id}", detail: %{}, bubbles: false)}
        class="button ui-size-sm"
      >
        Selected
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:tree-view:value",
            to: "##{@id}",
            detail: %{respond_to: "client"},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Selected (client only)
      </.action>
    </div>
    <.tree_view
      id={@id}
      class="tree-view"
      expanded_value={api_read_expanded_value()}
      value={api_read_selected_value()}
      items={@items}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    <.api_client_read_listener id={@id} />
    """
  end

  def api_selected_client_js_heex do
    """
    <.action phx-click={JS.dispatch("corex:tree-view:value", to: "#tree-api-selected-js", detail: %{}, bubbles: false)}>Selected</.action>
    <.action phx-click={JS.dispatch("corex:tree-view:value", to: "#tree-api-selected-js", detail: %{respond_to: "client"}, bubbles: false)}>Selected (client only)</.action>
    <.tree_view id="tree-api-selected-js" class="tree-view" expanded_value={["repo-corex", "repo-lib"]} value={["repo-lib-tree-view-ex"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_selected_client_js_js do
    ~S"""
    const layoutToast = (title, description) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el = document.getElementById("tree-api-selected-js");
    el?.addEventListener("tree-view-value", (e) => {
      layoutToast(
        "tree-view-value",
        `${e.detail.id}\n${JSON.stringify(e.detail.value)}`
      );
    });
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:value", { bubbles: false, detail: {} })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:value", {
        bubbles: false,
        detail: { respond_to: "client" },
      })
    );
    """
  end

  def api_selected_client_js_ts do
    ~S"""
    const layoutToast = (title: string, description: string) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el: HTMLElement | null = document.getElementById("tree-api-selected-js");
    el?.addEventListener("tree-view-value", (e: Event) => {
      const d = (e as CustomEvent<{ id: string; value: string[] | null }>).detail;
      layoutToast("tree-view-value", `${d.id}\n${JSON.stringify(d.value)}`);
    });
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:value", { bubbles: false, detail: {} })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:tree-view:value", {
        bubbles: false,
        detail: { respond_to: "client" },
      })
    );
    """
  end

  def api_selected_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_selected} class="button ui-size-sm">Selected</.action>
      <.action phx-click={@event_selected_client_only} class="button ui-size-sm">
        Selected (client only)
      </.action>
    </div>
    <.tree_view
      id={@id}
      class="tree-view"
      expanded_value={api_read_expanded_value()}
      value={api_read_selected_value()}
      items={@items}
    >
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    <.api_client_read_listener id={@id} />
    """
  end

  def api_selected_server_heex do
    """
    <.action phx-click="tree_api_get_selected">Selected</.action>
    <.action phx-click="tree_api_get_selected_client_only">Selected (client only)</.action>
    <.tree_view id="tree-api-get-selected-server" class="tree-view" expanded_value={["repo-corex", "repo-lib"]} value={["repo-lib-tree-view-ex"]} items={#{code_api_items()}}>
      <:label>Corex</:label>
      <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
    </.tree_view>
    """
  end

  def api_selected_server_elixir do
    ~S"""
    def handle_event("tree_api_get_selected", _params, socket) do
      {:noreply, Corex.TreeView.value(socket, "tree-api-get-selected-server")}
    end

    def handle_event("tree_api_get_selected_client_only", _params, socket) do
      {:noreply, Corex.TreeView.value(socket, "tree-api-get-selected-server", respond_to: :client)}
    end

    def handle_event("tree_view_value_response", %{"id" => id, "value" => value}, socket) do
      desc = "#{id}\n#{inspect(value)}"

      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "tree_view_value_response", desc, :info,
         duration: 5000
       )}
    end
    """
  end

  def api_selected_server_js do
    ~S"""
    const layoutToast = (title, description) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el = document.getElementById("tree-api-get-selected-server");
    el?.addEventListener("tree-view-value", (e) => {
      layoutToast(
        "tree-view-value",
        `${e.detail.id}\n${JSON.stringify(e.detail.value)}`
      );
    });
    """
  end

  def api_selected_server_ts do
    ~S"""
    const layoutToast = (title: string, description: string) => {
      document.querySelector("#layout-toast")?.dispatchEvent(
        new CustomEvent("corex:toast:create", {
          bubbles: true,
          detail: { title, description, type: "info", duration: 5000 },
        })
      );
    };
    const el: HTMLElement | null = document.getElementById("tree-api-get-selected-server");
    el?.addEventListener("tree-view-value", (e: Event) => {
      const d = (e as CustomEvent<{ id: string; value: string[] | null }>).detail;
      layoutToast("tree-view-value", `${d.id}\n${JSON.stringify(d.value)}`);
    });
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
      expanded_client_heex: api_expanded_client_binding_heex(),
      expanded_client_js: api_expanded_client_binding_js(),
      expanded_client_ts: api_expanded_client_binding_ts(),
      expanded_js_heex: api_expanded_client_js_heex(),
      expanded_js: api_expanded_client_js_js(),
      expanded_js_ts: api_expanded_client_js_ts(),
      expanded_server_heex: api_expanded_server_heex(),
      expanded_server_elixir: api_expanded_server_elixir(),
      expanded_server_js: api_expanded_server_js(),
      expanded_server_ts: api_expanded_server_ts(),
      selected_client_heex: api_selected_client_binding_heex(),
      selected_client_js: api_selected_client_binding_js(),
      selected_client_ts: api_selected_client_binding_ts(),
      selected_js_heex: api_selected_client_js_heex(),
      selected_js: api_selected_client_js_js(),
      selected_js_ts: api_selected_client_js_ts(),
      selected_server_heex: api_selected_server_heex(),
      selected_server_elixir: api_selected_server_elixir(),
      selected_server_js: api_selected_server_js(),
      selected_server_ts: api_selected_server_ts()
    }
  end

  # --------------------------------------------------------------------------
  # Events
  # --------------------------------------------------------------------------

  def events_items, do: api_items()

  def events_server_heex do
    """
    <.tree_view
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
    E2eWeb.Demos.DocExamples.event_handlers_snippet([
      {"tree_server_expanded", ~S|%{"id" => id, "expandedValue" => expanded} = params|},
      {"tree_server_selection", ~S|%{"id" => id} = params|}
    ])
  end

  def events_client_heex do
    """
    <.tree_view
      id="tree-events-client"
      class="tree-view"
      expanded_value={["repo-corex", "repo-lib"]}
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
  # Patterns  -  Redirect (Navigate)
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
        value: "nav-branch-accordion",
        children: [
          %{label: "Structure", value: ~p"/accordion/anatomy"},
          %{label: "Playground", value: ~p"/accordion/playground"}
        ]
      },
      %{
        label: "Tree view",
        value: "nav-branch-tree-view",
        children: [
          %{label: "Structure", value: ~p"/tree-view/anatomy"},
          %{label: "Playground", value: ~p"/tree-view/playground"}
        ]
      }
    ])
  end

  def patterns_redirect_expanded, do: ["nav-branch-accordion", "nav-branch-tree-view"]

  def patterns_redirect_value, do: [~p"/tree-view/anatomy"]

  def patterns_redirect_heex do
    """
    <.tree_view
      class="tree-view"
      redirect
      on_selection_change="patterns_tree_redirect_nav"
      expanded_value={["nav-branch-accordion", "nav-branch-tree-view"]}
      value={[#{inspect(~p"/tree-view/anatomy")}]}
      items={
        Corex.Tree.new([
          %{
            label: "Accordion",
            value: "nav-branch-accordion",
            children: [
              %{label: "Structure", value: #{inspect(~p"/accordion/anatomy")}},
              %{label: "Playground", value: #{inspect(~p"/accordion/playground")}}
            ]
          },
          %{
            label: "Tree view",
            value: "nav-branch-tree-view",
            children: [
              %{label: "Structure", value: #{inspect(~p"/tree-view/anatomy")}},
              %{label: "Playground", value: #{inspect(~p"/tree-view/playground")}}
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
