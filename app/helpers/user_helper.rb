module UserHelper

  def relative_user_name them, us
    if them === us
      "you"
    else
      them.name
    end
  end

end