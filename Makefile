NAME=ibt
MAC_REMOTE=mac
WIN_REMOTE=win
BUILD_DIR=prj/$(NAME)
SCP=rsync -arvz
SSH=ssh

# list : List all the targets and what they do
list:
	@printf 'Available options are:\n'
	@sed -n '/^# / { s/# //; 1d; p; }' Makefile | \
		awk -F ':' '{ printf "  %-20s - %s\n", $$1, $$2 }'


# deploy : Run and test on locally connected device
deploy:
	flutter run


# build : 
build:
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


# checks for ssh, a build dir, rsync and anything else...
checks:
	@test ! -z "$(BUILD_DIR)/" || printf "No build directory specified.  Stopping.\n" > /dev/stderr
	@test ! -z "$(BUILD_DIR)/"
	rsync || printf "rsync not installed.  Stopping.\n" > /dev/stderr
	rsync
	ssh || printf "rsync not installed.  Stopping.\n" > /dev/stderr
	ssh	


remote-build:
	@test ! -z "$(BUILD_DIR)/" || printf "No build directory specified.  Stopping.\n" > /dev/stderr
	@test ! -z "$(BUILD_DIR)/"
	@echo $(SSH) $(REMOTE) "test -d $(BUILD_DIR)/ || mkdir -p $(BUILD_DIR)/"
	@echo $(SCP) $(REMOTE)


# filelist: list of files needed when copying flutter code to other places...
filelist:
	android/
	bob.iml
	ios/
	lib/
	pubspec.lock
	pubspec.yaml
	README.md
	test/
