include $(THEOS)/makefiles/common.mk

export TARGET = iphone:clang:9.3:9.0

export ARCHS = arm64

BUNDLE_NAME = PodSeek
PodSeek_FILES = PodSeek.m
PodSeek_INSTALL_PATH = /Library/PreferenceBundles
PodSeek_FRAMEWORKS = UIKit CoreGraphics QuartzCore
PodSeek_PRIVATE_FRAMEWORKS = Preferences
PodSeek_CFLAGS = -Wno-deprecated-declarations
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PodSeek.plist$(ECHO_END)
