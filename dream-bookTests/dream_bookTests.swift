//
//  dream_bookTests.swift
//  dream-bookTests
//
//  Created by 张凌青 on 2026/2/16.
//

import Testing
@testable import dream_book
import Foundation

struct dream_bookTests {

    @Test
    func dreamCardDateFormattersOutputChineseParts() {
        let date = makeDate(year: 2025, month: 12, day: 14, hour: 11, minute: 21)

        #expect(DreamCardFormatters.weekday(from: date) == "星期日")
        #expect(DreamCardFormatters.fullDate(from: date) == "2025年12月14日")
        #expect(DreamCardFormatters.meridiemTime(from: date).contains("11:21"))
        #expect(DreamCardFormatters.meridiemTime(from: date).contains("上午"))
    }

    @Test
    func dreamCardInsightPadsSecondaryMetricsToThreeRows() {
        let insight = DreamCardInsight(
            title: "梦之书分析卡片",
            subtitle: "本梦心理指标",
            primary: DreamCardMetric(label: "清晰度", value: "80", unit: "分"),
            secondary: [
                DreamCardMetric(label: "情绪强度", value: "40", unit: "%")
            ]
        )

        #expect(insight.normalizedSecondary.count == 3)
        #expect(insight.normalizedSecondary[0].label == "情绪强度")
        #expect(insight.normalizedSecondary[1].value == "--")
        #expect(insight.normalizedSecondary[2].label == "待补充")
    }

    @Test
    func dreamCardSnapshotFallbackTextsWorkForEmptyContent() {
        let snapshot = DreamCardSnapshot(
            recordedAt: makeDate(year: 2025, month: 12, day: 14, hour: 11, minute: 21),
            dreamTitle: "空内容",
            dreamSummary: "   ",
            moodEmoji: "🌙",
            moodLabel: "平静",
            sceneTag: "测试",
            heroMedia: .gradient(theme: .oceanMint),
            insight: DreamCardInsight(
                title: "梦之书分析卡片",
                subtitle: "本梦心理指标",
                primary: DreamCardMetric(label: "清晰度", value: "0", unit: "分"),
                secondary: []
            ),
            aiInsightValue: "0 点",
            keywordCount: "0 个",
            narrativeTitle: "叙事分析",
            narrativeBody: " ",
            originalTitle: "原始梦境",
            originalBody: ""
        )

        #expect(snapshot.displaySummary == "这段梦还没有摘要。")
        #expect(snapshot.displayNarrativeBody == "AI 尚未生成叙事分析。")
        #expect(snapshot.displayOriginalBody == "原始梦境内容为空。")
    }

    private func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(identifier: "Asia/Shanghai")
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return components.date ?? .now
    }

}
