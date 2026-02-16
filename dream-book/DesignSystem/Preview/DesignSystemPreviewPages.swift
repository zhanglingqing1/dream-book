//
//  DesignSystemPreviewPages.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI，依赖设计令牌与预览原子组件（SectionHeader/ColorTokenRow/FloatingDreamCard 等）
 * [OUTPUT]: 对外提供 DesignSystemHomeView 页面结构（主题模式、颜色、排版、材质、组件、导航示例）
 * [POS]: DesignSystem/Preview/ 的页面层文件，被 DesignSystemPreview.swift 消费并承接亮暗切换
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

struct DesignSystemHomeView: View {
    @Binding var themeMode: ThemeMode

    var body: some View {
        DesignSystemPageContainer(
            title: "DreamBook 设计系统",
            subtitle: "先统一视觉语言，再写业务页面。所有页面都从令牌与组件生长。"
        ) {
            ThemeModeSection(themeMode: $themeMode)
            HeroSection()
            ColorSystemSection()
            TypographySection()
            MaterialSection()
            ComponentSection()
            NavigationSection()
        }
        .navigationTitle("设计系统")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ============================================================
// MARK: - 页面容器
// ============================================================

private struct DesignSystemPageContainer<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

    init(
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppColor.bg, AppColor.surface],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    VStack(alignment: .leading, spacing: AppSpacing.s) {
                        Text(title)
                            .textRole(.screenTitle)
                            .foregroundColor(AppColor.textPrimary)

                        Text(subtitle)
                            .textRole(.bodySecondary)
                            .foregroundColor(AppColor.textSecondary)
                    }
                    .padding(.top, AppSpacing.s)

                    content
                }
                .padding(.horizontal, AppSpacing.l)
                .padding(.bottom, AppSpacing.xxl)
            }
        }
    }
}

// ============================================================
// MARK: - 分区：主题模式
// ============================================================

private struct ThemeModeSection: View {
    @Binding var themeMode: ThemeMode

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            SectionHeader(
                title: "主题模式",
                subtitle: "默认暗色，支持亮色。两者共享同一套语义令牌，避免分叉维护。"
            )

            Picker("主题模式", selection: $themeMode) {
                ForEach(ThemeMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding(AppSpacing.s)
            .background(AppCardBackground(cornerRadius: AppCornerRadius.md, fill: AppColor.surface))
            .gentleLiftShadow()
        }
    }
}

// ============================================================
// MARK: - 分区：封面
// ============================================================

private struct HeroSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            SectionHeader(
                title: "视觉北极星",
                subtitle: "暗色梦境底 + 轻浮起卡片 + 语义化排版，不靠特例分支。"
            )

            FloatingDreamCard()

            HStack(spacing: AppSpacing.s) {
                DreamTagPill(title: "Dark First", tone: .ink)
                DreamTagPill(title: "Semantic Token", tone: .neutral)
                DreamTagPill(title: "Soft Float", tone: .glow)
            }
        }
    }
}

// ============================================================
// MARK: - 分区：色彩系统
// ============================================================

private struct ColorSystemSection: View {
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            SectionHeader(
                title: "色彩系统",
                subtitle: "背景层、文本层、强调层与情绪层分离，避免业务页面硬编码色值。"
            )

            LazyVGrid(columns: gridItems, spacing: AppSpacing.m) {
                ColorSwatchCard(title: "背景 · bg", color: AppColor.bg)
                ColorSwatchCard(title: "容器 · surface", color: AppColor.surface)
                ColorSwatchCard(title: "卡片 · card", color: AppColor.card)
                ColorSwatchCard(title: "主强调 · accentInk", color: AppColor.accentInk)
            }

            VStack(spacing: AppSpacing.s) {
                ColorTokenRow(
                    title: "moodCalm",
                    subtitle: "平静主题色",
                    color: AppColor.moodCalm
                )
                ColorTokenRow(
                    title: "moodMystic",
                    subtitle: "神秘主题色",
                    color: AppColor.moodMystic
                )
                ColorTokenRow(
                    title: "moodWarm",
                    subtitle: "温暖主题色",
                    color: AppColor.moodWarm
                )
            }
        }
    }
}

// ============================================================
// MARK: - 分区：排版系统
// ============================================================

private struct TypographySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            SectionHeader(
                title: "排版系统",
                subtitle: "所有文本走角色，不在页面写字号。角色就是单一真相源。"
            )

            ForEach(AppTextRole.previewRoles, id: \.self) { role in
                TypographySpecCard(
                    role: role,
                    sample: sampleText(for: role)
                )
            }
        }
    }

    private func sampleText(for role: AppTextRole) -> String {
        switch role {
        case .heroTitle:
            return "梦在你睡着时继续写作"
        case .screenTitle:
            return "DreamBook Design System"
        case .sectionTitle:
            return "Section Title"
        case .bodyPrimary:
            return "记录、解析、洞察是同一条价值链。"
        case .bodySecondary:
            return "Secondary body text for metadata."
        case .bodyStrong:
            return "Strong body text"
        case .meta:
            return "Meta information"
        case .overline:
            return "overline"
        case .dataValue:
            return "08:32"
        case .button:
            return "Button"
        }
    }
}

// ============================================================
// MARK: - 分区：材质与边界
// ============================================================

private struct MaterialSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            SectionHeader(
                title: "材质与边界",
                subtitle: "统一卡片结构: 外扩填充 + 内边框 + 双层阴影。"
            )

            SpecCard(rows: [
                SpecRow(title: "外扩填充", value: String(format: "%.1fpt", AppCardStyle.outerExpand)),
                SpecRow(title: "边框内缩", value: String(format: "%.1fpt", AppCardStyle.borderInset)),
                SpecRow(title: "边框宽度", value: String(format: "%.1fpt", AppCardStyle.borderWidth)),
                SpecRow(title: "边框透明", value: String(format: "%.2f", AppCardStyle.borderOpacity))
            ])

            MaterialSampleCard()
        }
    }
}

// ============================================================
// MARK: - 分区：组件示例
// ============================================================

private struct ComponentSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            SectionHeader(
                title: "组件示例",
                subtitle: "只展示当前可复用组件: 卡片、按钮、标签。"
            )

            FloatingDreamCard()

            HStack(spacing: AppSpacing.s) {
                DreamTagPill(title: "周报", tone: .neutral)
                DreamTagPill(title: "已解析", tone: .success)
                DreamTagPill(title: "高频符号", tone: .glow)
            }

            VStack(spacing: AppSpacing.s) {
                DreamActionButton(title: "生成今日解析", tone: .primary, action: {})
                DreamActionButton(title: "查看历史梦境", tone: .secondary, action: {})
            }
        }
    }
}

// ============================================================
// MARK: - 分区：底部导航
// ============================================================

private struct NavigationSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            SectionHeader(
                title: "底部导航",
                subtitle: "Tab 与主行动同层，入口常驻。"
            )

            BottomNavigationPreview()
        }
    }
}
