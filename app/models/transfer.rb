class Transfer < ActiveRecord::Base

  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  validate :must_be_affordable
 
  def must_be_affordable
    return if self.id
    destination_points = to.points
    future_to_balance = destination_points + points
    if future_to_balance < 0 && future_to_balance < destination_points
      errors.add(:points, "must not be a quantity that would make the destination account negative (or more negative)")
    end
  end

end