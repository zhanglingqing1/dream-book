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
            LazyVStack(alignment: .leading, spacing: DreamSpacing.xxl) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    DreamTimelineCardRow(index: index, item: item) {
                        onSelect(item)
                    }
                }
            }
            .padding(.horizontal, DreamSpacing.l)
            .padding(.top, DreamSpacing.s)
            .padding(.bottom, DreamSpacing.xxxl)
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
            HStack(alignment: .top, spacing: DreamSpacing.m) {
                DreamTimelineDateColumn(date: item.recordedAt)
                    .frame(width: DreamCardLayout.timelineColumnWidth)
                    .padding(.top, DreamCardLayout.timelineTopPadding)

                VStack(alignment: .leading, spacing: DreamSpacing.s) {
                    ZStack(alignment: .topLeading) {
                        DreamCardHeroStackView(item: item)
                            .frame(height: DreamCardLayout.heroHeight)

                        DreamSummaryPanel(item: item)
                            .offset(y: DreamCardLayout.heroHeight - DreamCardLayout.summaryCardTopPadding)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: DreamCardLayout.heroHeight + DreamCardLayout.timelineSummaryRevealHeight)

                    Text(DreamCardFormatters.meridiemTime(from: item.recordedAt))
                        .dreamRole(.caption)
                        .foregroundColor(DreamColor.textSecondary)
                        .padding(.leading, DreamSpacing.xs)
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
        VStack(alignment: .leading, spacing: DreamSpacing.xs) {
            Text(DreamCardFormatters.dayNumber(from: date))
                .dreamRole(.metric)
                .foregroundColor(DreamColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(DreamCardFormatters.monthNumber(from: date))
                .dreamRole(.body)
                .foregroundColor(DreamColor.textSecondary)
        }
    }
}

private struct DreamSummaryPanel: View {
    let item: DreamCardSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.s) {
            HStack(alignment: .top) {
                Text(item.dreamTitle)
                    .dreamRole(.navTitle)
                    .foregroundColor(DreamColor.textPrimary)
                    .lineLimit(1)

                Spacer(minLength: DreamSpacing.s)

                Text(item.sceneTag)
                    .dreamRole(.caption)
                    .foregroundColor(DreamColor.textSecondary)
                    .padding(.horizontal, DreamSpacing.s)
                    .padding(.vertical, DreamSpacing.xs)
                    .background(
                        Capsule(style: .continuous)
                            .fill(DreamColor.surface)
                    )
            }

            HStack(alignment: .top, spacing: DreamSpacing.xs) {
                Text(item.moodEmoji)
                    .font(.system(size: 22))
                    .padding(.top, 2)

                Text(item.displaySummary)
                    .dreamRole(.body)
                    .foregroundColor(DreamColor.textSecondary)
                    .lineLimit(DreamCardLayout.summaryBodyLineLimit)
            }
        }
        .frame(minHeight: DreamCardLayout.summaryPanelMinHeight, alignment: .topLeading)
        .padding(.horizontal, DreamSpacing.l)
        .padding(.vertical, DreamSpacing.l)
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

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DreamSpacing.xl) {
                    DreamDetailHeroHeader(item: item, onClose: handleClose)

                    DreamDetailMetaSection(item: item)

                    DreamDetailTextSection(
                        title: item.narrativeTitle,
                        content: item.displayNarrativeBody
                    )

                    DreamDetailOriginalSection(item: item)
                }
                .padding(.horizontal, DreamSpacing.l)
                .padding(.top, DreamSpacing.l)
                .padding(.bottom, 140)
            }
            .accessibilityIdentifier("dream.detail.sheet")
        }
        .safeAreaInset(edge: .bottom) {
            DreamDetailActionBar(
                onShare: onShare,
                onDeepAnalyze: onDeepAnalyze,
                onMore: onMore
            )
            .padding(.horizontal, DreamSpacing.l)
            .padding(.vertical, DreamSpacing.s)
            .background(.clear)
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
            DreamCardHeroStackView(item: item)
                .frame(height: DreamCardLayout.heroHeight + DreamCardLayout.detailHeroHeightDelta)

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 26, weight: .regular))
                    .foregroundColor(DreamColor.textPrimary)
                    .frame(width: 72, height: 72)
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
            .accessibilityLabel("关闭详情")
            .accessibilityIdentifier("dream.detail.close")
        }
    }
}

private struct DreamDetailMetaSection: View {
    let item: DreamCardSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            Text(DreamCardFormatters.weekday(from: item.recordedAt))
                .dreamRole(.navTitle)
                .foregroundColor(DreamColor.textPrimary)

            HStack(alignment: .bottom, spacing: DreamSpacing.m) {
                VStack(alignment: .leading, spacing: DreamSpacing.xxs) {
                    Text(DreamCardFormatters.fullDate(from: item.recordedAt))
                        .dreamRole(.body)
                        .foregroundColor(DreamColor.textSecondary)
                }

                Spacer(minLength: DreamSpacing.s)

                DreamDetailPrimaryTimeView(date: item.recordedAt)
            }

            DreamMetaInfoRow(label: "AI洞察值", value: item.aiInsightValue)
            DreamMetaInfoRow(label: "高频关键词", value: item.keywordCount)

            Divider()
                .overlay(DreamColor.stroke.opacity(0.72))
        }
    }
}

private struct DreamDetailPrimaryTimeView: View {
    let date: Date

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: DreamSpacing.xs) {
            Text(DreamCardFormatters.clockTime(from: date))
                .font(
                    .system(
                        size: DreamCardLayout.detailTimeClockSize,
                        weight: .semibold,
                        design: .default
                    )
                )
                .monospacedDigit()
                .foregroundColor(DreamColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            Text(DreamCardFormatters.meridiemLabel(from: date))
                .font(
                    .system(
                        size: DreamCardLayout.detailTimeMeridiemSize,
                        weight: .semibold,
                        design: .serif
                    )
                )
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
                .dreamRole(.body)
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
        VStack(alignment: .leading, spacing: DreamSpacing.m) {
            Text(title)
                .dreamRole(.navTitle)
                .foregroundColor(DreamColor.textPrimary)

            Text(content)
                .dreamRole(.body)
                .foregroundColor(DreamColor.textPrimary)

            Divider()
                .overlay(DreamColor.stroke.opacity(0.72))
        }
    }
}

private struct DreamDetailOriginalSection: View {
    let item: DreamCardSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: DreamSpacing.s) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.originalTitle)
                    .dreamRole(.navTitle)
                    .foregroundColor(DreamColor.textPrimary)

                Spacer(minLength: DreamSpacing.s)

                Text("1 份")
                    .dreamRole(.metric)
                    .foregroundColor(DreamColor.textPrimary)
            }

            Text(item.displayOriginalBody)
                .dreamRole(.body)
                .foregroundColor(DreamColor.textSecondary)
        }
    }
}

struct DreamDetailActionBar: View {
    let onShare: () -> Void
    let onDeepAnalyze: () -> Void
    let onMore: () -> Void

    var body: some View {
        HStack(spacing: DreamSpacing.s) {
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
                .padding(.horizontal, DreamSpacing.l)
                .frame(height: 58)
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
        .dreamCardShadow()
    }
}

private struct DreamActionCircleButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "ellipsis")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(DreamColor.textPrimary)
                .frame(width: 58, height: 58)
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
        .dreamCardShadow()
    }
}
