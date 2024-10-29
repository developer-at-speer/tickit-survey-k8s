require 'rails_helper'

RSpec.describe SurveyResponsesController, type: :request do
  let!(:survey_response) { build(:survey_response) } # Assuming you have a factory for SurveyResponse

  let(:valid_attributes) {
    {
      response: [
        {
          "questionId": 1,
          "response": "Good"
      },
      {
          "questionId": 2,
          "response": 2
      },
      {
          "questionId": 3,
          "response": "Have a wonderful day!"
      }
      ]
    }
  }

  let(:invalid_attributes) {
    {
      response: [
        {
          "questionId": 1,
          "response": "Really bad"
      },
      {
          "questionId": 2,
          "response": 7
      },
      {
          "questionId": 3,
          "response": 0,
      }
      ]
    }
  }

  let (:missing_attributes) {
    {
     response: [
        {
          "response": "Really bad"
        },
        {
          "questionId": 2,
        },
        {
          "response": 0,
        }
      ]
    }
  }

  def decrypt_survey_response(response_hex, encryption_key)
    binified_response = hex_to_bin(response_hex)
    Encryptor.decrypt(value: binified_response, key: hex_to_bin(encryption_key[:key_hash]), iv: hex_to_bin(encryption_key[:iv]))
  end

  def hex_to_bin(hex)
    hex = '0' << hex unless (hex.length % 2) == 0
    hex.scan(/[A-Fa-f0-9]{2}/).inject('') { |encoded, byte| encoded << [byte].pack('H2') }
  end

  describe 'GET /survey_responses' do
    it 'returns a successful response' do
      get survey_responses_path, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /survey_responses' do
    it 'creates a survey_response' do
      expect {
        post survey_responses_path, params: { survey_response: valid_attributes }, as: :json
      }.to change(SurveyResponse, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "should encrypt the user's survey submission" do
      post survey_responses_path, params: { survey_response: valid_attributes }, as: :json
      jsonified_response = valid_attributes[:response].to_json

      decrypted_survey_response = decrypt_survey_response(SurveyResponse.last.response, EncryptionKey.last)
      expect(jsonified_response).to eq(decrypted_survey_response)
      expect(SurveyResponse.last.response).not_to eq(valid_attributes[jsonified_response])
    end

    it 'throws an error when there are missing values in response array' do
      expect {
        post survey_responses_path, params: { survey_response: missing_attributes }, as: :json
      }.to change(SurveyResponse, :count).by(0)

      expect(response).to have_http_status(:bad_request)
    end

    it 'throws an error when invalid values are passed in' do
      expect {
        post survey_responses_path, params: { survey_response: invalid_attributes }, as: :json
      }.to change(SurveyResponse, :count).by(0)

      expect(response).to have_http_status(:bad_request)
    end
  end

end
