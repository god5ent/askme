module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.png'
    end
  end

  def inclination(number, one, several)
    one if number == 1
    several
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end
end