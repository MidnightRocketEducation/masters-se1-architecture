# ------------------------------------------------------------------
#  Detect the host OS
# ------------------------------------------------------------------
OS := $(shell uname -s)

# ------------------------------------------------------------------
#  Build command – different flags for macOS vs Linux
# ------------------------------------------------------------------
ifeq ($(OS),Darwin)                 # macOS
	SWIFT_BUILD_CMD := swift build -c release
else ifeq ($(OS),Linux)             # Linux
	ARCH := $(shell uname -m)
	ifneq ($(filter $(ARCH), aarch64 x86_64),)
	SWIFT_BUILD_CMD := swift build -c release --swift-sdk $(ARCH)-swift-linux-musl
else
	SWIFT_BUILD_CMD := $(error Unsupported architecture: $(ARCH))
endif
else
	SWIFT_BUILD_CMD := $(error Unsupported OS: $(OS))
endif

# ------------------------------------------------------------------
#  Default target – just build the project
# ------------------------------------------------------------------
.PHONY: build
build:
	$(SWIFT_BUILD_CMD)
