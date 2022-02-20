# Changelog

## Cldr_Lists v2.10.0

This is the changelog for Cldr_lists v2.10.0 released on February 21st, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Updates to [ex_cldr version 2.26.0](https://hex.pm/packages/ex_cldr/2.26.0) and [ex_cldr_numbers version 2.25.0](https://hex.pm/packages/ex_cldr_numbers/2.25.0) which use atoms for locale names and rbnf locale names. This is consistent with other elements of `t:Cldr.LanguageTag` where atoms are used when the cardinality of the data is fixed and relatively small and strings where the data is free format.

## Cldr_Lists v2.9.0

This is the changelog for Cldr_lists v2.9.0 released on October 27th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Updates to support [CLDR release 40](https://cldr.unicode.org/index/downloads/cldr-40) via [ex_cldr version 2.24](https://hex.pm/packages/ex_cldr/2.24.0)

### Deprecations

* Don't call deprecated `Cldr.Config.get_locale/2`, call `Cldr.Locale.Loader.get_locale/2` instead.

* Don't call deprecated `Cldr.Config.known_locale_names/1`, call `Cldr.Locale.Loader.known_locale_names/1` instead.

## Cldr_Lists v2.9.0-rc.2

This is the changelog for Cldr_lists v2.9.0-rc.2 released on October 25th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Deprecations

* Don't call deprecated `Cldr.Config.known_locale_names/1`, call `Cldr.Locale.Loader.known_locale_names/1` instead.

## Cldr_Lists v2.9.0-rc.1

This is the changelog for Cldr_lists v2.9.0-rc.1 released on October 24th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Deprecations

* Don't call deprecated `Cldr.Config.get_locale/2`, call `Cldr.Locale.Loader.get_locale/2` instead.

## Cldr_Lists v2.9.0-rc.1

This is the changelog for Cldr_lists v2.9.0-rc.0 released on October 3rd, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Support [CLDR 40](http://cldr.unicode.org/index/downloads/cldr-40)

## Cldr_Lists v2.8.0

This is the changelog for Cldr_lists v2.8.0 released on April 8th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Support [CLDR 39](http://cldr.unicode.org/index/downloads/cldr-39)

## Cldr_Lists v2.7.0

This is the changelog for Cldr_lists v2.7.0 released on November 1st, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Support [CLDR 38](http://cldr.unicode.org/index/downloads/cldr-38)

## Cldr_Lists v2.6.1

This is the changelog for Cldr_lists v2.6.1 released on September 26th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Bug Fixes

* Use `Cldr.default_backend!/0` instead of `Cldr.default_backend/0` if its available

## Cldr_Lists v2.6.0

This is the changelog for Cldr_lists v2.6.0 released on July 1st, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Standardize on `:format` rather than `:style` for formatting options. This is part of an ongoing effort to standardise option naming across the CLDR libraries. Thanks to @Zurga for the collaboration. Closes #4.  This reverts the decision made in `ex_cldr_lists version 2.4.0`.

* Deprecates `Cldr.List.list_styles_for/2` in favour of `Cldr.List.list_formats_for/2`

* Updates to use `Cldr.locale_and_backend_from/{1, 2}` which normalizes extraction of backend and locale from parameters and options. As a result, also bump the minimum version of `ex_cldr_numbers` to `2.15`

## Cldr_Lists v2.5.0

This is the changelog for Cldr_lists v2.5.0 released on May 4th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Add implementation for the `Cldr.Chars` protocol which is used by `Cldr.to_string/1` and which is a drop-in replacement for `Kernel.to_string/1` with added default localization.

* Depends upon [ex_cldr_numbers versin 2.17](https://hex.pm/packages/ex_cldr_numbers/2.17.0) which encapsulates CLDR39 data.

## Cldr_Lists v2.4.0

This is the changelog for Cldr_lists v2.4.0 released on August 31st, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Changes and deprecations

* Prefer the keyword option `:style` over `:format` to specify the list style in `Cldr.List.to_string/3` and `Cldr.List.intersperse/3`.  The keyword `:format` is deprecated and will be removed in `ex_cldr_lists` version 3.0

* Rename `Cldr.List.list_pattern_styles_for/2` to `Cldr.List.list_styles_for/2`. `Cldr.List.list_pattern_styles_for/2` will still operate and delegates to `Cldr.List.list_styles_for/2`.  It is now deprecated and will be removed in `ex_cldr_lists` 3.0.

## Cldr_Lists v2.3.0

This is the changelog for Cldr_lists v2.3.0 released on August 29th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Add `Cldr.List.known_list_styles/0`

## Cldr_Lists v2.2.2

This is the changelog for Cldr_lists v2.2.2 released on August 23rd, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Bug Fixes

* Fix `@spec` for `Cldr.List.to_string/3` and `Cldr.List.to_string!/3`

## Cldr_Lists v2.2.1

This is the changelog for Cldr_lists v2.2.1 released on August 21st, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Bug Fixes

* Replace `Cldr.get_current_locale/0` with `Cldr.get_locale/0` in docs

* The option `:backend` to `Cldr.List.to_string/3` will be used as the backend if provided

* Fix dialyzer warnings

## Cldr_Lists v2.2.0

This is the changelog for Cldr_lists v2.2.0 released on March 28th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Updates to [CLDR version 35.0.0](http://cldr.unicode.org/index/downloads/cldr-35) released on March 27th 2019.

## Cldr_Lists v2.1.0

This is the changelog for Cldr_lists v2.1.0 released on March 23rd, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Support `Cldr.default_backend/0` and apply it as the default for functions in `Cldr.List`

## Cldr_Lists v2.0.2

This is the changelog for Cldr_lists v2.0.2 released on March 20th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Bug Fixes

* Fix dialyzer warnings

## Cldr_Lists v2.0.1

This is the changelog for Cldr_lists v2.0.1 released on March 15th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Makes generation of documentation for backend modules optional.  This is implemented by the `:generate_docs` option to the backend configuration.  The default is `true`. For example:

```
defmodule MyApp.Cldr do
  use Cldr,
    default_locale: "en-001",
    locales: ["en", "ja"],
    gettext: MyApp.Gettext,
    generate_docs: false
end
```

## Cldr_Lists v2.0.0

This is the changelog for Cldr_lists v2.0.0 released on November 24th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_lists/tags)

### Enhancements

* Move to a backend module structure with [ex_cldr](https://hex.pm/packages/ex_cldr) version 2.0
* Add `Cldr.List.intersperse/3`.  Thanks to @lostkobrakai.  Closes #2.


