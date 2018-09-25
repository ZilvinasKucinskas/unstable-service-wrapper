require 'rails_helper'

module Api
  RSpec.describe UnstableTree, type: :service do
    include_context 'unstable tree api stubs and data'

    describe '#call' do
      subject(:response) { described_class.new(name).call.parsed_response }

      context 'with 500 code' do
        before { stub_upstream_failure }

        it { expect { response }.to raise_error(ExceptionHandler::UpstreamFailure) }
      end

      context 'with 200 response code' do
        before { stub_successful_response }

        it { is_expected.to match_unordered_json(tree) }
      end

      context 'with 404 response code' do
        before { stub_not_found_response }

        it { is_expected.to include_json(not_found_body) }
      end

      context 'with two upstream failures and third successfull response' do
        before { stub_two_failures_and_success_afterwards }

        it 'retries requests' do
          is_expected.to match_unordered_json(tree)
        end
      end
    end
  end
end
