# Preview/
> L2 | 父级: /dream-book/DesignSystem/CLAUDE.md

成员清单
DesignSystemPreviewPages.swift: 设计系统预览页面结构编排（含顶部亮暗切换按钮与首页各分区）。
DesignSystemPreviewAtoms.swift: 预览原子组件与示例组件集合（卡片、按钮、导航等）。
DreamBookFoundationPreview.swift: 梦之书 Foundation 分区主页，承载颜色/排版/模板等模块入口与基础组件示例。
DreamTypographySystemPreview.swift: 排版系统二级页，集中承载文字角色、版式规范与纵向节奏要求。
DreamCardPageTemplatesPreview.swift: 梦境卡片页面模板预览，承载列表模板、详情模板与 Page Sheet 弹出交互验收。

架构决策（预览门禁原则）
1. 预览页不是视觉拼图容器，而是设计系统规则的验收面板；展示顺序与说明文案应服务“令牌 -> 组件 -> 页面模板”的验证路径。
2. 页面模板预览必须区分“静态结构预览”和“真实交互语境验收”（如 Page Sheet），避免在错误语境下调 spacing。
3. 当模板出现重叠、遮挡、空白异常时，预览页应帮助定位到令牌与布局约束来源，而不是通过预览层加补丁隐藏问题。
4. 预览中的边距/节奏示例应与 Foundation 令牌保持同构，禁止在预览文件内发明另一套 spacing 规则。
5. 主页面优先做“模块入口收纳”，细项规范下沉至二级页，保证分类清晰与首屏决策负担可控。

开发规范（模板验收）
1. 列表模板与详情模板的版式验收优先检查：页面边距、区块节奏、Hero 安全区、底部操作区安全预留。
2. 真实 Page Sheet 相关问题（drag indicator、detent、底部遮挡）以 `.sheet` 路径验收为准，静态页签仅做结构预览。
3. 任何新增模板页签都要在说明中标注其用途（结构预览 / 交互验收 / 视觉基线）。
4. 梦境卡片模板预览需固定覆盖“有图叠层 + 无图叠层”双态，并验证图片/分析卡片的点击与横滑置顶切换行为。

法则: 成员完整·一行一文件·父级链接·技术词前置

[PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
