defmodule TestBackend.Cldr do
  use Cldr,
    default_locale: "en",
    locales: ["root", "fr", "zh", "en", "bs", "pl", "ru", "th", "he"],
    providers: [Cldr.List]
end

defmodule NoDocs.Cldr do
  use Cldr,
    default_locale: "en",
    locales: ["root", "fr", "zh"],
    providers: [Cldr.List],
    generate_docs: false
end