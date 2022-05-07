{
  description = "A nix flake for Long War Community Edition";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      wine = pkgs.wineWowPackages.unstableFull;
      winedeps = with pkgs; [wine xdummy mesa.drivers pkgs.pkgsi686Linux.mesa.drivers libglvnd];

      dotNet40 = pkgs.fetchurl {
        url = "https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe";
        sha256 = "sha256-ZeBkJY8uQYgWswT2Rv+eh68QHkyVUqsGS7dNKBw4ZZ8=";
      };
      udk = pkgs.fetchurl {
        url = "https://mcmullin.de/public/games/modding/xcom/udk/UDKInstall-2011-09-BETA.exe";
        sha256 = "sha256-224tDCt4iOcLMCNYqvHgIvC+psnsnNC52p0ejkMEo9c=";
      };

      winesetup = {
        pfx,
        cmd,
      }:
        ''
          set -Eeo pipefail
          set -x

          export DISPLAY=:99
          export WINEPREFIX="${pfx}"
          export WINEARCH='win32'
          export WINEDEBUG='fixme-all,trace-all'

          # Silence some warnings that can drown out useful output
          mkdir -p cache
          export XDG_CACHE_HOME="$PWD/cache"
          export FONTCONFIG_FILE="${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
          export FONTCONFIG_PATH="${pkgs.fontconfig.out}/etc/fonts/";

          # Needed to get software rendering OpenGL / GLX to work in our xserver
          export LD_LIBRARY_PATH="${pkgs.libglvnd}/lib:${pkgs.pkgsi686Linux.mesa.drivers}/lib:${pkgs.mesa.drivers}/lib:''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          export XDG_DATA_DIRS="${pkgs.pkgsi686Linux.mesa.drivers}/share:${pkgs.mesa.drivers}/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
          export LIBGL_DRIVERS_PATH="${pkgs.pkgsi686Linux.mesa.drivers}/lib/dri:${pkgs.mesa.drivers}/lib/dri''${LIBGL_DRIVERS_PATH:+:''${LIBGL_DRIVERS_PATH}}"

          mkdir -p /tmp/.X11-unix
          xdummy "$DISPLAY" -verbose +extension GLX +extension RANDR +extension RENDER &
          stop_dummy() {
            kill $1
            wait
          }
          trap "stop_dummy $!" EXIT
        ''
        + cmd
        + ''
          set +x
        '';
    in rec {
      packages = {
        udk_wpfx = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "XCOM-LW-CommunityEdition-udk";
          version = "0.0.1";
          # Only depend on the files that influence how the wine prefix and UDK get installed
          # This allows caching the lengthy UDK installation
          src = builtins.path {
            filter = path: type: builtins.elem (baseNameOf path) ["Makefile" "wine_build"];
            path = ./.;
            name = "lwce_udk_cache";
          };
          nativeBuildInputs = [pkgs.winetricks] ++ winedeps;
          preBuild = winesetup {
            pfx = "$PWD/build/wpfx";
            cmd = ''
              export W_CACHE="$PWD"
              export WINETRICKS_LATEST_VERSION_CHECK=disabled
              mkdir dotnet40
              ln -s "${dotNet40}" "dotnet40/$(stripHash "${dotNet40}")"
            '';
          };
          makeFlags = ["UDK=${udk}"];
          buildFlags = ["build/wpfx/drive_c/UDK/UDK-2011-09/UDKGame/Config/DefaultEngine.ini.default"];
          installPhase = ''
            cp -rT build/wpfx "$out"
          '';
        };

        lwce = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "XCOM-LW-CommunityEdition";
          version = "0.0.1";
          srcs = [
            (pkgs.lib.cleanSource ./.)
            packages.udk_wpfx
          ];
          sourceRoot = "source";
          nativeBuildInputs = [pkgs.dos2unix] ++ winedeps;
          preBuild = winesetup {
            pfx = "$PWD/build/wpfx";
            cmd = ''
              # wine requires that the wineprefix is owned by the current user, so we can't use it from the store path directly
              mkdir -p build
              chmod -R u+w "''${PWD%$sourceRoot}/$(stripHash "${packages.udk_wpfx}")"
              mv "''${PWD%$sourceRoot}/$(stripHash "${packages.udk_wpfx}")" "$WINEPREFIX"
            '';
          };
          makeFlags = ["UDK=${udk}"];
          installFlags = ["DESTDIR=$(out)"];
        };

        default = packages.lwce;
      };
      devShells = {
        default = packages.lwce;
      };
    });
}
