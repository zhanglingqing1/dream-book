//
//  BellyBookFoundation.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 Color/Font/Shape 能力，依赖系统 SF Symbols 作为基础图标
 * [OUTPUT]: 对外提供胃之书 Foundation 令牌（颜色、排版、间距、圆角、边界、阴影）与基础表面组件及阴影扩展
 * [POS]: DesignSystem/ 的基础层文件，作为后续页面复刻与组件抽象的唯一视觉真相源
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI
import UIKit

// ============================================================
// MARK: - 胃之书色彩令牌
// ============================================================

enum BBColor {
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

enum BBGradient {
    static let photoRing = AngularGradient(
        gradient: Gradient(
            colors: [
                BBColor.photoGlowMint,
                BBColor.photoGlowCyan,
                BBColor.photoGlowViolet,
                BBColor.photoGlowAmber,
                BBColor.photoGlowMint
            ]
        ),
        center: .center
    )
}

// ============================================================
// MARK: - 胃之书排版令牌
// ============================================================

enum BBTypography {
    static let pageTitle = Font.system(size: 22, weight: .semibold, design: .serif)
    static let sectionTitle = Font.system(size: 54, weight: .semibold, design: .serif)
    static let cardTitle = Font.system(size: 44, weight: .semibold, design: .serif)
    static let body = Font.system(size: 17, weight: .regular, design: .serif)
    static let bodyStrong = Font.system(size: 17, weight: .semibold, design: .serif)
    static let caption = Font.system(size: 13, weight: .regular, design: .default)
    static let metric = Font.system(size: 48, weight: .semibold, design: .default)
    static let metricUnit = Font.system(size: 20, weight: .semibold, design: .default)
}

struct BBTextStyle {
    let font: Font
    let tracking: CGFloat
    let lineSpacing: CGFloat
    let monospacedDigits: Bool
}

enum BBTextRole: String, CaseIterable {
    case navTitle
    case sectionTitle
    case cardTitle
    case body
    case bodyStrong
    case caption
    case metric
    case metricUnit

    var style: BBTextStyle {
        switch self {
        case .navTitle:
            return BBTextStyle(font: BBTypography.pageTitle, tracking: 0.2, lineSpacing: 0, monospacedDigits: false)
        case .sectionTitle:
            return BBTextStyle(font: BBTypography.sectionTitle, tracking: 0, lineSpacing: 0, monospacedDigits: false)
        case .cardTitle:
            return BBTextStyle(font: BBTypography.cardTitle, tracking: 0, lineSpacing: 1, monospacedDigits: false)
        case .body:
            return BBTextStyle(font: BBTypography.body, tracking: 0, lineSpacing: 2, monospacedDigits: false)
        case .bodyStrong:
            return BBTextStyle(font: BBTypography.bodyStrong, tracking: 0.1, lineSpacing: 2, monospacedDigits: false)
        case .caption:
            return BBTextStyle(font: BBTypography.caption, tracking: 0.3, lineSpacing: 1, monospacedDigits: false)
        case .metric:
            return BBTextStyle(font: BBTypography.metric, tracking: -0.5, lineSpacing: 0, monospacedDigits: true)
        case .metricUnit:
            return BBTextStyle(font: BBTypography.metricUnit, tracking: 0, lineSpacing: 0, monospacedDigits: false)
        }
    }

    static let previewRoles: [BBTextRole] = [.navTitle, .cardTitle, .body, .caption, .metric]
}

// ============================================================
// MARK: - 几何令牌
// ============================================================

enum BBSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let s: CGFloat = 12
    static let m: CGFloat = 16
    static let l: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
}

enum BBCornerRadius {
    static let sm: CGFloat = 16
    static let md: CGFloat = 22
    static let lg: CGFloat = 30
    static let xl: CGFloat = 38
    static let capsule: CGFloat = 999
}

enum BBStroke {
    static let hairline: CGFloat = 0.8
    static let regular: CGFloat = 1.0
    static let prominent: CGFloat = 1.4
}

enum BBSurfaceStyle {
    static let outerExpand: CGFloat = 1.0
    static let borderInset: CGFloat = 1.2
    static let borderWidth: CGFloat = 0.8
    static let borderOpacity: Double = 0.72
}

enum BBFloatingMetrics {
    static let innerStrokeWidth: CGFloat = 1.0
    static let innerStrokeOpacity: Double = 0.28
    static let shadowOpacity: Double = 0.22
    static let shadowRadius: CGFloat = 18
    static let shadowYOffset: CGFloat = 10
}

enum BBDockMetrics {
    // ---- iOS 导航比例：轨道更长，FAB 更收敛 ----
    static let railHeight: CGFloat = 70
    static let railHorizontalPadding: CGFloat = BBSpacing.xs
    static let railVerticalPadding: CGFloat = 5
    static let railToFabSpacing: CGFloat = BBSpacing.xs
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

enum BBShadow {
    struct Layer {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    static let cardA = Layer(color: BBColor.shadowPrimary.opacity(0.08), radius: 24, x: 0, y: 8)
    static let cardB = Layer(color: BBColor.shadowSecondary.opacity(0.06), radius: 48, x: 0, y: 24)
    static let dockA = Layer(color: BBColor.shadowPrimary.opacity(0.06), radius: 12, x: 0, y: 4)
    static let dockB = Layer(color: BBColor.shadowSecondary.opacity(0.04), radius: 24, x: 0, y: 12)
}

// ============================================================
// MARK: - 文本与阴影语义扩展
// ============================================================

extension Text {
    @ViewBuilder
    func bbRole(_ role: BBTextRole) -> some View {
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
    func bbCardShadow() -> some View {
        self
            .shadow(
                color: BBShadow.cardA.color,
                radius: BBShadow.cardA.radius,
                x: BBShadow.cardA.x,
                y: BBShadow.cardA.y
            )
            .shadow(
                color: BBShadow.cardB.color,
                radius: BBShadow.cardB.radius,
                x: BBShadow.cardB.x,
                y: BBShadow.cardB.y
            )
    }

    func bbDockShadow() -> some View {
        self
            .shadow(
                color: BBShadow.dockA.color,
                radius: BBShadow.dockA.radius,
                x: BBShadow.dockA.x,
                y: BBShadow.dockA.y
            )
            .shadow(
                color: BBShadow.dockB.color,
                radius: BBShadow.dockB.radius,
                x: BBShadow.dockB.x,
                y: BBShadow.dockB.y
            )
    }

    func bbFloatingShadow() -> some View {
        self.shadow(
            color: BBColor.shadowPrimary.opacity(BBFloatingMetrics.shadowOpacity),
            radius: BBFloatingMetrics.shadowRadius,
            x: 0,
            y: BBFloatingMetrics.shadowYOffset
        )
    }
}

// ============================================================
// MARK: - 基础表面组件
// ============================================================

struct BBSurfaceCard: View {
    let radius: CGFloat
    let fill: Color

    init(radius: CGFloat = BBCornerRadius.lg, fill: Color = BBColor.card) {
        self.radius = radius
        self.fill = fill
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .inset(by: -BBSurfaceStyle.outerExpand)
                .fill(fill)

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .inset(by: BBSurfaceStyle.borderInset)
                .strokeBorder(
                    BBColor.stroke.opacity(BBSurfaceStyle.borderOpacity),
                    lineWidth: BBSurfaceStyle.borderWidth
                )
        }
    }
}

struct BBDockPlate: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: BBDockMetrics.dockCornerRadius, style: .continuous)
                .inset(by: -BBSurfaceStyle.outerExpand)
                .fill(BBColor.dockFill)

            RoundedRectangle(cornerRadius: BBDockMetrics.dockCornerRadius, style: .continuous)
                .inset(by: BBSurfaceStyle.borderInset)
                .strokeBorder(
                    BBColor.stroke.opacity(BBSurfaceStyle.borderOpacity),
                    lineWidth: BBSurfaceStyle.borderWidth
                )
        }
    }
}

struct BBPremiumPill: View {
    let title: String

    init(title: String = "高级") {
        self.title = title
    }

    var body: some View {
        HStack(spacing: BBSpacing.xs) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 15, weight: .semibold))
            Text(title)
                .bbRole(.bodyStrong)
        }
        .foregroundColor(BBColor.premiumText)
        .padding(.horizontal, BBSpacing.m)
        .padding(.vertical, BBSpacing.s)
        .background(
            Capsule(style: .continuous)
                .fill(BBColor.premiumFill)
        )
    }
}

struct BBFloatingPlusButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: BBDockMetrics.fabCornerRadius, style: .continuous)
            .fill(BBColor.fabFill)
            .overlay(
                RoundedRectangle(cornerRadius: BBDockMetrics.fabCornerRadius, style: .continuous)
                    .strokeBorder(
                        BBColor.innerStroke.opacity(BBFloatingMetrics.innerStrokeOpacity),
                        lineWidth: BBFloatingMetrics.innerStrokeWidth
                    )
            )
            .overlay(
                Image(systemName: "plus")
                    .font(.system(size: BBDockMetrics.fabIconSize, weight: .regular))
                    .foregroundColor(BBColor.inverseText)
            )
            .bbFloatingShadow()
    }
}

struct BBNeonPhotoFrame<Content: View>: View {
    let radius: CGFloat
    private let content: Content

    init(radius: CGFloat = BBCornerRadius.md, @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.content = content()
    }

    var body: some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(BBGradient.photoRing, lineWidth: 2)
            )
            .shadow(color: BBColor.photoGlowMint.opacity(0.45), radius: 14, x: 0, y: 8)
            .shadow(color: BBColor.photoGlowViolet.opacity(0.30), radius: 24, x: 0, y: 16)
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
