require 'open-uri'

module OpenURI
  class << self
    alias :_open_http :open_http
  end

  def self.open_http(buf, target, proxy, options)
    proxy_wrap = proxy
    if proxy_wrap && proxy.first.class == URI::HTTP
      proxy_uri, proxy_user, proxy_pass = proxy
      proxy_wrap = [proxy_uri, proxy_user || proxy_uri.user, proxy_pass || proxy_uri.password]
    end

    _open_http(buf, target, proxy_wrap, options)
  end
end
