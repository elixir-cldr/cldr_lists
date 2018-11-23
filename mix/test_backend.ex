defmodule TestBackend.Cldr do
  use Cldr,
    default_locale: "en",
    locales: ["root", "fr", "zh", "en", "bs", "pl", "ru", "th", "he"]
end