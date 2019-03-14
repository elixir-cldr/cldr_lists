# Changelog for Cldr_Lists v2.0.1

This is the changelog for Cldr_lists v2.0.1 released on March 15th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/kipcole9/cldr_lists/tags)

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

# Changelog for Cldr_Lists v2.0.0

This is the changelog for Cldr_lists v2.0.0 released on November 24th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/kipcole9/cldr_lists/tags)

### Enhancements

* Move to a backend module structure with [ex_cldr](https://hex.pm/packages/ex_cldr) version 2.0
* Add `Cldr.List.intersperse/3`.  Thanks to @lostkobrakai.  Closes #2.


