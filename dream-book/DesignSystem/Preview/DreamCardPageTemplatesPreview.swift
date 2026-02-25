//
//  DreamCardPageTemplatesPreview.swift
//  dream-book
//
//  Created by Codex on 2026/2/18.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 sheet/presentationDetents 能力，依赖 DreamCardKit 与 DreamCardComponents
 * [OUTPUT]: 对外提供梦境卡片页面模板预览（列表模板 + 详情模板 + Page Sheet 路由示例）
 * [POS]: DesignSystem/Preview/ 的页面模板文件，承接梦境卡片组件的交互验收与视觉对齐
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

struct DreamCardPageTemplatesPreview: View {
    private static let v2NativeListEntryID = UUID(uuidString: "4B9F722C-B29E-4A92-9D46-8E810B7FC0A2")!

    @State private var selectedTemplate: DreamTemplateMode = .list
    @State private var selectedItem: DreamCardSnapshot?
    @State private var selectedItemV2: DreamCardSnapshot?

    private let mockItems = DreamCardMockData.samples

    var body: some View {
        ZStack {
            DreamColor.canvas
                .ignoresSafeArea()

            VStack(spacing: DreamLayoutRhythm.groupGap) {
                Picker("模板模式", selection: $selectedTemplate) {
                    ForEach(DreamTemplateMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, DreamLayoutInsets.page.leading)
                .padding(.top, DreamLayoutInsets.page.top)

                Text(templateInspectionHint)
                    .dreamRole(.caption)
                    .foregroundColor(DreamColor.textSecondary)
                    .padding(.horizontal, DreamLayoutInsets.page.leading)

                Group {
                    switch selectedTemplate {
                    case .list:
                        DreamTimelineCardListView(items: listItemsWithNativeV2Entry) { item in
                            if item.id == Self.v2NativeListEntryID {
                                selectedItemV2 = mockItems[0]
                                return
                            }
                            selectedItem = item
                        }
                    case .detail:
                        DreamCardDetailSheetView(
                            item: mockItems[0],
                            onClose: {},
                            onShare: {},
                            onDeepAnalyze: {},
                            onMore: {}
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .navigationTitle("梦境卡片模板")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedItem) { item in
            DreamCardDetailSheetView(
                item: item,
                onClose: { selectedItem = nil },
                onShare: {},
                onDeepAnalyze: {},
                onMore: {}
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .presentationBackground(.red)
            .presentationDetents([.fraction(DreamCardLayout.detailSheetDetentFraction)])
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.disabled)
            .interactiveDismissDisabled(false)
            .presentationCornerRadius(DreamCardLayout.sheetCornerRadius)
            .presentationSizing(.page)
        }
        .sheet(item: $selectedItemV2) { item in
            DreamCardDetailSheetView_V2(
                item: item,
                onClose: { selectedItemV2 = nil },
                onShare: {},
                onDeepAnalyze: {},
                onMore: {}
            )
        }
    }

    private var templateInspectionHint: String {
        switch selectedTemplate {
        case .list:
            return "点击列表卡片，使用真实 Page Sheet 路径验收顶部净空、底部安全区与交互。"
        case .detail:
            return "详情结构页签是静态内容预览（非系统 Sheet 容器）；Page Sheet 外边距/圆角/安全区请回到列表模板点击卡片验证。"
        }
    }

    private var listItemsWithNativeV2Entry: [DreamCardSnapshot] {
        mockItems + [v2NativeListEntry]
    }

    private var v2NativeListEntry: DreamCardSnapshot {
        let base = mockItems[0]

        return DreamCardSnapshot(
            id: Self.v2NativeListEntryID,
            recordedAt: base.recordedAt,
            dreamTitle: "\(base.dreamTitle) (V2 原生版)",
            dreamSummary: base.dreamSummary,
            moodEmoji: base.moodEmoji,
            moodLabel: base.moodLabel,
            sceneTag: base.sceneTag,
            heroMedia: base.heroMedia,
            insight: base.insight,
            aiInsightValue: base.aiInsightValue,
            keywordCount: base.keywordCount,
            narrativeTitle: base.narrativeTitle,
            narrativeBody: base.narrativeBody,
            originalTitle: base.originalTitle,
            originalBody: base.originalBody
        )
    }
}

private enum DreamTemplateMode: String, CaseIterable, Identifiable {
    case list
    case detail

    var id: String { rawValue }

    var title: String {
        switch self {
        case .list:
            return "列表模板"
        case .detail:
            return "详情结构"
        }
    }
}

private enum DreamCardMockData {
    static let samples: [DreamCardSnapshot] = [
        DreamCardSnapshot(
            recordedAt: makeDate(day: 14, month: 12, year: 2025, hour: 11, minute: 21),
            dreamTitle: "海边列车",
            dreamSummary: "我坐在一辆穿过海浪的列车里，窗外的路牌都写着遗忘的名字。",
            moodEmoji: "🌊",
            moodLabel: "平静",
            sceneTag: "旅程",
            heroMedia: .gradient(theme: .oceanMint),
            insight: DreamCardInsight(
                title: "梦之书分析卡片",
                subtitle: "本梦心理指标",
                primary: DreamCardMetric(label: "清晰度", value: "82", unit: "分"),
                secondary: [
                    DreamCardMetric(label: "情绪强度", value: "31", unit: "%"),
                    DreamCardMetric(label: "符号密度", value: "12", unit: "个"),
                    DreamCardMetric(label: "叙事连贯", value: "76", unit: "分")
                ]
            ),
            aiInsightValue: "16 点",
            keywordCount: "9 个",
            narrativeTitle: "潮声中的告别：你的内在过渡",
            narrativeBody: "列车代表你正在离开旧叙事，海浪象征情绪仍在波动。梦里你持续向前，说明你并未被过去困住，而是在寻找新的秩序。",
            originalTitle: "原始梦境",
            originalBody: "我在海边的列车上，车厢很旧但很安静。窗外一直有浪拍过来，路牌看不清，只记得自己没有害怕。"
        ),
        DreamCardSnapshot(
            recordedAt: makeDate(day: 6, month: 12, year: 2025, hour: 2, minute: 38),
            dreamTitle: "玻璃花园",
            dreamSummary: "我在一座玻璃做的温室里修补一只会发光的鸟，手上一直有碎片。",
            moodEmoji: "🕊️",
            moodLabel: "紧张",
            sceneTag: "修复",
            heroMedia: .gradient(theme: .lucidViolet),
            insight: DreamCardInsight(
                title: "梦之书分析卡片",
                subtitle: "本梦心理指标",
                primary: DreamCardMetric(label: "清晰度", value: "67", unit: "分"),
                secondary: [
                    DreamCardMetric(label: "情绪强度", value: "64", unit: "%"),
                    DreamCardMetric(label: "符号密度", value: "15", unit: "个"),
                    DreamCardMetric(label: "叙事连贯", value: "58", unit: "分")
                ]
            ),
            aiInsightValue: "22 点",
            keywordCount: "11 个",
            narrativeTitle: "修复与代价：你正在学会边界",
            narrativeBody: "玻璃与伤口反复出现，代表你正处理脆弱关系。发光的鸟是你想保护的价值，梦境提醒你在承担责任时也要保护自己。",
            originalTitle: "原始梦境",
            originalBody: "温室里全是玻璃植物，我想把一只受伤的鸟缝好。每次碰它手都会被割到，但我没有停。"
        ),
        DreamCardSnapshot(
            recordedAt: makeDate(day: 1, month: 12, year: 2025, hour: 7, minute: 5),
            dreamTitle: "黄昏码头",
            dreamSummary: "我在黄昏的码头等一艘迟到的船，广播只播放童年的录音。",
            moodEmoji: "⛵",
            moodLabel: "怀旧",
            sceneTag: "等待",
            heroMedia: .gradient(theme: .amberDusk),
            insight: DreamCardInsight(
                title: "梦之书分析卡片",
                subtitle: "本梦心理指标",
                primary: DreamCardMetric(label: "清晰度", value: "74", unit: "分"),
                secondary: [
                    DreamCardMetric(label: "情绪强度", value: "47", unit: "%"),
                    DreamCardMetric(label: "符号密度", value: "8", unit: "个"),
                    DreamCardMetric(label: "叙事连贯", value: "69", unit: "分")
                ]
            ),
            aiInsightValue: "13 点",
            keywordCount: "7 个",
            narrativeTitle: "等待并非停滞：你在整理旧记忆",
            narrativeBody: "船迟到意味着现实反馈延后，童年录音指向旧情绪被重新激活。梦境并不是阻滞，而是你的系统在重组重要记忆。",
            originalTitle: "原始梦境",
            originalBody: "码头只有我一个人，天是橙色的。广播里放着小时候的录音，我一直在等船靠岸。"
        )
    ]

    private static func makeDate(day: Int, month: Int, year: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(identifier: "Asia/Shanghai")
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return components.date ?? Date()
    }
}

#Preview {
    NavigationStack {
        DreamCardPageTemplatesPreview()
    }
    .environmentObject(ThemeStore())
}
