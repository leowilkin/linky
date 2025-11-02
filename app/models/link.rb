class Link < ApplicationRecord

  validates :short_name, presence: true, uniqueness: { scope: :domain }, format: { with: /\A[a-z0-9][a-z0-9._-]*\z/i }, length: { maximum: 64 }
  validates :url, presence: true
  validate :safe_urls
  validate :domain_in_allowed_list

  before_save :normalize_domain, :normalize_urls

  private

  def normalize_domain
    self.domain = nil if domain.blank?
  end

  def normalize_urls
    self.url = add_protocol(url) if url.present?
    self.params_url = add_protocol(params_url) if params_url.present?
  end

  def add_protocol(url)
    return url if url.blank? || url =~ /\A[a-z]+:\/\//i
    "https://#{url}"
  end

  def safe_urls
    errors.add(:url, 'must be http(s) with host') unless http_url?(url)
    if params_url.present? && !http_url?(params_url)
      errors.add(:params_url, 'must be http(s) with host')
    end
  end

  def http_url?(u)
    uri = URI.parse(u)
    uri.is_a?(URI::HTTP) && uri.host.present?
  rescue URI::InvalidURIError
    false
  end

  def domain_in_allowed_list
    return if domain.blank?
    errors.add(:domain, 'is not in allowed domains') unless Setting.allowed_domains.include?(domain)
  end

  def self.generate_random_short_name(domain = nil)
    loop do
      short_name = SecureRandom.alphanumeric(6).downcase
      break short_name unless exists?(short_name: short_name, domain: domain)
    end
  end

end
