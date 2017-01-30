require 'rails_helper'
require 'pp'

def login_user
  sign_in create(:user), scope: :user
end

describe QuestionsController do

  describe 'POST #create' do
    it 'creates a question and responds with JSON' do
      # sign_in create(:user), scope: :user
      login_user
      @expected_response = {
          "success"=>true,
          "message"=>"Question successfully created."
      }
      q = attributes_for(:question, tags: ['testing', 'this'])

      expect{
        post :create, question: q
      }.to change(Question,:count).by(1)
      expect(response).to be_success
      expect(response.header['Content-Type']).to include('application/json')
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq(@expected_response['success'])
      expect(parsed_response['message']).to eq(@expected_response['message'])
      expect(parsed_response['forwardingUrl'].split('/')[-1].to_i).to eq(Question.last.id)
    end

    it 'creates a question if there are no tags.' do
      login_user
      q = attributes_for(:question, tags: [])
      expect{
        post :create, question: q
      }.to change(Question, :count).by(1)
    end

    it 'refuses question creation without sign in' do
      login_with nil
      expect{
        post :create, question: attributes_for(:question)
      }.not_to change(Question, :count)
      expect(response.status).to eq(302)
      expect(response).to redirect_to new_user_session_url
    end



  end



end