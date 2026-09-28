#!/usr/bin/env bash
# tools/use-snapshot.sh -- install a config snapshot into the practice config.
#
#   bash tools/use-snapshot.sh 04          copy config/04 -> ~/.config/hero
#   bash tools/use-snapshot.sh --diff 04   show how ~/.config/hero differs from config/04
#   bash tools/use-snapshot.sh --verify 04 start Neovim on config/04 and fail on any error
#   bash tools/use-snapshot.sh --verify-all  verify every snapshot -- what CI runs
#
# The snapshots are a safety net, not the lesson. Write your own config first.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

APPNAME="${HERO_APPNAME:-hero}"
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/$APPNAME"

# Hard stop: this script must never be able to touch the real config.
if [[ "$APPNAME" == "nvim" || "$TARGET" == */nvim ]]; then
  echo "refusing to operate on '$TARGET' -- that is the real config." >&2
  echo "This course only ever writes to ~/.config/hero (see DESIGN.md §1)." >&2
  exit 1
fi

die() { echo "use-snapshot: $*" >&2; exit 1; }

snapshot_dir() {
  local n
  n="$(printf '%02d' "$((10#${1#0}))")" 2>/dev/null || die "'$1' is not a lesson number"
  [[ -d "config/$n" ]] || die "no snapshot for lesson $n (snapshots: $(ls config 2>/dev/null | tr '\n' ' '))"
  echo "config/$n"
}

# Start Neovim on a snapshot with that snapshot as its config dir, and fail if
# anything is written to stderr or the exit status is nonzero.
verify() {
  local dir="$1" tmp log status
  tmp="$(mktemp -d)"; log="$(mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp' '$log'" RETURN

  cp -r "$dir/." "$tmp/"

  set +e
  XDG_CONFIG_HOME="$(dirname "$tmp")" NVIM_APPNAME="$(basename "$tmp")" \
    nvim --headless -c 'quitall!' >/dev/null 2>"$log"
  status=$?
  set -e

  if [[ $status -ne 0 || -s "$log" ]]; then
    echo "  FAIL  $dir"
    sed 's/^/          /' "$log"
    return 1
  fi
  echo "  ok    $dir"
  return 0
}

case "${1:-}" in
  --verify-all)
    rc=0
    shopt -s nullglob
    dirs=(config/[0-9][0-9])
    shopt -u nullglob
    [[ ${#dirs[@]} -gt 0 ]] || die "no snapshots found under config/"
    for d in "${dirs[@]}"; do verify "$d" || rc=1; done
    exit $rc
    ;;
  --verify)
    [[ $# -ge 2 ]] || die "--verify needs a lesson number"
    verify "$(snapshot_dir "$2")"
    ;;
  --diff)
    [[ $# -ge 2 ]] || die "--diff needs a lesson number"
    dir="$(snapshot_dir "$2")"
    [[ -d "$TARGET" ]] || die "$TARGET does not exist yet"
    diff -ru "$TARGET" "$dir" && echo "identical to $dir"
    ;;
  ''|-h|--help)
    sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
    ;;
  -*)
    die "unknown flag $1"
    ;;
  *)
    dir="$(snapshot_dir "$1")"
    if [[ -d "$TARGET" ]] && [[ -n "$(ls -A "$TARGET" 2>/dev/null)" ]]; then
      echo "About to replace the contents of: $TARGET"
      echo "with: $dir"
      diff -rq "$TARGET" "$dir" 2>/dev/null | sed 's/^/  /' || true
      read -r -p "Proceed? [y/N] " reply
      [[ "$reply" == [yY] ]] || die "cancelled"
      rm -rf "$TARGET"
    fi
    mkdir -p "$TARGET"
    cp -r "$dir/." "$TARGET/"
    echo "installed $dir -> $TARGET"
    echo "start it with: NVIM_APPNAME=$APPNAME nvim"
    ;;
esac
