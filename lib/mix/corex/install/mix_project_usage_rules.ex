defmodule Mix.Corex.Install.MixProjectUsageRules do
  @moduledoc false

  @defp Enum.join(
          [
            "  defp usage_rules do",
            "    [",
            "      skills: [",
            "        location: \".claude/skills\",",
            "        package_skills: [:corex]",
            "      ]",
            "    ]",
            "  end"
          ],
          "\n"
        )

  @spec apply(String.t()) :: String.t()
  def apply(content) when is_binary(content) do
    if idempotent?(content) do
      content
    else
      content
      |> add_project_key()
      |> add_defp()
    end
  end

  defp idempotent?(content) do
    String.contains?(content, "defp usage_rules do") or
      Regex.match?(~r/usage_rules:\s*usage_rules\(\)/, content)
  end

  defp add_project_key(content) do
    if Regex.match?(~r/usage_rules:\s*usage_rules\(\)/, content) do
      content
    else
      Regex.replace(
        ~r/^(\s*)deps: deps\(\),/um,
        content,
        fn line, indent -> line <> "\n" <> indent <> "usage_rules: usage_rules()," end
      )
    end
  end

  defp add_defp(content) do
    if String.contains?(content, "defp usage_rules do") do
      content
    else
      case :binary.matches(content, "\n  end\nend") do
        [] ->
          content

        matches ->
          {start, len} = List.last(matches)
          before = binary_part(content, 0, start)
          after_match = binary_part(content, start + len, byte_size(content) - start - len)
          before <> "\n" <> "  end\n" <> @defp <> "\nend" <> after_match
      end
    end
  end
end
