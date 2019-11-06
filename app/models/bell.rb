class Bell < ApplicationRecord
  has_many :messages, dependent: :destroy
end
