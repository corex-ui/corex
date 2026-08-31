defmodule E2eWeb.Demos.TocDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_minimal_code do
    ~S"""
    <.toc class="toc" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.toc id="toc-anatomy-minimal" class="toc" />
    """
  end

  def anatomy_article_code do
    ~S"""
    <div class="grid grid-cols-[minmax(0,1fr)_12rem] gap-space items-start">
      <article id="toc-article" class="typo max-h-96 overflow-auto" tabindex="0">
        <h2 id="intro">Introduction</h2>
        <p>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sodales ullamcorper tristique.
          Nullam eget vestibulum ligula, at interdum tellus. Donec condimentum ex mi, congue molestie ipsum gravida a.
        </p>
        <p>
          Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae.
          Integer vitae nisl sit amet lorem pretium tincidunt. Curabitur auctor, nisl a commodo vehicula,
          nisi justo venenatis lectus, at tincidunt erat nisl a lorem.
        </p>
        <h2 id="install">Install</h2>
        <p>
          Add the Hex package, run the installer, and include Design CSS. Lorem ipsum dolor sit amet,
          consectetur adipiscing elit. Fusce posuere, lacus sit amet tincidunt tincidunt, nunc nisl
          tincidunt nisl, vitae aliquam nisl nisl sit amet nisl.
        </p>
        <p>
          Sed ac eros luctus, tincidunt nisl sit amet, aliquam nisl. Pellentesque habitant morbi tristique
          senectus et netus et malesuada fames ac turpis egestas.
        </p>
        <h3 id="usage">Usage</h3>
        <p>
          Render hosts with a stable id. Hooks hydrate Zag machines after JavaScript loads.
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet.
        </p>
        <p>
          Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Nullam quis risus eget
          urna mollis ornare vel eu leo. Cum sociis natoque penatibus et magnis dis parturient montes.
        </p>
        <h2 id="api">API</h2>
        <p>
          Client bindings dispatch CustomEvents. Server handlers push LiveView events.
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas faucibus mollis interdum.
        </p>
        <p>
          Cras mattis consectetur purus sit amet fermentum. Donec ullamcorper nulla non metus auctor fringilla.
          Etiam porta sem malesuada magna mollis euismod.
        </p>
        <h2 id="a11y">Accessibility</h2>
        <p>
          Parts keep Zag data attributes so keyboard and screen reader behavior stay intact.
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi leo risus, porta ac consectetur ac.
        </p>
        <p>
          Vestibulum id ligula porta felis euismod semper. Integer posuere erat a ante venenatis dapibus
          posuere velit aliquet. Aenean lacinia bibendum nulla sed consectetur.
        </p>
      </article>
      <div class="sticky top-space">
        <.toc class="toc" scroll_el="#toc-article" />
      </div>
    </div>
    """
  end

  def anatomy_article_example(assigns) do
    _ = assigns

    ~H"""
    <div class="grid w-full grid-cols-1 md:grid-cols-[minmax(0,1fr)_12rem] gap-space items-start">
      <article id="toc-article" class="typo max-h-96 overflow-auto pr-space" tabindex="0">
        <h2 id="intro">Introduction</h2>
        <p>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sodales ullamcorper tristique.
          Nullam eget vestibulum ligula, at interdum tellus. Donec condimentum ex mi, congue molestie ipsum gravida a.
        </p>
        <p>
          Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae.
          Integer vitae nisl sit amet lorem pretium tincidunt. Curabitur auctor, nisl a commodo vehicula,
          nisi justo venenatis lectus, at tincidunt erat nisl a lorem.
        </p>
        <p>
          Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.
        </p>
        <h2 id="install">Install</h2>
        <p>
          Add the Hex package, run the installer, and include Design CSS. Lorem ipsum dolor sit amet,
          consectetur adipiscing elit. Fusce posuere, lacus sit amet tincidunt tincidunt, nunc nisl
          tincidunt nisl, vitae aliquam nisl nisl sit amet nisl.
        </p>
        <p>
          Sed ac eros luctus, tincidunt nisl sit amet, aliquam nisl. Pellentesque habitant morbi tristique
          senectus et netus et malesuada fames ac turpis egestas.
        </p>
        <p>
          Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit sit amet non magna.
        </p>
        <h3 id="usage">Usage</h3>
        <p>
          Render hosts with a stable id. Hooks hydrate Zag machines after JavaScript loads.
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet.
        </p>
        <p>
          Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Nullam quis risus eget
          urna mollis ornare vel eu leo. Cum sociis natoque penatibus et magnis dis parturient montes.
        </p>
        <p>
          Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Donec sed odio dui.
        </p>
        <h2 id="api">API</h2>
        <p>
          Client bindings dispatch CustomEvents. Server handlers push LiveView events.
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas faucibus mollis interdum.
        </p>
        <p>
          Cras mattis consectetur purus sit amet fermentum. Donec ullamcorper nulla non metus auctor fringilla.
          Etiam porta sem malesuada magna mollis euismod.
        </p>
        <p>
          Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.
        </p>
        <h2 id="a11y">Accessibility</h2>
        <p>
          Parts keep Zag data attributes so keyboard and screen reader behavior stay intact.
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi leo risus, porta ac consectetur ac.
        </p>
        <p>
          Vestibulum id ligula porta felis euismod semper. Integer posuere erat a ante venenatis dapibus
          posuere velit aliquet. Aenean lacinia bibendum nulla sed consectetur.
        </p>
        <p>
          Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nullam id dolor id nibh ultricies vehicula.
        </p>
      </article>
      <div class="sticky top-space">
        <.toc id="toc-anatomy-article" class="toc" scroll_el="#toc-article" />
      </div>
    </div>
    """
  end

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc class="toc" />
    <.toc class="toc ui-accent" />
    <.toc class="toc ui-brand" />
    <.toc class="toc ui-alert" />
    <.toc class="toc ui-success" />
    <.toc class="toc ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.toc id="toc-style-default" class="toc" />
      <.toc id="toc-style-accent" class="toc ui-accent" />
      <.toc id="toc-style-brand" class="toc ui-brand" />
      <.toc id="toc-style-alert" class="toc ui-alert" />
      <.toc id="toc-style-success" class="toc ui-success" />
      <.toc id="toc-style-info" class="toc ui-info" />
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc class="toc ui-size-sm" />
    <.toc class="toc ui-size-md" />
    <.toc class="toc ui-size-lg" />
    <.toc class="toc ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.toc id="toc-style-size-sm" class="toc ui-size-sm" />
      <.toc id="toc-style-size-md" class="toc ui-size-md" />
      <.toc id="toc-style-size-lg" class="toc ui-size-lg" />
      <.toc id="toc-style-size-xl" class="toc ui-size-xl" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc class="toc ui-rounded-none" />
    <.toc class="toc ui-rounded-sm" />
    <.toc class="toc ui-rounded-md" />
    <.toc class="toc ui-rounded-lg" />
    <.toc class="toc ui-rounded-xl" />
    <.toc class="toc ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.toc id="toc-style-r-none" class="toc ui-rounded-none" />
      <.toc id="toc-style-r-sm" class="toc ui-rounded-sm" />
      <.toc id="toc-style-r-md" class="toc ui-rounded-md" />
      <.toc id="toc-style-r-lg" class="toc ui-rounded-lg" />
      <.toc id="toc-style-r-xl" class="toc ui-rounded-xl" />
      <.toc id="toc-style-r-full" class="toc ui-rounded-full" />
    </div>
    """
  end

  def styling_width_code do
    DemoScales.width_layout_variants("toc")
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("toc", modifier)
      ~s(<.toc class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("toc"))

    ~H"""
    <div class="flex flex-col gap-space">
      <.toc
        :for={step <- @width_variants}
        id={"toc-style-w-#{step.id}"}
        class={DemoScales.join_modifiers("toc", step.modifier)}
      />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("toc")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("toc", modifier)
      ~s(<.toc class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(assigns, :max_width_variants, DemoScales.max_width_variants("toc") |> Enum.take(4))

    ~H"""
    <div class="flex flex-col gap-space">
      <.toc
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("toc", step.modifier)}
      />
    </div>
    """
  end
end
