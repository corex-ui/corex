alias E2e.Accounts

signature = "M0,0L1,1Z"

user_attrs = %{
  birth_date: ~D[1990-01-15],
  country: "some country",
  name: "some name",
  signature: signature,
  terms: true
}

admin_attrs = %{
  birth_date: ~D[1990-01-15],
  country: :fra,
  name: "some name",
  signature: signature,
  terms: true
}

{:ok, _} = Accounts.create_user(user_attrs)
{:ok, _} = Accounts.create_user(Map.put(user_attrs, :name, "Bob"))
{:ok, _} = Accounts.create_admin(admin_attrs)
{:ok, _} = Accounts.create_admin(Map.put(admin_attrs, :name, "Admin Bob"))
