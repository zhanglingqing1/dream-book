//
//  DreamCardComponents.swift
//  dream-book
//
//  Created by Codex on 2026/2/18.
//

/**
 * [INPUT]: 依赖 SwiftUI 布局与交互能力，依赖 DreamBookFoundation 的视觉令牌与 DreamCardKit 的数据契约
 * [OUTPUT]: 对外提供梦境卡片列表/详情的核心组件（Hero 叠层、时间轴列表、Page Sheet 详情与底部操作条）
 * [POS]: DesignSystem/ 的梦境卡片组件层，承接页面模板并为后续业务页复用提供稳定接口
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI
import UIKit

// ============================================================
// MARK: - 列表模板
// ============================================================

struct DreamTimelineCardListView: View {
    let items: [DreamCardSnapshot]
    let onSelect: (DreamCardSnapshot) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: DreamCardLayout.timelineRowSpacing) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    DreamTimelineCardRow(index: index, item: item) {
                        onSelect(item)
                    }
                }
            }
            .padding(DreamCardLayout.listContentInsets)
        }
        .background(DreamColor.canvas)
    }
}

private struct DreamTimelineCardRow: View {
    let index: Int
    let item: DreamCardSnapshot
    let onTap: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: DreamCardLayout.timelineRowContentSpacing) {
            DreamTimelineDateColumn(date: item.recordedAt)
                .frame(width: DreamCardLayout.timelineColumnWidth)
                .padding(.top, DreamCardLayout.timelineTopPadding)

            VStack(alignment: .leading, spacing: 0) {
                DreamTimelineCardStage(item: item, onSelect: onTap)

                // ---- 时间标签：卡片外部下方独立呈现 ----
                Text(DreamCardFormatters.clockTime(from: item.recordedAt))
                    .dreamRole(.caption)
                    .foregroundColor(DreamColor.textSecondary)
                    .padding(.top, DreamCardLayout.summaryTimeTopPadding)
                    .onTapGesture(perform: onTap)
            }
        }
        .contentShape(Rectangle())
        .padding(.bottom, DreamCardLayout.timelineDebugRowBottomMargin)
        .accessibilityIdentifier("dream.list.row.\(index)")
    }
}

private enum DreamTimelineTopLayer {
    case insight
    case media
}

private struct DreamTimelineCardStage: View {
    let item: DreamCardSnapshot
    let onSelect: () -> Void

    @State private var topLayer: DreamTimelineTopLayer = .insight
    @GestureState private var swipeTranslation: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let hasMedia = item.hasHeroMedia
            let stageWidth = max(proxy.size.width, 1)
            let clampedSwipeProgress = max(-1, min(1, swipeTranslation / (stageWidth * 0.45)))
            let mediaIsTop = hasMedia && topLayer == .media
            let insightIsTop = !hasMedia || topLayer == .insight
            // ---- 中线驱动定位：先对齐整行屏幕中点，再映射到 Hero 合并簇 ----
            let stageCenterX = stageWidth * 0.5
            let clusterCenterX = stageCenterX + DreamCardLayout.timelineHeroStageToScreenCenterCorrectionX
            let mediaBaseOffsetX = clusterCenterX
                + DreamCardLayout.timelineHeroMediaCenterOffsetX
                - (DreamCardLayout.heroImageWidth * 0.5)
            let insightBaseOffsetX = clusterCenterX
                + (hasMedia ? DreamCardLayout.timelineHeroInsightCenterOffsetX : 0)
                - (DreamCardLayout.insightCardWidth * 0.5)
            let insightBaseOffsetY = hasMedia
                ? DreamCardLayout.insightCardOffsetY + DreamCardLayout.timelineFloatingInsightDropY
                : DreamCardLayout.insightCardOffsetY + DreamCardLayout.timelineFloatingInsightDropYNoMedia
            let mediaDepthOffsetX = mediaIsTop ? 0 : DreamCardLayout.timelineLayerDepthOffsetX
            let mediaDepthOffsetY = mediaIsTop ? 0 : DreamCardLayout.timelineLayerDepthOffsetY
            let insightDepthOffsetX = insightIsTop ? 0 : -DreamCardLayout.timelineLayerDepthOffsetX
            let insightDepthOffsetY = insightIsTop ? 0 : DreamCardLayout.timelineLayerDepthOffsetY
            let mediaParallaxX = clampedSwipeProgress * DreamCardLayout.timelineLayerParallaxRange * (mediaIsTop ? 0.85 : 0.5)
            let insightParallaxX = clampedSwipeProgress * DreamCardLayout.timelineLayerParallaxRange * (insightIsTop ? -0.75 : -0.45)

            ZStack(alignment: .topLeading) {
                if hasMedia {
                    DreamHeroMediaCard(media: item.heroMedia)
                        .frame(width: DreamCardLayout.heroImageWidth, height: DreamCardLayout.heroImageHeight)
                        .rotationEffect(
                            .degrees(
                                mediaIsTop
                                    ? DreamCardLayout.heroImageRotation
                                    : DreamCardLayout.heroImageRotation - 1.2
                            )
                        )
                        .scaleEffect(mediaIsTop ? 1 : DreamCardLayout.timelineLayerBackScale)
                        .opacity(mediaIsTop ? 1 : DreamCardLayout.timelineLayerBackOpacity)
                        .offset(
                            x: mediaBaseOffsetX + mediaDepthOffsetX + mediaParallaxX,
                            y: DreamCardLayout.heroImageOffsetY + mediaDepthOffsetY
                        )
                        .zIndex(mediaIsTop ? 2.6 : 1.2)
                        .onTapGesture {
                            bringToFront(.media)
                        }
                }

                DreamSummaryPanel(item: item)
                    .offset(y: DreamCardLayout.heroHeight - DreamCardLayout.summaryCardTopPadding)
                    .zIndex(0.2)
                    .onTapGesture(perform: onSelect)

                DreamInsightOverlayCard(insight: item.insight)
                    .frame(width: DreamCardLayout.insightCardWidth)
                    .rotationEffect(
                        .degrees(
                            insightIsTop
                                ? DreamCardLayout.insightCardRotation
                                : DreamCardLayout.insightCardRotation - 1.1
                        )
                    )
                    .scaleEffect(insightIsTop ? 1 : DreamCardLayout.timelineLayerBackScale)
                    .opacity(insightIsTop ? 1 : DreamCardLayout.timelineLayerBackOpacity)
                    .offset(
                        x: insightBaseOffsetX + insightDepthOffsetX + insightParallaxX,
                        y: insightBaseOffsetY + insightDepthOffsetY
                    )
                    .dreamFloatingShadow()
                    .zIndex(insightIsTop ? 2.8 : 1.4)
                    .onTapGesture {
                        bringToFront(.insight)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: DreamCardLayout.timelineStageHeight)
        .simultaneousGesture(
            DragGesture(minimumDistance: 14, coordinateSpace: .local)
                .updating($swipeTranslation) { value, state, _ in
                    guard item.hasHeroMedia else { return }
                    guard abs(value.translation.width) > abs(value.translation.height) else { return }
                    state = value.translation.width
                }
                .onEnded { value in
                    guard item.hasHeroMedia else { return }
                    let translation = value.translation
                    guard abs(translation.width) > abs(translation.height) else { return }
                    guard abs(translation.width) >= DreamCardLayout.timelineLayerSwitchSwipeThreshold else { return }
                    toggleTopLayer()
                }
        )
        .animation(layerSwitchAnimation, value: topLayer)
    }

    private func bringToFront(_ layer: DreamTimelineTopLayer) {
        withAnimation(layerSwitchAnimation) {
            topLayer = layer
        }
    }

    private func toggleTopLayer() {
        withAnimation(layerSwitchAnimation) {
            topLayer = (topLayer == .insight) ? .media : .insight
        }
    }

    private var layerSwitchAnimation: Animation {
        .spring(
            response: DreamCardLayout.timelineLayerSwitchAnimationResponse,
            dampingFraction: DreamCardLayout.timelineLayerSwitchAnimationDamping
        )
    }
}

private struct DreamTimelineDateColumn: View {
    let date: Date

    var body: some View {
        // ---- 日号 + 月号上标：减重并形成更精致的主次错落 ----
        HStack(alignment: .lastTextBaseline, spacing: DreamCardLayout.timelineDatePairSpacing) {
            Text(DreamCardFormatters.dayNumber(from: date))
                .font(.system(size: DreamCardLayout.timelineDayFontSize, weight: .medium, design: .default))
                .tracking(-0.2)
                .monospacedDigit()
                .foregroundColor(DreamColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.86)

            Text(DreamCardFormatters.monthNumber(from: date))
                .font(.system(size: DreamCardLayout.timelineMonthFontSize, weight: .regular, design: .default))
                .tracking(0.1)
                .baselineOffset(DreamCardLayout.timelineMonthBaselineOffset)
                .foregroundColor(DreamColor.textSecondary)
                .lineLimit(1)
        }
    }
}

private struct DreamSummaryPanel: View {
    let item: DreamCardSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: DreamCardLayout.summaryPanelGroupSpacing) {
            // ---- 标题区：按用户输入原文展示，不做拼接干预 ----
            Text(item.dreamTitle)
                .dreamRole(.navTitle)
                .foregroundColor(DreamColor.textPrimary)
                .lineLimit(DreamCardLayout.summaryTitleLineLimit)

            // ---- 正文区：按用户输入原文展示，不注入 emoji 或回退文案 ----
            Text(item.dreamSummary)
                .font(.system(size: 15, weight: .regular, design: .serif))
                .tracking(0.05)
                .foregroundColor(DreamColor.textSecondary.opacity(0.88))
                .lineLimit(DreamCardLayout.summaryBodyLineLimit)
                .lineSpacing(DreamCardLayout.summaryBodyLineSpacing)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, DreamCardLayout.summaryPanelOverlayClearance)
        .frame(minHeight: DreamCardLayout.summaryPanelMinHeight, alignment: .topLeading)
        .padding(DreamCardLayout.summaryPanelInsets)
        .background(DreamSurfaceCard(radius: DreamCornerRadius.lg, fill: DreamColor.cardStrong))
        .dreamCardShadow()
    }
}

// ============================================================
// MARK: - Hero 叠层
// ============================================================

struct DreamCardHeroStackView: View {
    let item: DreamCardSnapshot

    var body: some View {
        ZStack(alignment: .topLeading) {
            if item.hasHeroMedia {
                DreamHeroMediaCard(media: item.heroMedia)
                    .frame(width: DreamCardLayout.heroImageWidth, height: DreamCardLayout.heroImageHeight)
                    .rotationEffect(.degrees(DreamCardLayout.heroImageRotation))
                    .offset(y: DreamCardLayout.heroImageOffsetY)
            }

            DreamInsightOverlayCard(insight: item.insight)
                .frame(width: DreamCardLayout.insightCardWidth)
                .rotationEffect(.degrees(DreamCardLayout.insightCardRotation))
                .offset(
                    x: item.hasHeroMedia ? DreamCardLayout.insightCardOffsetX : DreamSpacing.xs,
                    y: DreamCardLayout.insightCardOffsetY
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

private struct DreamDetailHeroStackView: View {
    let item: DreamCardSnapshot

    var body: some View {
        ZStack(alignment: .topLeading) {
            if item.hasHeroMedia {
                DreamHeroMediaCard(media: item.heroMedia)
                    .frame(
                        width: DreamCardLayout.detailHeroImageWidth,
                        height: DreamCardLayout.detailHeroImageHeight
                    )
                    .rotationEffect(.degrees(DreamCardLayout.detailHeroImageRotation))
                    .offset(y: DreamCardLayout.detailHeroImageOffsetY)
            }

            DreamInsightOverlayCard(insight: item.insight)
                .frame(width: DreamCardLayout.detailInsightCardWidth)
                .rotationEffect(.degrees(DreamCardLayout.detailInsightCardRotation))
                .offset(
                    x: item.hasHeroMedia ? DreamCardLayout.detailInsightCardOffsetX : DreamSpacing.xs,
                    y: DreamCardLayout.detailInsightCardOffsetY
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

private struct DreamHeroMediaCard: View {
    let media: DreamMediaSource

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DreamCornerRadius.lg, style: .continuous)
                .fill(baseGradient)

            if let image = resolvedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity)
            } else {
                DreamHeroMediaPlaceholder(media: media)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: DreamCornerRadius.lg, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DreamCornerRadius.lg, style: .continuous)
                .stroke(DreamColor.stroke.opacity(0.55), lineWidth: DreamStroke.hairline)
        )
        .dreamCardShadow()
    }

    private var resolvedImage: UIImage? {
        guard case let .asset(name) = media else {
            return nil
        }
        return UIImage(named: name)
    }

    private var baseGradient: LinearGradient {
        switch media {
        case .none:
            return LinearGradient(
                colors: [DreamColor.surface, DreamColor.card],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .asset:
            return LinearGradient(
                colors: [DreamColor.surface, DreamColor.cardStrong],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case let .gradient(theme):
            return LinearGradient(
                colors: theme.colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

private struct DreamHeroMediaPlaceholder: View {
    let media: DreamMediaSource

    var body: some View {
        ZStack {
            LinearGradient(
                colors: glowColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 0)

                Text("梦境影像")
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.inverseText)
            }
            .padding(DreamSpacing.l)
        }
    }

    private var glowColors: [Color] {
        switch media {
        case .none:
            return [DreamColor.surface.opacity(0.96), DreamColor.card.opacity(0.92)]
        case .asset:
            return [DreamColor.photoGlowViolet.opacity(0.44), DreamColor.photoGlowMint.opacity(0.36)]
        case let .gradient(theme):
            return theme.colors.map { $0.opacity(0.78) }
        }
    }
}

struct DreamInsightOverlayCard: View {
    let insight: DreamCardInsight

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(insight.title)
                .font(.system(size: 16, weight: .bold, design: .serif))
                .tracking(0.1)
                .foregroundColor(ticketInk)
                .lineLimit(1)
                .minimumScaleFactor(0.88)

            Rectangle()
                .fill(ticketRuleStrong)
                .frame(height: 2.2)

            Text(insight.subtitle)
                .font(.system(size: 12, weight: .regular, design: .serif))
                .foregroundColor(ticketInk.opacity(0.70))
                .lineLimit(1)

            HStack(alignment: .firstTextBaseline, spacing: DreamSpacing.xs) {
                Text(insight.primary.label)
                    .font(.system(size: 14, weight: .semibold, design: .serif))
                    .foregroundColor(ticketInk)

                Spacer(minLength: DreamSpacing.s)

                DreamMetricValueView(metric: insight.primary, role: .metric)
            }

            Rectangle()
                .fill(ticketRuleStrong)
                .frame(height: 2.2)

            ForEach(Array(insight.normalizedSecondary.enumerated()), id: \.element.id) { index, metric in
                HStack(alignment: .firstTextBaseline, spacing: DreamSpacing.xs) {
                    Text(metric.label)
                        .font(.system(size: 12, weight: .medium, design: .serif))
                        .foregroundColor(ticketInk)

                    Spacer(minLength: DreamSpacing.s)

                    DreamMetricValueView(metric: metric, role: .bodyStrong)
                }

                if index < insight.normalizedSecondary.count - 1 {
                    Rectangle()
                        .fill(ticketRuleSoft)
                        .frame(height: 0.7)
                }
            }
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: DreamCornerRadius.md, style: .continuous)
                .fill(DreamColor.paperCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DreamCornerRadius.md, style: .continuous)
                .stroke(DreamColor.paperCardStroke.opacity(0.42), lineWidth: 0.9)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DreamCornerRadius.md - 3, style: .continuous)
                .inset(by: 2)
                .stroke(DreamColor.paperCardInnerStroke.opacity(0.36), lineWidth: 0.6)
        )
    }

    private var ticketInk: Color {
        DreamColor.textPrimary.opacity(0.90)
    }

    private var ticketRuleStrong: Color {
        DreamColor.textPrimary.opacity(0.56)
    }

    private var ticketRuleSoft: Color {
        DreamColor.textPrimary.opacity(0.14)
    }
}

private struct DreamMetricValueView: View {
    let metric: DreamCardMetric
    let role: DreamTextRole

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            Text(metric.value)
                .font(valueFont)
                .tracking(valueTracking)
                .foregroundColor(valueColor)
                .lineLimit(1)
                .minimumScaleFactor(0.86)

            if !metric.unit.isEmpty {
                Text(metric.unit)
                    .font(unitFont)
                    .tracking(0.1)
                    .foregroundColor(unitColor)
                    .lineLimit(1)
            }
        }
    }

    private var valueFont: Font {
        switch role {
        case .metric:
            return .system(size: 24, weight: .bold, design: .serif)
        case .bodyStrong:
            return .system(size: 13, weight: .semibold, design: .serif)
        default:
            return role.style.font
        }
    }

    private var unitFont: Font {
        switch role {
        case .metric:
            return .system(size: 10, weight: .medium, design: .serif)
        case .bodyStrong:
            return .system(size: 9, weight: .medium, design: .serif)
        default:
            return DreamTextRole.caption.style.font
        }
    }

    private var valueTracking: CGFloat {
        role == .metric ? -0.25 : 0
    }

    private var valueColor: Color {
        DreamColor.textPrimary.opacity(role == .metric ? 0.92 : 0.88)
    }

    private var unitColor: Color {
        DreamColor.textPrimary.opacity(role == .metric ? 0.66 : 0.60)
    }
}

// ============================================================
// MARK: - 详情 Sheet
// ============================================================

struct DreamCardDetailSheetView: View {
    let item: DreamCardSnapshot
    let onClose: () -> Void
    let onShare: () -> Void
    let onDeepAnalyze: () -> Void
    let onMore: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: DreamCardLayout.detailSectionSpacing) {
                DreamDetailHeroHeader(item: item, onClose: handleClose)

                DreamDetailMetaSection(item: item)

                DreamDetailTextSection(
                    title: item.narrativeTitle,
                    content: item.displayNarrativeBody
                )

                DreamDetailOriginalSection(item: item)
            }
            .padding(.horizontal, DreamCardLayout.detailContentInsets.leading)
            .padding(.top, DreamCardLayout.detailContentInsets.top)
            .padding(.bottom, DreamCardLayout.detailActionBarContentClearance)
        }
        .accessibilityIdentifier("dream.detail.sheet")
        .safeAreaInset(edge: .bottom, spacing: 0) {
            DreamDetailActionBarPlate {
                DreamDetailActionBar(
                    onShare: onShare,
                    onDeepAnalyze: onDeepAnalyze,
                    onMore: onMore
                )
            }
        }
    }

    private func handleClose() {
        onClose()
    }
}

private struct DreamDetailHeroHeader: View {
    let item: DreamCardSnapshot
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            DreamDetailHeroStackView(item: item)
                .frame(height: DreamCardLayout.detailHeroContentHeight)
                .padding(.top, DreamCardLayout.detailHeroDragIndicatorClearance + DreamCardLayout.detailHeroTopPadding)
                .padding(.bottom, DreamCardLayout.detailHeroBottomPadding)

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: DreamCardLayout.detailCloseButtonIconSize, weight: .regular))
                    .foregroundColor(DreamColor.textPrimary)
                    .frame(
                        width: DreamCardLayout.detailCloseButtonSize,
                        height: DreamCardLayout.detailCloseButtonSize
                    )
                    .background(
                        Circle()
                            .fill(DreamColor.surface)
                    )
                    .overlay(
                        Circle()
                            .stroke(DreamColor.stroke.opacity(0.72), lineWidth: DreamStroke.hairline)
                    )
            }
            .buttonStyle(.plain)
            .dreamFloatingShadow()
            .padding(.top, DreamCardLayout.detailHeroDragIndicatorClearance + DreamCardLayout.detailCloseButtonInset)
            .padding(.trailing, DreamCardLayout.detailCloseButtonInset)
            .accessibilityLabel("关闭详情")
            .accessibilityIdentifier("dream.detail.close")
        }
        .frame(maxWidth: .infinity, minHeight: DreamCardLayout.detailHeroContainerHeight, alignment: .topLeading)
    }
}

private struct DreamDetailMetaSection: View {
    let item: DreamCardSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: DreamCardLayout.detailSectionInnerSpacing) {
            Text(DreamCardFormatters.weekday(from: item.recordedAt))
                .dreamRole(.navTitle)
                .foregroundColor(DreamColor.textPrimary)

            HStack(alignment: .firstTextBaseline, spacing: DreamSpacing.m) {
                VStack(alignment: .leading, spacing: DreamLayoutRhythm.tightGap) {
                    Text(DreamCardFormatters.fullDate(from: item.recordedAt))
                        .dreamRole(.caption)
                        .foregroundColor(DreamColor.textSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: DreamSpacing.s)

                DreamDetailPrimaryTimeView(date: item.recordedAt)
            }

            DreamMetaInfoRow(label: "AI洞察值", value: item.aiInsightValue)
            DreamMetaInfoRow(label: "高频关键词", value: item.keywordCount)

            Divider()
                .overlay(DreamColor.stroke.opacity(0.72))
                .padding(.top, DreamCardLayout.detailDividerTopPadding)
        }
    }
}

private struct DreamDetailPrimaryTimeView: View {
    let date: Date

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: DreamLayoutRhythm.tightGap) {
            Text(DreamCardFormatters.clockTime(from: date))
                .dreamRole(.detailTime)
                .foregroundColor(DreamColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.88)

            Text(DreamCardFormatters.meridiemLabel(from: date))
                .dreamRole(.detailTime)
                .foregroundColor(DreamColor.textSecondary)
                .lineLimit(1)
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

private struct DreamMetaInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .dreamRole(.caption)
                .foregroundColor(DreamColor.textSecondary)

            Spacer(minLength: DreamSpacing.s)

            Text(value)
                .dreamRole(.bodyStrong)
                .foregroundColor(DreamColor.textPrimary)
        }
    }
}

private struct DreamDetailTextSection: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: DreamCardLayout.detailSectionInnerSpacing) {
            Text(title)
                .dreamRole(.navTitle)
                .foregroundColor(DreamColor.textPrimary)

            Text(content)
                .dreamRole(.body)
                .foregroundColor(DreamColor.textPrimary)
                .lineSpacing(4)

            Divider()
                .overlay(DreamColor.stroke.opacity(0.72))
                .padding(.top, DreamCardLayout.detailDividerTopPadding)
        }
    }
}

private struct DreamDetailOriginalSection: View {
    let item: DreamCardSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: DreamCardLayout.detailSectionInnerSpacing) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.originalTitle)
                    .dreamRole(.navTitle)
                    .foregroundColor(DreamColor.textPrimary)

                Spacer(minLength: DreamSpacing.s)

                Text("1 份")
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.textPrimary)
            }

            Text(item.displayOriginalBody)
                .dreamRole(.body)
                .foregroundColor(DreamColor.textSecondary)
                .lineSpacing(4)
        }
    }
}

struct DreamDetailActionBar: View {
    let onShare: () -> Void
    let onDeepAnalyze: () -> Void
    let onMore: () -> Void

    var body: some View {
        HStack(spacing: DreamCardLayout.detailActionBarSpacing) {
            DreamActionCapsuleButton(title: "分享", action: onShare)
                .accessibilityIdentifier("dream.action.share")

            DreamActionCapsuleButton(title: "深度解析", action: onDeepAnalyze)
                .accessibilityIdentifier("dream.action.deepAnalyze")

            DreamActionCircleButton(action: onMore)
                .accessibilityIdentifier("dream.action.more")
        }
        .frame(maxWidth: .infinity)
    }
}

private struct DreamActionCapsuleButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .dreamRole(.bodyStrong)
                .foregroundColor(DreamColor.textPrimary)
                .padding(.horizontal, DreamLayoutInsets.pill.leading)
                .frame(height: DreamCardLayout.detailActionBarButtonHeight)
                .frame(maxWidth: .infinity)
                .background(
                    Capsule(style: .continuous)
                        .fill(DreamColor.cardStrong)
                )
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(DreamColor.stroke.opacity(0.72), lineWidth: DreamStroke.hairline)
                )
        }
        .buttonStyle(.plain)
        .dreamFloatingShadow()
    }
}

private struct DreamActionCircleButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "ellipsis")
                .font(.system(size: DreamCardLayout.detailActionBarIconSize, weight: .bold))
                .foregroundColor(DreamColor.textPrimary)
                .frame(
                    width: DreamCardLayout.detailActionBarMoreSize,
                    height: DreamCardLayout.detailActionBarMoreSize
                )
                .background(
                    Circle()
                        .fill(DreamColor.cardStrong)
                )
                .overlay(
                    Circle()
                        .stroke(DreamColor.stroke.opacity(0.72), lineWidth: DreamStroke.hairline)
                )
        }
        .buttonStyle(.plain)
        .dreamFloatingShadow()
    }
}

private struct DreamDetailActionBarPlate<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            // ---- 顶部柔和过渡：让底部模糊区像从内容里“浮现”出来 ----
            Color.clear
                .frame(height: DreamCardLayout.detailActionBarBackdropTopFadeHeight)

            content
                .padding(.horizontal, DreamCardLayout.detailActionBarPlateHorizontalPadding)
                .padding(.vertical, DreamCardLayout.detailActionBarPlateVerticalPadding)
                .padding(.horizontal, DreamCardLayout.detailContentInsets.leading)
                .padding(.bottom, DreamCardLayout.detailActionBarPlateBottomPadding)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, DreamCardLayout.detailActionBarBackdropHorizontalInset)
        .background(alignment: .bottom) {
            ZStack(alignment: .top) {
                Rectangle()
                .fill(.ultraThinMaterial)

                LinearGradient(
                    colors: [
                        DreamColor.canvas.opacity(0),
                        DreamColor.canvas.opacity(DreamCardLayout.detailActionBarBackdropTintOpacity)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                Rectangle()
                    .fill(DreamColor.stroke.opacity(DreamCardLayout.detailActionBarBackdropTopStrokeOpacity))
                    .frame(height: DreamStroke.hairline)
            }
            .compositingGroup()
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.22),
                        .init(color: .black, location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
