class Valhalla < Formula
  desc "Routing engine for OpenStreetMap, Transitland, and elevation tiles"
  homepage "https://github.com/valhalla/valhalla/"
  url "https://github.com/valhalla/valhalla.git",
      :tag => "2.4.7",
      :revision => "2c086e9716da2e0eba91206849c2a95f2d63d53b"

  option "without-boost-python", "Skip compiling Python bindings"

  deprecated_option "without-python-bindings" => "without-boost-python"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost-python" => :recommended
  depends_on "curl" if MacOS.version <= :lion
  depends_on "geos"
  depends_on "jq"
  depends_on "libspatialite"
  depends_on "lua"
  depends_on "lz4"
  depends_on "prime_server"
  depends_on "protobuf"
  depends_on "protobuf-c"
  depends_on "sqlite"

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"

    system "./autogen.sh"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    if build.with? "boost-python"
      args << "--enable-python-bindings=yes"
    else
      args << "--enable-python-bindings=no"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/valhalla_service", 1)
    assert_match "Usage: #{bin}/valhalla_service config/file.json", output
    system "python", "-c", "import valhalla"
  end
end
