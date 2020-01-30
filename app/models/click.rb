require 'action_view'
require 'action_view/helpers'

class Click < ActiveRecord::Base

  include ActionView::Helpers::DateHelper

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

  def created_time_ago_in_words
    time_ago_in_words(self.created_at) + " ago"
  end

  def next_click_allowed
    self.created_at + POINTS_TO_MINUTES[self.value].minutes
  end

  def next_click_allowed_words
    time_ago_in_words(self.next_click_allowed)
  end

  private

  def set_points
    self.value ||= POSSIBLE_POINTS.sample
  end
end