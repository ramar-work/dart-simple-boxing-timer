NAME=ibt
MAC_REMOTE=mac
WIN_REMOTE=win
BUILD_DIR=~/prj/$(NAME)
MAC_REMOTE_BIN=/usr/local/flutter/bin/flutter
SCP=rsync -arz
SSH=ssh
FILELIST=./android ./assets ./ios ./lib ./test Makefile pubspec.lock pubspec.yaml

# list : List all the targets and what they do
list:
	@printf 'Available options are:\n'
	@sed -n '/^# / { s/# //; 1d; p; }' Makefile | \
		awk -F ':' '{ printf "  %-20s - %s\n", $$1, $$2 }'


# deploy : Run and test on locally connected device
deploy:
	flutter run


# lint : Test for errors
lint:
	@flutter analyze lib | grep 'error'


# analyze : Test for errors AND stylistic notes
analyze:
	flutter analyze lib | grep 'error'


# pkg : Builds an APK or other signed package (not like pkg on other file types)
pkg:
	flutter build


# ios : syncs code and builds a version of this app on ios
ios: REMOTE=$(MAC_REMOTE)
ios: remote-build
	@printf '' > /dev/null


# android : syncs code and builds a version of this app on another Android capable system
android: REMOTE=
android:
	@printf '' > /dev/null


# finalize : Prepare a build for all platforms and do something else
finalize:
	printf '' > /dev/null


# filelist: show list of files needed when copying flutter code to other places...
filelist:
	echo $(FILELIST)


checks:
	@test ! -z "$(BUILD_DIR)/" || printf "No build directory specified.  Stopping.\n" > /dev/stderr
	@test ! -z "$(BUILD_DIR)/"
	rsync || printf "rsync not installed.  Stopping.\n" > /dev/stderr
	rsync
	ssh || printf "rsync not installed.  Stopping.\n" > /dev/stderr
	ssh	


remote-build:
	test ! -z "$(BUILD_DIR)/" || printf "No build directory specified.  Stopping.\n" > /dev/stderr
	test ! -z "$(BUILD_DIR)/"
	$(SSH) $(REMOTE) "test -d $(BUILD_DIR)/ || mkdir -p $(BUILD_DIR)/build/"
	$(SCP) $(FILELIST) $(REMOTE):$(BUILD_DIR)/
	$(SSH) $(REMOTE) "cd $(BUILD_DIR) && $(MAC_REMOTE_BIN) run"


