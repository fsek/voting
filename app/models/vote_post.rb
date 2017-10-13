# frozen_string_literal: true

# Holds a users vote for a specific voting
class VotePost < ApplicationRecord
  acts_as_paranoid

  belongs_to :vote
  belongs_to :user

  has_many :audits, as: :auditable

  attr_accessor :vote_option_ids, :votecode

  validates :user_id, :vote_id, :votecode, presence: true
  validates :user_id, uniqueness: { scope: :vote_id,
                                    message: I18n.t('vote_post.already_voted') }
  validate :vote_open, :user_details, :option_details

  after_create :log_create
  after_update :log_update
  after_destroy :log_destroy

  def log_create
    Audit.create!(auditable: self, user_id: user_id, vote_id: vote_id,
                  audited_changes: create_changes,
                  action: 'create', updater_id: updater)
  end

  def log_update
    log('update') if log_changes.present?
  end

  def log_destroy
    log('destroy')
  end

  def log(action)
    Audit.create!(auditable: self, user_id: user_id, vote_id: vote_id,
                  audited_changes: log_changes,
                  action: action, updater_id: updater)
  end

  def create_changes
    saved_changes.except(:created_at, :updated_at, :deleted_at, :id, :selected)
  end

  def log_changes
    saved_changes.except(:created_at, :updated_at, :deleted_at, :id)
  end

  def updater
    User.current.id if User.current && !destroyed?
  end

  def trim_votecode
    self.votecode = votecode.gsub(/[^0-9a-zA-Z]/, '')
  end

  private

  def user_details
    unless User.exists?(id: user_id, votecode: votecode, presence: true)
      errors.add(:votecode, I18n.t('vote_post.bad_votecode_or_presence'))
    end
  end

  def vote_open
    unless vote.present? && vote.open?
      errors.add(:votecode, I18n.t('vote_post.vote_closed'))
    end
  end

  def option_details
    if vote_option_ids.present?
      unless vote_option_ids.count <= vote.choices
        errors.add(:vote_option_ids, I18n.t('vote_post.too_many_options'))
      end
      unless vote_option_ids.uniq.count == vote_option_ids.count
        errors.add(:vote_option_ids, I18n.t('vote_post.same_option_twice'))
      end
      unless (vote_option_ids.map(&:to_i) - vote.vote_option_ids).empty?
        errors.add(:vote_option_ids, I18n.t('vote_post.unallowed_options'))
      end
    end
  end
end
