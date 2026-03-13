defmodule MakeupSyntect do
  @moduledoc """
  MakeupSyntect is an adapter for Makeup, providing syntax highlighting using the [syntect](https://docs.rs/syntect/latest/syntect/) Rust library.

  More syntax definitions are included using [two-face](https://docs.rs/two-face/latest/two_face/).

  For a list of supported langugages, see: `MakeupSyntect.Syntaxes`.
  """

  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :makeup_syntect,
    crate: "makeup_syntect",
    base_url: "https://github.com/elixir-makeup/makeup_syntect/releases/download/v#{version}",
    force_build: System.get_env("MAKEUP_SYNTECT_BUILD") in ["1", "true"],
    version: version

  @syntax_set_key :makeup_syntect_syntax_set

  @doc """
  Tokenizes the given text using syntect.

  ## Parameters
    - text: The source code text to tokenize
    - opts: Optional keyword list of options
      - language: Optional language identifier (e.g. "rust", "html", "javascript")
      - syntax_set: Optional syntax set resource (created via initialize_syntaxes_from_folders)
  """
  def tokenize(text, opts \\ []) do
    language = Keyword.get(opts, :language)
    syntax_set = Keyword.get(opts, :syntax_set, :persistent_term.get(@syntax_set_key, nil))
    do_tokenize(text, language, syntax_set)
  end

  @doc """
  Initializes a syntax set from the given folders. Returns a reference that can be used
  in tokenize calls to avoid rebuilding the syntax set each time.
  """
  def initialize_syntaxes_from_folders(_folders), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  # Initializes and stores the default syntax set in persistent_term.
  # Should be called during application startup.
  def initialize_default_syntax_set(folders \\ []) do
    syntax_set =
      initialize_syntaxes_from_folders(
        [
          Application.app_dir(:makeup_syntect, "priv/extra_syntaxes")
        ] ++ Application.get_env(:makeup_syntect, :extra_syntax_folders, []) ++ folders
      )

    :persistent_term.put(@syntax_set_key, syntax_set)
  end

  @doc false
  def supported_syntaxes() do
    get_supported_syntaxes(:persistent_term.get(@syntax_set_key, nil))
  end

  # NIF implementations
  @doc false
  def do_tokenize(_text, _language, _syntax_set), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  def get_supported_syntaxes(_syntax_set), do: :erlang.nif_error(:nif_not_loaded)
end
