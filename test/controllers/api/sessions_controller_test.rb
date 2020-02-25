require 'test_helper'

class Api::SessionsControllerTest < ActionDispatch::IntegrationTest
  describe Api::SessionsController do
    describe '#show' do
      it 'renders current user if signed in' do
        sign_in users(:nobody)
        get api_session_url
        assert_response 200
        assert_template :show
      end

      it 'renders error if not signed in' do
        get api_session_url
        assert_response 401
      end
    end
  end
end
