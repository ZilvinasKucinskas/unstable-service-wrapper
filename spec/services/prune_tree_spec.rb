require 'rails_helper'

RSpec.describe PruneTree, type: :service do
  let(:tree) { JSON.parse(file_fixture('original_tree.json').read) }

  describe '#call' do
    subject(:pruning) { described_class.new(tree, indicators).call }

    context 'with original example' do
      let(:indicators) { [1, 32, 31] }
      let(:pruned_tree) { JSON.parse(file_fixture('pruned_example_tree.json').read) }

      it { is_expected.to match_unordered_json(pruned_tree) }
    end
  end
end
