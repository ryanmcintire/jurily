class MockApiController < ApplicationController

  protect_from_forgery with: :null_session

  def test
    response = {
        data: params,
        success: true
    }
    render status: 200, json: response.to_json
  end

end