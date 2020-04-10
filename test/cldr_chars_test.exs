defmodule Cldr.List.CharsTest do
  use ExUnit.Case, async: true

  test "to_string on a list" do
    assert Cldr.to_string(["a", "b"]) == "a and b"
  end

end