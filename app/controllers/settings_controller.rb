class SettingsController < ApplicationController
  def index
    @domains = Setting.allowed_domains.join("\n")
  end

  def update
    domains = params[:domains].to_s.split("\n").map(&:strip).reject(&:blank?)
    Setting.allowed_domains = domains
    redirect_to settings_path, notice: 'Settings updated successfully.'
  end
end
