# 规则怪谈·无限层 Rulekeeper

> 一部**规则可以被机器验证**的长篇小说。AI 每天续写一章，层的规则由机器门禁强制校验——违反规则，拒稿；就像故事里违反规则，被抹除。

- 世界观：近未来，「层」随机降临。每层一套规则。遵守规则活，违反规则被抹除。
- 主角：林柯，管理局第 7 期守规人。
- 技术：本象协议（Origin IR）——每章一个语义事务，世界状态公开可查。
- 状态面板（实时）：`adapters/story/cli.mjs state pkg.origin` 或查看 chapters/state 目录。

## 快速开始

```bash
# 查看当前世界状态（人物 SAN/已知规则/物品/伏笔）
node adapters/story/cli.mjs state pkg.origin

# 读正文
cat chapters/ch01.txt
```

## 共创（五个入口）

1. **投票**：Discussions 每周票选下周层
2. **提名**：Issue「层设定提名」一句话
3. **创作**：Issue「层设定」模板提交完整层 → 合入后正文署名
4. **抓虫**：Issue「规则虫」报告章节违反规则的 bug
5. **番外**：PR 提交符合 canon 的番外

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 已发布

| 章 | 层 | 状态 |
|---|---|---|
| 01-03 | 层01·午夜便利店 | ✅ 已发布 |
| 04-06 | 层02·电梯公寓 | ✅ 已发布 |
| 07+ | 每日自动续写 | ⏰ GitHub Actions cron（北京 06:30，门禁通过才落盘） |

## 自动续写与 briefs 共创

本仓库每天由 GitHub Actions 自动写一章（`world/` 世界包 + 五道门禁）。
你可以 PR 提交 `briefs/chNN.md`（下一章的剧情方向/规则提示）——合入后
明天的自动章节就按你的 brief 写。没有 brief 则自由续写。

## IP

© 贺去病（hequbing.com）。共创贡献按 CONTRIBUTING 授权条款进入 canon。
