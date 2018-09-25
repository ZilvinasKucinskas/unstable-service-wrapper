class TreesController < ApplicationController
  def show
    validate_indicators

    response = Api::UnstableTree.new(params[:name]).call

    case response.code
    when 200
      json_response(PruneTree.new(response.parsed_response, indicators.map(&:to_i)).call)
    when 404
      json_response(response.parsed_response, :not_found)
    end
  end

  private

  def validate_indicators
    raise ExceptionHandler::MalformedParameters unless correct_indicators?
  end

  def indicators
    params[:indicator_ids] || []
  end

  def correct_indicators?
    indicators.is_a?(Array) && indicators.all? { |element| element !~ /\D/ }
  end
end
