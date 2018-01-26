class PrimeServer < Formula
  desc "non-blocking (web)server API for distributed computing and SOA based on zeromq"
  homepage "https://github.com/kevinkreiser/prime_server"
  version "0.6.3"
  url "https://github.com/kevinkreiser/prime_server.git", tag: version
  sha256 "dd891bc74e2220597460b3811a1bc4e3488aaf809c1fa6bfbc849b564bc8d597"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "czmq"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pipe_output("prime_serverd").include?("Usage: prime_serverd num_requests|server_listen_endpoint concurrency")
  end
end
