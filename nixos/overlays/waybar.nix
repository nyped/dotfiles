# FIXME: temporary. waybar 0.16.0 fails its checkPhase on the
# "SleeperThread control flags are stable under concurrent wake and stop"
# test (waybar:utils, exit status 42).
# Upstream issue: https://github.com/Alexays/Waybar/issues/5356
# Likely fixed by https://github.com/Alexays/Waybar/pull/5470 (merged after
# the 0.16.0 tag), so drop this overlay once nixpkgs ships the next release.
self: super: {
  waybar = super.waybar.override { runTests = false; };
}
