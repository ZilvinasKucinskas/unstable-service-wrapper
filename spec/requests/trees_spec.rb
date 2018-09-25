require 'rails_helper'

RSpec.describe 'Trees API', type: :request do
  describe 'GET /tree/:name' do
    let(:url) { "#{Api::UnstableTree.base_uri}#{Api::UnstableTree::TREE_PATH}#{name}" }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:params) { {} }
    let(:tree) { JSON.parse(file_fixture('original_tree.json').read) }

    subject(:request) { get("/tree/#{name}", params: params) }

    context 'with existing tree name' do
      let(:name) { 'input' }

      before { stub_request(:get, url).to_return(body: tree.to_json, status: 200, headers: headers) }

      context 'with indicator_ids is not provided' do
        before { request }

        it { expect(response).to have_http_status(200) }
        it { expect(json_response).to match_unordered_json(tree) }
      end

      context 'with example indicator_ids' do
        let(:params) { { indicator_ids: [1, 32, 31] } }
        let(:pruned_tree) { JSON.parse(file_fixture('pruned_example_tree.json').read) }

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
        let(:name) { 'input' }
        let(:upstream_failure_body) { 'Internal derper error. Nobody has been notified.' }

        before do
          stub_request(:get, url).to_return(body: upstream_failure_body, status: 500, headers: headers)
          request
        end

        it { expect(response).to have_http_status(500) }
        it { expect(json_response['error']).to eq(I18n.t('errors.upstream_failure')) }
      end
    end

    context 'with non-existent tree name' do
      let(:name) { 'asd' }
      let(:not_found_body) { { 'error' => 'Can\'t find that tree' } }

      before do
        stub_request(:get, url).to_return(body: not_found_body.to_json, status: 404, headers: headers)
        request
      end

      it { expect(response).to have_http_status(404) }
      it { expect(json_response).to include_json(not_found_body) }
    end
  end
end
