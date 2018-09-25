require 'rails_helper'

module Api
  RSpec.describe UnstableTree, type: :service do
    include_context 'unstable tree api stubs and data'

    describe '#call' do
      subject(:response) { described_class.new(name).call.parsed_response }

      context 'with 500 code' do
        before { stub_upstream_failure }

        it 'raises error and retries', aggregate_failures: true do
          expect { response }.to raise_error(ExceptionHandler::UpstreamFailure)
          expect(stub_upstream_failure).to have_been_requested.times(described_class::TRIES)
        end
      end

      context 'with 200 response code' do
        before { stub_successful_response }

        it 'does not raise error and calls endpoint exactly once', aggregate_failures: true do
          is_expected.to match_unordered_json(tree)
          expect(stub_successful_response).to have_been_requested.once
        end
      end

      context 'with 404 response code' do
        before { stub_not_found_response }

        it 'does not raise error and calls endpoint exactly once', aggregate_failures: true do
          is_expected.to include_json(not_found_body)
          expect(stub_not_found_response).to have_been_requested.once
        end
      end

      context 'with two upstream failures and third successfull response' do
        before { stub_two_failures_and_success_afterwards }

        it 'does not raise error and calls endpoint 3 times', aggregate_failures: true do
          is_expected.to match_unordered_json(tree)
          expect(stub_two_failures_and_success_afterwards).to have_been_requested.times(3)
        end
      end
    end
  end
end
