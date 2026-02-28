defmodule CorexTest do
  use CorexTest.ComponentCase, async: true

  describe "__using__/1" do
    test "with default opts imports all components" do
      defmodule AllComponents do
        use Corex

        def try_code(assigns), do: code(assigns)
      end

      result = render_component(&AllComponents.try_code/1, code: "def x, do: 1")
      assert is_binary(to_string(result))
    end

    test "with only: [code] imports only specified component" do
      defmodule OnlyCode do
        use Corex, only: [:code]

        def try_code(assigns), do: code(assigns)
      end

      result = render_component(&OnlyCode.try_code/1, code: "x")
      assert is_binary(to_string(result))

      assert_raise UndefinedFunctionError, fn ->
        apply(OnlyCode, :action, [%{}])
      end
    end

    test "with except: [code] excludes specified component" do
      defmodule ExceptCode do
        use Corex, except: [:code]

        def try_hidden_input(assigns), do: hidden_input(assigns)
      end

      result = render_component(&ExceptCode.try_hidden_input/1, id: "x", name: "x", value: "x")
      assert is_binary(to_string(result))

      assert_raise UndefinedFunctionError, fn ->
        apply(ExceptCode, :code, [%{code: "x"}])
      end
    end

    test "with prefix generates prefixed functions" do
      defmodule PrefixedComponents do
        use Corex, prefix: "corex", only: [:code]

        def try_code(assigns), do: corex_code(assigns)
      end

      result = render_component(&PrefixedComponents.try_code/1, code: "x")
      assert is_binary(to_string(result))

      assert_raise UndefinedFunctionError, fn ->
        apply(PrefixedComponents, :code, [%{code: "x"}])
      end
    end
  end
end
