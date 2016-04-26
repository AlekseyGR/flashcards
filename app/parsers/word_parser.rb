class WordParser
  class << self
    def word_collection(url, original_text_selector, translated_text_selector)
      words_with_translation = parse_words(url, original_text_selector, translated_text_selector)
      words_with_translation.map do |original, translation|
        [original.content.downcase, translation.content.downcase]
      end
    end

    private

    def parse_words(url, original_text_selector, translated_text_selector)
      doc = Nokogiri::HTML(open(url))
      originals = doc.search(original_text_selector)
      translations = doc.search(translated_text_selector)
      originals.zip(translations)
    end
  end
end
