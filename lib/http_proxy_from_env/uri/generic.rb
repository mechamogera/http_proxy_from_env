require 'uri'

class URI::Generic
  unless method_defined? :find_proxy
    def find_proxy
      raise BadURIError, "relative URI: #{self}" if self.relative?
      name = self.scheme.downcase + '_proxy'
      proxy_uri = nil
      if name == 'http_proxy' && ENV.include?('REQUEST_METHOD') # CGI?
        # HTTP_PROXY conflicts with *_proxy for proxy settings and
        # HTTP_* for header information in CGI.
        # So it should be careful to use it.
        pairs = ENV.reject {|k, v| /\Ahttp_proxy\z/i !~ k }
        case pairs.length
        when 0 # no proxy setting anyway.
          proxy_uri = nil
        when 1
          k, _ = pairs.shift
          if k == 'http_proxy' && ENV[k.upcase] == nil
            # http_proxy is safe to use because ENV is case sensitive.
            proxy_uri = ENV[name]
          else
            proxy_uri = nil
          end
        else # http_proxy is safe to use because ENV is case sensitive.
          proxy_uri = ENV.to_hash[name]
        end
        if !proxy_uri
          # Use CGI_HTTP_PROXY.  cf. libwww-perl.
          proxy_uri = ENV["CGI_#{name.upcase}"]
        end
      elsif name == 'http_proxy'
        unless proxy_uri = ENV[name]
          if proxy_uri = ENV[name.upcase]
            warn 'The environment variable HTTP_PROXY is discouraged.  Use http_proxy.'
          end
        end
      else
        proxy_uri = ENV[name] || ENV[name.upcase]
      end

      if proxy_uri.nil? || proxy_uri.empty?
        return nil
      end

      if self.hostname
        require 'socket'
        begin
          addr = IPSocket.getaddress(self.hostname)
          return nil if /\A127\.|\A::1\z/ =~ addr
        rescue SocketError
        end
      end

      name = 'no_proxy'
      if no_proxy = ENV[name] || ENV[name.upcase]
        no_proxy.scan(/([^:,]*)(?::(\d+))?/) {|host, port|
          if /(\A|\.)#{Regexp.quote host}\z/i =~ self.host &&
            (!port || self.port == port.to_i)
            return nil
          end
        }
      end
      URI.parse(proxy_uri)
    end
  end
end
