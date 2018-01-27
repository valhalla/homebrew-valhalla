class Valhalla < Formula
  desc "Routing engine for OpenStreetMap, Transitland, and elevation tiles"
  homepage "https://github.com/valhalla/valhalla/"
  url "https://github.com/valhalla/valhalla.git", :tag => "2.4.6", :shallow => true
  sha256 "e24207d520fb6edaf82e93ce593f12f0f6f1278aef30e1d8ab5893890f474374"

  option "without-python-bindings", "Skip compiling optional Python bindings"

  ["autoconf", "automake", "libtool", "libspatialite", "geos", "pkg-config"].each do |package|
    depends_on package => :build
  end
  ["protobuf", "protobuf-c", "sqlite", "lua", "jq", "curl", "prime_server", "lz4"].each do |package|
    depends_on package
  end

  unless build.without? "python-bindings"
    depends_on "boost-python" => :build
  end

  def install
    system "./autogen.sh"
    system "export LDFLAGS=\"-L#{HOMEBREW_PREFIX}/opt/sqlite/lib/ -lsqlite3\""
    system "export PKG_CONFIG_PATH=#{HOMEBREW_PREFIX}/opt/curl/lib/pkgconfig"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-protobuf-libdir=#{HOMEBREW_PREFIX}/opt/protobuf-c/lib",
                          "--with-protoc=#{HOMEBREW_PREFIX}/opt/protobuf/bin/protoc",
                          # "--link-python-framework-via-dynamic-lookup", TODO: improve Python module stuff
                          "--enable-python-bindings=#{build.without?("python-bindings") ? 'no' : 'yes'}"
    system "make", "install"
  end

  test do
    pipe_output("${bin}/valhalla_service").include?("Usage: valhalla_service config/file.json [concurrency]")
  end
end
