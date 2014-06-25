require_relative '../spec_helper'

describe URI::Generic do
  def with_env(envs = {}, &block)
    ENV.clear
    envs.each { |key, value| ENV[key] = value }
    block.call if block
  end

  def env_from_description
    a = self.class.description.split(/\s+\=\>\s+|\s*,\s*/)
    Hash[*a]
  end


  describe "#find_proxy" do
    let(:proxy_uri) { "http://192.168.0.1" }

    context "request to other"
      let(:request_uri) { "http://192.168.2.1" }

      subject { with_env(env_from_description) { URI(request_uri).find_proxy } }

      context "" do
        it { is_expected.to be_nil }
      end

      context "http_proxy => http://192.168.0.1/" do
        it { is_expected.to eq(URI(proxy_uri)) }
      end

      context "HTTP_PROXY => http://192.168.0.1/" do
        it { is_expected.to eq(URI(proxy_uri)) }
      end

      context "REQUEST_METHOD => GET" do
        it { is_expected.to be_nil }
      end

      context "CGI_HTTP_PROXY => http://192.168.0.1, REQUEST_METHOD => GET" do
        it { is_expected.to eq(URI(proxy_uri)) }
      end

      context "http_proxy => http://192.168.0.1/, no_proxy => 192.168.2.1" do
        it { is_expected.to be_nil }
      end

      context "http_proxy => http://192.168.0.1/, no_proxy => 192.168.2.1:8080" do
        it { is_expected.to eq(URI(proxy_uri)) }
      end

      context "http_proxy => http://192.168.0.1/, no_proxy => 192.168.2.1:80" do
        it { is_expected.to be_nil }
      end

      context "http_proxy => http://192.168.0.1/, no_proxy => 2.1:80" do
        it { is_expected.to be_nil }
      end

      context "CGI_HTTP_PROXY => http://192.168.0.1, REQUEST_METHOD => GET, no_proxy => 192.168.2.1" do
        it { is_expected.to be_nil }
      end
  end

  context "request to own" do
    let(:request_uri) { "http://localhost" }

    subject { with_env(env_from_description) { URI(request_uri).find_proxy } }

    context "http_proxy => http://192.168.0.1/" do
      it { is_expected.to be_nil }
    end
  end
end
