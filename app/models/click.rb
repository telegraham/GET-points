class Click < ActiveRecord::Base

  belongs_to :user

  validate :user_can_click

  POSSIBLE_POINTS = [
    # 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    # 100, 100, 100, 100, 100, 100, 100, 100, 
    # 250, 250, 250, 250, 
    # 500, 500, 
    # 1000
    10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 10_000, 
    100_000, 100_000, 100_000, 100_000, 100_000, 100_000, 100_000, 100_000, 
    250_000, 250_000, 250_000, 250_000, 
    500_000, 500_000, 
    1_000_000
  ]

  POINTS_TO_MINUTES = { # do not remove keys from me
    0 => 15,
    100 => 30,
    250 => 45,
    500 => 60,
    1000 => 90,

    10_000 => 15,
    100_000 => 30,
    250_000 => 45,
    500_000 => 60,
    1_000_000 => 90,

  }

  after_initialize :set_points

  def timeout
    POINTS_TO_MINUTES[self.value].minutes
  end

  def next_click_allowed
    @next_click_allowed ||= self.created_at + self.timeout
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