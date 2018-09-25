RSpec.shared_context 'unstable tree api stubs and data' do
  let(:name) { 'input' }
  let(:url) { "#{Api::UnstableTree.base_uri}#{Api::UnstableTree::TREE_PATH}#{name}" }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:upstream_failure_body) { 'Internal derper error. Nobody has been notified.' }
  let(:not_found_body) { { 'error' => 'Can\'t find that tree' } }
  let(:tree) { JSON.parse(file_fixture('original_tree.json').read) }
  let(:pruned_tree) { JSON.parse(file_fixture('pruned_example_tree.json').read) }

  def stub_upstream_failure
    stub_request(:get, url).to_return(body: upstream_failure_body, status: 500, headers: headers)
  end

  def stub_successful_response
    stub_request(:get, url).to_return(body: tree.to_json, status: 200, headers: headers)
  end

  def stub_not_found_response
    stub_request(:get, url).to_return(body: not_found_body.to_json, status: 404, headers: headers)
  end

  def stub_two_failures_and_success_afterwards
    stub_request(:get, url).
      to_raise(Net::ReadTimeout).
      to_return(body: upstream_failure_body, status: 500, headers: headers).
      to_return(body: tree.to_json, status: 200, headers: headers)
  end
end
