//
//  DesignSystemProtocol.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 Color 与 UIKit 的 UIColor 动态主题能力
 * [OUTPUT]: 对外提供 DS 语义色值常量（亮/暗双模式），作为设计系统唯一色值真相源
 * [POS]: DesignSystem/ 的协议层文件，被 DesignTokens.swift 消费并驱动全局主题一致性
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI
import UIKit

// ============================================================
// MARK: - DreamBook 语义色值协议层
// ============================================================

enum DS {
    // ---- 背景层 ----
    static let backgroundPrimary = Color.theme(light: "#F6F8FD", dark: "#0A0F1E")
    static let backgroundSurface = Color.theme(light: "#EEF2FB", dark: "#141B30")
    static let backgroundCard = Color.theme(light: "#FFFFFF", dark: "#1A223A")
    static let stroke = Color.theme(light: "#D5DDEE", dark: "#2E3A5D")

    // ---- 文本层 ----
    static let textPrimary = Color.theme(light: "#151B2E", dark: "#F3F5FF")
    static let textSecondary = Color.theme(light: "#4E5A7C", dark: "#C2C8E1")
    static let textTertiary = Color.theme(light: "#7C88A7", dark: "#8A93B8")

    // ---- 强调层 ----
    static let accentInk = Color.theme(light: "#2D5BEE", dark: "#95BEFF")
    static let accentGlowA = Color.theme(light: "#5A7CF8", dark: "#6AABFF")
    static let accentGlowB = Color.theme(light: "#36B8DF", dark: "#79E1FF")
    static let accentGlowC = Color.theme(light: "#E7A46C", dark: "#F8C89A")

    // ---- 情绪层 ----
    static let moodCalm = Color.theme(light: "#3E73D9", dark: "#74A5FF")
    static let moodMystic = Color.theme(light: "#2EA9B9", dark: "#6ED4E1")
    static let moodWarm = Color.theme(light: "#CC7F4A", dark: "#F2AE7D")
    static let moodAlert = Color.theme(light: "#D65F66", dark: "#FF7E7E")

    // ---- 语义状态 ----
    static let success = Color.theme(light: "#2F9D72", dark: "#66C79A")
    static let warning = Color.theme(light: "#D8943E", dark: "#F2BC78")
    static let danger = Color.theme(light: "#D66167", dark: "#F58B8B")

    // ---- 材质辅助 ----
    static let innerStroke = Color.theme(light: "#FFFFFF", dark: "#DCE6FF")
    static let shadowPrimary = Color.theme(light: "#000000", dark: "#000000")
    static let shadowSecondary = Color.theme(light: "#000000", dark: "#000000")
}

// ============================================================
// MARK: - 亮暗主题桥接
// ============================================================

private extension Color {
    static func theme(light: String, dark: String) -> Color {
        Color(
            uiColor: UIColor { traits in
                let isDark = traits.userInterfaceStyle == .dark
                return UIColor(hex: isDark ? dark : light)
            }
        )
    }
}

private extension UIColor {
    convenience init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r, g, b, a: UInt64

        switch hexSanitized.count {
        case 3:
            (r, g, b, a) = (
                ((rgb >> 8) & 0xF) * 17,
                ((rgb >> 4) & 0xF) * 17,
                (rgb & 0xF) * 17,
                255
            )
        case 4:
            (r, g, b, a) = (
                ((rgb >> 12) & 0xF) * 17,
                ((rgb >> 8) & 0xF) * 17,
                ((rgb >> 4) & 0xF) * 17,
                (rgb & 0xF) * 17
            )
        case 6:
            (r, g, b, a) = (
                (rgb >> 16) & 0xFF,
                (rgb >> 8) & 0xFF,
                rgb & 0xFF,
                255
            )
        case 8:
            (r, g, b, a) = (
                (rgb >> 24) & 0xFF,
                (rgb >> 16) & 0xFF,
                (rgb >> 8) & 0xFF,
                rgb & 0xFF
            )
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(Double(a) / 255 * alpha)
        )
    }
}
