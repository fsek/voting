# frozen_string_literal: true

# Abstract active record class to inherit from
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
