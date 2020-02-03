module UserHelper

  def relative_user_name(them, logged_in_user)
    (them == logged_in_user) ? "you" : them.name
  end

  private

  def transfers_with(primary, secondary, other_secondary = secondary)
    secondary = primary == secondary ? other_secondary : secondary
    "/#{ primary.slug }/transfers_with/#{ secondary.slug }"
  end

end