//
//  DesignTokens.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 的布局与字体能力，依赖 DS 色值常量库
 * [OUTPUT]: 对外提供 AppColor/AppTypography/AppTextRole/AppSpacing/AppCornerRadius/AppOpacity/AppIconSize/AppCardStyle/AppButtonMetrics/AppShadow 语义令牌，以及卡片/按钮背景与文本/阴影语义扩展
 * [POS]: DesignSystem/ 的令牌主入口，被预览页和后续业务页面统一消费
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

// ============================================================
// MARK: - 色彩令牌
// ============================================================

enum AppColor {
    static let bg = DS.backgroundPrimary
    static let surface = DS.backgroundSurface
    static let card = DS.backgroundCard
    static let stroke = DS.stroke

    static let textPrimary = DS.textPrimary
    static let textSecondary = DS.textSecondary
    static let textTertiary = DS.textTertiary

    static let accentInk = DS.accentInk
    static let accentGlowA = DS.accentGlowA
    static let accentGlowB = DS.accentGlowB
    static let accentGlowC = DS.accentGlowC

    static let moodCalm = DS.moodCalm
    static let moodMystic = DS.moodMystic
    static let moodWarm = DS.moodWarm
    static let moodAlert = DS.moodAlert

    static let success = DS.success
    static let warning = DS.warning
    static let danger = DS.danger

    static let innerStroke = DS.innerStroke
    static let shadowPrimary = DS.shadowPrimary
    static let shadowSecondary = DS.shadowSecondary
}

// ============================================================
// MARK: - 版式令牌
// ============================================================

enum AppTypography {
    static let hero = Font.system(size: 34, weight: .semibold, design: .serif)
    static let screen = Font.system(size: 28, weight: .semibold, design: .serif)
    static let section = Font.system(size: 21, weight: .medium, design: .serif)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyStrong = Font.system(size: 17, weight: .semibold, design: .default)
    static let meta = Font.system(size: 13, weight: .regular, design: .default)
    static let overline = Font.system(size: 11, weight: .medium, design: .rounded)
}

struct AppTextStyle {
    let font: Font
    let lineSpacing: CGFloat
    let tracking: CGFloat
    let lineLimit: Int?
    let monospacedDigit: Bool
}

enum AppTextRole: String, CaseIterable {
    case heroTitle
    case screenTitle
    case sectionTitle
    case bodyPrimary
    case bodySecondary
    case bodyStrong
    case meta
    case overline
    case dataValue
    case button

    var displayName: String { rawValue }

    var style: AppTextStyle {
        switch self {
        case .heroTitle:
            return AppTextStyle(
                font: AppTypography.hero,
                lineSpacing: 4,
                tracking: 0,
                lineLimit: nil,
                monospacedDigit: false
            )
        case .screenTitle:
            return AppTextStyle(
                font: AppTypography.screen,
                lineSpacing: 3,
                tracking: 0,
                lineLimit: nil,
                monospacedDigit: false
            )
        case .sectionTitle:
            return AppTextStyle(
                font: AppTypography.section,
                lineSpacing: 2,
                tracking: 0,
                lineLimit: nil,
                monospacedDigit: false
            )
        case .bodyPrimary:
            return AppTextStyle(
                font: AppTypography.body,
                lineSpacing: 3,
                tracking: 0,
                lineLimit: nil,
                monospacedDigit: false
            )
        case .bodySecondary:
            return AppTextStyle(
                font: AppTypography.meta,
                lineSpacing: 2,
                tracking: 0,
                lineLimit: nil,
                monospacedDigit: false
            )
        case .bodyStrong:
            return AppTextStyle(
                font: AppTypography.bodyStrong,
                lineSpacing: 3,
                tracking: 0,
                lineLimit: nil,
                monospacedDigit: false
            )
        case .meta:
            return AppTextStyle(
                font: AppTypography.meta,
                lineSpacing: 1,
                tracking: 0.2,
                lineLimit: 1,
                monospacedDigit: false
            )
        case .overline:
            return AppTextStyle(
                font: AppTypography.overline,
                lineSpacing: 0,
                tracking: 1.0,
                lineLimit: 1,
                monospacedDigit: false
            )
        case .dataValue:
            return AppTextStyle(
                font: Font.system(size: 28, weight: .semibold, design: .default),
                lineSpacing: 0,
                tracking: 0.3,
                lineLimit: 1,
                monospacedDigit: true
            )
        case .button:
            return AppTextStyle(
                font: AppTypography.bodyStrong,
                lineSpacing: 0,
                tracking: 0.1,
                lineLimit: 1,
                monospacedDigit: false
            )
        }
    }

    static let previewRoles: [AppTextRole] = [
        .heroTitle,
        .screenTitle,
        .sectionTitle,
        .bodyPrimary,
        .bodySecondary,
        .meta,
        .overline,
        .dataValue
    ]
}

// ============================================================
// MARK: - 布局令牌
// ============================================================

enum AppSpacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

enum AppCornerRadius {
    static let sm: CGFloat = 12
    static let md: CGFloat = 18
    static let lg: CGFloat = 26
    static let capsule: CGFloat = 999
}

enum AppOpacity {
    static let subtle: Double = 0.06
    static let light: Double = 0.14
    static let medium: Double = 0.24
    static let strong: Double = 0.34
}

enum AppIconSize {
    static let sm: CGFloat = 16
    static let md: CGFloat = 22
    static let lg: CGFloat = 30
}

enum AppCardStyle {
    static let outerExpand: CGFloat = 1.0
    static let borderInset: CGFloat = 1.2
    static let borderWidth: CGFloat = 0.8
    static let borderOpacity: Double = 0.78
}

enum AppButtonMetrics {
    static let minHeight: CGFloat = 48
    static let horizontal: CGFloat = 16
    static let vertical: CGFloat = 12
    static let innerStrokeWidth: CGFloat = 1.0
    static let innerStrokeOpacity: Double = 0.28
    static let shadowOpacity: Double = 0.22
    static let shadowRadius: CGFloat = 18
    static let shadowYOffset: CGFloat = 10
}

enum AppShadow {
    struct Layer {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    static let softFloat = [
        Layer(color: AppColor.shadowPrimary.opacity(0.08), radius: 24, x: 0, y: 8),
        Layer(color: AppColor.shadowSecondary.opacity(0.06), radius: 48, x: 0, y: 24)
    ]

    static let gentleLift = [
        Layer(color: AppColor.shadowPrimary.opacity(0.06), radius: 12, x: 0, y: 4),
        Layer(color: AppColor.shadowSecondary.opacity(0.04), radius: 24, x: 0, y: 12)
    ]
}

// ============================================================
// MARK: - 语义扩展
// ============================================================

extension Text {
    @ViewBuilder
    func textRole(_ role: AppTextRole) -> some View {
        let style = role.style
        let base = self
            .font(style.font)
            .lineSpacing(style.lineSpacing)
            .tracking(style.tracking)
            .lineLimit(style.lineLimit)

        if style.monospacedDigit {
            base.monospacedDigit()
        } else {
            base
        }
    }
}

extension Image {
    func appIcon(size: CGFloat = AppIconSize.sm, weight: Font.Weight = .semibold) -> some View {
        self.font(.system(size: size, weight: weight))
    }
}

extension View {
    func softFloatShadow() -> some View {
        self
            .shadow(
                color: AppShadow.softFloat[0].color,
                radius: AppShadow.softFloat[0].radius,
                x: AppShadow.softFloat[0].x,
                y: AppShadow.softFloat[0].y
            )
            .shadow(
                color: AppShadow.softFloat[1].color,
                radius: AppShadow.softFloat[1].radius,
                x: AppShadow.softFloat[1].x,
                y: AppShadow.softFloat[1].y
            )
    }

    func gentleLiftShadow() -> some View {
        self
            .shadow(
                color: AppShadow.gentleLift[0].color,
                radius: AppShadow.gentleLift[0].radius,
                x: AppShadow.gentleLift[0].x,
                y: AppShadow.gentleLift[0].y
            )
            .shadow(
                color: AppShadow.gentleLift[1].color,
                radius: AppShadow.gentleLift[1].radius,
                x: AppShadow.gentleLift[1].x,
                y: AppShadow.gentleLift[1].y
            )
    }

    func appButtonShadow() -> some View {
        self.shadow(
            color: AppColor.shadowPrimary.opacity(AppButtonMetrics.shadowOpacity),
            radius: AppButtonMetrics.shadowRadius,
            x: 0,
            y: AppButtonMetrics.shadowYOffset
        )
    }
}

// ============================================================
// MARK: - 基础背景组件
// ============================================================

struct AppCardBackground: View {
    let cornerRadius: CGFloat
    let fill: Color

    init(cornerRadius: CGFloat, fill: Color = AppColor.card) {
        self.cornerRadius = cornerRadius
        self.fill = fill
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .inset(by: -AppCardStyle.outerExpand)
                .fill(fill)

            RoundedRectangle(cornerRadius: cornerRadius)
                .inset(by: AppCardStyle.borderInset)
                .strokeBorder(
                    AppColor.stroke.opacity(AppCardStyle.borderOpacity),
                    lineWidth: AppCardStyle.borderWidth
                )
        }
    }
}

struct AppButtonBackground: View {
    let cornerRadius: CGFloat
    let fill: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(fill)

            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(
                    AppColor.innerStroke.opacity(AppButtonMetrics.innerStrokeOpacity),
                    lineWidth: AppButtonMetrics.innerStrokeWidth
                )
        }
    }
}
