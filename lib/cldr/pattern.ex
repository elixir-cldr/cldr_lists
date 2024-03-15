defmodule Cldr.List.Pattern do
  @moduledoc """
  A list pattern drives list formatting and it defines how to combine
  list elements at the begging, in the middle and at the end of
  a list. It also has a special pattern used when the list contains
  only two elements.

  """

  defstruct [:start, :middle, :end, :two]

  @type pattern :: [non_neg_integer() | String.t(), ...]

  @type t :: %__MODULE__{
    start: pattern(),
    middle: pattern(),
    end: pattern(),
    two: pattern()
  }

  @valid_options [:start, :middle, :end, :two]

  @doc """
  Creates a new list format.

  A list pattern consists of four string
  templates into which list elements are interpolated
  when formatting.

  The four templates are:

  * `:start` used to format the first two
    list elements.

  * `:middle` is used to format elements in
    the middle of the list.

  * `:end` is used to format the last two
    elements in the list.

  * `:two` is used to format a list if
    it contains only two elements.

  Only the `:start` option is required. It
  will be used as the default for any other
  option that is not provided.

  ## Arguments

  * `options` is a keyword list of options.

  ## Options

  * `:start` is a pattern template as a string.
    This option is required.

  * `:middle` is a pattern template as a string.

  * `:end` is a pattern template as a string.

  * `:two` is a pattern template as a string.

  ## Returns

  `{:ok, pattern}` or

  `{:error, reason}`

  ## Pattern template

  A pattern template is a string that contains
  two placeholders denoted by `{0}` and `{1}`.

  ## Example

      iex> Cldr.List.Pattern.new(
      ...>   start: "{0}, {1}"),
      ...>   middle: "{0}, {1}"),
      ...>   end: "{0} and {1}"),
      ...>   two: "{0} and {1}")
      ...>  )
      {:ok, _pattern}

  """
  def new(options) when is_list(options) do
    with {:ok, options} <- validate_options(options) do
      start = Keyword.get(options, :start)

      struct(__MODULE__, options)
      |> put_new(:middle, start)
      |> put_new(:end, start)
      |> put_new(:two, start)
      |> wrap(:ok)
    end
  end

  defp validate_options(options) when is_list(options) do
    options =
      Enum.reduce_while options, [], fn
        {key, string}, acc when key in @valid_options and is_binary(string) ->
          case validate_pattern(string) do
            {:error, reason} ->
              {:halt, {:error, reason}}

            {:ok, string} ->
              pattern = Cldr.Substitution.parse(string)
              {:cont, [{key, pattern} | acc]}
          end

        {key, value}, _acc when key in @valid_options ->
          {:halt, {:error, "Invalid value #{inspect value} found. Option #{inspect key} should be a string"}}

        {key, _value}, _acc ->
          {:halt, {:error, "Invalid option #{inspect key} found. Valid options are #{inspect @valid_options}"}}
      end

      case options do
        {:error, reason} ->
          {:error, reason}

        options ->
          if Keyword.has_key?(options, :start),
            do: {:ok, options},
            else: {:error, "Option :start must be provided"}
      end
  end

  defp validate_pattern(string) when is_binary(string) do
    if String.contains?(string, "{0}") && String.contains?(string, "{1}") do
      {:ok, string}
    else
      {:error, "Invalid pattern #{inspect string}. A pattern must have two placeholders {0} and {1}"}
    end
  end

  defp put_new(options, key, default) do
    if Map.get(options, key), do: options, else: Map.put(options, key, default)
  end

  defp wrap(term, atom) do
    {atom, term}
  end
end