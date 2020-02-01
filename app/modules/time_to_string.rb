require 'action_view'
require 'action_view/helpers'

module TimeToString
  include ActionView::Helpers::DateHelper

  def click_time_ago_in_words(click)
    click ? time_ago_in_words(click.created_at) + " ago" : "never"
  end

  def click_time_future_in_words(click)
    (click && click.next_click_allowed >= Time.now) ? "in " + time_ago_in_words(click.next_click_allowed) : "now"
  end
end