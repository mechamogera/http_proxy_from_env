require_relative '../spec_helper'

describe Net::HTTP do
  let(:address) { 'address' }
  let(:proxy_address) { 'proxy.example' }
  let(:proxy_port) { 8080 }
  let(:proxy_user) { "proxy_user" }
  let(:proxy_pass) { "proxy_pass" }
  let(:proxy_uri) { "http://#{proxy_address}:#{proxy_port}" }
  let(:proxy_uri_with_auth) { "http://#{proxy_user}:#{proxy_pass}@#{proxy_address}:#{proxy_port}" }

  context 'proxy env' do
    before do
      ENV.delete('http_proxy')
      ENV.delete('HTTP_PROXY')
    end
    
    describe "HTTP.new" do
      let(:http) { http = Net::HTTP.new(address) }

      it { expect(http.proxy?).to be_falsey }
      it { expect(http.proxy_uri).to be_nil }
      it { expect(http.proxy_from_env?).to be_truthy }
      it { expect(http.proxy_address).to be_nil }
      it { expect(http.proxy_port).to be_nil }
      it { expect(http.proxy_user).to be_nil }
      it { expect(http.proxy_pass).to be_nil }
    end

    describe "Proxy.new" do
      let(:http) { Net::HTTP::Proxy().new(address) }

      it { expect(http.proxy?).to be_falsey }
      it { expect(http.proxy_uri).to be_nil }
      it { expect(http.proxy_from_env?).to be_truthy }
      it { expect(http.proxy_address).to be_nil }
      it { expect(http.proxy_port).to be_nil }
      it { expect(http.proxy_user).to be_nil }
      it { expect(http.proxy_pass).to be_nil }
    end
  end

  context 'proxy env' do
    before do
      ENV['http_proxy'] = proxy_uri
    end

    describe "HTTP.new" do
      let(:http) { http = Net::HTTP.new(address) }

      it { expect(http.proxy?).to be_truthy }
      it { expect(http.proxy_uri).to eq(URI(proxy_uri)) }
      it { expect(http.proxy_from_env?).to be_truthy }
      it { expect(http.proxy_address).to eq(proxy_address) }
      it { expect(http.proxy_port).to eq(proxy_port) }
      it { expect(http.proxy_user).to be_nil }
      it { expect(http.proxy_pass).to be_nil }
    end

    describe "Proxy.new" do
      let(:http) { Net::HTTP::Proxy().new(address) }

      it { expect(http.proxy?).to be_truthy }
      it { expect(http.proxy_uri).to eq(URI(proxy_uri)) }
      it { expect(http.proxy_from_env?).to be_truthy }
      it { expect(http.proxy_address).to eq(proxy_address) }
      it { expect(http.proxy_port).to eq(proxy_port) }
      it { expect(http.proxy_user).to be_nil }
      it { expect(http.proxy_pass).to be_nil }
    end

    describe "Proxy.new with auth" do
      let(:http) { http = Net::HTTP::Proxy(:ENV, nil, proxy_user, proxy_pass).new(address) }

      it { expect(http.proxy?).to be_truthy }
      it { expect(http.proxy_uri).to eq(URI(proxy_uri)) }
      it { expect(http.proxy_from_env?).to be_truthy }
      it { expect(http.proxy_address).to eq(proxy_address) }
      it { expect(http.proxy_port).to eq(proxy_port) }
      it { expect(http.proxy_user).to eq(proxy_user) }
      it { expect(http.proxy_pass).to eq(proxy_pass) }
    end

    describe "Proxy.new with proxy" do
      let(:force_proxy_address) { "hoge_address" }
      let(:force_proxy_port) { 1234 }
      let(:force_proxy_user) { "hoge_user" }
      let(:force_proxy_pass) { "hoge_pass" }
      let(:http) { http = Net::HTTP::Proxy(force_proxy_address, force_proxy_port, force_proxy_user, force_proxy_pass).new(address) }

      it { expect(http.proxy?).to be_truthy }
      it { expect(http.proxy_uri).to eq(URI(proxy_uri)) }
      it { expect(http.proxy_from_env?).to be_falsey }
      it { expect(http.proxy_address).to eq(force_proxy_address) }
      it { expect(http.proxy_port).to eq(force_proxy_port) }
      it { expect(http.proxy_user).to eq(force_proxy_user) }
      it { expect(http.proxy_pass).to eq(force_proxy_pass) }
    end
  end

  context 'auth proxy env' do
    before do
      ENV['http_proxy'] = proxy_uri_with_auth
    end

    describe "HTTP.new" do
      let(:http) { http = Net::HTTP.new(address) }

      it { expect(http.proxy?).to be_truthy }
      it { expect(http.proxy_uri).to eq(URI(proxy_uri_with_auth)) }
      it { expect(http.proxy_from_env?).to be_truthy }
      it { expect(http.proxy_address).to eq(proxy_address) }
      it { expect(http.proxy_port).to eq(proxy_port) }
      it { expect(http.proxy_user).to eq(proxy_user) }
      it { expect(http.proxy_pass).to eq(proxy_pass) }
    end

    describe "Proxy.new" do
      let(:http) { Net::HTTP::Proxy().new(address) }

      it { expect(http.proxy?).to be_truthy }
      it { expect(http.proxy_uri).to eq(URI(proxy_uri_with_auth)) }
      it { expect(http.proxy_from_env?).to be_truthy }
      it { expect(http.proxy_address).to eq(proxy_address) }
      it { expect(http.proxy_port).to eq(proxy_port) }
      it { expect(http.proxy_user).to eq(proxy_user) }
      it { expect(http.proxy_pass).to eq(proxy_pass) }
    end

    describe "Proxy.new with auth" do
      let(:force_proxy_user) { "hoge_user" }
      let(:force_proxy_pass) { "hoge_pass" }
      let(:http) { http = Net::HTTP::Proxy(:ENV, nil, force_proxy_user, force_proxy_pass).new(address) }

      it { expect(http.proxy?).to be_truthy }
      it { expect(http.proxy_uri).to eq(URI(proxy_uri_with_auth)) }
      it { expect(http.proxy_from_env?).to be_truthy }
      it { expect(http.proxy_address).to eq(proxy_address) }
      it { expect(http.proxy_port).to eq(proxy_port) }
      it { expect(http.proxy_user).to eq(force_proxy_user) }
      it { expect(http.proxy_pass).to eq(force_proxy_pass) }
    end
  end
end
