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

  scope :includes_users, -> { includes(:to, :from) }

  scope :involving, -> (user_id) {
    where("from_id = ? OR to_id = ?", user_id, user_id)
  }
  scope :between, -> (user, other_user) {
    where("(from_id = ? AND to_id = ?) OR (from_id = ? AND to_id = ?)", user.id, other_user.id, other_user.id, user.id)
  }

  scope :point_totals_by_user, -> {
    select("to_id, from_id, sum(points) as points, min(created_at) as created_at_min, max(created_at) as created_at_max")
    .group(:to_id, :from_id)
    .order("to_id + from_id asc, greatest(to_id, from_id), least(to_id, from_id)")
  }

  scope :chronologically_desc, -> {
    order("coalesce(created_at, to_timestamp(0)) desc, id desc")
  }

end