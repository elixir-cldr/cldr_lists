require Cldr.List.Backend

defmodule MyApp.Cldr do
  use Cldr,
    default_locale: "en",
    locales: ["und", "fr", "zh", "en", "bs", "pl", "ru", "th", "he"],
    providers: [Cldr.List]
end

defmodule NoDocs.Cldr do
  use Cldr,
    default_locale: "en",
    locales: ["und", "fr", "zh"],
    providers: [Cldr.List],
    generate_docs: false
end