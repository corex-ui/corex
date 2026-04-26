defmodule E2eWeb.ThemeGeneratorLive do
  use E2eWeb, :live_view

  @token_salt "theme_gen_export"

  @impl true
  def mount(_params, _session, socket) do
    config = E2e.DesignPalette.Config.defaults()
    ui = config["ui_ratio_base"]["default"]
    neo_sel = get_in(config, ["themes", "neo-light", "semantic", "selected", "lightness"]) || 85
    ui_ln = get_in(config, ["themes", "neo-light", "surface", "ui", "lightness"]) || 94
    brand = config["seeds"]["brand"] || "#32479C"

    {:ok,
     socket
     |> assign(:page_title, "Theme generator")
     |> assign(:config, config)
     |> assign(:ui_ratio_default, to_string(ui))
     |> assign(:neo_selected_lightness, to_string(neo_sel))
     |> assign(:ui_lightness, to_string(ui_ln))
     |> assign(:brand_color, brand)
     |> assign(:workspace, nil)
     |> assign(:export_id, nil)
     |> assign(:export_token, nil)
     |> assign(:preview_css, "")
     |> assign(:build_error, nil)}
  end

  @impl true
  def terminate(_reason, socket) do
    cleanup(socket)
    :ok
  end

  defp cleanup(socket) do
    if wid = socket.assigns[:export_id] do
      :ets.delete(:theme_generator_exports, wid)
    end

    if ws = socket.assigns[:workspace] do
      E2e.ThemeGenerator.Workspace.delete!(ws)
    end
  end

  @impl true
  def handle_event("regenerate", params, socket) do
    config = merged_config(socket.assigns.config, params)

    if old = socket.assigns[:workspace] do
      E2e.ThemeGenerator.Workspace.delete!(old)
    end

    if oid = socket.assigns[:export_id] do
      :ets.delete(:theme_generator_exports, oid)
    end

    case E2e.ThemeGenerator.Build.run(config) do
      {:ok, workspace} ->
        export_id = :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
        :ets.insert(:theme_generator_exports, {export_id, workspace})
        token = Phoenix.Token.sign(E2eWeb.Endpoint, @token_salt, export_id)
        preview = E2e.ThemeGenerator.Build.preview_css_snippet(workspace)

        {:noreply,
         socket
         |> assign(:config, config)
         |> assign(:ui_ratio_default, to_string(params["ui_ratio_default"] || ""))
         |> assign(:neo_selected_lightness, to_string(params["neo_selected_lightness"] || ""))
         |> assign(:ui_lightness, to_string(params["ui_lightness"] || ""))
         |> assign(:brand_color, String.trim(to_string(params["brand_color"] || "")))
         |> assign(:workspace, workspace)
         |> assign(:export_id, export_id)
         |> assign(:export_token, token)
         |> assign(:preview_css, preview)
         |> assign(:build_error, nil)
         |> put_flash(:info, "Preview built in a temporary directory.")}

      {:error, msg} ->
        {:noreply,
         socket
         |> assign(:workspace, nil)
         |> assign(:export_id, nil)
         |> assign(:export_token, nil)
         |> assign(:preview_css, "")
         |> assign(:build_error, msg)
         |> put_flash(:error, msg)}
    end
  end

  defp merged_config(base, params) do
    ud =
      case Float.parse(to_string(params["ui_ratio_default"] || "")) do
        {f, _} -> f
        :error -> base["ui_ratio_base"]["default"]
      end

    nl =
      case Integer.parse(to_string(params["neo_selected_lightness"] || "")) do
        {i, _} -> i
        :error -> get_in(base, ["themes", "neo-light", "semantic", "selected", "lightness"]) || 85
      end

    ui_ln =
      case Integer.parse(to_string(params["ui_lightness"] || "")) do
        {i, _} -> clamp_pct(i)
        :error -> get_in(base, ["themes", "neo-light", "surface", "ui", "lightness"]) || 94
      end

    brand =
      case normalize_brand_hex(String.trim(to_string(params["brand_color"] || ""))) do
        {:ok, hex} -> hex
        :error -> base["seeds"]["brand"]
      end

    overrides = %{
      "seeds" => %{"brand" => brand},
      "ui_ratio_base" => %{"default" => ud},
      "themes" => %{
        "neo-light" => %{
          "surface" => %{
            "ui" => %{"lightness" => ui_ln}
          },
          "semantic" => %{
            "selected" => %{"lightness" => nl}
          }
        }
      }
    }

    E2e.DesignPalette.Config.merge_overrides(base, overrides)
  end

  defp clamp_pct(i) when is_integer(i), do: min(99, max(1, i))

  defp normalize_brand_hex(<<>>), do: :error

  defp normalize_brand_hex(s) do
    s = String.trim(s)

    hex =
      cond do
        Regex.match?(~r/^#[0-9a-fA-F]{6}$/, s) -> String.downcase(s)
        Regex.match?(~r/^[0-9a-fA-F]{6}$/, s) -> "#" <> String.downcase(s)
        true -> nil
      end

    if hex, do: {:ok, hex}, else: :error
  end

  defp export_href(token, kind) when is_binary(token) do
    ~p"/theme-generator/export" <> "?" <> URI.encode_query(%{"token" => token, "kind" => kind})
  end

  defp export_href(_, _), do: "#"

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <h1 class="typo typo--h1">Theme generator</h1>
      <p class="typo typo--body">
        Builds use a temporary directory only. Site assets under
        <code class="typo typo--code">assets/corex</code>
        are not modified.
      </p>

      <form class="layout__stack" phx-submit="regenerate">
        <label class="typo typo--label">
          ui_ratio_base.default
          <input class="native-input" type="text" name="ui_ratio_default" value={@ui_ratio_default} />
        </label>
        <label class="typo typo--label">
          neo-light semantic selected lightness
          <input
            class="native-input"
            type="text"
            name="neo_selected_lightness"
            value={@neo_selected_lightness}
          />
        </label>
        <label class="typo typo--label">
          neo-light UI surface lightness (1–99)
          <input class="native-input" type="text" name="ui_lightness" value={@ui_lightness} />
        </label>
        <label class="typo typo--label">
          brand seed color (#RRGGBB)
          <input
            class="native-input"
            type="text"
            name="brand_color"
            value={@brand_color}
            autocomplete="off"
          />
        </label>
        <button class="button button--solid" type="submit">Regenerate preview</button>
      </form>

      <%= if @build_error do %>
        <pre class="typo typo--body" style="white-space: pre-wrap;"><%= @build_error %></pre>
      <% end %>

      <%= if @export_token do %>
        <p class="typo typo--body">
          <a class="link" href={export_href(@export_token, "json")}>
            Download token JSON (zip)
          </a>
          ·
          <a class="link" href={export_href(@export_token, "css")}>
            Download token CSS (zip)
          </a>
        </p>
      <% end %>

      <div class="layout__stack" data-theme="neo" data-mode="light" id="theme-gen-preview">
        <%= if @preview_css != "" do %>
          <style type="text/css">
            <%= raw(@preview_css) %>
          </style>
        <% end %>
        <div class="layout__row layout__row--wrap">
          <button class="button button--solid" type="button">Solid</button>
          <button class="button button--outline" type="button">Outline</button>
          <button class="button button--brand" type="button">Brand</button>
        </div>
        <div class="layout__row">
          <div class="typo typo--body">Preview uses generated CSS above.</div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
