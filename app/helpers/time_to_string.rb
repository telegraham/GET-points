require 'action_view'
require 'action_view/helpers'
require 'active_support/core_ext'

module TimeToString
  include ActionView::Helpers::DateHelper

  def click_time_ago_in_words(click)
    click ? time_ago_in_words(click.created_at) + " ago" : "never"
  end

  def click_time_future_in_words(click)
    (click && click.next_click_allowed >= Time.current) ? time_future_in_words(click.next_click_allowed) : "now"
  end

  def precise_time(time)
    if time.nil?
      "unknown"
    elsif time > Time.current
      time_ago_in_words(time) + " from now"
    elsif time.day == Time.current.day
      time.localtime.strftime("Today at %l:%M:%S %p %Z")
    elsif time.day == Time.current.day - 1
      time.localtime.strftime("Yesterday at %l:%M:%S %p %Z")
    elsif time > 1.week.ago
      time.localtime.strftime("%A at %l:%M:%S %p %Z")
    elsif time.year == Time.current.year
      time.localtime.strftime("%A, %B %e at %l:%M:%S %p %Z")
    else
      time.localtime.strftime("%A, %B %e, %Y at %l:%M:%S %p %Z")
    end
  end

  private

  def time_future_in_words(time)
    "in " + time_ago_in_words(time)
  end
end