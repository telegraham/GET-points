class Transfer < ActiveRecord::Base

  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  validate :must_be_positive

  def must_be_positive
    if points < 0
      errors.add(:points, "must be a positive number")
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
    .order("abs(sum(points)) desc")
  }

  scope :chronologically_desc, -> {
    order("coalesce(created_at, to_timestamp(0)) desc, id desc")
  }

end