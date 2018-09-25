module ExceptionHandler
  extend ActiveSupport::Concern

  class UpstreamFailure < StandardError; end

  included do
    rescue_from ExceptionHandler::UpstreamFailure, with: :upstream_failure
  end

  private

  def upstream_failure
    json_response({ error: I18n.t('errors.upstream_failure') }, :internal_server_error)
  end
end
