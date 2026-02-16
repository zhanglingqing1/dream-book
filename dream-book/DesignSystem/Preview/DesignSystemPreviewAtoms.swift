//
//  DesignSystemPreviewAtoms.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI，依赖设计令牌（AppColor/AppTextRole/AppSpacing/AppCornerRadius/AppCardStyle）
 * [OUTPUT]: 对外提供设计系统预览原子组件与示例组件（SectionHeader/SpecCard/FloatingDreamCard 等）
 * [POS]: DesignSystem/Preview/ 的原子层文件，被 DesignSystemPreviewPages.swift 消费
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

// ============================================================
// MARK: - 基础原子
// ============================================================

struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .textRole(.sectionTitle)
                .foregroundColor(AppColor.textPrimary)

            Text(subtitle)
                .textRole(.bodySecondary)
                .foregroundColor(AppColor.textSecondary)
        }
    }
}

struct PreviewDivider: View {
    var body: some View {
        Divider()
            .overlay(AppColor.stroke.opacity(0.8))
            .padding(.leading, AppSpacing.l)
            .padding(.trailing, AppSpacing.l)
    }
}

struct ColorTokenRow: View {
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            Circle()
                .fill(color)
                .frame(width: AppIconSize.sm, height: AppIconSize.sm)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .textRole(.bodyStrong)
                    .foregroundColor(AppColor.textPrimary)

                Text(subtitle)
                    .textRole(.meta)
                    .foregroundColor(AppColor.textTertiary)
            }

            Spacer()
        }
        .padding(.horizontal, AppSpacing.m)
        .padding(.vertical, AppSpacing.s)
        .background(AppCardBackground(cornerRadius: AppCornerRadius.md))
        .gentleLiftShadow()
    }
}

struct ColorSwatchCard: View {
    let title: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.s) {
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .fill(color)
                .frame(height: 66)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .inset(by: AppCardStyle.borderInset)
                        .strokeBorder(
                            AppColor.stroke.opacity(AppCardStyle.borderOpacity),
                            lineWidth: AppCardStyle.borderWidth
                        )
                )
                .gentleLiftShadow()

            Text(title)
                .textRole(.meta)
                .foregroundColor(AppColor.textSecondary)
        }
        .padding(AppSpacing.m)
        .background(AppCardBackground(cornerRadius: AppCornerRadius.md))
        .softFloatShadow()
    }
}

struct TypographySpecCard: View {
    let role: AppTextRole
    let sample: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(role.displayName)
                .textRole(.overline)
                .foregroundColor(AppColor.textTertiary)
                .textCase(.uppercase)

            Text(sample)
                .textRole(role)
                .foregroundColor(AppColor.textPrimary)
        }
        .padding(AppSpacing.m)
        .background(AppCardBackground(cornerRadius: AppCornerRadius.md))
        .softFloatShadow()
    }
}

struct SpecRow: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}

struct SpecCard: View {
    let rows: [SpecRow]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                HStack {
                    Text(row.title)
                        .textRole(.bodyPrimary)
                        .foregroundColor(AppColor.textPrimary)

                    Spacer()

                    Text(row.value)
                        .textRole(.bodySecondary)
                        .foregroundColor(AppColor.textSecondary)
                }
                .padding(.horizontal, AppSpacing.l)
                .padding(.vertical, AppSpacing.m)

                if index < rows.count - 1 {
                    PreviewDivider()
                }
            }
        }
        .background(AppCardBackground(cornerRadius: AppCornerRadius.lg))
        .softFloatShadow()
    }
}

struct MaterialSampleCard: View {
    var body: some View {
        HStack(spacing: AppSpacing.m) {
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .fill(
                    LinearGradient(
                        colors: [AppColor.accentGlowA, AppColor.accentGlowB],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 86, height: 86)
                .overlay(
                    Image(systemName: "moon.stars.fill")
                        .appIcon(size: AppIconSize.md)
                        .foregroundColor(.white.opacity(0.9))
                )

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("梦境材质卡")
                    .textRole(.bodyStrong)
                    .foregroundColor(AppColor.textPrimary)

                Text("柔和光晕 + 细边框 + 双层阴影")
                    .textRole(.bodySecondary)
                    .foregroundColor(AppColor.textSecondary)
            }

            Spacer()
        }
        .padding(AppSpacing.l)
        .background(AppCardBackground(cornerRadius: AppCornerRadius.lg))
        .softFloatShadow()
    }
}

// ============================================================
// MARK: - 业务示例组件
// ============================================================

struct FloatingDreamCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            HStack {
                Text("昨夜梦境")
                    .textRole(.meta)
                    .foregroundColor(AppColor.textTertiary)

                Spacer()

                DreamTagPill(title: "新记录", tone: .glow)
            }

            Text("我在一座会呼吸的图书馆里追逐一只发光的鱼。")
                .textRole(.bodyPrimary)
                .foregroundColor(AppColor.textPrimary)

            HStack(spacing: AppSpacing.xl) {
                StatBlock(label: "清晰度", value: "8.7")
                StatBlock(label: "情绪", value: "平静")
            }
        }
        .padding(AppSpacing.l)
        .background(AppCardBackground(cornerRadius: AppCornerRadius.lg))
        .softFloatShadow()
    }
}

struct StatBlock: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(label)
                .textRole(.overline)
                .foregroundColor(AppColor.textTertiary)

            Text(value)
                .textRole(.dataValue)
                .foregroundColor(AppColor.accentInk)
        }
    }
}

struct DreamTagPill: View {
    enum Tone { case ink, neutral, success, glow }

    let title: String
    let tone: Tone

    var body: some View {
        Text(title)
            .textRole(.meta)
            .foregroundColor(textColor)
            .padding(.horizontal, AppSpacing.m)
            .padding(.vertical, AppSpacing.xs)
            .background(Capsule().fill(backgroundColor))
    }

    private var textColor: Color {
        switch tone {
        case .ink: return AppColor.accentInk
        case .neutral: return AppColor.textSecondary
        case .success: return AppColor.success
        case .glow: return AppColor.textPrimary
        }
    }

    private var backgroundColor: Color {
        switch tone {
        case .ink, .neutral:
            return AppColor.surface
        case .success:
            return AppColor.success.opacity(AppOpacity.light)
        case .glow:
            return AppColor.accentGlowA.opacity(AppOpacity.light)
        }
    }
}

struct DreamActionButton: View {
    enum Tone { case primary, secondary }

    let title: String
    let tone: Tone
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .textRole(.button)
                .foregroundColor(tone == .primary ? AppColor.bg : AppColor.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(minHeight: AppButtonMetrics.minHeight)
                .padding(.horizontal, AppButtonMetrics.horizontal)
                .background(
                    AppButtonBackground(
                        cornerRadius: AppCornerRadius.md,
                        fill: tone == .primary ? AppColor.accentInk : AppColor.surface
                    )
                )
                .appButtonShadow()
        }
        .buttonStyle(.plain)
    }
}

// ============================================================
// MARK: - 底部导航示例
// ============================================================

struct BottomNavigationPreview: View {
    var body: some View {
        ZStack(alignment: .trailing) {
            CapsuleBackground(fill: AppColor.surface)
                .frame(height: 60)
                .gentleLiftShadow()

            HStack(spacing: AppSpacing.l) {
                NavItem(icon: "house", isSelected: true)
                NavItem(icon: "sparkles")
                NavItem(icon: "chart.bar")
                NavItem(icon: "person")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, AppSpacing.xl)
            .padding(.trailing, 88)

            FloatingActionButton()
                .padding(.trailing, AppSpacing.s)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.s)
    }
}

struct CapsuleBackground: View {
    let fill: Color

    var body: some View {
        ZStack {
            Capsule()
                .inset(by: -AppCardStyle.outerExpand)
                .fill(fill)

            Capsule()
                .inset(by: AppCardStyle.borderInset)
                .strokeBorder(
                    AppColor.stroke.opacity(AppCardStyle.borderOpacity),
                    lineWidth: AppCardStyle.borderWidth
                )
        }
    }
}

struct NavItem: View {
    let icon: String
    let isSelected: Bool

    init(icon: String, isSelected: Bool = false) {
        self.icon = icon
        self.isSelected = isSelected
    }

    var body: some View {
        ZStack {
            if isSelected {
                CapsuleBackground(fill: AppColor.card)
                    .frame(width: 56, height: 40)
                    .softFloatShadow()
            }

            Image(systemName: icon)
                .appIcon(size: 18, weight: .semibold)
                .foregroundColor(isSelected ? AppColor.accentInk : AppColor.textTertiary)
        }
        .frame(width: 56, height: 40)
    }
}

struct FloatingActionButton: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(AppColor.accentInk)
                .frame(width: 54, height: 54)
                .overlay(
                    Circle()
                        .strokeBorder(
                            AppColor.innerStroke.opacity(AppButtonMetrics.innerStrokeOpacity),
                            lineWidth: AppButtonMetrics.innerStrokeWidth
                        )
                )
                .appButtonShadow()

            Image(systemName: "plus")
                .appIcon(size: 22, weight: .bold)
                .foregroundColor(AppColor.bg)
        }
        .accessibilityLabel("主行动按钮")
    }
}

#Preview {
    DesignSystemPreview()
}
