class RedirectController < ApplicationController
  skip_before_action :require_login

  def index
    path = request.path.reverse.chop.reverse
    short = path.split('/').first
    short = path if short.blank?
    param = path.gsub(/#{short}\/?/, "")

    @short = short

    link = Link.find_by_short_name( short )

    if link
      if link.authenticated_only && !logged_in?
        redirect_to login_path, alert: 'Please log in to access this link'
        return
      end
      
      link.clicks += 1
      link.save
      redirect_to construct_url(link, param), allow_other_host: true
    end

  end

  private

    def construct_url(link, param)
      if !param.blank?
        return "#{link.params_url}#{param}" if link.params_url
      end
      return link.url
    end

end
