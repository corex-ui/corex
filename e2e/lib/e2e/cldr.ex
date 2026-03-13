defmodule E2e.Cldr do
  use Cldr,
    default_locale: "en",
    locales: ["en", "ar"],
    providers: [Cldr.Language, Cldr.Territory]
end
