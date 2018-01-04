# frozen_string_literal: true

module ItemsHelper
  def item_type(type)
    t("model.item.types.#{type}")
  end

  def item_types
    Item.types.keys.map { |t| [item_type(t), t] }
  end

  def item_multiplicity(type)
    t("model.item.multiplicities.#{type}")
  end
end
