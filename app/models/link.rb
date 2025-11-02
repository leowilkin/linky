class Link < ApplicationRecord

  validates :short_name, presence: true, uniqueness: { scope: :domain }
  validates :url, presence: true

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

  def self.generate_random_short_name(domain = nil)
    loop do
      short_name = SecureRandom.alphanumeric(6).downcase
      break short_name unless exists?(short_name: short_name, domain: domain)
    end
  end

end
