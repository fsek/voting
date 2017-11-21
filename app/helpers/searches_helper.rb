# frozen_string_literal: true

module SearchesHelper
  def search_presences
    [[t('model.vote_user.presences.all'), nil],
     [t('model.vote_user.presences.present'), true],
     [t('model.vote_user.presences.not_present'), false]]
  end
end
