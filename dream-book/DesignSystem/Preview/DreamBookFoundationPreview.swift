//
//  DreamBookFoundationPreview.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 与 DreamBookFoundation 令牌/基础组件能力
 * [OUTPUT]: 对外提供 DreamBookFoundationPreview 页面，用于展示梦之书设计系统基础分层与生成态容器演示
 * [POS]: DesignSystem/Preview/ 的基础预览页，按系统分区展示颜色、排版、处理态组件原语与导航结构
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
    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            SectionTitle("排版系统")

            VStack(alignment: .leading, spacing: DreamSpacing.s) {
                Text("梦境档案")
                    .dreamRole(.navTitle)
                Text("昨夜梦境")
                    .dreamRole(.cardTitle)
                Text("我在一座会呼吸的图书馆里追逐发光的纸船。")
                    .dreamRole(.body)
                Text("@dream_0724")
                    .dreamRole(.caption)
                Text("8.7")
                    .dreamRole(.metric)
            }
            .foregroundColor(DreamColor.textPrimary)
            .padding(DreamSpacing.l)
            .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
            .dreamCardShadow()
        }
    }
}

private struct SurfacePrimitiveSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            SectionTitle("处理态组件")

            VStack(alignment: .leading, spacing: DreamSpacing.l) {
                VStack(alignment: .leading, spacing: DreamSpacing.s) {
                    DemoLabel(text: "A · 解梦中（有内容）")
                    DreamNeonPhotoFrame(
                        radius: DreamCornerRadius.md,
                        isProcessing: true
                    ) {
                        DemoMediaContent(title: "梦境图像")
                    }
                    .frame(height: 210)

                    ProcessingStatusPill(text: "解梦中")
                }

                VStack(alignment: .leading, spacing: DreamSpacing.s) {
                    DemoLabel(text: "B · 生成图片/视频中（无内容占位）")
                    DreamNeonPhotoFrame(
                        radius: DreamCornerRadius.md,
                        isProcessing: true,
                        showPlaceholder: true
                    ) {
                        DemoMediaContent(title: "占位回退")
                    }
                    .frame(height: 156)

                    ProcessingStatusPill(text: "生成图片/视频中")
                }
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

private struct FoundationColorSpec: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
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
