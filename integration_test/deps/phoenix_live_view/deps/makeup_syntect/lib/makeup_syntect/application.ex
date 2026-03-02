defmodule MakeupSyntect.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Makeup.Registry

  defp register_for_languages do
    Application.get_env(:makeup_syntect, :register_for_languages, :all)
  end

  defp excluded_languages do
    Application.get_env(:makeup_syntect, :excluded_languages, ["elixir", "erlang", "html_eex"])
  end

  @impl true
  def start(_type, _args) do
    MakeupSyntect.initialize_default_syntax_set()

    for %{name: name, codeblock_name: sanitized_name, extensions: extensions} <-
          languages_to_register_for() do
      Registry.register_lexer(MakeupSyntect.Lexer,
        options: [language: name],
        names: [name, sanitized_name],
        extensions: extensions
      )
    end

    children = []

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MakeupSyntect.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp languages_to_register_for do
    all_languages = MakeupSyntect.Syntaxes.all()

    case register_for_languages() do
      :all ->
        excluded_languages = excluded_languages()

        Enum.reject(all_languages, fn %{codeblock_name: name} -> name in excluded_languages end)

      languages ->
        Enum.filter(all_languages, fn %{codeblock_name: name} -> name in languages end)
    end
  end
end
