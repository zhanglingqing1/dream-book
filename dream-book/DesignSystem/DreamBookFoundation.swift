//
//  DreamBookFoundation.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 Color/Font/Shape/动画能力，依赖系统 SF Symbols 作为基础图标
 * [OUTPUT]: 对外提供梦之书 Foundation 令牌（颜色、排版、间距、圆角、边界、阴影）与基础表面组件及处理态容器组件
 * [POS]: DesignSystem/ 的基础层文件，作为后续页面复刻与解梦/生成态组件抽象的唯一视觉真相源
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
    static let detailTime = Font.system(size: 30, weight: .semibold, design: .default)
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
    case detailTime
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
        case .detailTime:
            return DreamTextStyle(font: DreamTypography.detailTime, tracking: -0.2, lineSpacing: 0, monospacedDigits: true)
        case .metric:
            return DreamTextStyle(font: DreamTypography.metric, tracking: -0.5, lineSpacing: 0, monospacedDigits: true)
        case .metricUnit:
            return DreamTextStyle(font: DreamTypography.metricUnit, tracking: 0, lineSpacing: 0, monospacedDigits: false)
        }
    }

    static let previewRoles: [DreamTextRole] = [.navTitle, .cardTitle, .body, .caption, .metric]

    // ---- 排版语义：帮助组件与预览页在同一语言下对齐 ----
    var usageTitle: String {
        switch self {
        case .navTitle:
            return "页面/区块标题"
        case .sectionTitle:
            return "超大章节标题"
        case .cardTitle:
            return "主卡片标题"
        case .body:
            return "正文内容"
        case .bodyStrong:
            return "强调正文"
        case .caption:
            return "标签/辅助信息"
        case .detailTime:
            return "详情主时间"
        case .metric:
            return "单值指标"
        case .metricUnit:
            return "指标单位"
        }
    }

    var usageNotes: String {
        switch self {
        case .navTitle:
            return "用于页面名、梦境段标题；不要与正文混排在同一行。"
        case .sectionTitle:
            return "只用于少数沉浸式封面，不进入常规列表/详情正文。"
        case .cardTitle:
            return "用于主视觉卡首屏标题；优先单行，必要时允许两行。"
        case .body:
            return "长文本默认角色，保持可读行距；适合叙事与原文。"
        case .bodyStrong:
            return "用于关键值、按钮文案、行内重点，不替代标题层级。"
        case .caption:
            return "用于时间标签、状态标签、次要说明；避免承载主信息。"
        case .detailTime:
            return "详情页时间专用，同一行中的时分/上午下午必须同级。"
        case .metric:
            return "用于单值冲击型数字（如评分/热量），避免用于列表行文。"
        case .metricUnit:
            return "仅跟随 metric 使用，不单独承担信息层级。"
        }
    }
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

// ============================================================
// MARK: - 版式规范令牌（边距 / 内边距 / 节奏）
// ============================================================

enum DreamLayoutInsets {
    // ---- 页面外边距 ----
    static let page = EdgeInsets(
        top: DreamSpacing.s,
        leading: DreamSpacing.l,
        bottom: DreamSpacing.xxxl,
        trailing: DreamSpacing.l
    )

    // ---- Sheet 内容区 ----
    static let sheetContent = EdgeInsets(
        top: DreamSpacing.l,
        leading: DreamSpacing.l,
        bottom: DreamSpacing.xxl,
        trailing: DreamSpacing.l
    )

    // ---- 标准卡片内边距 ----
    static let card = EdgeInsets(
        top: DreamSpacing.l,
        leading: DreamSpacing.l,
        bottom: DreamSpacing.l,
        trailing: DreamSpacing.l
    )

    // ---- 紧凑卡片 / 行项目 ----
    static let compactCard = EdgeInsets(
        top: DreamSpacing.m,
        leading: DreamSpacing.m,
        bottom: DreamSpacing.m,
        trailing: DreamSpacing.m
    )

    // ---- 胶囊按钮 / 状态标签 ----
    static let pill = EdgeInsets(
        top: DreamSpacing.s,
        leading: DreamSpacing.m,
        bottom: DreamSpacing.s,
        trailing: DreamSpacing.m
    )
}

enum DreamLayoutRhythm {
    // ---- 页面纵向节奏 ----
    static let pageSectionGap: CGFloat = DreamSpacing.xxl
    static let majorBlockGap: CGFloat = DreamSpacing.xl

    // ---- 区块内部节奏 ----
    static let groupGap: CGFloat = DreamSpacing.m
    static let rowGap: CGFloat = DreamSpacing.s
    static let tightGap: CGFloat = DreamSpacing.xs

    // ---- 分割线前后呼吸 ----
    static let dividerTopGap: CGFloat = DreamSpacing.s
    static let dividerBottomGap: CGFloat = DreamSpacing.s
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

enum DreamProcessingVisualMetrics {
    static let borderLineWidth: CGFloat = 2.0
    static let borderFlowDuration: Double = 2.8
    static let glowSoftRadius: CGFloat = 12
    static let glowHardRadius: CGFloat = 22
    static let glowSoftOpacity: Double = 0.40
    static let glowHardOpacity: Double = 0.24

    static let shimmerSweepDuration: Double = 1.35
    static let shimmerAngle: Double = -18
    static let shimmerBandRatio: CGFloat = 0.32
    static let shimmerBandMinimum: CGFloat = 92
    static let shimmerSurfaceOpacity: Double = 0.20
    static let shimmerBandOpacity: Double = 0.92

    static let reducedPulseDuration: Double = 2.0
    static let stateTransitionDuration: Double = 0.22
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
    let isProcessing: Bool
    let showPlaceholder: Bool
    private let content: Content
    private let placeholder: AnyView

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var borderPhase: Double = 0
    @State private var shimmerOffset: CGFloat = -1.1
    @State private var pulseOpacity: Double = 0.62

    init(
        radius: CGFloat = DreamCornerRadius.md,
        isProcessing: Bool = false,
        showPlaceholder: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.radius = radius
        self.isProcessing = isProcessing
        self.showPlaceholder = showPlaceholder
        self.content = content()
        self.placeholder = AnyView(DreamNeonDefaultPlaceholder())
    }

    init<Placeholder: View>(
        radius: CGFloat = DreamCornerRadius.md,
        isProcessing: Bool = false,
        showPlaceholder: Bool = false,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder content: () -> Content
    ) {
        self.radius = radius
        self.isProcessing = isProcessing
        self.showPlaceholder = showPlaceholder
        self.content = content()
        self.placeholder = AnyView(placeholder())
    }

    var body: some View {
        let frameShape = RoundedRectangle(cornerRadius: radius, style: .continuous)

        ZStack {
            if showPlaceholder {
                placeholder
            } else {
                content
            }

            if isProcessing {
                processingShimmer
                    .transition(.opacity)
            }
        }
        .clipShape(frameShape)
        .overlay {
            // ---- 常态边界：处理完成后只保留中性描边 ----
            frameShape
                .stroke(DreamColor.stroke.opacity(isProcessing ? 0.34 : 0.62), lineWidth: DreamStroke.regular)
        }
        .overlay {
            if isProcessing {
                processingBorder(frameShape: frameShape)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: DreamProcessingVisualMetrics.stateTransitionDuration), value: isProcessing)
        .animation(.easeInOut(duration: DreamProcessingVisualMetrics.stateTransitionDuration), value: showPlaceholder)
        .onAppear {
            restartProcessingAnimation()
        }
        .onChange(of: isProcessing) { _, _ in
            restartProcessingAnimation()
        }
        .onChange(of: reduceMotion) { _, _ in
            restartProcessingAnimation()
        }
    }

    @ViewBuilder
    private func processingBorder(frameShape: RoundedRectangle) -> some View {
        frameShape
            .overlay(
                frameShape
                    .stroke(
                        AngularGradient(
                            colors: [
                                DreamColor.photoGlowMint,
                                DreamColor.photoGlowCyan,
                                DreamColor.photoGlowViolet,
                                DreamColor.photoGlowAmber,
                                DreamColor.photoGlowMint
                            ],
                            center: .center,
                            angle: .degrees(borderPhase)
                        ),
                        lineWidth: DreamProcessingVisualMetrics.borderLineWidth
                    )
            )
            .overlay(
                frameShape
                    .stroke(
                        AngularGradient(
                            colors: [
                                DreamColor.photoGlowMint.opacity(0.70),
                                DreamColor.photoGlowCyan.opacity(0.65),
                                DreamColor.photoGlowViolet.opacity(0.68),
                                DreamColor.photoGlowAmber.opacity(0.65),
                                DreamColor.photoGlowMint.opacity(0.70)
                            ],
                            center: .center,
                            angle: .degrees(borderPhase)
                        ),
                        lineWidth: DreamProcessingVisualMetrics.borderLineWidth + 0.8
                    )
                    .blur(radius: 2.8)
                    .opacity(reduceMotion ? pulseOpacity : 0.64)
            )
            .shadow(
                color: DreamColor.photoGlowMint.opacity(reduceMotion ? pulseOpacity : DreamProcessingVisualMetrics.glowSoftOpacity),
                radius: DreamProcessingVisualMetrics.glowSoftRadius,
                x: 0,
                y: 6
            )
            .shadow(
                color: DreamColor.photoGlowViolet.opacity(reduceMotion ? max(0.12, pulseOpacity - 0.20) : DreamProcessingVisualMetrics.glowHardOpacity),
                radius: DreamProcessingVisualMetrics.glowHardRadius,
                x: 0,
                y: 14
            )
    }

    private var processingShimmer: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let shimmerBand = max(width * DreamProcessingVisualMetrics.shimmerBandRatio, DreamProcessingVisualMetrics.shimmerBandMinimum)

            ZStack {
                // ---- 底层柔光：持续提供“正在处理”的材质反馈 ----
                LinearGradient(
                    colors: [
                        .clear,
                        DreamColor.photoGlowCyan.opacity(0.14),
                        DreamColor.photoGlowViolet.opacity(0.10),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(reduceMotion ? pulseOpacity * 0.55 : DreamProcessingVisualMetrics.shimmerSurfaceOpacity)

                // ---- 主扫光带：斜向移动，模拟反射光掠过 ----
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.00),
                        .init(color: DreamColor.photoGlowMint.opacity(0.30), location: 0.28),
                        .init(color: DreamColor.inverseText.opacity(0.55), location: 0.50),
                        .init(color: DreamColor.photoGlowViolet.opacity(0.28), location: 0.72),
                        .init(color: .clear, location: 1.00)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: shimmerBand, height: max(height * 1.9, 1))
                .rotationEffect(.degrees(DreamProcessingVisualMetrics.shimmerAngle))
                .offset(x: reduceMotion ? 0 : shimmerOffset * width)
                .opacity(reduceMotion ? pulseOpacity : DreamProcessingVisualMetrics.shimmerBandOpacity)
            }
            .blendMode(.screen)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .allowsHitTesting(false)
    }

    private func restartProcessingAnimation() {
        borderPhase = 0
        shimmerOffset = -1.1
        pulseOpacity = 0.62

        guard isProcessing else { return }

        if reduceMotion {
            withAnimation(
                .easeInOut(duration: DreamProcessingVisualMetrics.reducedPulseDuration)
                    .repeatForever(autoreverses: true)
            ) {
                pulseOpacity = 0.88
            }
            return
        }

        withAnimation(
            .linear(duration: DreamProcessingVisualMetrics.borderFlowDuration)
                .repeatForever(autoreverses: false)
        ) {
            borderPhase = 360
        }

        withAnimation(
            .linear(duration: DreamProcessingVisualMetrics.shimmerSweepDuration)
                .repeatForever(autoreverses: false)
        ) {
            shimmerOffset = 1.1
        }
    }
}

private struct DreamNeonDefaultPlaceholder: View {
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

            VStack(alignment: .leading, spacing: DreamSpacing.s) {
                RoundedRectangle(cornerRadius: DreamCornerRadius.sm, style: .continuous)
                    .fill(DreamColor.textTertiary.opacity(0.20))
                    .frame(height: 18)

                RoundedRectangle(cornerRadius: DreamCornerRadius.sm, style: .continuous)
                    .fill(DreamColor.textTertiary.opacity(0.14))
                    .frame(height: 12)

                Spacer(minLength: 0)

                RoundedRectangle(cornerRadius: DreamCornerRadius.sm, style: .continuous)
                    .fill(DreamColor.textTertiary.opacity(0.18))
                    .frame(width: 120, height: 12)
            }
            .padding(DreamSpacing.l)
        }
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
