//
//  DreamBookFoundationPreview.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 与 DreamBookFoundation 令牌/基础组件能力
 * [OUTPUT]: 对外提供 DreamBookFoundationPreview 页面，用于展示梦之书设计系统基础分层、排版/版式规范与处理态容器演示
 * [POS]: DesignSystem/Preview/ 的基础预览页，按系统分区展示颜色、排版、版式、处理态组件原语与导航结构
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

struct DreamBookFoundationPreview: View {
    @EnvironmentObject private var themeStore: ThemeStore

    private let colorSpecs: [FoundationColorSpec] = [
        .init(name: "[背景] canvas", color: DreamColor.canvas),
        .init(name: "[背景] surface", color: DreamColor.surface),
        .init(name: "[背景] card", color: DreamColor.card),
        .init(name: "[文本] textPrimary", color: DreamColor.textPrimary),
        .init(name: "[文本] textSecondary", color: DreamColor.textSecondary),
        .init(name: "[强调] fabFill", color: DreamColor.fabFill),
        .init(name: "[强调] premiumFill", color: DreamColor.premiumFill),
        .init(name: "[强调] premiumText", color: DreamColor.premiumText),
        .init(name: "[边界] stroke", color: DreamColor.stroke)
    ]

    var body: some View {
        ZStack {
            DreamColor.canvas
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: DreamSpacing.xxl) {
                    HeaderStrip()
                    ColorTokenSection(specs: colorSpecs)
                    TypographyTokenSection()
                    LayoutSpecSection()
                    SurfacePrimitiveSection()
                    NavigationSystemSection()
                    PageTemplateSection()
                }
                .padding(.horizontal, DreamSpacing.l)
                .padding(.top, DreamSpacing.s)
                .padding(.bottom, DreamSpacing.xxxl)
            }
        }
        .navigationTitle("梦之书设计系统")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { themeStore.toggle() }) {
                    HStack(spacing: DreamSpacing.xs) {
                        Image(systemName: themeStore.mode.icon)
                            .font(.system(size: 13, weight: .semibold))
                        Text(themeStore.mode.title)
                            .dreamRole(.caption)
                    }
                    .foregroundColor(DreamColor.textPrimary)
                    .padding(.horizontal, DreamSpacing.s)
                    .padding(.vertical, DreamSpacing.xs)
                    .background(
                        Capsule(style: .continuous)
                            .fill(DreamColor.surface)
                    )
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(DreamColor.stroke.opacity(0.72), lineWidth: DreamStroke.hairline)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("切换亮暗主题")
            }
        }
    }
}

// ============================================================
// MARK: - 页面分区
// ============================================================

private struct HeaderStrip: View {
    var body: some View {
        HStack {
            Circle()
                .fill(DreamColor.surface)
                .frame(width: 54, height: 54)
                .overlay(
                    Image(systemName: "scribble.variable")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(DreamColor.textSecondary)
                )
                .dreamCardShadow()

            Spacer()

            Text("梦之书")
                .dreamRole(.navTitle)
                .foregroundColor(DreamColor.textPrimary)

            Spacer()

            DreamPremiumPill(title: "系统规范")
        }
    }
}

private struct ColorTokenSection: View {
    let specs: [FoundationColorSpec]
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            SectionTitle("颜色系统")

            LazyVGrid(columns: columns, spacing: DreamSpacing.s) {
                ForEach(specs) { spec in
                    ColorTokenCell(spec: spec)
                }
            }
        }
    }
}

private struct TypographyTokenSection: View {
    private let roleSpecs: [FoundationTextRoleSpec] = [
        .init(role: .navTitle, sample: "梦境条目标题"),
        .init(role: .cardTitle, sample: "潮声中的告别"),
        .init(role: .body, sample: "列车代表你正在离开旧叙事，海浪象征情绪仍在波动。"),
        .init(role: .bodyStrong, sample: "深度解析"),
        .init(role: .caption, sample: "2025年12月14日 · AI洞察值"),
        .init(role: .detailTime, sample: "11:21 上午"),
        .init(role: .metric, sample: "82"),
        .init(role: .metricUnit, sample: "分")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            SectionTitle("排版系统")

            VStack(alignment: .leading, spacing: DreamLayoutRhythm.groupGap) {
                Text("层级用途与文字角色")
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.textPrimary)

                VStack(alignment: .leading, spacing: DreamLayoutRhythm.rowGap) {
                    ForEach(roleSpecs) { spec in
                        TypographyRoleRow(spec: spec)
                    }
                }
                .padding(DreamLayoutInsets.compactCard)
                .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
                .dreamCardShadow()

                TypographySpecNoteCard()
            }
        }
    }
}

private struct LayoutSpecSection: View {
    private let insetSpecs: [FoundationInsetSpec] = [
        .init(name: "页面外边距", insets: DreamLayoutInsets.page, note: "列表/预览页基础安全边距"),
        .init(name: "Sheet 内容区", insets: DreamLayoutInsets.sheetContent, note: "详情页与弹层内容起始边距"),
        .init(name: "标准卡片内边距", insets: DreamLayoutInsets.card, note: "内容卡、说明卡默认内边距"),
        .init(name: "紧凑卡片内边距", insets: DreamLayoutInsets.compactCard, note: "行卡片、紧凑信息模块"),
        .init(name: "胶囊按钮内边距", insets: DreamLayoutInsets.pill, note: "状态标签/轻操作按钮")
    ]

    private let rhythmSpecs: [FoundationRhythmSpec] = [
        .init(name: "页面区块间距", value: DreamLayoutRhythm.pageSectionGap, note: "一级区块之间"),
        .init(name: "大区块间距", value: DreamLayoutRhythm.majorBlockGap, note: "Hero 与 Meta、正文块之间"),
        .init(name: "组间距", value: DreamLayoutRhythm.groupGap, note: "卡片内部组块"),
        .init(name: "行间距", value: DreamLayoutRhythm.rowGap, note: "标签行、信息行"),
        .init(name: "紧凑间距", value: DreamLayoutRhythm.tightGap, note: "图标与文字、短标签")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            SectionTitle("版式规范")

            VStack(alignment: .leading, spacing: DreamLayoutRhythm.groupGap) {
                Text("内外边距要求")
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.textPrimary)

                VStack(alignment: .leading, spacing: DreamLayoutRhythm.rowGap) {
                    ForEach(insetSpecs) { spec in
                        LayoutInsetRow(spec: spec)
                    }
                }
                .padding(DreamLayoutInsets.compactCard)
                .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
                .dreamCardShadow()
            }

            VStack(alignment: .leading, spacing: DreamLayoutRhythm.groupGap) {
                Text("纵向节奏要求")
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.textPrimary)

                VStack(alignment: .leading, spacing: DreamLayoutRhythm.rowGap) {
                    ForEach(rhythmSpecs) { spec in
                        LayoutRhythmRow(spec: spec)
                    }
                }
                .padding(DreamLayoutInsets.compactCard)
                .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
                .dreamCardShadow()
            }
        }
    }
}

private struct SurfacePrimitiveSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            SectionTitle("处理态组件")

            VStack(alignment: .leading, spacing: DreamSpacing.s) {
                DemoLabel(text: "统一处理态（文案按场景切换：解梦中 / 生成中）")
                DreamNeonPhotoFrame(
                    radius: DreamCornerRadius.md,
                    isProcessing: true
                ) {
                    DemoMediaContent(title: "处理中内容")
                }
                .frame(height: 196)

                ProcessingStatusPill(text: "处理中")
            }
        }
    }
}

private struct NavigationSystemSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            SectionTitle("导航系统")

            BottomDockShowcase()
        }
    }
}

private struct PageTemplateSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            SectionTitle("页面模板")

            NavigationLink {
                DreamCardPageTemplatesPreview()
            } label: {
                HStack(spacing: DreamSpacing.m) {
                    Image(systemName: "rectangle.stack.person.crop")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(DreamColor.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: DreamCornerRadius.sm, style: .continuous)
                                .fill(DreamColor.surface)
                        )

                    VStack(alignment: .leading, spacing: DreamSpacing.xxs) {
                        Text("梦境卡片列表与详情")
                            .dreamRole(.bodyStrong)
                            .foregroundColor(DreamColor.textPrimary)
                        Text("Page Sheet 交互模板")
                            .dreamRole(.caption)
                            .foregroundColor(DreamColor.textSecondary)
                    }

                    Spacer(minLength: DreamSpacing.s)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(DreamColor.textTertiary)
                }
                .padding(DreamSpacing.m)
                .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
                .dreamCardShadow()
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("dream.preview.templates.entry")
        }
    }
}

private struct BottomDockShowcase: View {
    @State private var selectedTab: DockTabItem = .home

    var body: some View {
        HStack(alignment: .center, spacing: DreamDockMetrics.railToFabSpacing) {
            DockTabRail(selectedTab: $selectedTab)
                .frame(maxWidth: .infinity)

            DreamFloatingPlusButton()
                .frame(width: DreamDockMetrics.fabWidth, height: DreamDockMetrics.fabHeight)
        }
        .frame(maxWidth: .infinity)
    }
}

private enum DockTabItem: String, CaseIterable, Identifiable {
    case home
    case dreams
    case insights
    case profile

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .home:
            return "house"
        case .dreams:
            return "moon.stars"
        case .insights:
            return "chart.line.uptrend.xyaxis"
        case .profile:
            return "person.crop.circle"
        }
    }

    var selectedSymbol: String {
        switch self {
        case .home:
            return "house.fill"
        case .dreams:
            return "moon.stars.fill"
        case .insights:
            return "chart.line.uptrend.xyaxis.circle.fill"
        case .profile:
            return "person.crop.circle.fill"
        }
    }

    var title: String {
        switch self {
        case .home:
            return "首页"
        case .dreams:
            return "梦境"
        case .insights:
            return "洞察"
        case .profile:
            return "我的"
        }
    }
}

private struct DockTabRail: View {
    @Binding var selectedTab: DockTabItem

    var body: some View {
        ZStack {
            DreamDockPlate()
                .dreamDockShadow()

            HStack(spacing: DreamDockMetrics.tabItemSpacing) {
                ForEach(DockTabItem.allCases) { tab in
                    DockTabButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        onTap: { selectedTab = tab }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, DreamDockMetrics.railHorizontalPadding)
            .padding(.vertical, DreamDockMetrics.railVerticalPadding)
        }
        .frame(height: DreamDockMetrics.railHeight)
    }
}

private struct DockTabButton: View {
    let tab: DockTabItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: DreamDockMetrics.tabSelectionCornerRadius, style: .continuous)
                        .fill(DreamColor.cardStrong)
                        .overlay(
                            RoundedRectangle(cornerRadius: DreamDockMetrics.tabSelectionCornerRadius, style: .continuous)
                                .stroke(DreamColor.stroke.opacity(DreamSurfaceStyle.borderOpacity), lineWidth: DreamStroke.hairline)
                        )
                        .padding(.horizontal, DreamDockMetrics.tabSelectionHorizontalInset)
                        .padding(.vertical, DreamDockMetrics.tabSelectionVerticalInset)
                        .dreamCardShadow()
                }

                Image(systemName: isSelected ? tab.selectedSymbol : tab.symbol)
                    .font(.system(size: DreamDockMetrics.tabIconSize, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? DreamColor.textPrimary : DreamColor.textTertiary)
            }
            .frame(maxWidth: .infinity, minHeight: DreamDockMetrics.tabButtonHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityValue(isSelected ? "当前页" : "未选中")
    }
}

// ============================================================
// MARK: - 小型原子
// ============================================================

private struct FoundationTextRoleSpec: Identifiable {
    let role: DreamTextRole
    let sample: String

    var id: String { role.rawValue }
}

private struct FoundationInsetSpec: Identifiable {
    let id = UUID()
    let name: String
    let insets: EdgeInsets
    let note: String
}

private struct FoundationRhythmSpec: Identifiable {
    let id = UUID()
    let name: String
    let value: CGFloat
    let note: String
}

private struct FoundationColorSpec: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

private struct TypographyRoleRow: View {
    let spec: FoundationTextRoleSpec

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.xxs) {
            HStack(alignment: .firstTextBaseline, spacing: DreamSpacing.s) {
                Text(spec.role.usageTitle)
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.textPrimary)

                Spacer(minLength: DreamSpacing.s)

                Text(spec.role.rawValue)
                    .dreamRole(.caption)
                    .foregroundColor(DreamColor.textTertiary)
            }

            Text(spec.sample)
                .dreamRole(spec.role)
                .foregroundColor(DreamColor.textPrimary)
                .lineLimit(2)

            Text(spec.role.usageNotes)
                .dreamRole(.caption)
                .foregroundColor(DreamColor.textSecondary)
        }
        .padding(.vertical, DreamSpacing.xs)
        .overlay(alignment: .bottom) {
            Divider()
                .overlay(DreamColor.stroke.opacity(0.42))
        }
    }
}

private struct TypographySpecNoteCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DreamLayoutRhythm.rowGap) {
            Text("排版约束")
                .dreamRole(.bodyStrong)
                .foregroundColor(DreamColor.textPrimary)

            Text("标题负责导航与分段；正文负责阅读；caption 只承载辅助信息；metric 与 detailTime 仅用于高显著数字。")
                .dreamRole(.caption)
                .foregroundColor(DreamColor.textSecondary)
                .lineSpacing(2)
        }
        .padding(DreamLayoutInsets.compactCard)
        .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
        .dreamCardShadow()
    }
}

private struct LayoutInsetRow: View {
    let spec: FoundationInsetSpec

    var body: some View {
        HStack(alignment: .top, spacing: DreamSpacing.s) {
            VStack(alignment: .leading, spacing: DreamSpacing.xxs) {
                Text(spec.name)
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.textPrimary)

                Text(spec.note)
                    .dreamRole(.caption)
                    .foregroundColor(DreamColor.textSecondary)
            }

            Spacer(minLength: DreamSpacing.s)

            VStack(alignment: .trailing, spacing: 2) {
                Text("T\(int(spec.insets.top)) L\(int(spec.insets.leading))")
                    .dreamRole(.caption)
                Text("B\(int(spec.insets.bottom)) R\(int(spec.insets.trailing))")
                    .dreamRole(.caption)
            }
            .foregroundColor(DreamColor.textSecondary)
        }
        .padding(.vertical, DreamSpacing.xs)
        .overlay(alignment: .bottom) {
            Divider()
                .overlay(DreamColor.stroke.opacity(0.42))
        }
    }

    private func int(_ value: CGFloat) -> Int {
        Int(value.rounded())
    }
}

private struct LayoutRhythmRow: View {
    let spec: FoundationRhythmSpec

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: DreamSpacing.s) {
            VStack(alignment: .leading, spacing: DreamSpacing.xxs) {
                Text(spec.name)
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.textPrimary)

                Text(spec.note)
                    .dreamRole(.caption)
                    .foregroundColor(DreamColor.textSecondary)
            }

            Spacer(minLength: DreamSpacing.s)

            Text("\(Int(spec.value.rounded())) pt")
                .dreamRole(.caption)
                .foregroundColor(DreamColor.textSecondary)
        }
        .padding(.vertical, DreamSpacing.xs)
        .overlay(alignment: .bottom) {
            Divider()
                .overlay(DreamColor.stroke.opacity(0.42))
        }
    }
}

private struct ColorTokenCell: View {
    let spec: FoundationColorSpec

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.xs) {
            RoundedRectangle(cornerRadius: DreamCornerRadius.sm, style: .continuous)
                .fill(spec.color)
                .overlay(
                    RoundedRectangle(cornerRadius: DreamCornerRadius.sm, style: .continuous)
                        .stroke(DreamColor.stroke.opacity(0.60), lineWidth: DreamStroke.hairline)
                )
                .frame(height: 54)

            Text(spec.name)
                .dreamRole(.caption)
                .foregroundColor(DreamColor.textSecondary)
        }
        .padding(DreamSpacing.xs)
        .background(DreamSurfaceCard(radius: DreamCornerRadius.md, fill: DreamColor.cardStrong))
        .dreamCardShadow()
    }
}

private struct SectionTitle: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .dreamRole(.bodyStrong)
            .foregroundColor(DreamColor.textPrimary)
    }
}

private struct DemoLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .dreamRole(.caption)
            .foregroundColor(DreamColor.textSecondary)
    }
}

private struct DemoMediaContent: View {
    let title: String

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    DreamColor.surface,
                    DreamColor.cardStrong
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                LinearGradient(
                    colors: [
                        DreamColor.photoGlowMint.opacity(0.20),
                        DreamColor.photoGlowViolet.opacity(0.16),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            VStack(alignment: .leading, spacing: DreamSpacing.s) {
                HStack {
                    Circle()
                        .fill(DreamColor.photoGlowMint.opacity(0.85))
                        .frame(width: 10, height: 10)

                    Circle()
                        .fill(DreamColor.photoGlowViolet.opacity(0.85))
                        .frame(width: 10, height: 10)
                }

                Spacer(minLength: 0)

                Text(title)
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.textPrimary)
            }
            .padding(DreamSpacing.l)
        }
    }
}

private struct ProcessingStatusPill: View {
    let text: String

    var body: some View {
        HStack(spacing: DreamSpacing.s) {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            DreamColor.photoGlowAmber.opacity(0.95),
                            DreamColor.photoGlowViolet.opacity(0.62),
                            DreamColor.photoGlowMint.opacity(0.25)
                        ],
                        center: .center,
                        startRadius: 1,
                        endRadius: 26
                    )
                )
                .frame(width: 26, height: 26)

            Text(text)
                .dreamRole(.bodyStrong)
                .foregroundColor(DreamColor.textPrimary)
        }
        .padding(.horizontal, DreamSpacing.m)
        .padding(.vertical, DreamSpacing.s)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DreamCornerRadius.lg, style: .continuous)
                .fill(DreamColor.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DreamCornerRadius.lg, style: .continuous)
                .stroke(DreamColor.stroke.opacity(0.72), lineWidth: DreamStroke.hairline)
        )
        .dreamCardShadow()
    }
}

#Preview {
    NavigationStack {
        DreamBookFoundationPreview()
    }
    .environmentObject(ThemeStore())
}
