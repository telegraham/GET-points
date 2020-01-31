class Transfer < ActiveRecord::Base

  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  def affordable?
    to.points + points > 0
  end

end