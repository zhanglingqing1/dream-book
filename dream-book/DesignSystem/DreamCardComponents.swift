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
        Button(action: onTap) {
            HStack(alignment: .top, spacing: DreamCardLayout.timelineRowContentSpacing) {
                DreamTimelineDateColumn(date: item.recordedAt)
                    .frame(width: DreamCardLayout.timelineColumnWidth)
                    .padding(.top, DreamCardLayout.timelineTopPadding)

                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        DreamCardHeroStackView(item: item)
                            .frame(height: DreamCardLayout.heroHeight)

                        DreamSummaryPanel(item: item)
                            .offset(y: DreamCardLayout.heroHeight - DreamCardLayout.summaryCardTopPadding)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: DreamCardLayout.heroHeight + DreamCardLayout.timelineSummaryRevealHeight)

                    // ---- 时间标签：卡片外部下方独立呈现 ----
                    Text(DreamCardFormatters.clockTime(from: item.recordedAt))
                        .dreamRole(.caption)
                        .foregroundColor(DreamColor.textSecondary)
                        .padding(.top, DreamCardLayout.summaryTimeTopPadding)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("dream.list.row.\(index)")
    }
}

private struct DreamTimelineDateColumn: View {
    let date: Date

    var body: some View {
        // ---- 日号 + 月号下标：水平基线对齐 ----
        HStack(alignment: .lastTextBaseline, spacing: 2) {
            Text(DreamCardFormatters.dayNumber(from: date))
                .dreamRole(.metric)
                .foregroundColor(DreamColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(DreamCardFormatters.monthNumber(from: date))
                .dreamRole(.caption)
                .foregroundColor(DreamColor.textSecondary)
        }
    }
}

private struct DreamSummaryPanel: View {
    let item: DreamCardSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: DreamCardLayout.summaryPanelGroupSpacing) {
            // ---- 标题独占一行 ----
            Text(item.dreamTitle)
                .dreamRole(.navTitle)
                .foregroundColor(DreamColor.textPrimary)
                .lineLimit(DreamCardLayout.summaryTitleLineLimit)

            // ---- 正文区：emoji + 摘要 + 标签 pill ----
            HStack(alignment: .top, spacing: DreamCardLayout.summaryPanelTightSpacing) {
                Text(item.moodEmoji)
                    .font(.system(size: 20))
                    .padding(.top, 1)

                Text(item.displaySummary)
                    .dreamRole(.body)
                    .foregroundColor(DreamColor.textSecondary)
                    .lineLimit(DreamCardLayout.summaryBodyLineLimit)
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(item.sceneTag)
                    .dreamRole(.caption)
                    .foregroundColor(DreamColor.textSecondary)
                    .padding(.vertical, DreamCardLayout.summaryTagPillVerticalPadding)
                    .padding(.horizontal, DreamCardLayout.summaryTagPillHorizontalPadding)
                    .background(
                        Capsule(style: .continuous)
                            .fill(DreamColor.surface)
                    )
                    .lineLimit(1)
            }
        }
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
            DreamHeroMediaCard(media: item.heroMedia)
                .frame(width: DreamCardLayout.heroImageWidth, height: DreamCardLayout.heroImageHeight)
                .rotationEffect(.degrees(DreamCardLayout.heroImageRotation))
                .offset(y: DreamCardLayout.heroImageOffsetY)

            DreamInsightOverlayCard(insight: item.insight)
                .frame(width: DreamCardLayout.insightCardWidth)
                .rotationEffect(.degrees(DreamCardLayout.insightCardRotation))
                .offset(
                    x: DreamCardLayout.insightCardOffsetX,
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
            DreamHeroMediaCard(media: item.heroMedia)
                .frame(
                    width: DreamCardLayout.detailHeroImageWidth,
                    height: DreamCardLayout.detailHeroImageHeight
                )
                .rotationEffect(.degrees(DreamCardLayout.detailHeroImageRotation))
                .offset(y: DreamCardLayout.detailHeroImageOffsetY)

            DreamInsightOverlayCard(insight: item.insight)
                .frame(width: DreamCardLayout.detailInsightCardWidth)
                .rotationEffect(.degrees(DreamCardLayout.detailInsightCardRotation))
                .offset(
                    x: DreamCardLayout.detailInsightCardOffsetX,
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

            VStack(alignment: .leading, spacing: DreamSpacing.s) {
                HStack(spacing: DreamSpacing.xs) {
                    Circle()
                        .fill(DreamColor.inverseText.opacity(0.84))
                        .frame(width: 9, height: 9)
                    Circle()
                        .fill(DreamColor.inverseText.opacity(0.62))
                        .frame(width: 9, height: 9)
                }

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
        VStack(alignment: .leading, spacing: DreamSpacing.s) {
            Text(insight.title)
                .dreamRole(.bodyStrong)
                .foregroundColor(DreamColor.textPrimary)

            Rectangle()
                .fill(DreamColor.textSecondary.opacity(0.76))
                .frame(height: 1)

            Text(insight.subtitle)
                .dreamRole(.body)
                .foregroundColor(DreamColor.textSecondary)

            HStack(alignment: .firstTextBaseline, spacing: DreamSpacing.s) {
                Text(insight.primary.label)
                    .dreamRole(.bodyStrong)
                    .foregroundColor(DreamColor.textPrimary)

                Spacer(minLength: DreamSpacing.s)

                DreamMetricValueView(metric: insight.primary, role: .metric)
            }

            Rectangle()
                .fill(DreamColor.textSecondary.opacity(0.76))
                .frame(height: 1)

            ForEach(Array(insight.normalizedSecondary.enumerated()), id: \.element.id) { index, metric in
                HStack(alignment: .firstTextBaseline, spacing: DreamSpacing.s) {
                    Text(metric.label)
                        .dreamRole(.bodyStrong)
                        .foregroundColor(DreamColor.textPrimary)

                    Spacer(minLength: DreamSpacing.s)

                    DreamMetricValueView(metric: metric, role: .bodyStrong)
                }

                if index < insight.normalizedSecondary.count - 1 {
                    Divider()
                        .overlay(DreamColor.stroke.opacity(0.68))
                }
            }
        }
        .padding(.horizontal, DreamSpacing.m)
        .padding(.vertical, DreamSpacing.s)
        .background(
            RoundedRectangle(cornerRadius: DreamCornerRadius.md, style: .continuous)
                .fill(DreamColor.cardStrong)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DreamCornerRadius.md, style: .continuous)
                .stroke(DreamColor.textSecondary.opacity(0.56), lineWidth: DreamStroke.regular)
        )
        .dreamCardShadow()
    }
}

private struct DreamMetricValueView: View {
    let metric: DreamCardMetric
    let role: DreamTextRole

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            Text(metric.value)
                .dreamRole(role)
                .foregroundColor(DreamColor.textPrimary)

            if !metric.unit.isEmpty {
                Text(metric.unit)
                    .dreamRole(.caption)
                    .foregroundColor(DreamColor.textSecondary)
            }
        }
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
        ZStack {
            DreamColor.canvas
                .ignoresSafeArea()

            DreamDetailActionBarBottomSafeAreaFill()

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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private func handleClose() {
        onClose()
    }
}

private struct DreamDetailActionBarBottomSafeAreaFill: View {
    var body: some View {
        GeometryReader { proxy in
            let fillHeight = proxy.safeAreaInsets.bottom + DreamCardLayout.detailActionBarBottomSafeAreaOverlap

            if fillHeight > 0 {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        DreamColor.canvas.opacity(DreamCardLayout.detailActionBarBackdropTintOpacity)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: fillHeight)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
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
