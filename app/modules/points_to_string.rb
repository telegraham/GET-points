require 'action_view'
require 'action_view/helpers'

module PointsToString
  include ActionView::Helpers::NumberHelper

  def points_in_words(points)
      # points.abs > 999_999 ? number_to_human(points) : 
      number_with_precision(points, precision: 0, delimiter: ",")
  end
end