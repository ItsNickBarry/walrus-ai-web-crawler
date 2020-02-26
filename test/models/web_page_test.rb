require 'test_helper'

class WebPageTest < ActiveSupport::TestCase
  describe WebPage do
    describe '#descendents' do
      before do
        @web_page = web_pages(:duckduckgo)
      end

      it 'returns direct children with given depth of 1' do
        descendents = @web_page.descendents 1

        assert descendents.include? web_pages(:wikipedia)
        refute descendents.include? web_pages(:wikimedia)

        assert_equal descendents.length, 1
      end

      it 'returns indirect children with given depth of 2' do
        descendents = @web_page.descendents 2

        assert descendents.include? web_pages(:wikipedia)
        assert descendents.include? web_pages(:wikimedia)

        assert_equal descendents.length, 2
      end

      it 'does not return unrelated web pages' do
        descendents = @web_page.descendents 10

        refute descendents.include? web_pages(:google)
      end

      it 'includes depths in results' do
        descendents = @web_page.descendents 2

        assert_equal descendents.find { |el| el == web_pages(:wikipedia) }.level, 1
        assert_equal descendents.find { |el| el == web_pages(:wikimedia) }.level, 2
      end
    end
  end
end
