defmodule Cldr.List do
  @moduledoc """
  `Cldr` incudes patterns that enable list to be catenated together
  to form a grammatically correct language construct for a given locale.

  If we have a list of days like `["Monday", "Tuesday", "Wednesday"]`
  then we can format that list for a given locale by:

      iex> Cldr.List.to_string(["Monday", "Tuesday", "Wednesday"], locale: "en")
      {:ok, "Monday, Tuesday, and Wednesday"}
  """

  require Cldr
  alias Cldr.Substitution

  @type string_list :: list(String.Chars.t())
  @type pattern_type :: :or | :standard | :unit | :unit_narrow | :unit_short
  @default_style :standard

  @doc """
  Formats a list into a string according to the list pattern rules for a locale.

  * `list` is any list of of terms that can be passed through `Kernel.to_string/1`

  * `options` are:

    * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale/0`

    * `format` is one of those returned by
    `Cldr.List.list_pattern_types_for/1`. The default is `format: :standard`

  ## Examples

      iex> Cldr.List.to_string(["a", "b", "c"], locale: "en")
      {:ok, "a, b, and c"}

      iex> Cldr.List.to_string(["a", "b", "c"], locale: "en", format: :unit_narrow)
      {:ok, "a b c"}

      iex> Cldr.List.to_string(["a", "b", "c"], locale: "fr")
      {:ok, "a, b et c"}

      iex> Cldr.List.to_string([1,2,3,4,5,6])
      {:ok, "1, 2, 3, 4, 5, and 6"}

      iex> Cldr.List.to_string(["a"])
      {:ok, "a"}

      iex> Cldr.List.to_string([1,2])
      {:ok, "1 and 2"}
  """
  @spec to_string(Cldr.List.string_list(), Keyword.t()) ::
          {:ok, String.t()} | {:error, {atom, binary}}
  def to_string(list, options \\ [])

  def to_string([], _options) do
    {:ok, ""}
  end

  def to_string(list, options) do
    case normalize_options(options) do
      {:error, {_exception, _message}} = error ->
        error

      {locale, format} ->
        {:ok, :erlang.iolist_to_binary(to_string(list, locale, format))}
    end
  end

  @doc """
  Formats a list using `to_string/2` but raises if there is
  an error.

  ## Examples

      iex> Cldr.List.to_string!(["a", "b", "c"], locale: "en")
      "a, b, and c"

      iex> Cldr.List.to_string!(["a", "b", "c"], locale: "en", format: :unit_narrow)
      "a b c"
  """
  @spec to_string!(Cldr.List.string_list(), Keyword.t()) :: String.t() | Exception.t()
  def to_string!(list, options \\ []) do
    case to_string(list, options) do
      {:error, {exception, message}} ->
        raise exception, message

      {:ok, string} ->
        string
    end
  end

  # For when the list is empty
  defp to_string([], _locale, _pattern_type) do
    ""
  end

  # For when there is one element only
  defp to_string([first], _locale, _pattern_type) do
    Kernel.to_string(first)
  end

  # For when there are two elements only
  defp to_string([first, last], locale, pattern_type) do
    pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:"2"]

    Substitution.substitute([first, last], pattern)
    |> :erlang.iolist_to_binary()
  end

  # For when there are three elements only
  defp to_string([first, middle, last], locale, pattern_type) do
    first_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:start]
    last_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:end]

    last = Substitution.substitute([middle, last], last_pattern)
    Substitution.substitute([first, last], first_pattern)
  end

  # For when there are more than 3 elements
  defp to_string([first | rest], locale, pattern_type) do
    first_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:start]

    Substitution.substitute([first, do_to_string(rest, locale, pattern_type)], first_pattern)
  end

  # When there are only two left (ie last)
  defp do_to_string([first, last], locale, pattern_type) do
    last_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:end]

    Substitution.substitute([first, last], last_pattern)
  end

  # For the middle elements
  defp do_to_string([first | rest], locale, pattern_type) do
    middle_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:middle]

    Substitution.substitute([first, do_to_string(rest, locale, pattern_type)], middle_pattern)
  end

  @doc """
  Formats a list into a string according to the list pattern rules for a locale.

  * `list` is any list

  * `options` are:

    * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale/0`

    * `format` is one of those returned by
    `Cldr.List.list_pattern_types_for/1`. The default is `format: :standard`

  ## Examples

      iex> Cldr.List.intersperse(["a", 1, :ok], locale: "en")
      {:ok, ["a", ", ", 1, ", and ", :ok]}

      iex> Cldr.List.intersperse(["a", 1, :ok], locale: "en", format: :unit_narrow)
      {:ok, ["a", " ", 1, " ", :ok]}

      iex> Cldr.List.intersperse(["a", 1, :ok], locale: "fr")
      {:ok, ["a", ", ", 1, " et ", :ok]}

      iex> Cldr.List.intersperse(["a", 1, 2, 3, :ok])
      {:ok, ["a", ", ", 1, ", ", 2, ", ", 3, ", and ", :ok]}

      iex> Cldr.List.intersperse(["a"])
      {:ok, ["a"]}

      iex> Cldr.List.intersperse(["a", 1])
      {:ok, ["a", " and ", 1]}
  """
  @spec intersperse(list(), Keyword.t()) :: {:ok, list()} | {:error, {atom, binary}}
  def intersperse(list, options \\ [])

  def intersperse([], _options) do
    {:ok, []}
  end

  def intersperse(list, options) do
    case normalize_options(options) do
      {:error, {_exception, _message}} = error ->
        error

      {locale, format} ->
        {:ok, List.flatten(intersperse(list, locale, format))}
    end
  end

  @doc """
  Formats a list using `to_string/2` but raises if there is
  an error.

  ## Examples

      iex> Cldr.List.intersperse!(["a", 1, :ok], locale: "en")
      ["a", ", ", 1, ", and ", :ok]

      iex> Cldr.List.intersperse!(["a", 1, :ok], locale: "en", format: :unit_narrow)
      ["a", " ", 1, " ", :ok]
  """
  @spec intersperse!(list(), Keyword.t()) :: list | Exception.t()
  def intersperse!(list, options \\ []) do
    case intersperse(list, options) do
      {:error, {exception, message}} ->
        raise exception, message

      {:ok, string} ->
        string
    end
  end

  # For when the list is empty
  defp intersperse([], _locale, _pattern_type) do
    []
  end

  # For when there is one element only
  defp intersperse([_] = list, _locale, _pattern_type) do
    list
  end

  # For when there are two elements only
  defp intersperse([first, last], locale, pattern_type) do
    pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:"2"]

    list_substitute([first, last], pattern)
    |> List.flatten()
  end

  # For when there are three elements only
  defp intersperse([first, middle, last], locale, pattern_type) do
    first_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:start]
    last_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:end]

    last = list_substitute([middle, last], last_pattern)
    list_substitute([first, last], first_pattern)
  end

  # For when there are more than 3 elements
  defp intersperse([first | rest], locale, pattern_type) do
    first_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:start]

    list_substitute([first, do_intersperse(rest, locale, pattern_type)], first_pattern)
  end

  # When there are only two left (ie last)
  defp do_intersperse([first, last], locale, pattern_type) do
    last_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:end]

    list_substitute([first, last], last_pattern)
  end

  # For the middle elements
  defp do_intersperse([first | rest], locale, pattern_type) do
    middle_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:middle]

    list_substitute([first, do_intersperse(rest, locale, pattern_type)], middle_pattern)
  end

  # Takes care of a common case where there is one parameter
  def list_substitute([item], [0, string]) when is_binary(string) do
    [item, string]
  end

  def list_substitute(item, [0, string]) when is_binary(string) do
    [item, string]
  end

  def list_substitute(item, [string, 0]) when is_binary(string) do
    [string, item]
  end

  def list_substitute(item, [string1, 0, string2])
      when is_binary(string1) and is_binary(string2) do
    [string1, item, string2]
  end

  # Takes care of the common case where there are two parameters separated
  # by a string.
  def list_substitute([item_0, item_1], [0, string, 1]) when is_binary(string) do
    [item_0, string, item_1]
  end

  def list_substitute([item_0, item_1], [1, string, 0]) when is_binary(string) do
    [item_1, string, item_0]
  end

  # Takes care of the common case where there are three parameters separated
  # by strings.
  def list_substitute([item_0, item_1, item_2], [0, string_1, 1, string_2, 2]) do
    [item_0, string_1, item_1, string_2, item_2]
  end

  @spec list_patterns_for(Cldr.locale()) :: Map.t()
  @spec list_pattern_styles_for(Cldr.locale()) :: [atom]
  for locale_name <- Cldr.known_locale_names() do
    patterns = Cldr.Config.get_locale(locale_name).list_formats
    pattern_names = Map.keys(patterns)

    @doc """
    Returns the list patterns for a locale.

    List patterns provide rules for combining multiple
    items into a language format appropriate for a locale.

    ## Example

        iex> Cldr.List.list_patterns_for "en"
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
            "2": [0, " and ", 1],
            end: [0, ", and ", 1],
            middle: [0, ", ", 1],
            start: [0, ", ", 1]
          },
          standard_short: %{
            "2": [0, " and ", 1],
            end: [0, ", and ", 1],
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
    def list_patterns_for(unquote(locale_name)) do
      unquote(Macro.escape(patterns))
    end

    @doc """
    Returns the styles of list patterns available for a locale.

    Returns a list of `atom`s of of the list format styles that are
    available in CLDR for a locale.

    ## Example

        iex> Cldr.List.list_pattern_styles_for("en")
        [:or, :or_narrow, :or_short, :standard, :standard_narrow, :standard_short, :unit, :unit_narrow, :unit_short]

    """
    def list_pattern_styles_for(unquote(locale_name)) do
      unquote(pattern_names)
    end
  end

  defp normalize_options(options) do
    locale = options[:locale] || Cldr.get_current_locale()
    format = options[:format] || @default_style

    with {:ok, locale} <- Cldr.validate_locale(locale),
         {:ok, _} <- verify_format(locale.cldr_locale_name, format) do
      {locale, format}
    else
      {:error, {_exception, _message}} = error -> error
    end
  end

  defp verify_format(locale_name, format) do
    if !(format in list_pattern_styles_for(locale_name)) do
      {:error,
       {Cldr.UnknownFormatError, "The list format style #{inspect(format)} is not known."}}
    else
      {:ok, format}
    end
  end
end
