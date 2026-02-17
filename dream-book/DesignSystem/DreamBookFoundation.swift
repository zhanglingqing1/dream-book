//
//  DreamBookFoundation.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 Color/Font/Shape 能力，依赖系统 SF Symbols 作为基础图标
 * [OUTPUT]: 对外提供梦之书 Foundation 令牌（颜色、排版、间距、圆角、边界、阴影）与基础表面组件及阴影扩展
 * [POS]: DesignSystem/ 的基础层文件，作为后续页面复刻与组件抽象的唯一视觉真相源
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI
import UIKit

// ============================================================
// MARK: - 梦之书色彩令牌
// ============================================================

enum DreamColor {
    // ---- 中性背景 ----
    static let canvas = Color.theme(light: "#ECECEC", dark: "#121211")
    static let surface = Color.theme(light: "#F4F4F2", dark: "#1B1B1A")
    static let card = Color.theme(light: "#F8F8F7", dark: "#242422")
    static let cardStrong = Color.theme(light: "#FFFFFF", dark: "#2B2B29")
    static let stroke = Color.theme(light: "#D4D4D2", dark: "#3A3A38")

    // ---- 文本层 ----
    static let textPrimary = Color.theme(light: "#3D3A37", dark: "#F2F1EE")
    static let textSecondary = Color.theme(light: "#78726C", dark: "#B2ABA4")
    static let textTertiary = Color.theme(light: "#A6A29E", dark: "#89847E")

    // ---- 功能强调 ----
    static let premiumFill = Color.theme(light: "#DFDCD7", dark: "#3A342D")
    static let premiumText = Color.theme(light: "#6F5D4A", dark: "#DDCAB3")
    static let dockFill = Color.theme(light: "#EFEFED", dark: "#20201F")
    static let fabFill = Color.theme(light: "#3A3A3A", dark: "#ECEBE8")
    static let inverseText = Color.theme(light: "#F4F4F2", dark: "#1E1E1D")
    static let innerStroke = Color.theme(light: "#FFFFFF", dark: "#E8DED2")
    static let shadowPrimary = Color.theme(light: "#000000", dark: "#000000")
    static let shadowSecondary = Color.theme(light: "#000000", dark: "#000000")

    // ---- 图片高光色 ----
    static let photoGlowMint = Color.theme(light: "#57E7D1", dark: "#4DCDBA")
    static let photoGlowCyan = Color.theme(light: "#5EC5FF", dark: "#5BA9E8")
    static let photoGlowViolet = Color.theme(light: "#D57BE9", dark: "#BA74D5")
    static let photoGlowAmber = Color.theme(light: "#F7C56A", dark: "#DFAE5D")
}

enum DreamGradient {
    static let photoRing = AngularGradient(
        gradient: Gradient(
            colors: [
                DreamColor.photoGlowMint,
                DreamColor.photoGlowCyan,
                DreamColor.photoGlowViolet,
                DreamColor.photoGlowAmber,
                DreamColor.photoGlowMint
            ]
        ),
        center: .center
    )
}

// ============================================================
// MARK: - 梦之书排版令牌
// ============================================================

enum DreamTypography {
    static let pageTitle = Font.system(size: 22, weight: .semibold, design: .serif)
    static let sectionTitle = Font.system(size: 54, weight: .semibold, design: .serif)
    static let cardTitle = Font.system(size: 44, weight: .semibold, design: .serif)
    static let body = Font.system(size: 17, weight: .regular, design: .serif)
    static let bodyStrong = Font.system(size: 17, weight: .semibold, design: .serif)
    static let caption = Font.system(size: 13, weight: .regular, design: .default)
    static let metric = Font.system(size: 48, weight: .semibold, design: .default)
    static let metricUnit = Font.system(size: 20, weight: .semibold, design: .default)
}

struct DreamTextStyle {
    let font: Font
    let tracking: CGFloat
    let lineSpacing: CGFloat
    let monospacedDigits: Bool
}

enum DreamTextRole: String, CaseIterable {
    case navTitle
    case sectionTitle
    case cardTitle
    case body
    case bodyStrong
    case caption
    case metric
    case metricUnit

    var style: DreamTextStyle {
        switch self {
        case .navTitle:
            return DreamTextStyle(font: DreamTypography.pageTitle, tracking: 0.2, lineSpacing: 0, monospacedDigits: false)
        case .sectionTitle:
            return DreamTextStyle(font: DreamTypography.sectionTitle, tracking: 0, lineSpacing: 0, monospacedDigits: false)
        case .cardTitle:
            return DreamTextStyle(font: DreamTypography.cardTitle, tracking: 0, lineSpacing: 1, monospacedDigits: false)
        case .body:
            return DreamTextStyle(font: DreamTypography.body, tracking: 0, lineSpacing: 2, monospacedDigits: false)
        case .bodyStrong:
            return DreamTextStyle(font: DreamTypography.bodyStrong, tracking: 0.1, lineSpacing: 2, monospacedDigits: false)
        case .caption:
            return DreamTextStyle(font: DreamTypography.caption, tracking: 0.3, lineSpacing: 1, monospacedDigits: false)
        case .metric:
            return DreamTextStyle(font: DreamTypography.metric, tracking: -0.5, lineSpacing: 0, monospacedDigits: true)
        case .metricUnit:
            return DreamTextStyle(font: DreamTypography.metricUnit, tracking: 0, lineSpacing: 0, monospacedDigits: false)
        }
    }

    static let previewRoles: [DreamTextRole] = [.navTitle, .cardTitle, .body, .caption, .metric]
}

// ============================================================
// MARK: - 几何令牌
// ============================================================

enum DreamSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let s: CGFloat = 12
    static let m: CGFloat = 16
    static let l: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
}

enum DreamCornerRadius {
    static let sm: CGFloat = 16
    static let md: CGFloat = 22
    static let lg: CGFloat = 30
    static let xl: CGFloat = 38
    static let capsule: CGFloat = 999
}

enum DreamStroke {
    static let hairline: CGFloat = 0.8
    static let regular: CGFloat = 1.0
    static let prominent: CGFloat = 1.4
}

enum DreamSurfaceStyle {
    static let outerExpand: CGFloat = 1.0
    static let borderInset: CGFloat = 1.2
    static let borderWidth: CGFloat = 0.8
    static let borderOpacity: Double = 0.72
}

enum DreamFloatingMetrics {
    static let innerStrokeWidth: CGFloat = 1.0
    static let innerStrokeOpacity: Double = 0.28
    static let shadowOpacity: Double = 0.22
    static let shadowRadius: CGFloat = 18
    static let shadowYOffset: CGFloat = 10
}

enum DreamDockMetrics {
    // ---- iOS 导航比例：轨道更长，FAB 更收敛 ----
    static let railHeight: CGFloat = 70
    static let railHorizontalPadding: CGFloat = DreamSpacing.xs
    static let railVerticalPadding: CGFloat = 5
    static let railToFabSpacing: CGFloat = DreamSpacing.xs
    static let dockCornerRadius: CGFloat = 35

    static let tabItemSpacing: CGFloat = 0
    static let tabButtonHeight: CGFloat = 60
    static let tabIconSize: CGFloat = 19
    static let tabSelectionHorizontalInset: CGFloat = 0
    static let tabSelectionVerticalInset: CGFloat = 1
    static let tabSelectionCornerRadius: CGFloat = dockCornerRadius

    static let fabWidth: CGFloat = 84
    static let fabHeight: CGFloat = 70
    static let fabCornerRadius: CGFloat = dockCornerRadius
    static let fabIconSize: CGFloat = 22
}

enum DreamShadow {
    struct Layer {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    static let cardA = Layer(color: DreamColor.shadowPrimary.opacity(0.08), radius: 24, x: 0, y: 8)
    static let cardB = Layer(color: DreamColor.shadowSecondary.opacity(0.06), radius: 48, x: 0, y: 24)
    static let dockA = Layer(color: DreamColor.shadowPrimary.opacity(0.06), radius: 12, x: 0, y: 4)
    static let dockB = Layer(color: DreamColor.shadowSecondary.opacity(0.04), radius: 24, x: 0, y: 12)
}

// ============================================================
// MARK: - 文本与阴影语义扩展
// ============================================================

extension Text {
    @ViewBuilder
    func dreamRole(_ role: DreamTextRole) -> some View {
        let style = role.style
        let base = self
            .font(style.font)
            .tracking(style.tracking)
            .lineSpacing(style.lineSpacing)

        if style.monospacedDigits {
            base.monospacedDigit()
        } else {
            base
        }
    }
}

extension View {
    func dreamCardShadow() -> some View {
        self
            .shadow(
                color: DreamShadow.cardA.color,
                radius: DreamShadow.cardA.radius,
                x: DreamShadow.cardA.x,
                y: DreamShadow.cardA.y
            )
            .shadow(
                color: DreamShadow.cardB.color,
                radius: DreamShadow.cardB.radius,
                x: DreamShadow.cardB.x,
                y: DreamShadow.cardB.y
            )
    }

    func dreamDockShadow() -> some View {
        self
            .shadow(
                color: DreamShadow.dockA.color,
                radius: DreamShadow.dockA.radius,
                x: DreamShadow.dockA.x,
                y: DreamShadow.dockA.y
            )
            .shadow(
                color: DreamShadow.dockB.color,
                radius: DreamShadow.dockB.radius,
                x: DreamShadow.dockB.x,
                y: DreamShadow.dockB.y
            )
    }

    func dreamFloatingShadow() -> some View {
        self.shadow(
            color: DreamColor.shadowPrimary.opacity(DreamFloatingMetrics.shadowOpacity),
            radius: DreamFloatingMetrics.shadowRadius,
            x: 0,
            y: DreamFloatingMetrics.shadowYOffset
        )
    }
}

// ============================================================
// MARK: - 基础表面组件
// ============================================================

struct DreamSurfaceCard: View {
    let radius: CGFloat
    let fill: Color

    init(radius: CGFloat = DreamCornerRadius.lg, fill: Color = DreamColor.card) {
        self.radius = radius
        self.fill = fill
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .inset(by: -DreamSurfaceStyle.outerExpand)
                .fill(fill)

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .inset(by: DreamSurfaceStyle.borderInset)
                .strokeBorder(
                    DreamColor.stroke.opacity(DreamSurfaceStyle.borderOpacity),
                    lineWidth: DreamSurfaceStyle.borderWidth
                )
        }
    }
}

struct DreamDockPlate: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DreamDockMetrics.dockCornerRadius, style: .continuous)
                .inset(by: -DreamSurfaceStyle.outerExpand)
                .fill(DreamColor.dockFill)

            RoundedRectangle(cornerRadius: DreamDockMetrics.dockCornerRadius, style: .continuous)
                .inset(by: DreamSurfaceStyle.borderInset)
                .strokeBorder(
                    DreamColor.stroke.opacity(DreamSurfaceStyle.borderOpacity),
                    lineWidth: DreamSurfaceStyle.borderWidth
                )
        }
    }
}

struct DreamPremiumPill: View {
    let title: String

    init(title: String = "高级") {
        self.title = title
    }

    var body: some View {
        HStack(spacing: DreamSpacing.xs) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 15, weight: .semibold))
            Text(title)
                .dreamRole(.bodyStrong)
        }
        .foregroundColor(DreamColor.premiumText)
        .padding(.horizontal, DreamSpacing.m)
        .padding(.vertical, DreamSpacing.s)
        .background(
            Capsule(style: .continuous)
                .fill(DreamColor.premiumFill)
        )
    }
}

struct DreamFloatingPlusButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: DreamDockMetrics.fabCornerRadius, style: .continuous)
            .fill(DreamColor.fabFill)
            .overlay(
                RoundedRectangle(cornerRadius: DreamDockMetrics.fabCornerRadius, style: .continuous)
                    .strokeBorder(
                        DreamColor.innerStroke.opacity(DreamFloatingMetrics.innerStrokeOpacity),
                        lineWidth: DreamFloatingMetrics.innerStrokeWidth
                    )
            )
            .overlay(
                Image(systemName: "plus")
                    .font(.system(size: DreamDockMetrics.fabIconSize, weight: .regular))
                    .foregroundColor(DreamColor.inverseText)
            )
            .dreamFloatingShadow()
    }
}

struct DreamNeonPhotoFrame<Content: View>: View {
    let radius: CGFloat
    private let content: Content

    init(radius: CGFloat = DreamCornerRadius.md, @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.content = content()
    }

    var body: some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(DreamGradient.photoRing, lineWidth: 2)
            )
            .shadow(color: DreamColor.photoGlowMint.opacity(0.45), radius: 14, x: 0, y: 8)
            .shadow(color: DreamColor.photoGlowViolet.opacity(0.30), radius: 24, x: 0, y: 16)
    }
}

// ============================================================
// MARK: - Hex 转色
// ============================================================

private extension Color {
    static func theme(light: String, dark: String) -> Color {
        Color(
            uiColor: UIColor { traits in
                let selected = traits.userInterfaceStyle == .dark ? dark : light
                return UIColor(hex: selected)
            }
        )
    }
}

private extension UIColor {
    convenience init(hex: String, alpha: Double = 1.0) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleaned = cleaned.replacingOccurrences(of: "#", with: "")

        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let r, g, b: UInt64
        switch cleaned.count {
        case 3:
            r = ((value >> 8) & 0xF) * 17
            g = ((value >> 4) & 0xF) * 17
            b = (value & 0xF) * 17
        case 6:
            r = (value >> 16) & 0xFF
            g = (value >> 8) & 0xFF
            b = value & 0xFF
        default:
            r = 0
            g = 0
            b = 0
        }

        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: alpha
        )
    }
}
