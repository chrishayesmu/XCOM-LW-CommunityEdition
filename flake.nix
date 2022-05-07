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
          set -Eeuo pipefail
          set -x

          export DISPLAY=:99
          export WINEPREFIX="${pfx}"
          export WINEARCH='win32'
          export WINEDEBUG='fixme-all,trace-all'

          export FONTCONFIG_FILE="${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
          export FONTCONFIG_PATH="${pkgs.fontconfig.out}/etc/fonts/";
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

          mkdir -p cache
          export XDG_CACHE_HOME="$PWD/cache"
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
          nativeBuildInputs = with pkgs; [winetricks wine xdummy mesa.drivers pkgs.pkgsi686Linux.mesa.drivers libglvnd];
          buildPhase = winesetup {
            pfx = "$PWD/build/wpfx";
            cmd = ''
              export W_CACHE="$PWD"
              export WINETRICKS_LATEST_VERSION_CHECK=disabled
              mkdir dotnet40
              ln -s "${dotNet40}" "dotnet40/$(stripHash "${dotNet40}")"

              make UDK="${udk}" build/wpfx/drive_c/UDK/UDK-2011-09/UDKGame/Config/DefaultEngine.ini.default
            '';
          };
          installPhase = ''
            cp -rT build/wpfx "$out"
          '';
        };

        lwce = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "XCOM-LW-CommunityEdition";
          version = "0.0.1";
          src = pkgs.lib.cleanSource ./.;
          nativeBuildInputs = with pkgs; [dos2unix wine xdummy mesa.drivers pkgs.pkgsi686Linux.mesa.drivers libglvnd];
          buildPhase = winesetup {
            pfx = "$PWD/build/wpfx";
            cmd = ''
              mkdir -p "$WINEPREFIX"
              cp -rfP --no-preserve=all -t "$WINEPREFIX" "${packages.udk_wpfx}"/*

              make UDK="${udk}"
            '';
          };
          installPhase = ''
            set -Eeuo pipefail
            make UDK="${udk}" DESTDIR="$out" install
          '';
        };

        default = packages.lwce;
      };
      devShells = {
        default = packages.lwce;
      };
    });
}
