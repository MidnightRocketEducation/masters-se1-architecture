#!/bin/sh
set -eu
SCRIPT_DIR="$(realpath "$(dirname -- "$0")")"; readonly SCRIPT_DIR;
print() { printf "%b%b" "${1-""}" "${2-"\\n"}"; }
stderr() { print "$@" 1>&2; }
reportError() { stderr "$2"; return "$1"; }
verbosePrint() { test -n "${VERBOSE_MODE+x}" && stderr "$@" || true; }

commandv() { command -v "$1" || reportError "$?" "Executable '$1' not found"; }


trash="$(commandv "trash" || commandv "rm")" # Trash if available otherwise rm


TARGET_DIR="$(realpath "$1")"

git ls-files --error-unmatch "$TARGET_DIR" > /dev/null 2>&1 || reportError "$?" "'$(realpath --relative-base="$PWD" "$TARGET_DIR")' is not tracked by git!"

ZIP_FILE="$2"

test -f "$ZIP_FILE" || reportError 1 "'$ZIP_FILE' no such file"

cd "$SCRIPT_DIR"


# Clear existing files
# This results in deleted files in overleaf, also gets deleted here.
# rm -r "$TARGET_DIR"
# mkdir "$TARGET_DIR"
find "$TARGET_DIR" -mindepth 1 -delete


unzip -d "$TARGET_DIR" "$ZIP_FILE"


COAUTHOR_FILE="$TARGET_DIR/.coauthors"

if [ -f "$COAUTHOR_FILE" ]; then
	GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-"$(git config get --default="$(git config get --default "${EMAIL:-"n/A"}" user.email)" author.email)"}"
	COAUTHORS="$(grep -v "$GIT_AUTHOR_EMAIL" "$COAUTHOR_FILE" | awk 'NF > 0 && !/^[[:space:]]*#/{print("Co-authored-by: " $0)}' | sort -u)"
fi

git add -- "$TARGET_DIR"

if git diff --quiet --cached -- "$TARGET_DIR"; then
	stderr "Nothing to commit"
else
	git commit --cleanup strip -F - -- "$TARGET_DIR" <<-EOF
	Backup overleaf latex
	
	"$COAUTHORS"
	EOF
fi

"$trash" "$ZIP_FILE"
