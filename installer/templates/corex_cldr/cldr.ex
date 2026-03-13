defmodule <%= @app_module %>.Cldr do
  use Cldr,
    default_locale: "<%= @default_locale %>",
    locales: <%= inspect(@locales) %>,
    providers: [Cldr.Language, Cldr.Territory]
end
