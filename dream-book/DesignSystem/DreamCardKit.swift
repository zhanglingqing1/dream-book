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
    static let timelineColumnWidth: CGFloat = 62
    static let timelineTopPadding: CGFloat = 18

    static let heroHeight: CGFloat = 256
    static let heroImageWidth: CGFloat = 224
    static let heroImageHeight: CGFloat = 212
    static let heroImageRotation: Double = -4
    static let heroImageOffsetY: CGFloat = 22

    static let insightCardWidth: CGFloat = 232
    static let insightCardRotation: Double = 4.5
    static let insightCardOffsetX: CGFloat = 62
    static let insightCardOffsetY: CGFloat = 10

    static let timelineSummaryRevealHeight: CGFloat = 176
    static let summaryCardTopPadding: CGFloat = 22
    static let summaryPanelMinHeight: CGFloat = 156
    static let summaryBodyLineLimit: Int = 3

    static let detailHeroHeightDelta: CGFloat = 8
    static let detailTimeClockSize: CGFloat = 38
    static let detailTimeMeridiemSize: CGFloat = 24

    static let sheetCornerRadius: CGFloat = 44
    static let sheetDetentFraction: CGFloat = 0.90
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
