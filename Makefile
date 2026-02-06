APP_NAME = StayAwake
BUILD_DIR = build
APP_BUNDLE = $(BUILD_DIR)/$(APP_NAME).app
INSTALL_DIR = $(HOME)/Applications

.PHONY: build install uninstall run clean autostart

build:
	@command -v caffeinate >/dev/null 2>&1 || { echo "Error: 'caffeinate' not found on this system. StayAwake requires caffeinate (built into macOS) and cannot be installed without it."; exit 1; }
	@echo "Building $(APP_NAME)..."
	@mkdir -p $(APP_BUNDLE)/Contents/MacOS
	@mkdir -p $(APP_BUNDLE)/Contents/Resources
	@swiftc -o $(APP_BUNDLE)/Contents/MacOS/$(APP_NAME) src/$(APP_NAME).swift -framework Cocoa
	@cp resources/Info.plist $(APP_BUNDLE)/Contents/
	@cp resources/AppIcon.icns $(APP_BUNDLE)/Contents/Resources/
	@echo "Built $(APP_BUNDLE)"

install: build
	@mkdir -p $(INSTALL_DIR)
	@cp -R $(APP_BUNDLE) $(INSTALL_DIR)/
	@echo "Installed to $(INSTALL_DIR)/$(APP_NAME).app"

uninstall:
	@rm -rf $(INSTALL_DIR)/$(APP_NAME).app
	@echo "Uninstalled $(APP_NAME)"

run: build
	@open $(APP_BUNDLE)

autostart: install
	@osascript -e 'tell application "System Events" to make login item at end with properties {path:"$(INSTALL_DIR)/$(APP_NAME).app", hidden:false}'
	@echo "$(APP_NAME) will now start automatically on login"

clean:
	@rm -rf $(BUILD_DIR)
	@echo "Cleaned build directory"
