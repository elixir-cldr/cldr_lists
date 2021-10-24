defmodule Cldr.List do
  @moduledoc """
  Cldr module to formats lists.

  If we have a list of days like `["Monday", "Tuesday", "Wednesday"]`
  then we can format that list for a given locale by:

      iex> Cldr.List.to_string(["Monday", "Tuesday", "Wednesday"], MyApp.Cldr, locale: "en")
      {:ok, "Monday, Tuesday, and Wednesday"}

  """

  @type pattern_type :: :or | :or_narrow | :or_short | :standard | :standard_narrow |
                        :standard_short | :unit | :unit_narrow | :unit_short

  @doc """
  Formats a list into a string according to the list pattern rules for a locale.

  ## Arguments

  * `list` is any list of of terms that can be passed through `Kernel.to_string/1`

  * `options` is a keyword list

  ## Options

  * `:locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_locale/1`

  * `:format` is one of those returned by
    `Cldr.List.known_list_formats/0`. The default is `format: :standard`

  ## Examples

      iex> Cldr.List.to_string(["a", "b", "c"], MyApp.Cldr, locale: "en")
      {:ok, "a, b, and c"}

      iex> Cldr.List.to_string(["a", "b", "c"], MyApp.Cldr, locale: "en", format: :unit_narrow)
      {:ok, "a b c"}

      iex> Cldr.List.to_string(["a", "b", "c"], MyApp.Cldr, locale: "fr")
      {:ok, "a, b et c"}

      iex> Cldr.List.to_string([1,2,3,4,5,6], MyApp.Cldr)
      {:ok, "1, 2, 3, 4, 5, and 6"}

      iex> Cldr.List.to_string(["a"], MyApp.Cldr)
      {:ok, "a"}

      iex> Cldr.List.to_string([1,2], MyApp.Cldr)
      {:ok, "1 and 2"}

  """
  @spec to_string([term(), ...], Cldr.backend() | Keyword.t(), Keyword.t()) ::
          {:ok, String.t()} | {:error, {atom, binary}}

  def to_string(list, backend \\ default_backend(), options \\ [])

  def to_string(list, options, []) when is_list(options) do
    {backend, options} = Keyword.pop(options, :backend, default_backend())
    to_string(list, backend, options)
  end

  def to_string(list, backend, options) do
    module = Module.concat(backend, List)
    module.to_string(list, options)
  end

  @doc """
  Formats a list using `to_string/2` but raises if there is
  an error.

  ## Examples

      iex> Cldr.List.to_string!(["a", "b", "c"], MyApp.Cldr, locale: "en")
      "a, b, and c"

      iex> Cldr.List.to_string!(["a", "b", "c"], MyApp.Cldr, locale: "en", format: :unit_narrow)
      "a b c"

  """
  @spec to_string!([term(), ...], Cldr.backend() | Keyword.t(), Keyword.t()) :: String.t() | no_return()

  def to_string!(list, backend \\ default_backend(), options \\ [])

  def to_string!(list, options, []) when is_list(options) do
    {_locale, backend} = Cldr.locale_and_backend_from(options)
    to_string!(list, backend, options)
  end

  def to_string!(list, backend, options) do
    {_locale, backend} = Cldr.locale_and_backend_from(options[:locale], backend)
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

  * `:locale` is any configured locale. See `Cldr.known_locale_names/1`. The default
    is `locale: Cldr.get_locale/1`

  * `:format` is atom returned by
    `Cldr.List.known_list_formats/0`. The default is `:standard`

  ## Examples

      iex> Cldr.List.intersperse(["a", "b", "c"], MyApp.Cldr, locale: "en")
      {:ok, ["a", ", ", "b", ", and ", "c"]}

      iex> Cldr.List.intersperse(["a", "b", "c"], MyApp.Cldr, locale: "en", format: :unit_narrow)
      {:ok, ["a", " ", "b", " ", "c"]}

      iex> Cldr.List.intersperse(["a", "b", "c"], MyApp.Cldr, locale: "fr")
      {:ok, ["a", ", ", "b", " et ", "c"]}

      iex> Cldr.List.intersperse([1,2,3,4,5,6], MyApp.Cldr)
      {:ok, [1, ", ", 2, ", ", 3, ", ", 4, ", ", 5, ", and ", 6]}

      iex> Cldr.List.intersperse(["a"], MyApp.Cldr)
      {:ok, ["a"]}

      iex> Cldr.List.intersperse([1,2], MyApp.Cldr)
      {:ok, [1, " and ", 2]}

  """
  @spec intersperse(list(term()), Cldr.backend(), Keyword.t()) ::
          {:ok, list(String.t())} | {:error, {module(), String.t()}}

  def intersperse(list, backend \\ nil, options \\ [])

  def intersperse(list, options, []) when is_list(options) do
    {_locale, backend} = Cldr.locale_and_backend_from(options)
    module = Module.concat(backend, List)
    module.intersperse(list, options)
  end

  def intersperse(list, backend, options) do
    {_locale, backend} = Cldr.locale_and_backend_from(options[:locale], backend)

    module = Module.concat(backend, List)
    module.intersperse(list, options)
  end

  @doc """
  Formats a list using `intersperse/2` but raises if there is
  an error.

  ## Examples

      iex> Cldr.List.intersperse!(["a", "b", "c"], MyApp.Cldr, locale: "en")
      ["a", ", ", "b", ", and ", "c"]

      iex> Cldr.List.intersperse!(["a", "b", "c"], MyApp.Cldr, locale: "en", format: :unit_narrow)
      ["a", " ", "b", " ", "c"]

  """
  @spec intersperse!(list(term()), Cldr.backend(), Keyword.t()) :: list(String.t()) | no_return()

  def intersperse!(list, backend \\ nil, options \\ []) do
    {_locale, backend} = Cldr.locale_and_backend_from(options[:locale], backend)

    module = Module.concat(backend, List)
    module.intersperse!(list, options)
  end

  @doc """
  Returns the list patterns for a locale.

  List patterns provide rules for combining multiple
  items into a language format appropriate for a locale.

  ## Example

      iex> Cldr.List.list_patterns_for "en", MyApp.Cldr
      %{
        or: %{
          2 => [0, " or ", 1],
          end: [0, ", or ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        or_narrow: %{
          2 => [0, " or ", 1],
          end: [0, ", or ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        or_short: %{
          2 => [0, " or ", 1],
          end: [0, ", or ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        standard: %{
          2 => [0, " and ", 1],
          end: [0, ", and ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        standard_narrow: %{
          2 => [0, ", ", 1],
          end: [0, ", ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        standard_short: %{
          2 => [0, " & ", 1],
          end: [0, ", & ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        unit: %{
          2 => [0, ", ", 1],
          end: [0, ", ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        },
        unit_narrow: %{
          2 => [0, " ", 1],
          end: [0, " ", 1],
          middle: [0, " ", 1],
          start: [0, " ", 1]
        },
        unit_short: %{
          2 => [0, ", ", 1],
          end: [0, ", ", 1],
          middle: [0, ", ", 1],
          start: [0, ", ", 1]
        }
      }

  """

  def list_patterns_for(locale, backend \\ default_backend()) do
    {locale, backend} = Cldr.locale_and_backend_from(locale, backend)

    module = Module.concat(backend, List)
    module.list_patterns_for(locale)
  end

  @doc """
  Returns the formats of list patterns available for a locale.

  Returns a list of `atom`s of of the list formats that are
  available in CLDR for a locale.

  ## Example

      iex> Cldr.List.list_formats_for("en", MyApp.Cldr)
      [:or, :or_narrow, :or_short, :standard, :standard_narrow,
        :standard_short, :unit, :unit_narrow, :unit_short]

  """

  def list_formats_for(locale, backend \\ nil) do
    {locale, backend} = Cldr.locale_and_backend_from(locale, backend)

    module = Module.concat(backend, List)
    module.list_formats_for(locale)
  end

  @deprecated "Use Cldr.List.list_formats_for/2"
  defdelegate list_styles_for(locale, backend), to: __MODULE__, as: :list_formats_for

  # TODO Remove at version 3.0
  @doc false
  defdelegate list_pattern_styles_for(locale, backend), to: __MODULE__, as: :list_formats_for


  @doc """
  Return the list of known list formats.

  ## Example

      iex> Cldr.List.known_list_formats()
      [:or, :or_narrow, :or_short, :standard, :standard_narrow,
        :standard_short, :unit, :unit_narrow, :unit_short]

  """
  @root_locale Cldr.Config.root_locale_name()
  @config %Cldr.Config{locales: [@root_locale]}
  @known_list_formats Cldr.Locale.Loader.get_locale(@root_locale, @config)
    |> Map.get(:list_formats) |> Map.keys

  def known_list_formats do
    @known_list_formats
  end

  @deprecated "Use Cldr.List.known_list_formats/0"
  def known_list_styles do
    known_list_formats()
  end

  @doc false
  # TODO remove for Cldr 3.0
  if Code.ensure_loaded?(Cldr) && function_exported?(Cldr, :default_backend!, 0) do
    def default_backend do
      Cldr.default_backend!()
    end
  else
    def default_backend do
      Cldr.default_backend()
    end
  end
end
