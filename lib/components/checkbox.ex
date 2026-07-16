defmodule Corex.Checkbox do
  @moduledoc ~S'''
    Phoenix implementation of [Zag.js Checkbox](https://zagjs.com/components/react/checkbox).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.checkbox class="checkbox">
    <:label>Option</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
  </.checkbox>
  ```

  ### Label and indicator

  ```heex
  <.checkbox class="checkbox">
    <:label>Accept the terms</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
  </.checkbox>
  ```

  ### Invalid

  ```heex
  <.checkbox
    class="checkbox ui-accent"
    invalid
    checked
    errors={["Required"]}
  >
    <:label>Subscribe</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.checkbox>
  ```

  ### Indeterminate

  ```heex
  <.checkbox class="checkbox" checked={:indeterminate}>
    <:label>Select some rows</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
    <:indeterminate>
      <.heroicon name="hero-minus" />
    </:indeterminate>
  </.checkbox>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.checkbox>`. Imperative helpers set or toggle checked state (boolean only; clears indeterminate).

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_checked/2`](#set_checked/2) | Set checked state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_checked/3`](#set_checked/3) | Set checked state (server) | `socket` |
  | [`toggle_checked/1`](#toggle_checked/1) | Toggle checked state (client) | `%Phoenix.LiveView.JS{}` |
  | [`toggle_checked/2`](#toggle_checked/2) | Toggle checked state (server) | `socket` |

  <!-- tabs-open -->

  ### set_checked

  ```heex
  <.action phx-click={Corex.Checkbox.set_checked("checkbox-api-bind", true)} class="button ui-size-sm">
    Set checked
  </.action>
  <.action phx-click={Corex.Checkbox.set_checked("checkbox-api-bind", false)} class="button ui-size-sm">
    Set unchecked
  </.action>
  <.action phx-click={Corex.Checkbox.toggle_checked("checkbox-api-bind")} class="button ui-size-sm">
    Toggle
  </.action>
  <.checkbox id="checkbox-api-bind" class="checkbox">
    <:label>Terms</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
    <:indeterminate>
      <.heroicon name="hero-minus" />
    </:indeterminate>
  </.checkbox>
  ```

  ### set_checked (dispatch)

  ```javascript
  const el = document.getElementById("checkbox-api-dispatch");

  el?.dispatchEvent(
    new CustomEvent("corex:checkbox:set-checked", { bubbles: false, detail: { checked: true } })
  );

  el?.dispatchEvent(
    new CustomEvent("corex:checkbox:set-checked", { bubbles: false, detail: { checked: false } })
  );

  el?.dispatchEvent(new CustomEvent("corex:checkbox:toggle-checked", { bubbles: false }));
  ```

  ```elixir
  def handle_event("check", %{"id" => id}, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, id, true)}
  end

  def handle_event("uncheck", %{"id" => id}, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, id, false)}
  end

  def handle_event("toggle", %{"id" => id}, socket) do
    {:noreply, Corex.Checkbox.toggle_checked(socket, id)}
  end
  ```

  <!-- tabs-close -->

  ## Events

  User-driven only. Declarative `checked` may be `true`, `false`, or `:indeterminate`; imperative `set_checked` is always boolean.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_checked_change="checkbox_changed"` | User toggles checked state | `%{"id" => id, "checked" => boolean}` |

  <!-- tabs-open -->

  ### on_checked_change

  ```heex
  <.checkbox
    class="checkbox"
    on_checked_change="checkbox_changed"
  >
    <:label>Subscribe</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
  </.checkbox>
  ```

  ```elixir
  def handle_event("checkbox_changed", %{"id" => id, "checked" => checked}, socket) do
    {:noreply, assign(socket, :checked, checked)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_checked_change_client="checkbox-changed"` | User toggles checked state | `id`, `checked` |

  <!-- tabs-open -->

  ### on_checked_change_client

  ```heex
  <.checkbox
    id="checkbox-on-checked-change-client"
    class="checkbox"
    on_checked_change_client="checkbox-changed"
  >
    <:label>Subscribe</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
  </.checkbox>
  ```

  ```javascript
  document.getElementById("checkbox-on-checked-change-client")?.addEventListener(
    "checkbox-changed",
    (event) => console.log(event.detail)
  );
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Async

  #### Heex

  ```heex
  <.async_result :let={checkbox} assign={@checkbox}>
    <:loading><.checkbox_skeleton class="checkbox" /></:loading>
    <.checkbox class="checkbox" checked={checkbox.checked}>
      <:label>Accept terms</:label>
      <:indicator><.heroicon name="hero-check" /></:indicator>
      <:indeterminate><.heroicon name="hero-minus" /></:indeterminate>
    </.checkbox>
  </.async_result>
  ```

  #### Elixir

  ```elixir
  socket =
    assign_async(socket, :checkbox, fn ->
      Process.sleep(1000)
      {:ok, %{checkbox: %{checked: true}}}
    end)
  ```

  ### Controlled (LiveView)

  #### Heex

  ```heex
  <.checkbox
    class="checkbox"
    controlled
    checked={@checked}
    on_checked_change="patterns_controlled_changed"
  >
    <:label>Accept terms</:label>
    <:indicator><.heroicon name="hero-check" /></:indicator>
    <:indeterminate><.heroicon name="hero-minus" /></:indeterminate>
  </.checkbox>
  ```

  #### Elixir

  ```elixir
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :checked, true)}
  end

  def handle_event("patterns_controlled_changed", %{"checked" => checked}, socket) do
    {:noreply, assign(socket, :checked, checked)}
  end
  ```

  <!-- tabs-close -->
  ## Style

  Target parts with `data-scope` and `data-part`, or import `checkbox.css` and stack modifiers on the host.

  ```css
  [data-scope="checkbox"][data-part="root"] {}
  [data-scope="checkbox"][data-part="control"] {}
  [data-scope="checkbox"][data-part="label"] {}
  [data-scope="checkbox"][data-part="hidden-input"] {}
  [data-scope="checkbox"][data-part="error"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components.css";
  ```

  Stack modifiers on the host (`class` on `<.checkbox>`). Combine axes, for example `checkbox ui-accent ui-size-lg` or `checkbox ui-info ui-solid`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on the control. Variant modifiers control surface treatment. Default is subtle: unchecked uses a neutral surface, checked uses selected with semantic ink text. Add `ui-solid` for a filled checked state.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for control ink and fill. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `checkbox` |
  | Accent | `checkbox ui-accent` |
  | Brand | `checkbox ui-brand` |
  | Alert | `checkbox ui-alert` |
  | Info | `checkbox ui-info` |
  | Success | `checkbox ui-success` |

  ### Variant

  Visual treatment of the control. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `checkbox` or `checkbox ui-accent` |
  | Solid | `checkbox ui-accent ui-solid` |

  ```heex
  <.checkbox class="checkbox" checked>
        <:label>Default</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox ui-accent" checked>
        <:label>Accent</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox ui-brand" checked>
        <:label>Brand</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox ui-alert" checked>
        <:label>Alert</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox ui-info" checked>
        <:label>Info</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox ui-success" checked>
        <:label>Success</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
  ```

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `checkbox ui-size-sm` |
  | Default | `checkbox` |
  | LG | `checkbox ui-size-lg` |
  | XL | `checkbox ui-size-xl` |

  ```heex
  <.checkbox class="checkbox ui-size-sm">
        <:label>Small</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
      </.checkbox>
      <.checkbox class="checkbox">
        <:label>Default</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
      </.checkbox>
      <.checkbox class="checkbox ui-size-lg">
        <:label>Large</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
      </.checkbox>
      <.checkbox class="checkbox ui-size-xl">
        <:label>XLarge</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
      </.checkbox>
  ```

  ### Invalid

  Invalid styles the label and control border. Checked indicators keep their semantic fill color.

  ```heex
  <.checkbox class="checkbox ui-accent" invalid checked errors={["Required"]}>
    <:label>Subscribe</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.checkbox>
  ```

  <!-- tabs-close -->

  ## Form

  Set the form `id` in `to_form/2` and use `<.form for={@form}>`. Use `field={@form[:terms]}` so the checkbox name matches the form. For Ecto validation in LiveView, add `phx-change` on the form so params stay in sync.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. Pass `invalid={Corex.FormField.invalid?(@form[:terms])}` when you want alert borders after validation.

  <!-- tabs-open -->

  ### Phoenix Form (changeset)

  #### Heex

  ```heex
      <.form
        :let={f}
        for={@form}
        action="/account/terms"
        method="post"
      >
        <.checkbox field={f[:terms]} class="checkbox">
          <:label>Accept terms</:label>
          <:indicator>
            <.heroicon name="hero-check" />
          </:indicator>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" class="button ui-accent">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def account_terms_page(conn, _params) do
        changeset = MyApp.Forms.Terms.changeset(%MyApp.Forms.Terms{}, %{})

        form =
          Phoenix.Component.to_form(changeset,
            as: :terms_changeset,
            id: "account-terms-changeset-form"
          )

        render(conn, :account_terms, form: form)
      end

      def account_terms_create(conn, %{"terms_changeset" => params}) do
        case MyApp.Forms.Terms.changeset(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)
            conn
            |> put_flash(:info, "Saved: terms=#{data.terms}")
            |> redirect(to: "/account")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)

            form =
              Phoenix.Component.to_form(changeset,
                as: :terms_changeset,
                id: "account-terms-changeset-form"
              )

            render(conn, :account_terms, form: form)
        end
      end
  ```

  #### Ecto

  ```elixir
      defmodule MyApp.Forms.Terms do
        use Ecto.Schema
        import Ecto.Changeset

        embedded_schema do
          field :terms, :boolean, default: false
        end

        def changeset(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms])
          |> validate_acceptance(:terms)
        end

        def changeset_validate(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms], message: "can't be blank")
          |> validate_acceptance(:terms, message: "must be accepted to continue")
        end
      end
  ```

  ### Ecto changeset (validation)

  #### Heex

  ```heex
      <.form
        :let={f}
        for={@form}
        action="/account/terms"
        method="post"
      >
        <.checkbox field={f[:terms]} class="checkbox">
          <:label>Accept terms (strict messages)</:label>
          <:indicator>
            <.heroicon name="hero-check" />
          </:indicator>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" class="button ui-accent">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def account_terms_strict_page(conn, _params) do
        changeset =
          MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, %{})

        form =
          Phoenix.Component.to_form(changeset,
            as: :terms_validate,
            id: "account-terms-validate-form"
          )

        render(conn, :account_terms_strict, form: form)
      end

      def account_terms_strict_create(conn, %{"terms_validate" => params}) do
        case MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)
            conn
            |> put_flash(:info, "Saved: terms=#{data.terms}")
            |> redirect(to: "/account")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)

            form =
              Phoenix.Component.to_form(changeset,
                as: :terms_validate,
                id: "account-terms-validate-form"
              )

            render(conn, :account_terms_strict, form: form)
        end
      end
  ```

  #### Ecto

  ```elixir
      defmodule MyApp.Forms.Terms do
        use Ecto.Schema
        import Ecto.Changeset

        embedded_schema do
          field :terms, :boolean, default: false
        end

        def changeset(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms])
          |> validate_acceptance(:terms)
        end

        def changeset_validate(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms], message: "can't be blank")
          |> validate_acceptance(:terms, message: "must be accepted to continue")
        end
      end
  ```

  ### Native form (plain HTML)

  ```heex
      <form
        action="/register"
        method="post"
      >
        <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
        <.checkbox
          name="user[accept_terms]"
          class="checkbox"
        >
          <:label>Accept terms</:label>
          <:indicator>
            <.heroicon name="hero-check" />
          </:indicator>
        </.checkbox>
        <.action type="submit" class="button ui-accent">Submit</.action>
      </form>
  ```

  ### LiveView · Phoenix Form (changeset)

  #### Heex

  ```heex
      <.form
        for={@form}
       
        phx-change="validate"
        phx-submit="save"
      >
        <.checkbox field={@form[:terms]} class="checkbox">
          <:label>Accept terms</:label>
          <:indicator>
            <.heroicon name="hero-check" />
          </:indicator>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" class="button ui-accent">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def mount(_params, _session, socket) do
        form =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset(%{})
          |> Phoenix.Component.to_form(as: :terms)

        {:ok, assign(socket, :form, form)}
      end

      def handle_event("validate", %{"terms" => params}, socket) do
        changeset =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset(params)
          |> Map.put(:action, :validate)

        {:noreply, assign(socket, :form, Phoenix.Component.to_form(changeset, action: :validate, as: :terms))}
      end

      def handle_event("save", %{"terms" => params}, socket) do
        case MyApp.Forms.Terms.changeset(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = _changeset ->
            {:noreply, assign(socket, :form, Phoenix.Component.to_form(MyApp.Forms.Terms.changeset(%MyApp.Forms.Terms{}, %{}), as: :terms))}

          changeset ->
            {:noreply, assign(socket, :form, Phoenix.Component.to_form(changeset, action: :insert, as: :terms))}
        end
      end
  ```

  #### Ecto

  ```elixir
      defmodule MyApp.Forms.Terms do
        use Ecto.Schema
        import Ecto.Changeset

        embedded_schema do
          field :terms, :boolean, default: false
        end

        def changeset(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms])
          |> validate_acceptance(:terms)
        end

        def changeset_validate(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms], message: "can't be blank")
          |> validate_acceptance(:terms, message: "must be accepted to continue")
        end
      end
  ```

  ### LiveView · Ecto Changeset (validation)

  #### Heex

  ```heex
      <.form
        for={@form}
       
        phx-change="validate_strict"
        phx-submit="save_strict"
      >
        <.checkbox field={@form[:terms]} class="checkbox">
          <:label>Accept terms</:label>
          <:indicator>
            <.heroicon name="hero-check" />
          </:indicator>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" class="button ui-accent">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def mount(_params, _session, socket) do
        form =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :terms_strict)

        {:ok, assign(socket, :strict_form, form)}
      end

      def handle_event("validate_strict", %{"terms_strict" => params}, socket) do
        changeset =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(socket, :strict_form, Phoenix.Component.to_form(changeset, action: :validate, as: :terms_strict))}
      end

      def handle_event("save_strict", %{"terms_strict" => params}, socket) do
        case MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = _changeset ->
            {:noreply,
             assign(
               socket,
               :strict_form,
               Phoenix.Component.to_form(MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, %{}), as: :terms_strict)
             )}

          changeset ->
            {:noreply, assign(socket, :strict_form, Phoenix.Component.to_form(changeset, action: :insert, as: :terms_strict))}
        end
      end
  ```

  #### Ecto

  ```elixir
      defmodule MyApp.Forms.Terms do
        use Ecto.Schema
        import Ecto.Changeset

        embedded_schema do
          field :terms, :boolean, default: false
        end

        def changeset(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms])
          |> validate_acceptance(:terms)
        end

        def changeset_validate(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms], message: "can't be blank")
          |> validate_acceptance(:terms, message: "must be accepted to continue")
        end
      end
  ```

  ### LiveView · Ecto + Controlled

  Use `controlled` with `phx-change` so the checkbox checked state and validation errors stay in sync during LiveView validation.

  #### Heex

  ```heex
      <.form
        for={@ecto_controlled_form}
        phx-change="validate_controlled"
        phx-submit="save_controlled"
      >
        <.checkbox
          field={@ecto_controlled_form[:terms]}
          class="checkbox"
          controlled
        >
          <:label>Accept terms</:label>
          <:indicator>
            <.heroicon name="hero-check" />
          </:indicator>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" class="button ui-accent">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def mount(_params, _session, socket) do
        ecto_controlled_form =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :terms_ecto_controlled, id: "checkbox-live-form-ecto-controlled")

        {:ok, assign(socket, :ecto_controlled_form, ecto_controlled_form)}
      end

      def handle_event("validate_controlled", %{"terms_ecto_controlled" => params}, socket) do
        validate_ecto_controlled(socket, params)
      end

      def handle_event("save_controlled", %{"terms_ecto_controlled" => params}, socket) do
        case MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_controlled_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, params),
                 as: :terms_ecto_controlled,
                 id: "checkbox-live-form-ecto-controlled"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_controlled_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :terms_ecto_controlled,
                 id: "checkbox-live-form-ecto-controlled"
               )
             )}
        end
      end

      defp validate_ecto_controlled(socket, params) do
        changeset =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_controlled_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :terms_ecto_controlled,
             id: "checkbox-live-form-ecto-controlled"
           )
         )}
      end
  ```

  ### LiveView · Ecto + Invalid

  Pass `invalid={Corex.FormField.invalid?(@form[:terms])}` for alert borders after validation. Error messages still render through the `:error` slot.

  #### Heex

  ```heex
      <.form
        for={@ecto_invalid_form}
        phx-change="validate_invalid"
        phx-submit="save_invalid"
      >
        <.checkbox
          field={@ecto_invalid_form[:terms]}
          class="checkbox"
          invalid={Corex.FormField.invalid?(@ecto_invalid_form[:terms])}
        >
          <:label>Accept terms</:label>
          <:indicator>
            <.heroicon name="hero-check" />
          </:indicator>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" class="button ui-accent">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def mount(_params, _session, socket) do
        ecto_invalid_form =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :terms_ecto_invalid, id: "checkbox-live-form-ecto-invalid")

        {:ok, assign(socket, :ecto_invalid_form, ecto_invalid_form)}
      end

      def handle_event("validate_invalid", %{"terms_ecto_invalid" => params}, socket) do
        validate_ecto_invalid(socket, params)
      end

      def handle_event("save_invalid", %{"terms_ecto_invalid" => params}, socket) do
        case MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_invalid_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, params),
                 as: :terms_ecto_invalid,
                 id: "checkbox-live-form-ecto-invalid"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_invalid_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :terms_ecto_invalid,
                 id: "checkbox-live-form-ecto-invalid"
               )
             )}
        end
      end

      defp validate_ecto_invalid(socket, params) do
        changeset =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_invalid_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :terms_ecto_invalid,
             id: "checkbox-live-form-ecto-invalid"
           )
         )}
      end
  ```

  <!-- tabs-close -->
  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Api.Imports, to: Corex.Checkbox.Api

  alias Corex.Checkable.Helpers, as: CheckableHelpers

  alias Corex.Checkbox.Anatomy.{
    Control,
    HiddenInput,
    Indeterminate,
    Indicator,
    Label,
    Props,
    Root
  }

  alias Corex.Checkbox.Connect
  alias Phoenix.HTML.Form

  @doc """
  Renders a checkbox component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the checkbox, useful for API to identify the checkbox"
  )

  attr(:checked, :any,
    default: false,
    doc:
      "Checked state: true, false, or :indeterminate (Zag CheckedState). Form fields still use boolean."
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "Whether the checkbox is controlled"
  )

  attr(:name, :string, doc: "The name of the checkbox input for form submission")

  attr(:form, :string, doc: "The form id to associate the checkbox with")

  attr(:aria_label, :string,
    default: "Label",
    doc: "The accessible label for the checkbox"
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "Whether the checkbox is disabled"
  )

  attr(:value, :string,
    default: "true",
    doc: "The value of the checkbox when checked"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the checkbox. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["vertical", "horizontal"],
    doc: "Layout orientation for CSS (vertical or horizontal)"
  )

  attr(:read_only, :boolean,
    default: false,
    doc: "Whether the checkbox is read-only"
  )

  attr(:invalid, :boolean,
    default: false,
    doc: "Whether the checkbox has validation errors"
  )

  attr(:required, :boolean,
    default: false,
    doc: "Whether the checkbox is required"
  )

  attr(:on_checked_change, :string,
    default: nil,
    doc:
      "LiveView event when checked changes. `handle_event` receives `%{\"id\" => id, \"checked\" => boolean}`."
  )

  attr(:on_checked_change_client, :string,
    default: nil,
    doc:
      "Browser event type on the checkbox element when checked changes. `event.detail`: `{ id, checked }`."
  )

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:email]. Automatically sets id, name, checked state, and errors from the form field"
  )

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :indicator, required: false do
    attr(:class, :string, required: false)
  end

  slot :indeterminate, required: false do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def checkbox(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns =
      assigns
      |> Corex.FormField.assign_form_field(field)
      |> assign(:checked, Form.normalize_value("checkbox", field.value))

    checkbox(assigns)
  end

  def checkbox(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "checkbox-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:form_field, fn -> false end)
      |> assign(:checked, CheckableHelpers.normalize_checked(assigns.checked))

    ~H"""
    <div
      id={@id}
      phx-hook="Checkbox"
      data-loading 
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}     
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        checked: @checked,
        form_field: @form_field,
        name: @name,
        form: @form,
        dir: @dir,
        orientation: @orientation,
        read_only: @read_only,
        invalid: @invalid,
        required: @required,
        on_checked_change: @on_checked_change,
        on_checked_change_client: @on_checked_change_client,
        label: @aria_label,
        disabled: @disabled,
        value: @value
      })}
    >
      <input type="hidden" name={@name} value="false" disabled={@disabled} />

      <label phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, checked: @checked, orientation: @orientation, read_only: @read_only})} {Connect.root(%Root{id: @id, dir: @dir, checked: @checked, orientation: @orientation, read_only: @read_only})}>
      <input
        phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id, name: @name, checked: @checked, disabled: @disabled, required: @required, invalid: @invalid, value: @value, controlled: @controlled})}
        {Connect.hidden_input(%HiddenInput{id: @id, name: @name, checked: @checked, disabled: @disabled, required: @required, invalid: @invalid, value: @value, controlled: @controlled})}
      />
      <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, checked: @checked, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}>
          <span
            :if={@indicator != []}
            phx-mounted={Connect.ignore_indicator(%Indicator{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
            {Connect.indicator(%Indicator{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
          >
          {render_slot(@indicator)}
          </span>
          <span
            :if={@indeterminate != []}
            phx-mounted={Connect.ignore_indeterminate(%Indeterminate{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
            {Connect.indeterminate(%Indeterminate{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
          >
          {render_slot(@indeterminate)}
          </span>
      </div>
      <span
        :if={@label != []}
        phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
        {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
      >
      {render_slot(@label)}
      </span>
      <span
        :if={@label == [] && @aria_label}
        class="sr-only"
        phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
        {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
      >
      {@aria_label}
      </span>
      </label>
      <div
        :if={@error != []}
        :for={msg <- @errors}
        class={Map.get(Enum.at(@error, 0), :class, nil)}
        data-scope="checkbox"
        data-part="error"
      >
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders a loading skeleton for the checkbox component.
  """

  attr(:skeleton_label, :boolean,
    default: true,
    doc:
      "When true, renders a compact label-line placeholder (same line height band as the real checkbox label)."
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "Same as checkbox: logical direction for layout."
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["vertical", "horizontal"],
    doc: "Same as checkbox: layout orientation for the skeleton root."
  )

  attr(:rest, :global)

  def checkbox_skeleton(assigns) do
    ~H"""
    <div data-dir={@dir} data-orientation={@orientation} {@rest}>
      <div
        data-scope="checkbox"
        data-part="root"
        data-loading
        dir={@dir}
        data-orientation={@orientation}
      >
        <div data-scope="checkbox" data-part="control" aria-hidden="true">
          <span data-scope="checkbox" data-part="indicator">
          </span>
        </div>
        <div
          :if={@skeleton_label}
          data-scope="checkbox"
          data-part="label"
          aria-hidden="true"
        >
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set checked state from a control (`phx-click`). Clears indeterminate when applied.

  ```heex
  <.action phx-click={Corex.Checkbox.set_checked("my-checkbox", true)}>Check</.action>
  <.checkbox id="my-checkbox" class="checkbox">
    <:label>Option</:label>
  </.checkbox>
  ```

  ```javascript
  document.getElementById("my-checkbox")?.dispatchEvent(
    new CustomEvent("corex:checkbox:set-checked", {
      bubbles: false,
      detail: { checked: true },
    })
  );
  ```
  """)

  defdelegate set_checked(checkbox_id, checked), to: Api

  api_doc(~S"""
  Set checked state from `handle_event`. Pushes `checkbox_set_checked` (no reply event).

  ```heex
  <.action phx-click="check_box">Check</.action>
  <.checkbox id="my-checkbox" class="checkbox">
    <:label>Option</:label>
  </.checkbox>
  ```

  ```elixir
  def handle_event("check_box", _, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, "my-checkbox", true)}
  end
  ```
  """)

  defdelegate set_checked(socket, checkbox_id, checked), to: Api

  api_doc(~S"""
  Toggle checked state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Checkbox.toggle_checked("my-checkbox")}>Toggle</.action>
  <.checkbox id="my-checkbox" class="checkbox">
    <:label>Option</:label>
  </.checkbox>
  ```

  ```javascript
  document.getElementById("my-checkbox")?.dispatchEvent(
    new CustomEvent("corex:checkbox:toggle-checked", { bubbles: false })
  );
  ```
  """)

  defdelegate toggle_checked(checkbox_id), to: Api

  api_doc(~S"""
  Toggle checked from `handle_event`. Pushes `checkbox_toggle_checked` (no reply event).

  ```heex
  <.action phx-click="toggle_box">Toggle</.action>
  <.checkbox id="my-checkbox" class="checkbox">
    <:label>Option</:label>
  </.checkbox>
  ```

  ```elixir
  def handle_event("toggle_box", _, socket) do
    {:noreply, Corex.Checkbox.toggle_checked(socket, "my-checkbox")}
  end
  ```
  """)

  defdelegate toggle_checked(socket, checkbox_id), to: Api
end
