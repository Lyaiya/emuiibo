APP_TITID := $(shell grep -oP '"tid"\s*:\s*"\K(\w+)' $(CURDIR)/emuiibo/toolbox.json)
APP_TITLE = emuiibo
export APP_TITLE

.PHONY: all dev emuiibo emuiibo-dev sysmodule sysmodule-dev overlay emuiigen dist clean emuiibo-clean emuiigen-clean

# We need to provide a custom target triple since the official tier 3 one doesn't provide crypto support
TARGET_TRIPLE := aarch64-nintendo-switch-freestanding-crypto

all: emuiibo emuiigen

dev: emuiibo-dev emuiigen

clean: emuiibo-clean emuiigen-clean

emuiibo: sysmodule overlay dist

emuiibo-dev: sysmodule-dev overlay dist

sysmodule:
	@cd emuiibo && cargo update && cargo nx build --release --target $(TARGET_TRIPLE).json

sysmodule-dev:
	@cd emuiibo && cargo update && cargo nx build --target $(TARGET_TRIPLE).json

overlay:
	@$(MAKE) -C overlay/

dist: sysmodule overlay
	@rm -rf $(CURDIR)/SdOut
	@mkdir -p $(CURDIR)/SdOut/atmosphere/contents/$(APP_TITID)/flags
	@touch $(CURDIR)/SdOut/atmosphere/contents/$(APP_TITID)/flags/boot2.flag
	@cp $(CURDIR)/emuiibo/target/$(TARGET_TRIPLE)/release/$(APP_TITLE).nsp $(CURDIR)/SdOut/atmosphere/contents/$(APP_TITID)/exefs.nsp
	@cp $(CURDIR)/emuiibo/toolbox.json $(CURDIR)/SdOut/atmosphere/contents/$(APP_TITID)/toolbox.json
	@mkdir -p $(CURDIR)/SdOut/switch/.overlays/lang/$(APP_TITLE)
	@cp -f $(CURDIR)/overlay/$(APP_TITLE).ovl $(CURDIR)/SdOut/switch/.overlays/$(APP_TITLE).ovl
	@cp -rf $(CURDIR)/overlay/lang/* $(CURDIR)/SdOut/switch/.overlays/lang/$(APP_TITLE)/
	@cd $(CURDIR)/SdOut; zip -r -q -9 $(APP_TITLE).zip atmosphere switch; cd $(CURDIR)

emuiigen:
	@cd emuiigen && mvn package

emuiibo-clean:
	@rm -rf $(CURDIR)/SdOut
	@cd emuiibo && cargo clean
	@$(MAKE) clean -C overlay/

emuiigen-clean:
	@cd emuiigen && mvn clean
