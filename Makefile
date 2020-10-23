all: video_enabler

video_enabler: main.m
	g++ main.m \
		-framework CoreServices \
		-framework Foundation \
		-framework CoreMedia \
		-framework CoreMediaIO \
		-framework CoreVideo \
		-framework AVFoundation \
		-D GitCommit="\"$(GIT_COMMIT)\""\
		-D GitDate="\"$(GIT_DATE)\""\
		-D GitRemote="\"$(GIT_REMOTE)\""\
		-D EasyVersion="\"$(EASY_VERSION)\""\
		-o video_enabler

clean:
	$(RM) video_enabler
