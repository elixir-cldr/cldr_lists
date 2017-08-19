# Elixir Cldr: Lists
![Build Status](http://sweatbox.noexpectations.com.au:8080/buildStatus/icon?job=cldr_lists)
![Deps Status](https://beta.hexfaktor.org/badge/all/github/kipcole9/cldr_lists.svg)
[![Hex pm](http://img.shields.io/hexpm/v/ex_cldr_lists.svg?style=flat)](https://hex.pm/packages/ex_cldr_lists)
[![License](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://github.com/kipcole9/cldr_lists/blob/master/LICENSE)

## Introduction & Getting Started

`ex_cldr_lists` is an addon library for [ex_cldr](https://hex.pm/packages/ex_cldr) that provides localisation and formatting for lists.

The primary api is `Cldr.List.to_string/2`.  The following examples demonstrate:

```elixir
iex> Cldr.List.to_string(["a", "b", "c"], locale: "en")
{:ok, "a, b, and c"}
```

For help in `iex`:

```elixir
iex> h Cldr.List.to_string
```

## Documentation

Primary documentation is available at https://hexdocs.pm/ex_cldr/1_getting_started.html#localizing-lists

## Installation

Note that `:ex_cldr_lists` requires Elixir 1.5 or later.

Add `ex_cldr_dates_time` as a dependency to your `mix` project:

    defp deps do
      [
        {:ex_cldr_lists, "~> 0.1.0"}
      ]
    end

then retrieve `ex_cldr_lists` from [hex](https://hex.pm/packages/ex_cldr_lists):

    mix deps.get
    mix deps.compile

