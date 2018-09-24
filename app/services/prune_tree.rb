class PruneTree
  SUB_THEMES_KEY = 'sub_themes'.freeze
  CATEGORIES_KEY = 'categories'.freeze
  INDICATORS_KEY = 'indicators'.freeze
  INDICATOR_ID_KEY = 'id'.freeze

  def initialize(tree, indicator_ids = [])
    # Note: Pruning mutates tree
    # If you want to make a deep copy of tree:
    # @tree = Marshal.load(Marshal.dump(tree)) # slow operation
    @tree = tree
    @indicators = indicator_ids
  end

  def call
    pruned_tree
  end

  private

  def pruned_tree
    tree.keep_if { |theme| pruned_sub_themes(theme[SUB_THEMES_KEY]).present? }
  end

  def pruned_sub_themes(sub_themes)
    sub_themes.keep_if { |sub_theme| pruned_categories(sub_theme[CATEGORIES_KEY]).present? }
  end

  def pruned_categories(categories)
    categories.keep_if { |category| pruned_indicators(category[INDICATORS_KEY]).present? }
  end

  def pruned_indicators(indicators)
    indicators.keep_if { |indicator| indicator_found?(indicator) }
  end

  def indicator_found?(indicator)
    indicators.include?(indicator[INDICATOR_ID_KEY])
  end

  attr_reader :tree, :indicators
end
