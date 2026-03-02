defmodule Pbkdf2 do
  @moduledoc """
  Elixir wrapper for the Pbkdf2 password hashing function.

  For a lower-level API, see `Pbkdf2.Base`.

  ## Configuration

  The following parameter can be set in the config file:

    * `:rounds` - computational cost
      * the number of rounds
      * `160_000` is the default

  If you are hashing passwords in your tests, it can be useful to add
  the following to the `config/test.exs` file:

      # Note: Do not use this value in production
      config :pbkdf2_elixir,
        rounds: 1

  ## Pbkdf2

  Pbkdf2 is a password-based key derivation function
  that uses a password, a variable-length salt and an iteration
  count and applies a pseudorandom function to these to
  produce a key.

  The original implementation used SHA-1 as the pseudorandom function,
  but this version uses HMAC-SHA-512, the default, or HMAC-SHA-256.

  ## Warning

  It is recommended that you set a maximum length for the password
  when using Pbkdf2. This maximum length should not prevent valid users from setting
  long passwords. It is instead needed to combat denial-of-service attacks.
  As an example, Django sets the maximum length to `4096` bytes.
  For more information, see [this link](https://www.djangoproject.com/weblog/2013/sep/15/security/).
  """

  use Comeonin

  alias Pbkdf2.Base

  @doc """
  Hashes a password with a randomly generated salt.

  ## Options

  In addition to the options for `Pbkdf2.Base.gen_salt/1` (`:salt_len` and
  `:format`), this function also takes options that are then passed on to
  the `hash_password` function in the `Pbkdf2.Base` module.

  See the documentation for `Pbkdf2.Base.hash_password/3` for further details.

  ## Examples

  The following examples show how to hash a password with a randomly-generated
  salt and then verify a password:

      iex> hash = Pbkdf2.hash_pwd_salt("password")
      ...> Pbkdf2.verify_pass("password", hash)
      true

      iex> hash = Pbkdf2.hash_pwd_salt("password")
      ...> Pbkdf2.verify_pass("incorrect", hash)
      false

  The next examples show how to use some of the various available options:

      iex> hash = Pbkdf2.hash_pwd_salt("password", rounds: 100_000)
      ...> Pbkdf2.verify_pass("password", hash)
      true

      iex> hash = Pbkdf2.hash_pwd_salt("password", digest: :sha256)
      ...> Pbkdf2.verify_pass("password", hash)
      true

      iex> hash = Pbkdf2.hash_pwd_salt("password", digest: :sha256, format: :django)
      ...> Pbkdf2.verify_pass("password", hash)
      true

  """
  @impl true
  def hash_pwd_salt(password, opts \\ []) do
    Base.hash_password(password, Base.gen_salt(opts), opts)
  end

  @doc """
  Verifies a password by hashing the password and comparing the hashed value
  with a stored hash.

  See the documentation for `hash_pwd_salt/2` for examples of using this function.
  """
  @impl true
  def verify_pass(password, stored_hash) do
    [alg, rounds, salt, hash] = String.split(stored_hash, "$", trim: true)
    digest = if alg =~ "sha512", do: :sha512, else: :sha256
    Base.verify_pass(password, hash, salt, digest, rounds, output(stored_hash))
  end

  defp output("$pbkdf2" <> _), do: :modular
  defp output("pbkdf2" <> _), do: :django
end
