module ApplicationHelper
  def active_on_nav(nav_pattern)
    if request.original_url =~ nav_pattern
      "active"
    else
      ""
    end
  end

  def build_title(show_env: false)
    title = ""
    if show_env && !Rails.env.production?
      title = "[#{Rails.env.upcase}] "
    end
    title << " #{content_for?(:title) ? content_for(:title) : 'Gloom'}"
    title
  end
end
