# Cldr for Lists
![Build Status](http://sweatbox.noexpectations.com.au:8080/buildStatus/icon?job=cldr_lists)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_cldr_lists.svg)](https://hex.pm/packages/ex_cldr_lists)
[![Hex.pm](https://img.shields.io/hexpm/dw/ex_cldr_lists.svg?)](https://hex.pm/packages/ex_cldr_lists)
[![Hex.pm](https://img.shields.io/hexpm/l/ex_cldr_lists.svg)](https://hex.pm/packages/ex_cldr_lists)

## Introduction and Getting Started

`ex_cldr_lists` is an add-on library for [ex_cldr](https://hex.pm/packages/ex_cldr) that provides localisation and formatting for lists.

`Cldr` interprets the CLDR rules for list formatting in a locale-specific way.

### Configuration

From [ex_cldr](https://hex.pm/packages/ex_cldr) version 2.0, a backend module must be defined into which the public API and the [CLDR](https://cldr.unicode.org) data is compiled.  See the [ex_cldr documentation](https://hexdocs.pm/ex_cldr/readme.html) for further information on configuration.

In the following examples we assume the presence of a module called `MyApp.Cldr` defined as:
```elixir
defmodule MyApp.Cldr do
  use Cldr, locales: ["en", "fr"], default_locale: "en"
end
```

## Installation

Note that `:ex_cldr_lists` requires Elixir 1.5 or later.

Add `ex_lists` as a dependency to your `mix` project:

    defp deps do
      [
        {:ex_cldr_lists, "~> 2.0"}
      ]
    end

then retrieve `ex_cldr_lists` from [hex](https://hex.pm/packages/ex_cldr_lists):

    mix deps.get
    mix deps.compile

## Public API & Examples

There are two common public API functions:

* `MyApp.Cldr.List.to_string/2` & `MyApp.Cldr.List.to_string!/2` which take a list of terms and returns a string.  Each item in the list must be understood by `Kernel.to_string/1`

* `MyApp.Cldr.List.intersperse/2` & `MyApp.Cldr.List.intersperse!/2` which takes a list of terms and returns a list interspersed within the list format. This function can be helpful when creating a list from `Phoenix` safe strings which are of the format `{:safe, "some string"}`

For help in `iex`:

```elixir
iex> h MyApp.Cldr.List.to_string
iex> h MyApp.Cldr.List.intersperse
```

### List Formatting

```elixir
iex> MyApp.Cldr.List.list_formats_for "en"
[:or, :standard, :standard_short, :unit, :unit_narrow, :unit_short]

iex> MyApp.Cldr.List.to_string(["a", "b", "c"], locale: "en")
{:ok, "a, b, and c"}

iex> MyApp.Cldr.List.to_string(["a", "b", "c"], locale: "en", format: :or)
{:ok, "a, b, or c"}

iex> MyApp.Cldr.List.to_string(["a", "b", "c"], locale: "en", format: :unit)
{:ok, "a, b, c"}

iex> MyApp.Cldr.List.to_string!(["a", "b", "c"], locale: "en", format: :unit)
"a, b, c"

iex> MyApp.Cldr.List.intersperse(["a", "b", "c"], locale: "en")
{:ok, ["a", ", ", "b", ", and ", "c"]}

```

### List Formats

List formats are referred to by a pattern style the standardises the way to refernce different formats in a locale.  See `MyApp.Cldr.List.list_formats_for/1`.  For example:

```elixir
iex> MyApp.Cldr.List.list_formats_for "en"
[:standard, :standard_short, :unit, :unit_narrow, :unit_short]

iex> MyApp.Cldr.List.list_formats_for "ru"
[:standard, :standard_short, :unit, :unit_narrow, :unit_short]

iex> MyApp.Cldr.List.list_formats_for "th"
[:standard, :standard_short, :unit, :unit_narrow, :unit_short]
```

### Known formats

The common formats for a locale are:

* :or,
* :or_narrow,
* :or_short,
* :standard,
* :standard_narrow,
* :standard_short,
* :unit,
* :unit_narrow,
* :unit_short

This list is not fixed or definitive, other formats may be present for a locale.

The definitions of these formats can be explored through `MyApp.Cldr.List.list_patterns_for/1`. For example:

```elixir
iex> MyApp.Cldr.List.list_patterns_for "fr"
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
