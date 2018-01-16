# frozen_string_literal: true

module UserService
  def self.set_card_number(user, card_number)
    if user.present? && card_number.present?
      if user.persisted? && user.card_number.present?
        user.errors.add(:card_number, I18n.t('user.card_number_already_set'))
        false
      else
        user.update(card_number: card_number)
      end
    else
      false
    end
  end
end
