require 'rails_helper'

RSpec.describe 'Trees API', type: :request do
  describe 'GET /tree/:name' do
    include_context 'unstable tree api stubs and data'

    let(:params) { {} }
    subject(:request) { get("/tree/#{name}", params: params) }

    context 'with existing tree name' do
      before { stub_successful_response }

      context 'with indicator_ids is not provided' do
        before { request }

        it { expect(response).to have_http_status(200) }
        it { expect(json_response).to match_unordered_json(tree) }
      end

      context 'with example indicator_ids' do
        let(:params) { { indicator_ids: [1, 32, 31] } }

        before { request }

        it { expect(response).to have_http_status(200) }
        it { expect(json_response).to match_unordered_json(pruned_tree) }
      end

      context 'when indicator_ids is not an array' do
        let(:bad_request_response) { { 'error' => I18n.t('errors.malformed_parameters') } }

        context 'with string' do
          let(:params) { { indicator_ids: 'incorrect' } }

          before { request }

          it { expect(response).to have_http_status(400) }
          it { expect(json_response).to include_json(bad_request_response) }
        end

        context 'with array of words' do
          let(:params) { { indicator_ids: %w[incorrect type] } }

          before { request }

          it { expect(response).to have_http_status(400) }
          it { expect(json_response).to include_json(bad_request_response) }
        end
      end

      context 'when upstream server fails' do
        before do
          stub_upstream_failure
          request
        end

        it { expect(response).to have_http_status(500) }
        it { expect(json_response['error']).to eq(I18n.t('errors.upstream_failure')) }
      end
    end

    context 'with non-existent tree name' do
      before do
        stub_not_found_response
        request
      end

      it { expect(response).to have_http_status(404) }
      it { expect(json_response).to include_json(not_found_body) }
    end
  end
end
