#!/usr/bin/env bash
set -e

resolve_link() {
  $(type -p greadlink readlink | head -1) "$1"
}

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(resolve_link "$name" || true)"
  done

  pwd
  cd "$cwd"
}

PREFIX="$1"
if [ -z "$1" ]; then
  { echo "usage: $0 <prefix>"
    echo "  e.g. $0 /usr/local"
  } >&2
  exit 1
fi

__ROOT="$(abs_dirname "$0")"
mkdir -p "$PREFIX"/{bin,libexec,share/man/man{1,7}}
cp -R "$__ROOT"/bin/* "$PREFIX"/bin
cp -R "$__ROOT"/libexec/* "$PREFIX"/libexec
#cp "$__ROOT"/man/portscanner.1 "$PREFIX"/share/man/man1
#cp "$__ROOT"/man/portscanner.7 "$PREFIX"/share/man/man7

echo "Installed Bats to $PREFIX/bin/portscanner"
