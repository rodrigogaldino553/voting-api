module Api
  module V1
    class CandidatesController < ApplicationController
      before_action :set_candidate, only: %i[ show update destroy ]

      # GET /api/v1/candidates
      def index
        @candidates = Candidate.all

        render json: CandidateSerializer.new(@candidates).serializable_hash
      end

      # GET /api/v1/candidates/1
      def show
        render json: CandidateSerializer.new(@candidate).serializable_hash
      end

      # POST /api/v1/candidates
      def create
        @candidate = Candidate.new(candidate_params)

        if @candidate.save
          render json: CandidateSerializer.new(@candidate).serializable_hash, status: :created, location: api_v1_candidate_url(@candidate)
        else
          render json: @candidate.errors, status: :unprocessable_content
        end
      end

      # PATCH/PUT /api/v1/candidates/1
      def update
        if @candidate.update(candidate_params)
          render json: CandidateSerializer.new(@candidate).serializable_hash
        else
          render json: @candidate.errors, status: :unprocessable_content
        end
      end

      # DELETE /api/v1/candidates/1
      def destroy
        @candidate.destroy!
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_candidate
          @candidate = Candidate.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def candidate_params
          params.expect(candidate: [ :name, :election_id ])
        end
    end
  end
end
