SRCDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BUILDDIR = build
DESTDIR = install


ew_stub_packages = Core Engine GFxUI
lwce_stub_packages = XComGame XComStrategyGame XComUIShell XComMutator XComLZMutator
lwce_packages = XComLongWarCommunityEdition


WPFX = $(BUILDDIR)/wpfx
UDK = UDKInstall-2011-09-BETA.exe
UDK_PATH = UDK/UDK-2011-09

WINE_UDK = $(WPFX)/drive_c/$(UDK_PATH)
UDK_SRCPATH = $(WINE_UDK)/Development/Src
UDK_RELPATH = $(shell sed -e 's#[^/]\+#..#g' <<<"$(UDK_SRCPATH)")

engine_conf = $(WINE_UDK)/UDKGame/Config/DefaultEngine.ini

export WINEPREFIX=$(abspath $(WPFX))
export WINEARCH=win32
export WINEDEBUG=fixme-all,trace-all

all: $(foreach pkg,$(lwce_packages),$(BUILDDIR)/$(pkg).u)

$(engine_conf).default: $(SRCDIR)/wine_build $(UDK)
	bash $(SRCDIR)/wine_build init_wpfx "$(UDK)" "$(UDK_SRCPATH)" "$(engine_conf)" "$(engine_conf).default"

$(engine_conf): $(SRCDIR)/wine_build $(engine_conf).default $(SRCDIR)/Stubs $(SRCDIR)/Src
	bash $(SRCDIR)/wine_build lwce_udk "$(UDK_SRCPATH)" "$(SRCDIR)" "$(engine_conf).default" "$(engine_conf)" $(ew_stub_packages) $(lwce_stub_packages) $(lwce_packages)

udk_rebuild:

$(BUILDDIR)/%.u: $(SRCDIR)/wine_build $(engine_conf) udk_rebuild
	bash $(SRCDIR)/wine_build lwce_build "$(WINE_UDK)"
	cp "$(WINE_UDK)/UDKGame/Script/$(notdir $@)" "$@"

install: $(wildcard Config/* Localization/* Patches/* README*) all
	mkdir -p "$(DESTDIR)"/{CookedPCConsole,Config,Localization}
	$(foreach pkg,$(lwce_packages),cp "$(BUILDDIR)/$(pkg).u" "$(DESTDIR)/CookedPCConsole")
	for f in Config/* Localization/*; do unix2dos <"$$f" >"$(DESTDIR)/$$f"; done
	unix2dos <Patches/XComGame_Overrides.upatch > "$(DESTDIR)/LWCE_Install.txt"
	unix2dos <README_installation.txt > "$(DESTDIR)/README.txt"


clean:
	rm -rf $(BUILDDIR)

.PHONY: clean all udk_rebuild install

