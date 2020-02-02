module UserHelper

  def relative_user_name them, us
    if them === us
      "you"
    else
      them.name
    end
  end

  def relative_transfers_between(from, to, current_user)
    "/#{ current_user.slug }/transfers_with/#{ from === current_user ? to.slug : from.slug }"
  end

end