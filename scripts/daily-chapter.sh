#!/usr/bin/env bash
# 规则怪谈·无限层 —— 每日自动写一章并推送（GitHub Actions）
# 每章 = 一个语义事务，过五道门禁（含文本禁区：违反怪谈规则即拒稿）。
# 失败不落盘（world 状态不变），第二天 cron 会重试同一章。
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# 1) hermes 通道配置（secrets → config.yaml，与 model.mjs 解析格式一致）
mkdir -p /tmp/hermes-home
cat > /tmp/hermes-home/config.yaml <<EOF
model:
  base_url: ${HERMES_API_BASE}
  api_key: ${HERMES_API_KEY}
  default: ${HERMES_MODEL}
EOF
export HERMES_HOME=/tmp/hermes-home

# 2) 引擎（2origin 仓库，含 rk-run.mjs + spec 禁区词表，单点维护）
ENGINE=/tmp/2origin
if [ ! -d "$ENGINE/.git" ]; then
  git clone --depth 1 https://github.com/dongsheng123132/2origin.git "$ENGINE"
fi

# 3) 下一章号（从世界包 outline 检测；失败不落盘 → 章号不变 → 天然幂等重试）
OUTLINE=world/narrative/chapters/outline.jsonl
if [ -f "$OUTLINE" ]; then
  LAST=$(node -e "const fs=require('fs');const l=fs.readFileSync('$OUTLINE','utf8').trim().split('\n').filter(Boolean).map(x=>JSON.parse(x).chapter);console.log(l.length?Math.max(...l):0)")
else
  LAST=0
fi
NEXT=$((LAST+1))
NN=$(printf '%02d' "$NEXT")
echo "== 下一章: ch$NN =="

# 4) 可选 brief（共创者 PR briefs/chNN.md 决定剧情方向；没有则自由续写）
BRIEF_ARGS=()
if [ -f "briefs/ch$NN.md" ]; then
  BRIEF_ARGS=(--brief "$(cat "briefs/ch$NN.md")")
  echo "== 使用 brief: briefs/ch$NN.md =="
fi

# 5) 写章（模型 → 事务 → 五道门禁 → 落盘；违反规则被拒即退出，状态不动）
node "$ENGINE/adapters/story/rk/rk-run.mjs" world "$NEXT" \
  --provider hermes --max-tokens 20000 --retries 3 "${BRIEF_ARGS[@]}"

# 6) 同步展示版 + 推送
mkdir -p briefs
cp world/narrative/chapters/ch$NN.txt chapters/ch$NN.txt
cp world/provenance/history.jsonl state/state.jsonl
git add world chapters state briefs
git -c user.name="dongsheng123132" -c user.email="hefangsheng@gmail.com" commit -q -m "ch$NN: 每日自动续写（GitHub Actions，门禁通过）" || echo "无改动可提交"
git push -q origin master || git push -q origin main
echo "== ch$NN 已推送 =="
