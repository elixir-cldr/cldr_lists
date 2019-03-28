defmodule Cldr.List do
  @moduledoc """
  Cldr module to formats lists.

  If we have a list of days like `["Monday", "Tuesday", "Wednesday"]`
  then we can format that list for a given locale by:

      iex> Cldr.List.to_string(["Monday", "Tuesday", "Wednesday"], TestBackend.Cldr, locale: "en")
      {:ok, "Monday, Tuesday, and Wednesday"}

  """

  @type pattern_type :: :or | :standard | :unit | :unit_narrow | :unit_short

  @doc """
  Formats a list into a string according to the list pattern rules for a locale.

  ## Arguments

  * `list` is any list of of terms that can be passed through `Kernel.to_string/1`

  * `options` is a keyword list

  ## Options

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale/0`

  * `format` is one of those returned by
    `Cldr.List.list_pattern_styles_for/2`. The default is `format: :standard`

  ## Examples

      iex> Cldr.List.to_string(["a", "b", "c"], TestBackend.Cldr, locale: "en")
      {:ok, "a, b, and c"}

      iex> Cldr.List.to_string(["a", "b", "c"], TestBackend.Cldr, locale: "en", format: :unit_narrow)
      {:ok, "a b c"}

      iex> Cldr.List.to_string(["a", "b", "c"], TestBackend.Cldr, locale: "fr")
      {:ok, "a, b et c"}

      iex> Cldr.List.to_string([1,2,3,4,5,6], TestBackend.Cldr)
      {:ok, "1, 2, 3, 4, 5, and 6"}

      iex> Cldr.List.to_string(["a"], TestBackend.Cldr)
      {:ok, "a"}

      iex> Cldr.List.to_string([1,2], TestBackend.Cldr)
      {:ok, "1 and 2"}

  """
  @spec to_string([term(), ...], Cldr.backend(), Keyword.t()) ::
          {:ok, String.t()} | {:error, {atom, binary}}

  def to_string(list, backend \\ Cldr.default_backend(), options \\ []) do
    module = Module.concat(backend, List)
    module.to_string(list, options)
  end

  @doc """
  Formats a list using `to_string/2` but raises if there is
  an error.

  ## Examples

      iex> Cldr.List.to_string!(["a", "b", "c"], TestBackend.Cldr, locale: "en")
      "a, b, and c"

      iex> Cldr.List.to_string!(["a", "b", "c"], TestBackend.Cldr, locale: "en", format: :unit_narrow)
      "a b c"

  """
  @spec to_string!([term(), ...], Cldr.backend(), Keyword.t()) :: String.t() | no_return()
  def to_string!(list, backend \\ Cldr.default_backend(), options \\ []) do
    module = Module.concat(backend, List)
    module.to_string!(list, options)
  end

  @doc """
  Intersperces a list elements into a list format according to the list
  pattern rules for a locale.

  This function can be helpful when creating a list from `Phoenix`
  safe strings which are of the format `{:safe, "some string"}`

  ## Arguments

  * `list` is any list of of terms

  * `options` is a keyword list

  ## Options

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale/1`

  * `format` is atom returned by
    `Cldr.List.list_pattern_styles_for/2`. The default is `:standard`

  ## Examples

      iex> Cldr.List.intersperse(["a", "b", "c"], TestBackend.Cldr, locale: "en")
      {:ok, ["a", ", ", "b", ", and ", "c"]}

      iex> Cldr.List.intersperse(["a", "b", "c"], TestBackend.Cldr, locale: "en", format: :unit_narrow)
      {:ok, ["a", " ", "b", " ", "c"]}

      iex> Cldr.List.intersperse(["a", "b", "c"], TestBackend.Cldr, locale: "fr")
      {:ok, ["a", ", ", "b", " et ", "c"]}

      iex> Cldr.List.intersperse([1,2,3,4,5,6], TestBackend.Cldr)
      {:ok, [1, ", ", 2, ", ", 3, ", ", 4, ", ", 5, ", and ", 6]}

      iex> Cldr.List.intersperse(["a"], TestBackend.Cldr)
      {:ok, ["a"]}

      iex> Cldr.List.intersperse([1,2], TestBackend.Cldr)
      {:ok, [1, " and ", 2]}

  """
  @spec intersperse(list(term()), Cldr.backend(), Keyword.t()) ::
          {:ok, list(String.t())} | {:error, {module(), String.t()}}

  def intersperse(list, backend \\ Cldr.default_backend(), options \\ []) do
    module = Module.concat(backend, List)
    module.intersperse(list, options)
  end

  @doc """
  Formats a list using `intersperse/2` but raises if there is
  an error.

  ## Examples

      iex> Cldr.List.intersperse!(["a", "b", "c"], TestBackend.Cldr, locale: "en")
      ["a", ", ", "b", ", and ", "c"]

      iex> Cldr.List.intersperse!(["a", "b", "c"], TestBackend.Cldr, locale: "en", format: :unit_narrow)
      ["a", " ", "b", " ", "c"]

  """
  @spec intersperse!(list(term()), Cldr.backend(), Keyword.t()) :: list(String.t()) | no_return()
  def intersperse!(list, backend \\ Cldr.default_backend(), options \\ []) do
    module = Module.concat(backend, List)
    module.intersperse!(list, options)
  end

  @doc """
  Returns the list patterns for a locale.

  List patterns provide rules for combining multiple
  items into a language format appropriate for a locale.

  ## Example

      iex> Cldr.List.list_patterns_for "en", TestBackend.Cldr
      %{
        or: %{
          "2": [0, " or ", 1],
          end: [0, ", or ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        or_narrow: %{
          "2": [0, " or ", 1],
          end: [0, ", or ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        or_short: %{
          "2": [0, " or ", 1],
          end: [0, ", or ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        standard: %{
          "2": [0, " and ", 1],
          end: [0, ", and ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        standard_narrow: %{
          "2": [0, ", ", 1],
          end: [0, ", ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        standard_short: %{
          "2": [0, " & ", 1],
          end: [0, ", & ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        unit: %{
          "2": [0, ", ", 1],
          end: [0, ", ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        unit_narrow: %{
          "2": [0, " ", 1],
          end: [0, " ", 1],
          middle: [0, " ", 1],
          start: [0, " ", 1]
        },
        unit_short: %{
          "2": [0, ", ", 1],
          end: [0, ", ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        }
      }

  """
  def list_patterns_for(locale, backend \\ Cldr.default_backend()) do
    module = Module.concat(backend, List)
    module.list_patterns_for(locale)
  end

  @doc """
  Returns the styles of list patterns available for a locale.

  Returns a list of `atom`s of of the list format styles that are
  available in CLDR for a locale.

  ## Example

      iex> Cldr.List.list_pattern_styles_for("en", TestBackend.Cldr)
      [:or, :or_narrow, :or_short, :standard, :standard_narrow,
        :standard_short, :unit, :unit_narrow, :unit_short]

  """
  def list_pattern_styles_for(locale, backend \\ Cldr.default_backend()) do
    module = Module.concat(backend, List)
    module.list_pattern_styles_for(locale)
  end
end
