class Performance < ApplicationRecord
  belongs_to :performer
  belongs_to :video
  has_many :activities
end
