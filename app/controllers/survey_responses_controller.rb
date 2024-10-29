require 'securerandom'
class SurveyResponsesController < ApplicationController
  before_action :set_survey_response, only: %i[ show update destroy ]

  def bin_to_hex(bin)
    bin.unpack('H*').first
  end

  def hex_to_bin(hex)
    hex = '0' << hex unless (hex.length % 2) == 0
    hex.scan(/[A-Fa-f0-9]{2}/).inject('') { |encoded, byte| encoded << [byte].pack('H2') }
  end

  def encrypt_survey_response(jsonified_response, encryption_key)
    hashed_response = Encryptor.encrypt(value: jsonified_response, key: hex_to_bin(encryption_key[:key_hash]), iv: hex_to_bin(encryption_key[:iv]))
    bin_to_hex(hashed_response)
  end

  def decrypt_survey_response(response_hex, encryption_key)
    binified_response = hex_to_bin(response_hex)
    Encryptor.decrypt(value: binified_response, key: hex_to_bin(encryption_key[:key_hash]), iv: hex_to_bin(encryption_key[:iv]))
  end

  def validate_dropdown_or_slider_question(question, survey_response)
    if !question["choices"].include?(survey_response["response"])
        raise "Invalid response '#{survey_response["response"]}' for questionId #{question["id"]}, please select one from the following options: #{question["choices"].to_sentence(last_word_connector: ' or ')}"
    end
  end

  def validate_text_question(question, survey_response)
    if !survey_response["response"].is_a? String
       raise "Invalid response '#{survey_response["response"]}' for questionId #{question["id"]}, please enter a text response"
    end
  end

  def validate_survey_response(survey_responses)
      questions_data = JSON.parse(File.read("#{Rails.root}/public/data.json"))["questions"]
      
      survey_responses.each do |survey_response|
        current_question = questions_data.find {|question| question["id"] == survey_response["questionId"]}
  
        if !current_question 
          raise "Invalid question ID: #{survey_response["questionId"]}"
        end

        if survey_response["response"].blank?
          raise "No response provided for question ID: #{survey_response["questionId"]}. Please enter a response and try again"
        end

        case current_question["questionType"]
        when "DROPDOWN"
          validate_dropdown_or_slider_question(current_question, survey_response)
        when "SLIDER"
          validate_dropdown_or_slider_question(current_question, survey_response)
        when "TEXT"
          validate_text_question(current_question, survey_response)
        end

      end
  end
  

  def generate_encryption_key
    secret_key = SecureRandom.random_bytes(32)
    iv = SecureRandom.random_bytes(12)
    hex_key = bin_to_hex(secret_key)
    hex_iv = bin_to_hex(iv)
    return {:key_hash => hex_key, :iv => hex_iv}
  end

  # GET /survey_responses
  def index
    @survey_responses = SurveyResponse.all

    render json: @survey_responses
  end

  # GET /survey_responses/1
  def show
    render json: @survey_response
  end

  # POST /survey_responses
  def create
    begin
    validate_survey_response(survey_response_params[:response])
    new_encryption_key = generate_encryption_key()
    encryption_key = EncryptionKey.create(key_hash: new_encryption_key[:key_hash], iv: new_encryption_key[:iv])
    jsonified_response = survey_response_params[:response].to_json
  
    hashed_response = encrypt_survey_response(jsonified_response, encryption_key)
   
    @survey_response = SurveyResponse.new(response: hashed_response, encryption_key: encryption_key)
    
    if @survey_response.save
      render json: @survey_response, status: :created, location: @survey_response
    else
      render json: @survey_response.errors, status: :unprocessable_entity
    end
    rescue => e
    render json: {error: e, status: 400}.to_json, status: :bad_request
    end
  end

  # PATCH/PUT /survey_responses/1
  # def update
  #   if @survey_response.update(survey_response_params)
  #     render json: @survey_response
  #   else
  #     render json: @survey_response.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /survey_responses/1
  # def destroy
  #   @survey_response.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_response
      @survey_response = SurveyResponse.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_response_params
      params.require(:survey_response).permit({ response: [:questionId, :response] })
    end
end
