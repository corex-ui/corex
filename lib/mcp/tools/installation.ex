defmodule Corex.MCP.Tools.Installation do
  @moduledoc false

  @valid_scenarios ~W(new_project existing_project all)

  def tools do
    [
      %{
        name: "installation_guide",
        description: """
        Return copy-paste steps and commands for installing Corex in a new Phoenix app (mix corex.new) or an existing app (deps, Esbuild ESM, JS hooks, layout, use Corex). Read-only; does not run shell commands.
        """,
        inputSchema: %{
          type: "object",
          properties: %{
            scenario: %{
              type: "string",
              enum: ["new_project", "existing_project", "all"],
              description:
                "new_project: archives and generator only; existing_project: minimal manual steps plus optional MCP plug; all: both (default)."
            }
          }
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &installation_guide/1
      }
    ]
  end

  def installation_guide(args) when args in [nil, %{}] do
    encode_guide(full_guide())
  end

  def installation_guide(%{"scenario" => scenario} = args)
      when scenario in @valid_scenarios and map_size(args) == 1 do
    payload =
      case scenario do
        "new_project" -> Map.put(new_project_section(), :scenario, scenario)
        "existing_project" -> Map.put(existing_project_section(), :scenario, scenario)
        "all" -> full_guide()
      end

    encode_guide(payload)
  end

  def installation_guide(_), do: {:error, :invalid_arguments}

  defp encode_guide(payload) do
    {:ok, Corex.Json.encode!(payload)}
  end

  defp full_guide do
    %{
      scenario: "all",
      new_project: new_project_section(),
      existing_project: existing_project_section(),
      reference_urls: %{
        hexdocs_corex: "https://hexdocs.pm/corex",
        manual_installation: "https://hexdocs.pm/corex/manual_installation.html",
        repository: "https://github.com/corex-ui/corex"
      }
    }
  end

  defp new_project_section do
    %{
      intent: "Create a new Phoenix application with Corex preconfigured.",
      prerequisites: [
        "Install the phx_new archive once per machine.",
        "Install the corex_new archive for mix corex.new."
      ],
      commands: [
        %{step: 1, run: "mix archive.install hex phx_new"},
        %{step: 2, run: "mix archive.install hex corex_new"},
        %{step: 3, run: "mix corex.new my_app"}
      ],
      update_generator: %{
        command: "mix local.corex",
        note: "Updates the corex.new archive before generating a project."
      },
      pipeline:
        "corex.new runs mix phx.new --no-install with forwarded Phoenix flags, then renders Corex-owned files from templates directly into the generated app.",
      mix_help: "mix help corex.new",
      task_module: "Mix.Tasks.Corex.New"
    }
  end

  defp existing_project_section do
    %{
      intent: "Add Corex to an existing Phoenix project.",
      approach:
        "Apply minimal_steps in order. Replace my_app with your OTP application name where paths use lib/my_app_web/. Full narrative and optional sections (design, toast, theming) are on Hexdocs.",
      guide: "https://hexdocs.pm/corex/manual_installation.html",
      corex_version_constraint: "~> #{corex_hex_version()}",
      minimal_steps: minimal_steps_existing_project(),
      mcp_mount_optional_dev: mcp_mount_snippet(),
      design_assets: %{
        guide: "https://hexdocs.pm/corex/styled.html",
        note:
          "Add {:corex_design}, register the :corex_design compiler, set config :corex, Corex.Design, run mix compile, and @import ./corex.tailwind.css in app.css."
      }
    }
  end

  defp corex_hex_version do
    case Application.spec(:corex, :vsn) do
      nil ->
        Mix.raise("corex application version is not available")

      v when is_list(v) ->
        List.to_string(v)

      v when is_binary(v) ->
        v

      v ->
        to_string(v)
    end
  end

  defp minimal_steps_existing_project do
    ver = corex_hex_version()

    [
      %{
        step: 1,
        title: "Add the dependency",
        edit_files: ["mix.exs"],
        run_commands: ["mix deps.get"],
        snippet: """
        # In mix.exs deps:
            {:corex, \"~> #{ver}\"}
        """
      },
      %{
        step: 2,
        title: "Configure Esbuild for ESM and code splitting",
        edit_files: ["config/config.exs"],
        snippet: """
        # Under config :esbuild, my_app: [ args: ~W(...) ], ensure the main target includes:
        #   --bundle --format=esm --splitting --target=es2022
        #   --outdir=../priv/static/assets/js
        #   --external:/fonts/* --external:/images/* --alias:@=.
        # and cd: Path.expand(\"../assets\", __DIR__),
        #     env: %{\"NODE_PATH\" => [Path.expand(\"../deps\", __DIR__), Mix.Project.build_path()]}

        config :esbuild,
          version: \"0.25.4\",
          my_app: [
            args:
              ~W(js/app.js --bundle --format=esm --splitting --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
            cd: Path.expand(\"../assets\", __DIR__),
            env: %{\"NODE_PATH\" => [Path.expand(\"../deps\", __DIR__), Mix.Project.build_path()]}
          ]
        """
      },
      %{
        step: 3,
        title: "Import Corex hooks in assets/js/app.js",
        edit_files: ["assets/js/app.js"],
        snippet: """
        import corex from \"corex\"

        const liveSocket = new LiveSocket(\"/live\", Socket, {
          longPollFallbackMs: 2500,
          params: { _csrf_token: csrfToken },
          hooks: { ...colocatedHooks, ...corex }
        })
        """
      },
      %{
        step: 4,
        title: "Load app.js as an ES module in the root layout",
        edit_files: ["lib/my_app_web/components/layouts/root.html.heex"],
        snippet: """
        <script defer phx-track-static type=\"module\" src={~p\"/assets/js/app.js\"}></script>
        """
      },
      %{
        step: 5,
        title: "Import Corex in the web layer",
        edit_files: ["lib/my_app_web.ex"],
        snippet: """
        defp html_helpers do
          quote do
            use Gettext, backend: MyAppWeb.Gettext
            import Phoenix.HTML
            import Phoenix.Component, except: [form: 1]
            import MyAppWeb.CoreComponents
            use Corex
            alias Phoenix.LiveView.JS
            alias MyAppWeb.Layouts
            unquote(verified_routes())
          end
        end
        """
      },
      %{
        step: 6,
        title: "Verify compile and assets",
        run_commands: ["mix compile", "mix assets.build"]
      },
      %{
        step: 7,
        title: "Optional: mount Corex MCP in dev (AI tools)",
        edit_files: ["lib/my_app_web/endpoint.ex"],
        note: "Served on the same port as Phoenix; never enable in prod.",
        snippet: mcp_mount_snippet()[:plug_block]
      }
    ]
  end

  defp mcp_mount_snippet do
    %{
      plug_block: """
      if Mix.env() == :dev do
        plug Corex.MCP
      end
      """,
      placement:
        "Insert in lib/my_app_web/endpoint.ex before the `if code_reloading? do` block, after Plug.Static (and sockets) so routing stays correct.",
      routes: %{
        landing: "GET /corex",
        config_json: "GET /corex/config",
        mcp_rpc: "POST /corex/mcp"
      },
      cursor_mcp_example: %{
        servers: %{
          corex: %{url: "http://localhost:4000/corex/mcp"}
        }
      }
    }
  end
end
