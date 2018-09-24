require 'rails_helper'

RSpec.describe PruneTree, type: :service do
  let(:tree) { JSON.parse(file_fixture('original_tree.json').read) }

  describe '#call' do
    subject(:pruning) { described_class.new(tree, indicators).call }

    context 'with no indicators' do
      let(:indicators) { [] }
      let(:empty_tree) { [] }

      it { is_expected.to match_unordered_json(empty_tree) }
    end

    context 'with original example' do
      let(:indicators) { [1, 32, 31] }
      let(:pruned_tree) { JSON.parse(file_fixture('pruned_example_tree.json').read) }

      it { is_expected.to match_unordered_json(pruned_tree) }
    end

    context 'with all indicators' do
      let(:indicators) do
        tree.map { |theme| theme[described_class::SUB_THEMES_KEY] }.flatten
            .map { |sub_theme| sub_theme[described_class::CATEGORIES_KEY] }.flatten
            .map { |category| category[described_class::INDICATORS_KEY] }.flatten
            .map { |indicator| indicator[described_class::INDICATOR_ID_KEY] }
      end

      it { is_expected.to match_unordered_json(tree) }
    end
  end
end
