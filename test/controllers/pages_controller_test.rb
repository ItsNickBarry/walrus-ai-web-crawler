require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  describe PagesController do
    describe '#root' do
      it 'renders root' do
        get root_url
        assert_response 200
        assert_template :root
      end
    end
  end
end
