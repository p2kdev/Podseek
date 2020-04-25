include $(THEOS)/makefiles/common.mk

export TARGET = iphone:clang:11.2:11.0
export ARCHS=arm64

TWEAK_NAME = PodSeek
PodSeek_FILES = Tweak.xm
PodSeek_FRAMEWORKS = MediaPlayer
PodSeek_PRIVATE_FRAMEWORKS = MediaRemote
PodSeek_CFLAGS = -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
