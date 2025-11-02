class RedirectController < ApplicationController
  skip_before_action :require_login

  def quick_create
    unless logged_in?
      redirect_to login_path, alert: 'Please log in to create quick links'
      return
    end

    # Get URL from form parameter
    url = params[:url]
    unless url.present?
      redirect_to root_path, alert: 'No URL provided'
      return
    end

    host_with_port = request.port.present? && ![80, 443].include?(request.port) ? "#{request.host}:#{request.port}" : request.host
    
    short_name = Link.generate_random_short_name(host_with_port)
    link = Link.new(
      short_name: short_name,
      url: url,
      domain: host_with_port
    )

    if link.save
      redirect_to link_path(link), notice: "Quick link created: #{request.host_with_port}/#{short_name}"
    else
      redirect_to root_path, alert: "Failed to create quick link: #{link.errors.full_messages.join(', ')}"
    end
  end

  def index
    # Get the raw path - Rails glob params mangle URLs with ://
    # Use original_fullpath and strip query string if present
    raw_path = request.original_fullpath.split('?').first
    path = raw_path.delete_prefix('/')
    short, param = path.split('/', 2)
    @short = short

    Rails.logger.debug "Redirect#index: original_fullpath=#{request.original_fullpath}, path=#{path}, short=#{short}"

    # Check if this looks like a URL for quick creation
    if path.include?('://') || path.match?(/^[a-z0-9.-]+\.[a-z]{2,}/i)
      unless logged_in?
        redirect_to login_path, alert: 'Please log in to create quick links'
        return
      end
      @url = path
      return render :quick_create_confirm
    end

    host_with_port = request.port.present? && ![80, 443].include?(request.port) ? "#{request.host}:#{request.port}" : request.host
    link = Link.find_by(short_name: short, domain: host_with_port) || 
           Link.find_by(short_name: short, domain: request.host) || 
           Link.find_by(short_name: short, domain: nil)

    unless link
      return head :not_found
    end

    if link.authenticated_only && !logged_in?
      redirect_to login_path, alert: 'Please log in to access this link'
      return
    end

    Link.increment_counter(:clicks, link.id)
    redirect_to construct_url(link, param.to_s), allow_other_host: true
  end

  private

    def construct_url(link, param)
      if !param.blank?
        return "#{link.params_url}#{param}" if link.params_url
      end
      return link.url
    end

end
