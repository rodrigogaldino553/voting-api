module Api
  module V1
    class CandidatesController < ApplicationController
      before_action :set_election, only: %i[index create]
      before_action :set_candidate, only: %i[show update destroy]

      # GET /api/v1/candidates
      def index
        @candidates = @election.present? ? @election.candidates : []

        render json: @candidates
      end

      # GET /api/v1/candidates/1
      def show
        render json: @candidate
      end

      # POST /api/v1/candidates
      def create
        @candidate = @election.candidates.new(candidate_params)

        return render json: {message: "You cant edit this election"}, status: :unauthorized if @election.user != current_user
        if @candidate.save
          render json: @candidate, status: :created, location: api_v1_candidate_url(@candidate)
        else
          render json: @candidate.errors, status: :unprocessable_content
        end
      end

      # PATCH/PUT /api/v1/candidates/1
      def update
        return render json: {message: "You cant edit this election"}, status: :unauthorized if @candidate&.election&.user != current_user
        if @candidate.update(candidate_params)
          render json: @candidate
        else
          render json: @candidate.errors, status: :unprocessable_content
        end
      end

      # DELETE /api/v1/candidates/1
      def destroy
        return render json: {message: "You cant edit this election"}, status: :unauthorized if @candidate&.election&.user != current_user
        @candidate.destroy!
        head :no_content
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_candidate
        @candidate = Candidate.find(params.expect(:id))
      end

      def set_election
        @election = Election.find(params[:election_id]) if params[:election_id]
      end

      # Only allow a list of trusted parameters through.
      def candidate_params
        params.expect(candidate: [:name])
      end
    end
  end
end
