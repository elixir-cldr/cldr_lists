# Changelog

## Cldr_Lists v0.3.3 November 13th, 2017

### Enhancements

* Update to [ex_cldr](https://hex.pm/packages/ex_cldr) version 0.13.0

## Cldr_Lists v0.3.2 November 8th, 2017

### Enhancements

* Update to [ex_cldr](https://hex.pm/packages/ex_cldr) version 0.12.0

## Cldr_Lists v0.3.1 November 3rd, 2017

### Enhancements

* Update to [ex_cldr](https://hex.pm/packages/ex_cldr) version 0.11.0 in which the term `territory` is preferred over `region`

## Cldr_Lists v0.3.0 November 2nd, 2017

### Enhancements

* Update to [ex_cldr](https://hex.pm/packages/ex_cldr) version 0.10.0 which incorporates CLDR data version 32 released on November 1st, 2017.  For further information on the changes in CLDR 32 release consult the [release notes](http://cldr.unicode.org/index/downloads/cldr-32).

* CLDR 32 introduces the list style `:or` which is invoked as part of the options to `Cldr.List.to_string/2`.  For example: `Cldr.List.to_string 1234, format: :or`.

## Cldr_Lists v0.2.2 November 1st, 2017

### Enhancements

* Update to ex_cldr v0.9.0

## Cldr_Lists v0.2.1 October 30th, 2017

### Enhancements

* Move to [ex_cldr](https://hex.pm/packages/ex_cldr) 0.8.2 which changes Cldr.Number.PluralRule.plural_rule/3 implementation for Float so that it no longer casts to a Decimal nor delegates to the Decimal path".  This will have a small positive impact on performance

## Cldr_Lists v0.2.0 October 25th, 2017

### Enhancements

* Update to [ex_cldr](https://hex.pm/packages/ex_cldr) version 0.8.0 for compatibility with the new `%Cldr.LanguageTag{}` representation of a locale

## Cldr_Lists v0.1.3 September 18th, 2017

### Enhancements

* Update to [ex_cldr](https://hex.pm/packages/ex_cldr) version 0.7.0 and add [ex_cldr_numbers](https://hex.pm/packages/ex_numbers) version 0.1.0

## Cldr_Lists v0.1.2 September 4th, 2017

### Enhancements

* Update to [ex_cldr](https://hex.pm/packages/ex_cldr) version 0.6.2

## Cldr_Lists v0.1.1 August 24, 2017

### Enhancements

* Update to [ex_cldr](https://hex.pm/packages/ex_cldr) version 0.5.2 which correctly serialises the locale downloading process

## Cldr_Lists v0.1.0 August 19, 2017

### Enhancements

* Initial release