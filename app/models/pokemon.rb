class Pokemon < ApplicationRecord
  has_and_belongs_to_many :abilities
  has_and_belongs_to_many :types
end
