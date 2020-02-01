class Click < ActiveRecord::Base

  belongs_to :user

  validate :user_can_click

  POSSIBLE_POINTS = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    100, 100, 100, 100, 100, 100, 100, 100, 
    250, 250, 250, 250, 
    500, 500, 
    1000
  ]

  POINTS_TO_MINUTES = {
    0 => 15,
    100 => 30,
    250 => 45,
    500 => 60,
    1000 => 90
  }

  after_initialize :set_points

  def next_click_allowed
    @next_click_allowed ||= self.created_at + POINTS_TO_MINUTES[self.value].minutes
  end

  def user_can_click
    unless user.can_click? || self.id
      errors.add(:user, "is not allowed to click right now")
    end
  end

  private

  def set_points
    self.value ||= POSSIBLE_POINTS.sample
  end
end