module ExceptionHandler
  extend ActiveSupport::Concern

  class UpstreamFailure < StandardError; end
  class MalformedParameters < StandardError; end

  included do
    rescue_from ExceptionHandler::UpstreamFailure, with: :upstream_failure
    rescue_from ExceptionHandler::MalformedParameters, with: :malformed_parameters_response
  end

  private

  def upstream_failure
    json_response({ error: I18n.t('errors.upstream_failure') }, :internal_server_error)
  end

  def malformed_parameters_response
    json_response({ error: I18n.t('errors.malformed_parameters') }, :bad_request)
  end
end
