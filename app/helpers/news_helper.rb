module NewsHelper
  def news_user(news)
    if news.present? && news.user.present?
      content_tag(:span, class: :link) do
        link_to(news.user, target: :blank) do
          fa_icon('user') + ' ' + news.user
        end
      end
    end
  end
end
