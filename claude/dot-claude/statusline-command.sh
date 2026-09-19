#!/usr/bin/env bash
set -euo pipefail

RESET=$'\033[0m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
CYAN=$'\033[36m'
MAGENTA=$'\033[35m'

color_for_pct() {
  local pct="$1"
  if [ "$pct" = "?" ] || [ "$pct" = "n/a" ]; then
    echo ""
    return
  fi
  local n=${pct%.*}
  if [ "$n" -ge 90 ] 2>/dev/null; then
    echo "$RED"
  elif [ "$n" -ge 70 ] 2>/dev/null; then
    echo "$YELLOW"
  else
    echo "$GREEN"
  fi
}

fmt_tokens() {
  awk -v n="$1" 'BEGIN {
    if (n >= 1000000) { s = sprintf("%.1f", n/1000000); sub(/\.0$/, "", s); printf "%sM", s }
    else if (n >= 1000) printf "%.0fK", n/1000
    else printf "%d", n
  }'
}

input="$(cat)"

model=$(echo "$input" | jq -r '.model.display_name // .model.id // "?"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')

branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

ctx_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
ctx_max=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -z "$ctx_used" ] && [ "$ctx_max" -gt 0 ] 2>/dev/null; then
  ctx_used=$(awk "BEGIN { printf \"%.0f\", ($ctx_tokens/$ctx_max)*100 }")
fi
[ -z "${ctx_used:-}" ] && ctx_used="?"

ctx_label=""
if [ "$ctx_max" -gt 0 ] 2>/dev/null; then
  ctx_label="$(fmt_tokens "$ctx_tokens")/$(fmt_tokens "$ctx_max")"
fi

usage=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // .rate_limits.seven_day.used_percentage // empty')
[ -z "$usage" ] && usage="n/a"

ctx_color=$(color_for_pct "$ctx_used")
usage_color=$(color_for_pct "$usage")

out="${MAGENTA}${model}${RESET}"
[ -n "$branch" ] && out="$out | ${CYAN}${branch}${RESET}"
if [ -n "$ctx_label" ]; then
  out="$out | ctx ${ctx_color}${ctx_label} (${ctx_used}%)${RESET}"
else
  out="$out | ctx ${ctx_color}${ctx_used}%${RESET}"
fi
out="$out | usage ${usage_color}${usage}%${RESET}"

echo "$out"
