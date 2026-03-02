defmodule Pbkdf2.Stats do
  @moduledoc """
  Module to provide statistics for the Pbkdf2 password hashing function.

  ## Configuring Pbkdf2

  The main configuration option for Pbkdf2 is the number of rounds that
  it uses. Increasing this value will increase the complexity, and time
  taken, of the Pbkdf2 function.

  Increasing the time that a password hash function takes makes it more
  difficult for an attacker to find the correct password. However, the
  amount of time a valid user has to wait also needs to be taken into
  consideration when setting the number of rounds.

  The correct number of rounds depends on circumstances specific to your
  use case, such as what level of security you want, how often the user
  has to log in, and the hardware you are using. However, for password
  hashing, we do not recommend setting the number of rounds to anything
  less than 100_000.
  """

  alias Pbkdf2.Base64

  @doc """
  Hash a password with Pbkdf2 and print out a report.

  This function hashes a password, and salt, with Pbkdf2.Base.hash_password/3
  and prints out statistics which can help you choose how to configure Pbkdf2.

  ## Options

  In addition to the options for Pbkdf2.Base.hash_password (rounds, output_fmt,
  digest and length), there are two options:

    * `:password` - the password used
      * the default is "password"
    * `:salt` - the salt used
      * the default is "somesaltSOMESALT"

  """
  def report(opts \\ []) do
    password = Keyword.get(opts, :password, "password")
    salt = Keyword.get(opts, :salt, "somesaltSOMESALT")
    {exec_time, encoded} = :timer.tc(Pbkdf2.Base, :hash_password, [password, salt, opts])

    Pbkdf2.verify_pass(password, encoded)
    |> format_result(encoded, exec_time)
  end

  defp format_result(check, encoded, exec_time) do
    [alg, rounds, _, hash] = String.split(encoded, "$", trim: true)

    IO.puts("""
    Digest:\t\t#{alg}
    Digest length:\t#{digest_length(encoded, hash)}
    Hash:\t\t#{encoded}
    Rounds:\t\t#{rounds}
    Time taken:\t#{format_time(exec_time)} seconds
    Verification #{if check, do: "OK", else: "FAILED"}
    """)
  end

  defp digest_length("$pbkdf2" <> _, hash), do: Base64.decode(hash) |> byte_size
  defp digest_length("pbkdf2" <> _, hash), do: Base.decode64!(hash) |> byte_size

  defp format_time(time) do
    Float.round(time / 1_000_000, 2)
  end
end
