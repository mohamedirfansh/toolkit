#!/usr/bin/env bash
# ============================================================
#  toolkit — AI coding toolkit installer
#  Usage: curl -fsSL https://raw.githubusercontent.com/mohamedirfansh/toolkit/master/install.sh | bash
# ============================================================

set -euo pipefail

# ── colours ────────────────────────────────────────────────
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BBLUE='\033[1;34m'
BMAGENTA='\033[1;35m'
BCYAN='\033[1;36m'
BWHITE='\033[1;37m'

BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'

# ── config ──────────────────────────────────────────────────
REPO_OWNER="${TOOLKIT_OWNER:-mohamedirfansh}"
REPO_NAME="${TOOLKIT_REPO:-toolkit}"
REPO_BRANCH="${TOOLKIT_BRANCH:-master}"
BASE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${REPO_BRANCH}"
API_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/git/trees/${REPO_BRANCH}?recursive=1"

TOOLKIT_VERSION="1.0.0"

# ── helpers ─────────────────────────────────────────────────
print_banner() {
  echo ""
  echo -e "${BG_CYAN}${BLACK}                                              ${RESET}"
  echo -e "${BG_CYAN}${BLACK}   ████████╗ ██████╗  ██████╗ ██╗     ██╗   ██╗   ${RESET}"
  echo -e "${BG_CYAN}${BLACK}      ██╔══╝██╔═══██╗██╔═══██╗██║     ██║   ██║   ${RESET}"
  echo -e "${BG_CYAN}${BLACK}      ██║   ██║   ██║██║   ██║██║     ██║   ██║   ${RESET}"
  echo -e "${BG_CYAN}${BLACK}      ██║   ██║   ██║██║   ██║██║     ██║▄▄ ██║   ${RESET}"
  echo -e "${BG_CYAN}${BLACK}      ██║   ╚██████╔╝╚██████╔╝███████╗╚██████╔╝   ${RESET}"
  echo -e "${BG_CYAN}${BLACK}      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝ ╚══▀▀═╝    ${RESET}"
  echo -e "${BG_CYAN}${BLACK}                                              ${RESET}"
  echo -e "${DIM}  AI Coding Toolkit v${TOOLKIT_VERSION} — by ${REPO_OWNER}${RESET}"
  echo ""
}

info()    { echo -e "  ${BCYAN}→${RESET}  $*"; }
success() { echo -e "  ${BGREEN}✓${RESET}  $*"; }
warn()    { echo -e "  ${BYELLOW}⚠${RESET}  $*"; }
error()   { echo -e "  ${BRED}✗${RESET}  $*" >&2; }
step()    { echo -e "\n${BWHITE}$*${RESET}"; }
dim()     { echo -e "  ${DIM}$*${RESET}"; }
header()  { echo -e "\n${BMAGENTA}━━━  $*  ━━━${RESET}\n"; }

# Read interactive input safely, even when script stdin is piped (e.g. curl | bash).
read_user_input() {
  local __var_name="$1"
  local __default="${2:-}"
  local __value=""

  if [[ -t 0 ]]; then
    read -r __value || __value=""
  elif [[ -r /dev/tty ]]; then
    read -r __value < /dev/tty || __value=""
  else
    __value=""
  fi

  printf -v "$__var_name" '%s' "${__value:-$__default}"
  return 0
}

confirm() {
  local prompt="$1"
  local default="${2:-y}"
  local response
  local yn_hint
  if [[ "$default" == "y" ]]; then
    yn_hint="${BGREEN}Y${RESET}${DIM}/n${RESET}"
  else
    yn_hint="${DIM}y/${RESET}${BGREEN}N${RESET}"
  fi
  echo -en "  ${BYELLOW}?${RESET}  ${prompt} [${yn_hint}]: "
  read_user_input response "$default"
  [[ "$response" =~ ^[Yy] ]]
}

# ── dependency checks ───────────────────────────────────────
check_deps() {
  local missing=()
  for cmd in curl; do
    command -v "$cmd" &>/dev/null || missing+=("$cmd")
  done

  # Check for at least one JSON parser / listing tool
  HAS_PYTHON=false
  HAS_JQ=false
  command -v python3 &>/dev/null && HAS_PYTHON=true
  command -v jq     &>/dev/null && HAS_JQ=true

  if [[ ${#missing[@]} -gt 0 ]]; then
    error "Missing required tools: ${missing[*]}"
    error "Please install them and try again."
    exit 1
  fi
}

# ── fetch helpers ───────────────────────────────────────────
fetch_file() {
  local remote_path="$1"
  local local_path="$2"
  local url="${BASE_URL}/${remote_path}"
  mkdir -p "$(dirname "$local_path")"
  curl -fsSL "$url" -o "$local_path" 2>/dev/null || {
    error "Failed to download: ${url}"
    return 1
  }
}

# List all paths in a category from GitHub tree API
list_category_items() {
  local category="$1"
  local raw
  raw=$(curl -fsSL "$API_URL" 2>/dev/null) || {
    warn "Could not reach GitHub API. Check your internet connection."
    return 1
  }

  if $HAS_JQ; then
    echo "$raw" | jq -r '.tree[].path' 2>/dev/null \
      | grep "^${category}/" \
      | awk -F'/' 'NF==2{print $2}' \
      | sort -u
  elif $HAS_PYTHON; then
    echo "$raw" | python3 -c "
import sys, json
data = json.load(sys.stdin)
cat = '${category}/'
seen = set()
for item in data.get('tree', []):
    p = item.get('path','')
    if p.startswith(cat):
        parts = p[len(cat):].split('/')
        if len(parts) >= 1 and parts[0]:
            if parts[0] not in seen:
                seen.add(parts[0])
                print(parts[0])
" 2>/dev/null | sort
  else
    # Fallback: grep approach
    echo "$raw" | grep -o '"path":"[^"]*"' \
      | sed 's/"path":"//;s/"//' \
      | grep "^${category}/" \
      | awk -F'/' 'NF==2{print $2}' \
      | sort -u
  fi
}

# List all files under a category/item path
list_item_files() {
  local path_prefix="$1"
  local raw
  raw=$(curl -fsSL "$API_URL" 2>/dev/null) || return 1

  if $HAS_JQ; then
    echo "$raw" | jq -r '.tree[] | select(.type=="blob") | .path' 2>/dev/null \
      | grep "^${path_prefix}/"
  elif $HAS_PYTHON; then
    echo "$raw" | python3 -c "
import sys, json
data = json.load(sys.stdin)
prefix = '${path_prefix}/'
for item in data.get('tree', []):
    if item.get('type') == 'blob' and item.get('path','').startswith(prefix):
        print(item['path'])
" 2>/dev/null
  else
    echo "$raw" | grep -o '"path":"[^"]*"' \
      | sed 's/"path":"//;s/"//' \
      | grep "^${path_prefix}/"
  fi
}

# ── AI tool detection ────────────────────────────────────────
detect_tools() {
  DETECTED_TOOLS=()
  # Claude Code
  [[ -d ".claude" ]] && DETECTED_TOOLS+=("claude-code")
  # Cursor
  [[ -d ".cursor" ]] && DETECTED_TOOLS+=("cursor")
  # Copilot (VS Code)
  [[ -d ".vscode" && -f ".vscode/settings.json" ]] && \
    grep -q "github.copilot" ".vscode/settings.json" 2>/dev/null && \
    DETECTED_TOOLS+=("copilot")
  # Windsurf
  [[ -d ".windsurf" ]] && DETECTED_TOOLS+=("windsurf")
  # Aider
  [[ -f ".aider.conf.yml" || -f ".aider.model.settings.yml" ]] && DETECTED_TOOLS+=("aider")
  # Continue
  [[ -f ".continue/config.json" ]] && DETECTED_TOOLS+=("continue")
  # Cody
  [[ -f ".sourcegraph/cody.json" ]] && DETECTED_TOOLS+=("cody")

  # Keep function success independent of detection result.
  return 0
}

# ── install scopes ───────────────────────────────────────────
select_scope() {
  step "📁  Select install scope"
  echo ""
  echo -e "  ${BWHITE}1)${RESET} ${BBLUE}Project${RESET}    ${DIM}— installs only in the current directory${RESET}"
  echo -e "  ${BWHITE}2)${RESET} ${BBLUE}Workspace${RESET}  ${DIM}— installs in \$XDG_CONFIG_HOME (~/.config/toolkit)${RESET}"
  echo -e "  ${BWHITE}3)${RESET} ${BBLUE}Global${RESET}     ${DIM}— installs in ~/toolkit (shared across all projects)${RESET}"
  echo ""
  echo -en "  ${BYELLOW}?${RESET}  Choose scope [${BGREEN}1${RESET}]: "
  read_user_input scope_choice "1"

  case "$scope_choice" in
    1) INSTALL_SCOPE="project";   INSTALL_BASE="." ;;
    2) INSTALL_SCOPE="workspace"; INSTALL_BASE="${XDG_CONFIG_HOME:-$HOME/.config}/toolkit" ;;
    3) INSTALL_SCOPE="global";    INSTALL_BASE="$HOME/toolkit" ;;
    *) INSTALL_SCOPE="project";   INSTALL_BASE="." ;;
  esac

  success "Scope: ${BBLUE}${INSTALL_SCOPE}${RESET} → ${DIM}${INSTALL_BASE}${RESET}"
}

# ── tool mapping ─────────────────────────────────────────────
get_tool_target_dir() {
  local tool="$1"
  local category="$2"
  local base="$INSTALL_BASE"

  case "$tool" in
    claude-code)
      case "$category" in
        skills)   echo "${base}/.claude/commands" ;;
        agents)   echo "${base}/.claude/agents" ;;
        instructions) echo "${base}/.claude/instructions" ;;
        prompts)  echo "${base}/.claude/prompts" ;;
        *)        echo "${base}/.claude/${category}" ;;
      esac
      ;;
    cursor)
      case "$category" in
        skills|instructions|prompts) echo "${base}/.cursor/rules" ;;
        agents)         echo "${base}/.cursor/agents" ;;
        *)              echo "${base}/.cursor/${category}" ;;
      esac
      ;;
    copilot)
      case "$category" in
        skills)                echo "${base}/.github/skills" ;;
        agents)                echo "${base}/.github/agents" ;;
        prompts)               echo "${base}/.github/prompts" ;;
        instructions)          echo "${base}/.github/instructions" ;;
        *)                     echo "${base}/.github/${category}" ;;
      esac
      ;;
    windsurf)
      case "$category" in
        skills|instructions|prompts) echo "${base}/.windsurf/rules" ;;
        agents)         echo "${base}/.windsurf/agents" ;;
        *)              echo "${base}/.windsurf/${category}" ;;
      esac
      ;;
    aider)
      echo "${base}/.aider/${category}"
      ;;
    *)
      echo "${base}/.toolkit/${category}"
      ;;
  esac
}

# ── tool selection ───────────────────────────────────────────
select_tool() {
  step "🛠   Select AI coding tool"
  echo ""

  local tools=(
    "claude-code:Claude Code (Anthropic)"
    "cursor:Cursor"
    "copilot:GitHub Copilot (VS Code)"
    "windsurf:Windsurf (Codeium)"
    "aider:Aider"
    "continue:Continue.dev"
    "generic:Generic / Other (raw files)"
  )

  detect_tools
  local i=1
  for entry in "${tools[@]}"; do
    local key="${entry%%:*}"
    local label="${entry#*:}"
    local detected_marker=""
    for d in "${DETECTED_TOOLS[@]:-}"; do
      [[ "$d" == "$key" ]] && detected_marker=" ${BGREEN}← detected${RESET}" && break
    done
    echo -e "  ${BWHITE}${i})${RESET} ${BCYAN}${label}${RESET}${detected_marker}"
    ((i++))
  done
  echo ""
  echo -en "  ${BYELLOW}?${RESET}  Choose tool [${BGREEN}1${RESET}]: "
  read_user_input tool_choice "1"

  local idx=$((tool_choice - 1))
  local entry="${tools[$idx]:-${tools[0]}}"
  SELECTED_TOOL="${entry%%:*}"
  SELECTED_TOOL_LABEL="${entry#*:}"
  success "Tool: ${BCYAN}${SELECTED_TOOL_LABEL}${RESET}"
}

# ── interactive category + item picker ───────────────────────
select_and_install() {
  local categories=("skills" "agents" "instructions" "prompts")

  header "📦  Choose what to install"

  echo -e "  ${DIM}Categories available:${RESET}\n"
  local ci=1
  for cat in "${categories[@]}"; do
    echo -e "  ${BWHITE}${ci})${RESET} ${BMAGENTA}${cat}${RESET}"
    ((ci++))
  done
  echo -e "  ${BWHITE}${ci})${RESET} ${BMAGENTA}all${RESET}  ${DIM}(install everything)${RESET}"
  echo ""
  echo -en "  ${BYELLOW}?${RESET}  Pick categories (e.g. ${DIM}1 3${RESET} or ${DIM}all${RESET}) [${BGREEN}all${RESET}]: "
  read_user_input cat_input "all"

  local selected_cats=()
  if [[ "$cat_input" == "all" || "$cat_input" == "$ci" ]]; then
    selected_cats=("${categories[@]}")
  else
    for token in $cat_input; do
      local idx=$((token - 1))
      if (( idx >= 0 && idx < ${#categories[@]} )); then
        selected_cats+=("${categories[$idx]}")
      fi
    done
  fi

  if [[ ${#selected_cats[@]} -eq 0 ]]; then
    warn "No categories selected. Aborting."
    exit 0
  fi

  TOTAL_INSTALLED=0

  for cat in "${selected_cats[@]}"; do
    header "📂  ${cat}"
    info "Fetching available ${cat}…"

    local items
    items=$(list_category_items "$cat") || { warn "Skipping ${cat} (could not list items)"; continue; }

    if [[ -z "$items" ]]; then
      warn "No ${cat} found in repository."
      continue
    fi

    echo ""
    local item_arr=()
    local ii=1
    while IFS= read -r item; do
      [[ -z "$item" ]] && continue
      item_arr+=("$item")
      echo -e "  ${BWHITE}${ii})${RESET} ${BCYAN}${item}${RESET}"
      ((ii++))
    done <<< "$items"

    echo -e "  ${BWHITE}${ii})${RESET} ${BGREEN}all${RESET}"
    echo ""
    echo -en "  ${BYELLOW}?${RESET}  Which ${cat} to install? (e.g. ${DIM}1 3${RESET} or ${DIM}all${RESET}) [${BGREEN}all${RESET}]: "
    read_user_input item_input "all"

    local selected_items=()
    if [[ "$item_input" == "all" || "$item_input" == "$ii" ]]; then
      selected_items=("${item_arr[@]}")
    else
      for token in $item_input; do
        local idx=$((token - 1))
        if (( idx >= 0 && idx < ${#item_arr[@]} )); then
          selected_items+=("${item_arr[$idx]}")
        fi
      done
    fi

    for item in "${selected_items[@]}"; do
      install_item "$cat" "$item"
    done
  done
}

install_item() {
  local category="$1"
  local item="$2"
  local item_prefix="${category}/${item}"

  local target_dir
  target_dir=$(get_tool_target_dir "$SELECTED_TOOL" "$category")

  info "Installing ${BCYAN}${item}${RESET} → ${DIM}${target_dir}/${item}${RESET}"

  local files
  files=$(list_item_files "$item_prefix") || { warn "Could not list files for ${item}"; return; }

  if [[ -z "$files" ]]; then
    # Maybe it's a flat file, not a directory
    local ext_try=("md" "txt" "sh" "json" "yaml" "yml" "ts" "py" "sql")
    for ext in "${ext_try[@]}"; do
      local candidate="${category}/${item}.${ext}"
      if fetch_file "$candidate" "${target_dir}/${item}.${ext}" 2>/dev/null; then
        success "Installed ${item}.${ext}"
        TOTAL_INSTALLED=$((TOTAL_INSTALLED + 1))
        return
      fi
    done
    warn "No files found for ${item}"
    return
  fi

  while IFS= read -r file_path; do
    [[ -z "$file_path" ]] && continue
    # Compute relative path within item
    local rel_path="${file_path#${item_prefix}/}"
    local dest="${target_dir}/${item}/${rel_path}"
    fetch_file "$file_path" "$dest" && \
      dim "  ↳ ${rel_path}" || \
      warn "Failed: ${file_path}"
    TOTAL_INSTALLED=$((TOTAL_INSTALLED + 1))
  done <<< "$files"

  # Post-install hooks for specific tools
  post_install_hook "$category" "$item" "$target_dir"
  success "Installed ${BCYAN}${item}${RESET}"
}

post_install_hook() {
  local category="$1"
  local item="$2"
  local target_dir="$3"

  case "$SELECTED_TOOL" in
    cursor)
      # Cursor rules need .mdc extension or folder
      if [[ "$category" == "skills" || "$category" == "instructions" || "$category" == "prompts" ]]; then
        # Rename .md to .mdc if needed
        find "${target_dir}/${item}" -name "SKILL.md" -o -name "*.md" 2>/dev/null | while read -r f; do
          local mdc="${f%.md}.mdc"
          cp "$f" "$mdc" 2>/dev/null || true
        done
      fi
      ;;
  esac
}

# ── summary ─────────────────────────────────────────────────
print_summary() {
  echo ""
  echo -e "${BG_CYAN}${BLACK}  ✓ Installation complete!  ${RESET}"
  echo ""
  success "Installed ${BGREEN}${TOTAL_INSTALLED}${RESET} file(s)"
  success "Tool:  ${BCYAN}${SELECTED_TOOL_LABEL}${RESET}"
  success "Scope: ${BBLUE}${INSTALL_SCOPE}${RESET} (${DIM}${INSTALL_BASE}${RESET})"
  echo ""
  echo -e "${DIM}  Contribute to: https://github.com/${REPO_OWNER}/${REPO_NAME}${RESET}"
  echo ""
}

# ── main ─────────────────────────────────────────────────────
main() {
  print_banner
  check_deps
  select_scope
  select_tool
  select_and_install
  print_summary
}

main "$@"
