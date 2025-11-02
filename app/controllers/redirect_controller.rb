class RedirectController < ApplicationController
  skip_before_action :require_login

  def quick_create
    unless logged_in?
      redirect_to login_path, alert: 'Please log in to create quick links'
      return
    end

    # Extract URL from path (everything after the first /)
    url = request.path.sub(/^\//, '')
    host_with_port = request.port.present? && ![80, 443].include?(request.port) ? "#{request.host}:#{request.port}" : request.host
    
    short_name = Link.generate_random_short_name(host_with_port)
    link = Link.new(
      short_name: short_name,
      url: url,
      domain: host_with_port
    )

    if link.save
      redirect_to link_path(link)
    else
      redirect_to root_path, alert: "Failed to create quick link: #{link.errors.full_messages.join(', ')}"
    end
  end

  def index
    full_path = request.path.sub(%r{^/}, '')
    
    # Check if this looks like a URL for quick creation
    if logged_in? && (full_path.include?('://') || full_path.match?(/^[a-z0-9.-]+\.[a-z]{2,}/i))
      return quick_create
    end
    
    path = request.path.reverse.chop.reverse
    short = path.split('/').first
    short = path if short.blank?
    param = path.gsub(/#{short}\/?/, "")

    @short = short

    host_with_port = request.port.present? && ![80, 443].include?(request.port) ? "#{request.host}:#{request.port}" : request.host
    link = Link.find_by(short_name: short, domain: host_with_port) || Link.find_by(short_name: short, domain: request.host) || Link.find_by(short_name: short, domain: nil)

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
