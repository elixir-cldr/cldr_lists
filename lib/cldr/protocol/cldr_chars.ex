defimpl Cldr.Chars, for: List do
  def to_string(list) do
    locale = Cldr.get_locale()
    Cldr.List.to_string!(list, locale.backend, locale: locale)
  end
end