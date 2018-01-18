# frozen_string_literal: true

module AdjustmentsHelper
  def split_adjustments(adjustments)
    val = ''

    adjustments.each do |a|
      val += if a.sub_item.present?
               "#{a.sub_item.list}#{in_out(a.presence)}, "
             else
               t('log.missing') + ', '
             end
    end

    val.chomp(', ')
  end

  def in_out(present)
    present ? t('model.adjustment.in') : t('model.adjustment.out')
  end

  def in_out_table(present)
    present ? t('model.adjustment.present') : t('model.adjustment.not_present')
  end

  def adjustment_collection
    [[t('model.adjustment.present'), true],
     [t('model.adjustment.not_present'), false]]
  end
end
