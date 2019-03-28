defmodule Cldr.List.Backend do
  def define_list_module(config) do
    module = inspect(__MODULE__)
    backend = config.backend
    config = Macro.escape(config)

    quote location: :keep, bind_quoted: [module: module, backend: backend, config: config] do
      defmodule List do
        @moduledoc false
        if Cldr.Config.include_module_docs?(config.generate_docs) do
          @moduledoc """
          Cldr backend module that formats lists.

          If we have a list of days like `["Monday", "Tuesday", "Wednesday"]`
          then we can format that list for a given locale by:

              iex> #{inspect __MODULE__}.to_string(["Monday", "Tuesday", "Wednesday"], locale: "en")
              {:ok, "Monday, Tuesday, and Wednesday"}

          """
        end

        @default_style :standard
        alias Cldr.Substitution

        @doc """
        Formats a list into a string according to the list pattern rules for a locale.

        ## Arguments

        * `list` is any list of of terms that can be passed through `Kernel.to_string/1`

        * `options` is a keyword list

        ## Options

        * `locale` is any configured locale. See `Cldr.known_locales()`. The default
          is `locale: Cldr.get_current_locale/0`

        * `format` is one of those returned by
          `Cldr.List.list_pattern_types_for/1`. The default is `format: :standard`

        ## Examples

            iex> #{inspect __MODULE__}.to_string(["a", "b", "c"], locale: "en")
            {:ok, "a, b, and c"}

            iex> #{inspect __MODULE__}.to_string(["a", "b", "c"], locale: "en", format: :unit_narrow)
            {:ok, "a b c"}

            iex> #{inspect __MODULE__}.to_string(["a", "b", "c"], locale: "fr")
            {:ok, "a, b et c"}

            iex> #{inspect __MODULE__}.to_string([1,2,3,4,5,6])
            {:ok, "1, 2, 3, 4, 5, and 6"}

            iex> #{inspect __MODULE__}.to_string(["a"])
            {:ok, "a"}

            iex> #{inspect __MODULE__}.to_string([1,2])
            {:ok, "1 and 2"}

        """
        @spec to_string(list(term()), Keyword.t()) ::
                {:ok, String.t()} | {:error, {module(), String.t()}}

        def to_string(list, options \\ []) do
          with {:ok, list} <- intersperse(list, options) do
            string =
              list
              |> Enum.map(&to_string/1)
              |> :erlang.iolist_to_binary

            {:ok, string}
          end
        end

        @doc """
        Formats a list using `to_string/2` but raises if there is
        an error.

        ## Examples

            iex> #{inspect __MODULE__}.to_string!(["a", "b", "c"], locale: "en")
            "a, b, and c"

            iex> #{inspect __MODULE__}.to_string!(["a", "b", "c"], locale: "en", format: :unit_narrow)
            "a b c"

        """
        @spec to_string!(list(term()), Keyword.t()) :: String.t() | no_return()
        def to_string!(list, options \\ []) do
          case to_string(list, options) do
            {:error, {exception, message}} ->
              raise exception, message

            {:ok, string} ->
              string
          end
        end

        @doc """
        Intersperces a list elements into a list format according to the list
        pattern rules for a locale.

        This function can be helpful when creating a list from `Phoenix`
        safe strings which are of the format `{:safe, "some string"}`

        ## Arguments

        * `list` is any list of of terms that can be passed through `Kernel.to_string/1`

        * `options` is a keyword list

        ## Options

        * `locale` is any configured locale. See `Cldr.known_locales()`. The default
          is `locale: Cldr.get_current_locale/0`

        * `format` is one of those returned by
          `Cldr.List.list_pattern_types_for/1`. The default is `format: :standard`

        ## Examples

            iex> #{inspect __MODULE__}.intersperse(["a", "b", "c"], locale: "en")
            {:ok, ["a", ", ", "b", ", and ", "c"]}

            iex> #{inspect __MODULE__}.intersperse(["a", "b", "c"], locale: "en", format: :unit_narrow)
            {:ok, ["a", " ", "b", " ", "c"]}

            iex> #{inspect __MODULE__}.intersperse(["a", "b", "c"], locale: "fr")
            {:ok, ["a", ", ", "b", " et ", "c"]}

            iex> #{inspect __MODULE__}.intersperse([1,2,3,4,5,6])
            {:ok, [1, ", ", 2, ", ", 3, ", ", 4, ", ", 5, ", and ", 6]}

            iex> #{inspect __MODULE__}.intersperse(["a"])
            {:ok, ["a"]}

            iex> #{inspect __MODULE__}.intersperse([1,2])
            {:ok, [1, " and ", 2]}

        """
        @spec intersperse(list(term()), Keyword.t()) ::
                {:ok, list()} | {:error, {module(), String.t()}}

        def intersperse(list, options \\ [])

        def intersperse([], _options) do
          {:ok, []}
        end

        def intersperse(list, options) do
          with {:ok, locale, format} <- normalize_options(options) do
            list =
              list
              |> intersperse(locale, format)
              |> :'Elixir.List'.flatten

            {:ok, list}
          end
        end

        # For when the list is empty
        def intersperse([], _locale, _pattern_type) do
          []
        end

        # For when there is one element only
        def intersperse([first], _locale, _pattern_type) do
          [first]
        end

        # For when there are two elements only
        def intersperse([first, last], locale, pattern_type) do
          pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:"2"]
          Substitution.substitute([first, last], pattern)
        end

        # For when there are three elements only
        def intersperse([first, middle, last], locale, pattern_type) do
          first_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:start]
          last_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:end]
          last = Substitution.substitute([middle, last], last_pattern)
          Substitution.substitute([first, last], first_pattern)
        end

        # For when there are more than 3 elements
        def intersperse([first | rest], locale, pattern_type) do
          first_pattern = list_patterns_for(locale.cldr_locale_name)[pattern_type][:start]
          Substitution.substitute([first, intersperse(rest, locale, pattern_type)], first_pattern)
        end

        @doc """
        Formats a list using `intersperse/2` but raises if there is
        an error.

        ## Examples

            iex> #{inspect __MODULE__}.intersperse!(["a", "b", "c"], locale: "en")
            ["a", ", ", "b", ", and ", "c"]

            iex> #{inspect __MODULE__}.intersperse!(["a", "b", "c"], locale: "en", format: :unit_narrow)
            ["a", " ", "b", " ", "c"]

        """
        @spec intersperse!(list(term()), Keyword.t()) :: list(String.t()) | no_return()
        def intersperse!(list, options \\ []) do
          case intersperse(list, options) do
            {:error, {exception, message}} ->
              raise exception, message

            {:ok, list} ->
              list
          end
        end

        @spec normalize_options(Keyword.t()) ::
          {:ok, LanguageTag.t(), atom()} | {:error, {module(), String.t()}}

        defp normalize_options(options) do
          locale = options[:locale] || unquote(backend).get_locale()
          format = options[:format] || @default_style

          with {:ok, locale} <- unquote(backend).validate_locale(locale),
               {:ok, _} <- verify_format(locale.cldr_locale_name, format) do
            {:ok, locale, format}
          end
        end

        @spec verify_format(String.t(), atom()) ::
          {:ok, atom()} | {:error, {module(), String.t()}}

        def verify_format(locale_name, format) do
          if format in list_pattern_styles_for(locale_name) do
            {:ok, format}
          else
            {:error,
             {Cldr.UnknownFormatError, "The list format style #{inspect(format)} is not known."}}
          end
        end

        @spec list_patterns_for(Cldr.Locale.locale_name()) :: map()
        @spec list_pattern_styles_for(Cldr.Locale.locale_name()) :: [atom]

        for locale_name <- Cldr.Config.known_locale_names(config) do
          patterns =
            locale_name
            |> Cldr.Config.get_locale(config)
            |> Map.get(:list_formats)

          pattern_names = Map.keys(patterns)

          @doc """
          Returns the list patterns for a locale.

          List patterns provide rules for combining multiple
          items into a language format appropriate for a locale.

          ## Example

              iex> #{inspect __MODULE__}.list_patterns_for "en"
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
          def list_patterns_for(unquote(locale_name)) do
            unquote(Macro.escape(patterns))
          end

          @doc """
          Returns the styles of list patterns available for a locale.

          Returns a list of `atom`s of of the list format styles that are
          available in CLDR for a locale.

          ## Example

              iex> #{inspect __MODULE__}.list_pattern_styles_for("en")
              [:or, :or_narrow, :or_short, :standard, :standard_narrow, :standard_short,
               :unit, :unit_narrow, :unit_short]

          """
          def list_pattern_styles_for(unquote(locale_name)) do
            unquote(pattern_names)
          end
        end
      end
    end
  end
end