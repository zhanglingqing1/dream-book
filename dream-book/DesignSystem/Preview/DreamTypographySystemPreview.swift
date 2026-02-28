//
//  DreamTypographySystemPreview.swift
//  dream-book
//
//  Created by Codex on 2026/2/27.
//

/**
 * [INPUT]: 依赖 SwiftUI 与 DreamBookFoundation 的排版/布局令牌能力
 * [OUTPUT]: 对外提供 DreamTypographySystemPreview 页面，集中展示文字角色、版式规范与纵向节奏要求
 * [POS]: DesignSystem/Preview/ 的排版系统二级页，由 DreamBookFoundationPreview 通过入口卡跳转
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

struct DreamTypographySystemPreview: View {
    private let roleSpecs: [FoundationTextRoleSpec] = [
        .init(role: .navTitle, sample: "原始梦境"),
        .init(role: .cardTitle, sample: "潮声中的告别"),
        .init(role: .body, sample: "列车代表你正在离开旧叙事，海浪象征情绪仍在波动。"),
        .init(role: .bodyStrong, sample: "深度解析"),
        .init(role: .caption, sample: "2025年12月14日 · AI洞察值"),
        .init(role: .detailTime, sample: "11:21 上午"),
        .init(role: .metric, sample: "82")
    ]

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
        ZStack {
            DreamColor.canvas
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: DreamSpacing.xl) {
                    IntroCard()
                    TypographyRoleSection(roleSpecs: roleSpecs)
                    TypographyConstraintCard()
                    LayoutInsetSection(insetSpecs: insetSpecs)
                    LayoutRhythmSection(rhythmSpecs: rhythmSpecs)
                }
                .padding(.horizontal, DreamSpacing.l)
                .padding(.top, DreamSpacing.s)
                .padding(.bottom, DreamSpacing.xxxl)
            }
        }
        .navigationTitle("排版系统")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ============================================================
// MARK: - 页面分区
// ============================================================

private struct IntroCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.xs) {
            Text("图文角色与办事规范")
                .dreamRole(.bodyStrong)
                .foregroundColor(DreamColor.textPrimary)

            Text("本页统一承载文字角色、内外边距和纵向节奏要求，业务页只消费语义令牌，不写裸字号和硬编码间距。")
                .dreamRole(.caption)
                .foregroundColor(DreamColor.textSecondary)
                .lineSpacing(2)
        }
        .padding(DreamLayoutInsets.compactCard)
        .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
        .dreamCardShadow()
    }
}

private struct TypographyRoleSection: View {
    let roleSpecs: [FoundationTextRoleSpec]

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            TypographyPageSectionTitle("层级用途与文字角色")

            VStack(alignment: .leading, spacing: DreamLayoutRhythm.rowGap) {
                ForEach(roleSpecs) { spec in
                    TypographyRoleRow(spec: spec)
                }
            }
            .padding(DreamLayoutInsets.compactCard)
            .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
            .dreamCardShadow()
        }
    }
}

private struct TypographyConstraintCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DreamLayoutRhythm.rowGap) {
            TypographyPageSectionTitle("排版约束")

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

private struct LayoutInsetSection: View {
    let insetSpecs: [FoundationInsetSpec]

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            TypographyPageSectionTitle("版式规范")

            VStack(alignment: .leading, spacing: DreamLayoutRhythm.rowGap) {
                ForEach(insetSpecs) { spec in
                    LayoutInsetRow(spec: spec)
                }
            }
            .padding(DreamLayoutInsets.compactCard)
            .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
            .dreamCardShadow()
        }
    }
}

private struct LayoutRhythmSection: View {
    let rhythmSpecs: [FoundationRhythmSpec]

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            TypographyPageSectionTitle("纵向节奏要求")

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

// ============================================================
// MARK: - 页面原子
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

private struct TypographyPageSectionTitle: View {
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

#Preview {
    NavigationStack {
        DreamTypographySystemPreview()
    }
    .environmentObject(ThemeStore())
}
