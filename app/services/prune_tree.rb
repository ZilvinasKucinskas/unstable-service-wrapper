class PruneTree
  SUB_THEMES_KEY = 'sub_themes'.freeze
  CATEGORIES_KEY = 'categories'.freeze
  INDICATORS_KEY = 'indicators'.freeze

  def initialize(tree, indicator_ids)
    # Note: Pruning mutates tree
    # If you want to make a deep copy of tree:
    # @tree = Marshal.load(Marshal.dump(tree)) # slow operation
    @tree = tree
    @indicators = indicator_ids
  end

  def call
    tree.keep_if do |theme|
      theme[SUB_THEMES_KEY].keep_if do |sub_theme|
        sub_theme[CATEGORIES_KEY].keep_if do |category|
          category[INDICATORS_KEY].keep_if { |indicator| indicators.include?(indicator['id']) }.present?
        end.present?
      end.present?
    end
  end

  private

  attr_reader :tree, :indicators
end
