module AdjustmentsHelper
  def split_adjustments(adjustments)
    val = ''
    adjustments.each do |a|
      val += '§' + a.agenda.order + in_out(a.presence) + ', '
    end
    val.chomp(', ')
  end

  def in_out(present)
    present ? t('adjustment.in') : t('adjustment.out')
  end

  def in_out_table(present)
    present ? t('adjustment.present') : t('adjustment.not_present')
  end

  def adjustment_collection
    [[t('adjustment.present'), true],
     [t('adjustment.not_present'), false]]
  end
end
