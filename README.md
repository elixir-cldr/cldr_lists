# Cldr for Lists
![Build Status](http://sweatbox.noexpectations.com.au:8080/buildStatus/icon?job=cldr_lists)
[![Hex pm](http://img.shields.io/hexpm/v/ex_cldr_lists.svg?style=flat)](https://hex.pm/packages/ex_cldr_lists)
[![License](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://github.com/kipcole9/cldr_lists/blob/master/LICENSE)

## Introduction and Getting Started

`ex_cldr_lists` is an addon library for [ex_cldr](https://hex.pm/packages/ex_cldr) that provides localisation and formatting for lists.

`Cldr` interprets the CLDR rules for list formatting is a locale-specific way.  The list is recursed over and the list elements are passed to `Kernel.to_string/1` therefore the list elements can be anything that can be understood by `Kernel.to_string/1`.

### Examples

```elixir
iex> Cldr.List.list_pattern_styles_for "en"
[:or, :standard, :standard_short, :unit, :unit_narrow, :unit_short]

iex> Cldr.List.to_string(["a", "b", "c"], locale: "en")
{:ok, "a, b, and c"}

iex> Cldr.List.to_string(["a", "b", "c"], locale: "en", format: :or)
{:ok, "a, b, or c"}

iex> Cldr.List.to_string(["a", "b", "c"], locale: "en", format: :unit)
{:ok, "a, b, c"}

iex> Cldr.List.to_string!(["a", "b", "c"], locale: "en", format: :unit)
"a, b, c"
```

For help in `iex`:

```elixir
iex> h Cldr.List.to_string
```

## Installation

Note that `:ex_cldr_lists` requires Elixir 1.5 or later.

Add `ex_cldr_dates_time` as a dependency to your `mix` project:

    defp deps do
      [
        {:ex_cldr_lists, "~> 1.0.0-rc or ~> 1.0"}
      ]
    end

then retrieve `ex_cldr_lists` from [hex](https://hex.pm/packages/ex_cldr_lists):

    mix deps.get
    mix deps.compile

## Public API

The primary api for list formatting is `Cldr.List.to_string/2`.  It provides the ability to format lists in a standard way for configured locales. For example:

```elixir
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
```

`Cldr.List.to_string/2` takes a Keyword list of options where the valid options are:

* `:format` where the format is any of the list pattern styles returned by `Cldr.List.list_pattern_styles_for/1`

* `:locale` where the locale is any of the locales returned by `Cldr.known_localenames/0` or a locale returned from `Cldr.Locale.new/1`.  The default locale is `Cldr.default_locale/0`.

## List Formats

List formats are referred to by a pattern style the standardises the way to refernce different formats in a locale.  See `Cldr.List.list_pattern_styles_for/1`.  For example:

```elixir
iex> Cldr.List.list__pattern_styles_for "en"
[:standard, :standard_short, :unit, :unit_narrow, :unit_short]

iex> Cldr.List.list_pattern_styles_for "ru"
[:standard, :standard_short, :unit, :unit_narrow, :unit_short]

iex> Cldr.List.list_pattern_styles_for "th"
[:standard, :standard_short, :unit, :unit_narrow, :unit_short]
```

## Formatting styles

The five list common formatting styles for a locale are:

* `:standard`

* `:standard_short`

* `:unit`

* `:unit_narrow`

* `:unit_short`

This list is not fixed or definitive, other styles may be present for a locale.

The definitions of these styles can be explored through `Cldr.List.list_patterns_for "locale"`. For example:

```elixir
iex> Cldr.List.list_patterns_for "fr"
%{standard: %{"2": "{0} et {1}", end: "{0} et {1}", middle: "{0}, {1}",
    start: "{0}, {1}"},
  standard_short: %{"2": "{0} et {1}", end: "{0} et {1}", middle: "{0}, {1}",
    start: "{0}, {1}"},
  unit: %{"2": "{0} et {1}", end: "{0} et {1}", middle: "{0}, {1}",
    start: "{0}, {1}"},
  unit_narrow: %{"2": "{0} {1}", end: "{0} {1}", middle: "{0} {1}",
    start: "{0} {1}"},
  unit_short: %{"2": "{0} et {1}", end: "{0} et {1}", middle: "{0}, {1}",
    start: "{0}, {1}"}}
```

