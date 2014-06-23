require 'net/http'
require 'http_proxy_from_env/uri/generic.rb'

class Net::HTTP
  unless method_defined?(:proxy_from_env)
    def self.new(address, port = nil, p_addr = :ENV, p_port = nil, p_user = nil, p_pass = nil)
      http = super address, port

      if proxy_class? then # from Net::HTTP::Proxy()
        http.proxy_from_env = @proxy_from_env
        http.proxy_address  = @proxy_address
        http.proxy_port     = @proxy_port
        http.proxy_user     = @proxy_user
        http.proxy_pass     = @proxy_pass
      elsif p_addr == :ENV then
        http.proxy_from_env = true
      else
        http.proxy_address = p_addr
        http.proxy_port    = p_port || default_port
        http.proxy_user    = p_user
        http.proxy_pass    = p_pass
      end

      http
    end

    def self.Proxy(p_addr = :ENV, p_port = nil, p_user = nil, p_pass = nil)
      return self unless p_addr

      Class.new(self) {
        @is_proxy_class = true

        if p_addr == :ENV then
          @proxy_from_env = true
          @proxy_address = nil
          @proxy_port    = nil
        else
          @proxy_from_env = false
          @proxy_address = p_addr
          @proxy_port    = p_port || default_port
        end

        @proxy_user = p_user
        @proxy_pass = p_pass
      }
    end

    @proxy_from_env = false
    @proxy_uri      = nil
    @proxy_address  = nil
    @proxy_port     = nil
    @proxy_user     = nil
    @proxy_pass     = nil

    attr_writer :proxy_from_env
    attr_writer :proxy_address
    attr_writer :proxy_port
    attr_writer :proxy_user
    attr_writer :proxy_pass

    def proxy?
      if @proxy_from_env then
        proxy_uri
      else
        @proxy_address
      end
    end

    def proxy_from_env?
      @proxy_from_env
    end

    def proxy_uri
      @proxy_uri ||= URI("http://#{address}:#{port}").find_proxy
    end

    def proxy_address
      if @proxy_from_env then
        proxy_uri && proxy_uri.hostname
      else
        @proxy_address
      end
    end

    def proxy_port
      if @proxy_from_env then
        proxy_uri && proxy_uri.port
      else
        @proxy_port
      end
    end

    def edit_path(path)
      if proxy? and not use_ssl? then
        "http://#{addr_port}#{path}"
      else
        path
      end
    end

    def conn_address
      proxy? ? proxy_address : address
    end

    def conn_port
      proxy? ? proxy_port : prot
    end
  end

  def proxy_user
    if @proxy_from_env then
      proxy_uri && proxy_uri.proxy_user
    else
      @proxy_user
    end
  end

  def proxy_pass
    if @proxy_from_env then
      proxy_uri && proxy_uri.proxy_pass
    else
      @proxy_pass
    end
  end
end
