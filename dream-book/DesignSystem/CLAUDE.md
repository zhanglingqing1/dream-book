# DesignSystem/
> L2 | 父级: /dream-book/CLAUDE.md

成员清单
DesignSystemProtocol.swift: 设计系统色值常量与语义色基线，作为视觉真相源。
DesignTokens.swift: 视觉令牌层（颜色、排版、间距、圆角、阴影、组件背景），统一消费双模式色值。
DreamBookFoundation.swift: 梦之书基础层，承载颜色/排版/几何/阴影/基础容器组件令牌真相源。
DreamCardKit.swift: 梦境卡片数据契约与布局令牌层，统一定义列表/详情的数据结构、时间格式与回退策略。
DreamCardComponents.swift: 梦境卡片组件层，封装 Hero 叠层、时间轴列表、Page Sheet 详情与底部操作条。
DesignSystemPreview.swift: 设计系统预览总入口，当前挂载梦之书 Foundation 分区页并承接后续模块演进。
Preview/: 设计系统预览页面层与原子组件层。

架构决策（系统性修复原则）
1. 设计系统修复优先改“规则归属”而非单点数值：先确定 Foundation 令牌、模块布局令牌、组件实现的职责边界，再调 spacing。
2. `DreamBookFoundation.swift` 负责语义级规范（文字角色、边距、节奏、阴影语言）；`DreamCardKit.swift` 负责梦境卡片数据契约与构图几何；`DreamCardComponents.swift` 只消费令牌与实现布局。
3. 禁止补丁式改动：发现重叠、遮挡、空白异常时，不直接堆叠新的 `padding/offset`，应先追溯到令牌来源与布局约束模型。
4. 版式问题优先通过统一令牌接管解决：`DreamLayoutInsets` / `DreamLayoutRhythm` 是模板层 spacing 的默认入口，避免组件内散落硬编码间距。
5. 固定值仅用于构图几何（尺寸/旋转/偏移）；与内容长度、设备安全区相关的留白应使用语义规则或派生值，避免遮挡回归。

开发规范（版式与验收）
1. 调整列表/详情模板时，先检查是否复用 Foundation 排版规范；若未复用，优先做"令牌接管"再做视觉微调。
2. 任何新模板必须声明：页面边距、区块节奏、卡片内边距、底部安全预留的令牌来源。
3. 验收时区分风格与版式：本模块允许在不改风格（颜色/材质/阴影/圆角）的前提下，单独迭代边距、对齐、节奏与安全区。
4. 出现列表文本区空白过大、详情底部遮挡等问题时，视为系统性版式缺陷，不以局部补丁 closure 作为最终方案。

版式复刻记录（参考截图对齐）
1. 日期列从 VStack（日上月下）改为 HStack（日号+月号下标），水平基线对齐，timelineColumnWidth 62→74。
2. Summary Panel：标题独占一行，标签 pill 移至正文区右侧（与 emoji+摘要同行），移除底部"情绪+时间"footer。
3. 时间标签（clockTime 格式）从卡片内移至卡片外下方独立呈现，summaryTimeTopPadding 控制间距。
4. summaryPanelMinHeight 186→150，配合 footer 移除后自然收紧卡片高度。
5. 详情关闭按钮 64→44、图标 24→16，匹配参考截图的精致比例。

法则: 成员完整·一行一文件·父级链接·技术词前置

[PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
