all:
	flutter run

build:
	flutter build apk

adb:
	sudo adb kill-server
	sudo adb start-server
