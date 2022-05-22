class Task < ApplicationRecord
  serialize :notes, Array
  belongs_to :user
end
