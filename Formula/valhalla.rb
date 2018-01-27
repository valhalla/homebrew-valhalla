class Valhalla < Formula
  desc "Open Source Routing Engine for OpenStreetMap"
  homepage "https://github.com/valhalla/valhalla/"
  version "2.4.6"
  url "https://github.com/valhalla/valhalla.git", tag: version, shallow: true
  sha256 "e24207d520fb6edaf82e93ce593f12f0f6f1278aef30e1d8ab5893890f474374"

  ["autoconf", "automake", "libtool", "boost-python", "libspatialite", "geos", "pkg-config"].each do |package|
    depends_on package => :build
  end
  ["protobuf", "protobuf-c", "sqlite3", "lua", "jq", "curl", "prime_server", "lz4"].each do |package|
    depends_on package
  end

  def install
    system "./autogen.sh"
    system 'export LDFLAGS="-L/usr/local/opt/sqlite/lib/ -lsqlite3"'
    system "export PKG_CONFIG_PATH=/usr/local/opt/curl/lib/pkgconfig"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-protobuf-libdir=/usr/local/opt/protobuf-c/lib",
                          "--with-protoc=/usr/local/opt/protobuf/bin/protoc"
    system "make", "install"
  end

  test do
    pipe_output("valhalla_service").include?("Usage: valhalla_service config/file.json [concurrency]")
  end
end
