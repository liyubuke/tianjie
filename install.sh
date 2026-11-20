#!/usr/bin/env bash
# 录音笔天阶功法 · 一键安装（macOS / Linux）
# 用法：curl -fsSL https://liyubuke.github.io/tianjie/install.sh | bash
#   在某个 AI 工具里执行：只装到这个工具。
#   自己在终端执行：列出本机的 AI 工具，选择装到哪个。
#   可选参数：--target=claude|codex|workbuddy|qwen|doubao|all（可用逗号写多个）
#   装完后：启动技能，第一步选录音 App（讯飞录音笔 / 讯飞听见 / Deepting），再装组件、登录授权。
set -o pipefail

SITE="${TIANJIE_SITE:-https://liyubuke.github.io/tianjie}"
SKILL="录音笔天阶功法"

NO_DEPS=0; ASSUME_YES=0; WANT=""
for a in "$@"; do
  case "${a}" in --no-deps) NO_DEPS=1 ;; --yes|-y) ASSUME_YES=1 ;; --target=*) WANT="${a#--target=}" ;; esac
done

say()  { printf '%s\n' "$*"; }
ok()   { printf '  [√] %s\n' "$*"; }
warn() { printf '  [!] %s\n' "$*"; }

say ""
say "== 录音笔天阶功法 · 安装 =="

# ---------- 1. 准备技能包 ----------
WORK="$(mktemp -d)"; trap 'rm -rf "${WORK}"' EXIT
SRC=""
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "${HERE}" ] && [ -f "${HERE}/${SKILL}/SKILL.md" ]; then
  SRC="${HERE}/${SKILL}"
else
  say "下载技能包……"
  if ! curl -fsSL "${SITE}/tianjie.zip" -o "${WORK}/tianjie.zip"; then
    say "下载失败：${SITE}/tianjie.zip"; say "请检查网络（GitHub 有时需要多试几次）后重试。"; exit 1
  fi
  (cd "${WORK}" && unzip -q tianjie.zip) || { say "解压失败"; exit 1; }
  SRC="${WORK}/${SKILL}"
  [ -f "${SRC}/SKILL.md" ] || { say "技能包内容不完整"; exit 1; }
fi

# ---------- 2. 决定装到哪个 AI 工具 ----------
# 每个工具：键|名称|技能目录|讯飞录音笔安装目标
REAL_HOME="${HOME}"
case "${HOME}" in */Library/Containers/com.bot.neotix.doubao/Data) DOUBAO_DIR="${HOME}/Doubao" ;; *) DOUBAO_DIR="${HOME}/Library/Containers/com.bot.neotix.doubao/Data/Doubao" ;; esac
tool_line() {
  case "$1" in
    claude)    echo "claude|Claude Code|${HOME}/.claude/skills|claude" ;;
    codex)     echo "codex|Codex|${HOME}/.codex/skills|codex" ;;
    workbuddy) echo "workbuddy|WorkBuddy|${HOME}/.workbuddy/skills|workbuddy" ;;
    qwen)      echo "qwen|千问|${HOME}/.qwenworkcn/skills|workspace" ;;
    doubao)    echo "doubao|豆包|${DOUBAO_DIR}/skills|workspace" ;;
  esac
}
installed_tools() {   # 本机有配置目录的工具
  [ -d "${HOME}/.claude" ]     && echo claude
  [ -d "${HOME}/.codex" ]      && echo codex
  [ -d "${HOME}/.workbuddy" ]  && echo workbuddy
  [ -d "${HOME}/.qwenworkcn" ] && echo qwen
  [ -d "${DOUBAO_DIR}" ]       && echo doubao
}
detect_host() {       # 当前是哪个 AI 工具在执行本脚本
  local b; b="$(printf '%s' "${__CFBundleIdentifier:-}" | tr 'A-Z' 'a-z')"
  if [ -n "${CLAUDECODE:-}${CLAUDE_CODE_ENTRYPOINT:-}" ]; then echo claude; return; fi
  if [ -n "${CODEX_SESSION_ID:-}${CODEX_THREAD_ID:-}${CODEX_VERSION:-}${CODEX_APP_TOOLS_PIPE_PATH:-}" ] || [[ "${b}" == *codex* ]]; then echo codex; return; fi
  if [ -n "${WORKBUDDY_CONFIG_DIR:-}${WORKBUDDY_HOME:-}${WORKBUDDY_APP_NAME:-}" ] || [[ "${b}" == *workbuddy* ]]; then echo workbuddy; return; fi
  if [[ "${b}" == *qwenwork* ]] || env | grep -q '^QWENWORK'; then echo qwen; return; fi
  if [[ "${b}" == *doubao* ]] || [[ "${HOME}" == *com.bot.neotix.doubao* ]]; then echo doubao; return; fi
}

KEYS=""
HOST="$(detect_host)"
if [ -n "${WANT}" ]; then
  if [ "${WANT}" = all ]; then KEYS="$(installed_tools | tr '\n' ' ')"; else KEYS="$(printf '%s' "${WANT}" | tr ',' ' ')"; fi
elif [ -n "${HOST}" ]; then
  KEYS="${HOST}"
  say "检测到你在 $(tool_line "${HOST}" | cut -d'|' -f2) 里执行，只装到这个工具。"
else
  AVAIL=($(installed_tools))
  if [ ${#AVAIL[@]} -eq 0 ]; then
    warn "没找到 Claude Code / Codex / WorkBuddy / 千问 / 豆包 的配置目录。"
    warn "装好其中一个 AI 工具后再运行，或加参数指定，例如：--target=claude"
    exit 1
  elif [ ${#AVAIL[@]} -eq 1 ]; then
    KEYS="${AVAIL[0]}"
  elif [ -r /dev/tty ] && [ -t 1 ]; then
    say ""; say "本机检测到这些 AI 工具，要装到哪个？"
    n=0; for k in "${AVAIL[@]}"; do n=$((n+1)); say "  ${n}. $(tool_line "${k}" | cut -d'|' -f2)"; done
    say "  a. 全部"
    printf '输入编号（多个用空格隔开，如 1 3）：'; read -r pick </dev/tty || pick=""
    for p in ${pick}; do
      case "${p}" in a|A) KEYS="${AVAIL[*]}" ;; *[!0-9]*|'') ;; *) [ "${p}" -ge 1 ] && [ "${p}" -le ${#AVAIL[@]} ] && KEYS="${KEYS} ${AVAIL[$((p-1))]}" ;; esac
    done
    [ -z "${KEYS// /}" ] && { say "没有选择，已退出。"; exit 1; }
  else
    warn "无法判断要装到哪个 AI 工具。请在要使用的 AI 工具里执行这条命令，"
    warn "或者加参数指定，例如：curl -fsSL ${SITE}/install.sh | bash -s -- --target=workbuddy"
    exit 1
  fi
fi
TOOLS=()
for k in ${KEYS}; do l="$(tool_line "${k}")"; [ -n "${l}" ] && TOOLS+=("${l#*|}"); done
[ ${#TOOLS[@]} -eq 0 ] && { warn "--target 只能是 claude、codex、workbuddy、qwen、doubao、all"; exit 1; }

# ---------- 3. 安装本技能 ----------
say ""; say "安装技能到："
for t in "${TOOLS[@]}"; do
  IFS='|' read -r name dir target <<<"$t"
  if mkdir -p "${dir}" 2>/dev/null && rm -rf "${dir}/${SKILL}" && cp -R "${SRC}" "${dir}/${SKILL}" 2>/dev/null; then
    ok "${name}  →  ${dir}/${SKILL}"
  else
    warn "${name}：没有写入权限（${dir}），已跳过"
  fi
done

# ---------- 4. 下一步：选录音 App、装组件、登录授权（交给技能第 0 步） ----------
FIRST="$(printf '%s' "${TOOLS[0]}" | cut -d'|' -f2)/${SKILL}/SKILL.md"
say ""
say "== 技能装好了 =="
if [ -n "${HOST}" ]; then
  say ""
  say "【请 AI 助手继续，不要停】"
  say "1. 立即读取 ${FIRST}，按其中「第 0 步」执行；"
  say "2. 先问用户用哪个录音 App（讯飞录音笔 App / 讯飞听见 App / Deepting App，可多选）；"
  say "3. 按用户的选择安装对应组件，并带用户完成账号登录和授权，直到检查通过；"
  say "4. 然后进入「选功法」，让用户点选一门功法开练。"
else
  say "下一步："
  say "1. 重启你的 AI 助手，对它说：录音笔天阶功法（Claude Code 里也可以输入 /录音笔天阶功法）"
  say "2. 它会先问你用哪个录音 App（讯飞录音笔 / 讯飞听见 / Deepting），"
  say "   再帮你装好对应组件、打开网页让你登录授权，完成后就能选功法开练。"
fi
