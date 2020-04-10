defmodule Cldr.List.Test do
  use ExUnit.Case
  alias Cldr.List

  describe "to_string/2" do
    test "that three element lists format correctly" do
      assert List.to_string([1, 2, 3], MyApp.Cldr) == {:ok, "1, 2, and 3"}
    end

    test "that two element lists format correctly" do
      assert List.to_string([1, 2], MyApp.Cldr) == {:ok, "1 and 2"}
    end

    test "that one element lists format correctly" do
      assert List.to_string([1], MyApp.Cldr) == {:ok, "1"}
    end

    test "that empty lists format correctly" do
      assert List.to_string([], MyApp.Cldr) == {:ok, ""}
    end

    test "that :format keyword works correctly" do
      assert List.to_string([1, 2], MyApp.Cldr, format: :standard_narrow) == {:ok, "1, 2"}
    end

    test "that :style keyword works correctly" do
      assert List.to_string([1, 2], MyApp.Cldr, style: :standard_narrow) == {:ok, "1, 2"}
    end

    test "a bad format returns an error" do
      assert List.to_string([1, 2, 3], MyApp.Cldr, format: :jabberwocky) ==
               {:error,
                {Cldr.UnknownFormatError, "The list style :jabberwocky is not known."}}
    end

    test "a bad locale returns an error" do
      assert List.to_string([1, 2, 3], MyApp.Cldr, locale: "nothing") ==
               {:error, {Cldr.UnknownLocaleError, "The locale \"nothing\" is not known."}}
    end

    test "that an invalid format raises" do
      assert_raise Cldr.UnknownFormatError, fn ->
        List.to_string!([1, 2, 3], MyApp.Cldr, format: :jabberwocky)
      end
    end
  end

  describe "intersperse/2" do
    test "that three element lists format correctly" do
      assert List.intersperse([1, 2, 3], MyApp.Cldr) == {:ok, [1, ", ", 2, ", and ", 3]}
    end

    test "that two element lists format correctly" do
      assert List.intersperse([1, 2], MyApp.Cldr) == {:ok, [1, " and ", 2]}
    end

    test "that one element lists format correctly" do
      assert List.intersperse([1], MyApp.Cldr) == {:ok, [1]}
    end

    test "that empty lists format correctly" do
      assert List.intersperse([], MyApp.Cldr) == {:ok, []}
    end

    test "a bad format returns an error" do
      assert List.intersperse([1, 2, 3], MyApp.Cldr, format: :jabberwocky) ==
               {:error,
                {Cldr.UnknownFormatError, "The list style :jabberwocky is not known."}}
    end

    test "a bad locale returns an error" do
      assert List.intersperse([1, 2, 3], MyApp.Cldr, locale: "nothing") ==
               {:error, {Cldr.UnknownLocaleError, "The locale \"nothing\" is not known."}}
    end

    test "that an invalid format raises" do
      assert_raise Cldr.UnknownFormatError, fn ->
        List.intersperse!([1, 2, 3], MyApp.Cldr, format: :jabberwocky)
      end
    end
  end

  if function_exported?(Code, :fetch_docs, 1) do
    describe "doc generation" do
      test "that no module docs are generated for a backend" do
        assert {:docs_v1, _, :elixir, _, :hidden, %{}, _} = Code.fetch_docs(NoDocs.Cldr)
      end

      assert "that module docs are generated for a backend" do
        {:docs_v1, _, :elixir, "text/markdown", _, %{}, _} = Code.fetch_docs(MyApp.Cldr)
      end
    end
  end
end
