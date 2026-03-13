defmodule Pbkdf2.Tools do
  @moduledoc false

  import Bitwise

  @allowed_chars ~c"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

  def get_random_string(len, allowed_chars \\ @allowed_chars) do
    :crypto.rand_seed()
    high = length(allowed_chars)

    Enum.to_list(1..len)
    |> Enum.reduce([], fn _x, acc ->
      [Enum.at(allowed_chars, :rand.uniform(high) - 1)] ++ acc
    end)
    |> to_string()
  end

  def check_salt_length(salt_len) when salt_len < 8 do
    IO.warn(
      "Using a salt less than 8 bytes long is not recommended. " <>
        "Please see the documentation for details."
    )

    :ok
  end

  def check_salt_length(salt_len) when salt_len > 1024 do
    raise ArgumentError, """
    The salt is too long. The maximum length is 1024 bytes.
    """
  end

  def check_salt_length(_), do: :ok

  def secure_check(hash, stored) do
    if byte_size(hash) == byte_size(stored) do
      secure_check(hash, stored, 0) == 0
    else
      false
    end
  end

  defp secure_check(<<h, rest_h::binary>>, <<s, rest_s::binary>>, acc) do
    secure_check(rest_h, rest_s, acc ||| bxor(h, s))
  end

  defp secure_check("", "", acc) do
    acc
  end
end
