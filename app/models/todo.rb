class Todo < ActiveRecord::Base
  before_validation { |t| t.title.strip! }
  validates :title, presence: true
end
