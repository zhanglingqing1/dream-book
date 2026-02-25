//
//  DreamCardKit.swift
//  dream-book
//
//  Created by Codex on 2026/2/18.
//

/**
 * [INPUT]: 依赖 Foundation 的时间格式化能力，依赖 SwiftUI 的基础类型承载媒体语义
 * [OUTPUT]: 对外提供梦境卡片数据契约、布局令牌与格式化工具（DreamCardSnapshot/Insight/Metric/Layout/Formatters）
 * [POS]: DesignSystem/ 的梦境卡片协议层，作为列表与详情组件的单一数据真相源
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import Foundation
import SwiftUI

// ============================================================
// MARK: - 数据契约
// ============================================================

struct DreamCardMetric: Identifiable, Hashable {
    let id: String
    let label: String
    let value: String
    let unit: String

    init(id: String = UUID().uuidString, label: String, value: String, unit: String) {
        self.id = id
        self.label = label
        self.value = value
        self.unit = unit
    }
}

struct DreamCardInsight: Hashable {
    let title: String
    let subtitle: String
    let primary: DreamCardMetric
    let secondary: [DreamCardMetric]

    var normalizedSecondary: [DreamCardMetric] {
        let topThree = Array(secondary.prefix(3))
        guard topThree.count < 3 else {
            return topThree
        }

        let placeholders = (topThree.count..<3).map { index in
            DreamCardMetric(
                id: "placeholder-\(index)",
                label: "待补充",
                value: "--",
                unit: ""
            )
        }
        return topThree + placeholders
    }
}

enum DreamMediaGradientTheme: String, Hashable, CaseIterable {
    case lucidViolet
    case oceanMint
    case amberDusk

    var colors: [Color] {
        switch self {
        case .lucidViolet:
            return [DreamColor.photoGlowViolet, DreamColor.photoGlowCyan, DreamColor.surface]
        case .oceanMint:
            return [DreamColor.photoGlowMint, DreamColor.photoGlowCyan, DreamColor.cardStrong]
        case .amberDusk:
            return [DreamColor.photoGlowAmber, DreamColor.photoGlowViolet, DreamColor.surface]
        }
    }
}

enum DreamMediaSource: Hashable {
    case asset(name: String)
    case gradient(theme: DreamMediaGradientTheme)
}

struct DreamCardSnapshot: Identifiable, Hashable {
    let id: UUID
    let recordedAt: Date
    let dreamTitle: String
    let dreamSummary: String
    let moodEmoji: String
    let moodLabel: String
    let sceneTag: String
    let heroMedia: DreamMediaSource
    let insight: DreamCardInsight
    let aiInsightValue: String
    let keywordCount: String
    let narrativeTitle: String
    let narrativeBody: String
    let originalTitle: String
    let originalBody: String

    init(
        id: UUID = UUID(),
        recordedAt: Date,
        dreamTitle: String,
        dreamSummary: String,
        moodEmoji: String,
        moodLabel: String,
        sceneTag: String,
        heroMedia: DreamMediaSource,
        insight: DreamCardInsight,
        aiInsightValue: String,
        keywordCount: String,
        narrativeTitle: String,
        narrativeBody: String,
        originalTitle: String,
        originalBody: String
    ) {
        self.id = id
        self.recordedAt = recordedAt
        self.dreamTitle = dreamTitle
        self.dreamSummary = dreamSummary
        self.moodEmoji = moodEmoji
        self.moodLabel = moodLabel
        self.sceneTag = sceneTag
        self.heroMedia = heroMedia
        self.insight = insight
        self.aiInsightValue = aiInsightValue
        self.keywordCount = keywordCount
        self.narrativeTitle = narrativeTitle
        self.narrativeBody = narrativeBody
        self.originalTitle = originalTitle
        self.originalBody = originalBody
    }
}

extension DreamCardSnapshot {
    var displaySummary: String {
        let trimmed = dreamSummary.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "这段梦还没有摘要。" : trimmed
    }

    var displayNarrativeBody: String {
        let trimmed = narrativeBody.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "AI 尚未生成叙事分析。" : trimmed
    }

    var displayOriginalBody: String {
        let trimmed = originalBody.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "原始梦境内容为空。" : trimmed
    }
}

// ============================================================
// MARK: - 布局令牌
// ============================================================

enum DreamCardLayout {
    // ---- 列表模板 ----
    static let listContentInsets: EdgeInsets = DreamLayoutInsets.page
    static let timelineRowSpacing: CGFloat = DreamLayoutRhythm.pageSectionGap
    static let timelineRowContentSpacing: CGFloat = DreamLayoutRhythm.groupGap
    static let timelineColumnWidth: CGFloat = 74
    static let timelineTopPadding: CGFloat = 14

    static let heroHeight: CGFloat = 224
    static let heroImageWidth: CGFloat = 196
    static let heroImageHeight: CGFloat = 186
    static let heroImageRotation: Double = -4
    static let heroImageOffsetY: CGFloat = 16

    static let insightCardWidth: CGFloat = 208
    static let insightCardRotation: Double = 4.5
    static let insightCardOffsetX: CGFloat = 50
    static let insightCardOffsetY: CGFloat = 6

    static let timelineSummaryBottomBreathing: CGFloat = DreamLayoutRhythm.groupGap
    static let summaryCardTopPadding: CGFloat = 28
    static let summaryPanelMinHeight: CGFloat = 150
    static let summaryBodyLineLimit: Int = 4
    static let summaryTitleLineLimit: Int = 2
    static let summaryPanelInsets: EdgeInsets = DreamLayoutInsets.card
    static let summaryPanelPillInsets: EdgeInsets = DreamLayoutInsets.pill
    static let summaryPanelGroupSpacing: CGFloat = DreamLayoutRhythm.groupGap
    static let summaryPanelRowSpacing: CGFloat = DreamLayoutRhythm.rowGap
    static let summaryPanelTightSpacing: CGFloat = DreamLayoutRhythm.tightGap
    static let summaryTimeTopPadding: CGFloat = DreamLayoutRhythm.tightGap
    static let summaryTagPillVerticalPadding: CGFloat = 6
    static let summaryTagPillHorizontalPadding: CGFloat = DreamSpacing.s

    static var timelineSummaryRevealHeight: CGFloat {
        summaryPanelMinHeight - summaryCardTopPadding + timelineSummaryBottomBreathing
    }

    // ---- 详情模板 ----
    static let detailContentInsets: EdgeInsets = DreamLayoutInsets.sheetContent
    static let detailSectionSpacing: CGFloat = DreamLayoutRhythm.majorBlockGap
    static let detailSectionInnerSpacing: CGFloat = DreamLayoutRhythm.groupGap
    static let detailDividerTopPadding: CGFloat = DreamLayoutRhythm.dividerTopGap
    static let detailHeroDragIndicatorClearance: CGFloat = DreamSpacing.s

    static let detailHeroContentHeight: CGFloat = 236
    static let detailHeroTopPadding: CGFloat = 12
    static let detailHeroBottomPadding: CGFloat = 24
    static var detailHeroContainerHeight: CGFloat {
        detailHeroDragIndicatorClearance + detailHeroTopPadding + detailHeroContentHeight + detailHeroBottomPadding
    }

    static let detailHeroImageWidth: CGFloat = 172
    static let detailHeroImageHeight: CGFloat = 164
    static let detailHeroImageRotation: Double = -3.6
    static let detailHeroImageOffsetY: CGFloat = 14

    static let detailInsightCardWidth: CGFloat = 184
    static let detailInsightCardRotation: Double = 4.0
    static let detailInsightCardOffsetX: CGFloat = 42
    static let detailInsightCardOffsetY: CGFloat = 5

    static let detailCloseButtonSize: CGFloat = 44
    static let detailCloseButtonInset: CGFloat = 8
    static let detailCloseButtonIconSize: CGFloat = 16

    static let detailActionBarButtonHeight: CGFloat = 52
    static let detailActionBarMoreSize: CGFloat = 52
    static let detailActionBarIconSize: CGFloat = 20
    static let detailActionBarSpacing: CGFloat = 10
    static let detailActionBarPlateHorizontalPadding: CGFloat = 10
    static let detailActionBarPlateVerticalPadding: CGFloat = 8
    static let detailActionBarPlateBottomPadding: CGFloat = 6
    static let detailActionBarBackdropTopFadeHeight: CGFloat = 28
    static let detailActionBarBackdropHorizontalInset: CGFloat = 0
    static let detailActionBarBackdropTopStrokeOpacity: Double = 0.28
    static let detailActionBarBackdropTintOpacity: Double = 0.08
    static let detailActionBarPlateStrokeOpacity: Double = 0.56
    static let detailActionBarContentClearance: CGFloat = 0
}

// ============================================================
// MARK: - 日期格式化
// ============================================================

enum DreamCardFormatters {
    private static let locale = Locale(identifier: "zh_CN")
    private static let timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current

    private static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = "yyyy年M月d日"
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()

    private static let clockFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = "hh:mm"
        return formatter
    }()

    private static let meridiemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = "a"
        return formatter
    }()

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = "d"
        return formatter
    }()

    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = "M"
        return formatter
    }()

    static func weekday(from date: Date) -> String {
        weekdayFormatter.string(from: date)
    }

    static func fullDate(from date: Date) -> String {
        dateFormatter.string(from: date)
    }

    static func meridiemTime(from date: Date) -> String {
        timeFormatter.string(from: date)
    }

    static func clockTime(from date: Date) -> String {
        clockFormatter.string(from: date)
    }

    static func meridiemLabel(from date: Date) -> String {
        meridiemFormatter.string(from: date)
    }

    static func dayNumber(from date: Date) -> String {
        dayFormatter.string(from: date)
    }

    static func monthNumber(from date: Date) -> String {
        monthFormatter.string(from: date)
    }
}
