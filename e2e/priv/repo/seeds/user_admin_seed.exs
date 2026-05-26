alias E2e.Accounts
alias E2e.Place

signature = ["M0,0L1,1Z"]

for {id, name, code, country} <- [
      {"seed-par", "Paris", "PAR", "FR"},
      {"seed-lon", "London", "LON", "GB"},
      {"seed-ber", "Berlin", "BER", "DE"},
      {"seed-mad", "Madrid", "MAD", "ES"},
      {"seed-rom", "Rome", "ROM", "IT"},
      {"seed-ams", "Amsterdam", "AMS", "NL"},
      {"seed-vie", "Vienna", "VIE", "AT"},
      {"seed-lis", "Lisbon", "LIS", "PT"},
      {"seed-dub", "Dublin", "DUB", "IE"},
      {"seed-bru", "Brussels", "BRU", "BE"},
      {"seed-zrh", "Zurich", "ZRH", "CH"},
      {"seed-osl", "Oslo", "OSL", "NO"},
      {"seed-cph", "Copenhagen", "CPH", "DK"},
      {"seed-ath", "Athens", "ATH", "GR"}
    ] do
  Place.create_city(%{id: id, name: name, iata_code: code, iata_country_code: country})
end

user_attrs = %{
  birth_date: ~D[1990-01-15],
  country: "some country",
  name: "some name",
  signature: signature,
  terms: true,
  level: 5,
  currency: "eur",
  tags: ["alpha", "beta"]
}

admin_attrs = %{
  birth_date: ~D[1990-01-15],
  country: :fra,
  name: "some name",
  signature: signature,
  terms: true,
  level: 5,
  currency: "eur",
  tags: ["alpha", "beta"]
}

{:ok, _} = Accounts.create_user(user_attrs)
{:ok, _} = Accounts.create_user(Map.put(user_attrs, :name, "Bob"))
{:ok, _} = Accounts.create_admin(admin_attrs)
{:ok, _} = Accounts.create_admin(Map.put(admin_attrs, :name, "Admin Bob"))
