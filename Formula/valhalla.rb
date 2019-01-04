  class Valhalla < Formula
    desc "Routing engine for OpenStreetMap, Transitland, and elevation tiles"
    homepage "https://github.com/valhalla/valhalla/"
    url "https://github.com/valhalla/valhalla.git",
        # :tag => "2.7.0",
        :revision => "87bb212ccd30e53bf445c1b4732645da4d19a7c0"
    # revision 1
    version "3.0.2-rc" # NOTE: not really, this is a placeholder

    option "without-boost-python", "Skip compiling Python bindings"

    deprecated_option "without-python-bindings" => "without-boost-python"

    depends_on "cmake" => :build
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
    depends_on "coreutils" # to supply nproc for scripts
    depends_on "parallel" => :recommended # for scripts

    head do
      url "https://github.com/valhalla/valhalla.git", :using => :git, :branch => "master"
    end

    def install
      ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
      args = []
      if build.with? "boost-python"
        args << "-DENABLE_PYTHON_BINDINGS=On"
      else
        args << "-DENABLE_PYTHON_BINDINGS=Off"
      end
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-DENABLE_NODE_BINDINGS=Off" # TODO: support Node bindings in the future

      system "git submodule update --init --recursive"

      mkdir "build" do
        system "cmake", "..", *args, *std_cmake_args
        system "make"
        system "make", "install"
     end
    end

    test do
      output = shell_output("#{bin}/valhalla_service", 1)
      assert_match "Usage: #{bin}/valhalla_service config/file.json", output
      system "python", "-c", "import valhalla"
    end
  end
