require 'test_helper'

class WebPageTest < ActiveSupport::TestCase
  describe WebPage do
    describe '#descendents' do
      it 'returns direct children with given depth of 1' do
        descendents = web_pages(:duckduckgo).descendents 1

        assert descendents.include? web_pages(:wikipedia)
        refute descendents.include? web_pages(:wikimedia)

        assert_equal descendents.length, 1
      end

      it 'returns indirect children with given depth of 2' do
        descendents = web_pages(:duckduckgo).descendents 2

        assert descendents.include? web_pages(:wikipedia)
        assert descendents.include? web_pages(:wikimedia)

        assert_equal descendents.length, 2
      end

      it 'does not return unrelated web pages' do
        descendents = web_pages(:duckduckgo).descendents 10

        refute descendents.include? web_pages(:google)
      end

      it 'includes depths in results' do
        descendents = web_pages(:duckduckgo).descendents 10

        assert_equal descendents.find { |el| el == web_pages(:wikipedia) }.depth, 1
        assert_equal descendents.find { |el| el == web_pages(:wikimedia) }.depth, 2
      end

      it 'runs with depth of 1 by default' do
        descendents = web_pages(:duckduckgo).descendents

        assert descendents.all? { |el| el.depth == 1 }
      end

      it 'does not return self when graph is cyclical' do
        descendents = web_pages(:google).descendents 10

        refute descendents.include? web_pages(:google)
      end

      it 'returns lowest depth for each match when graph is cyclical' do
        descendents = web_pages(:google).descendents 10

        assert_equal descendents.find { |el| el == web_pages(:google_plus) }.depth, 1
      end
    end
  end
end
