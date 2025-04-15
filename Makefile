all:
	flutter run

apk:
	flutter build apk

adb:
	sudo adb kill-server
	sudo adb start-server
