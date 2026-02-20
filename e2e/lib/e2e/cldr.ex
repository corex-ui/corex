defmodule E2e.Cldr do
  use Cldr,
    locales: [:en],
    providers: [Cldr.Territory]
end
