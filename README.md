# 录音笔天阶功法 · 安装说明

18 门把录音交给大模型干活的用法。装好后对 AI 说「录音笔天阶功法」，点选一门功法、确认后就开练。
支持 Claude Code、Codex、WorkBuddy、千问、豆包。

## 一句话安装（推荐）

把下面这句发给你的 AI 助手，它会自己下载安装。缺的「讯飞录音笔（智声互联）」「讯飞听见」读录音组件也会一起装上：

```
请帮我执行这条命令安装「录音笔天阶功法」：curl -fsSL https://liyubuke.github.io/tianjie/install.sh | bash
```

自己在终端装也可以：

- Mac / Linux：`curl -fsSL https://liyubuke.github.io/tianjie/install.sh | bash`
- Windows（PowerShell）：`irm https://liyubuke.github.io/tianjie/install.ps1 | iex`

安装脚本会自动找到本机装了哪些 AI 工具，每个工具都装一份。

## 读录音的两个组件

| 组件 | 读哪里的录音 | 单独安装指令 |
|---|---|---|
| 讯飞录音笔（智声互联） | 讯飞录音笔 App | `curl -fsSL https://open.iflyrecorder.com/skills/iflytek-recorder/install.sh \| bash` |
| 讯飞听见 | 讯飞听见 App | `curl -fsSL https://skillhub.cn/install/install.sh \| bash && skillhub install xftj-transcribe` |

安装时漏装了也没关系：每次启动功法前都会检查，缺了会提醒并帮你装上。第一次读录音会弹出账号授权页，登录并同意即可。

## 开练

- 对 AI 说「录音笔天阶功法」（Claude Code 里也可以输入 `/录音笔天阶功法`）；
- 先选阶（黄、玄、地、天），再选功法，看过确认说明后点「确认开练」（AI 工具没有点选框时，回复编号或功法名，再回复「确认」）；
- 也可以直接说要做的事，比如「用这周的录音写周报」，确认后直接开工；
- 做完可以接着提修改意见，或者说「菜单」换一门。

## 说明

- 本技能只读你的录音，不会上传、修改或删除录音，不会替你发消息；
- 第 5、12、16、18 门会在你的主目录下建一个「录音笔天阶功法」文件夹，存周报样板、知识库等，第一次写入前会先问你；
- 没装读录音组件也能用：直接粘贴转写文本或上传转写文件。
