# 录音笔天阶功法 · 安装说明

18 门把录音交给大模型干活的用法。支持 Claude Code、Codex、WorkBuddy、千问、豆包；支持讯飞录音笔、讯飞听见、Deepting 三个录音 App。

## 一句话安装（推荐）

在你要使用的那个 AI 助手里，发这句话：

```
请帮我安装「录音笔天阶功法」并按提示完成设置：curl -fsSL https://liyubuke.github.io/tianjie/install.sh | bash
```

AI 会依次完成：

1. 把技能装进当前这个 AI 工具（只装这一个，不碰你电脑上的其他 AI 工具）；
2. 问你用哪个录音 App：讯飞录音笔 App、讯飞听见 App、Deepting App，可以多选；
3. 装好对应的读录音组件，打开网页让你登录账号、完成授权，检查通过为止；
4. 让你点选一门功法，确认后开练。

自己在终端装也可以，装完再打开 AI 助手说「录音笔天阶功法」，会接着做第 2～4 步：

- Mac / Linux：`curl -fsSL https://liyubuke.github.io/tianjie/install.sh | bash`（会让你选装到哪个 AI 工具）
- Windows（PowerShell）：`irm https://liyubuke.github.io/tianjie/install.ps1 | iex`

## 三个录音 App 对应的组件

| 录音 App | 组件 | 单独安装指令 |
|---|---|---|
| 讯飞录音笔 App（智声互联） | recording-assistant-prod | `curl -fsSL https://open.iflyrecorder.com/skills/iflytek-recorder/install.sh \| bash` |
| 讯飞听见 App | xftj-transcribe | `curl -fsSL https://skillhub.cn/install/install.sh \| bash && skillhub install xftj-transcribe` |
| Deepting App | deepting-transcribe | `curl -fsSL https://skillhub.cn/install/install.sh \| bash && skillhub install deepting-transcribe` |

一般不用手动装：功法第一次启动时会按你选的 App 自动装、自动引导登录授权。以后想加一个 App，对 AI 说「加一个录音 App」就行。

## 开练

- 对 AI 说「录音笔天阶功法」（Claude Code 里也可以输入 `/录音笔天阶功法`）；
- 先看功法总览，再点选阶（黄、玄、地、天）和功法，看过确认说明后点「确认开练」。AI 工具没有点选框时，回复编号或功法名，再回复「确认」；
- 也可以直接说要做的事，比如「用这周的录音写周报」，确认后直接开工；
- 做完可以接着提修改意见，或者说「菜单」换一门。

## 说明

- 本技能只读你的录音，不会上传、修改或删除录音，不会替你发消息；
- 会在你的主目录下建一个「录音笔天阶功法」文件夹，存录音来源、周报样板、知识库等，写入前会告诉你；
- Deepting 重新授权会让旧的 API Key 失效，所以只有授权失效时才会重新授权；
- 没装组件也能用：直接粘贴转写文本或上传转写文件。
- 每天第一次使用会自动检查更新，有新版本会提醒你，同意后自动更新；你的设置和知识库不受影响。

## 我有更好的功法

有好用的录音用法，欢迎发邮件给作者李钰分享，好的功法会加进下一版：

bukeliyu@live.cn

在技能里说「我有更好的功法」，AI 会帮你把想法整理成邮件草稿。
