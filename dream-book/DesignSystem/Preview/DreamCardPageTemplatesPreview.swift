//
//  DreamCardPageTemplatesPreview.swift
//  dream-book
//
//  Created by Codex on 2026/2/18.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 sheet 导航能力，依赖 DreamCardKit 与 DreamCardComponents
 * [OUTPUT]: 对外提供梦境卡片页面模板预览（双卡列表 + 原生 Sheet 详情路由）
 * [POS]: DesignSystem/Preview/ 的页面模板文件，承接梦境卡片组件的底部弹窗验收与视觉对齐
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

struct DreamCardPageTemplatesPreview: View {
    @State private var selectedItem: DreamCardSnapshot?

    private let mockItems = DreamCardMockData.samples

    var body: some View {
        ZStack {
            DreamColor.canvas
                .ignoresSafeArea()

            DreamTimelineCardListView(items: templateListItems) { item in
                selectedItem = item
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
        }
    }

    private var templateListItems: [DreamCardSnapshot] {
        Array(mockItems.prefix(2))
    }
}

private enum DreamCardMockData {
    static let samples: [DreamCardSnapshot] = [
        DreamCardSnapshot(
            recordedAt: makeDate(day: 14, month: 12, year: 2025, hour: 11, minute: 21),
            dreamTitle: "海边列车",
            dreamSummary: "我梦见自己坐在一节快要散架的老列车里，车窗半开，咸湿的风和海浪一起灌进来，脚边全是潮水。我一路盯着站牌看，每一站都写着我认识却想不起的人名，列车没有广播也没有终点提示，只有铁轨和浪声叠在一起。最奇怪的是我一直很清醒，知道自己在离开什么，却怎么都说不出那个东西的名字。",
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
            originalBody: "我在海边的列车上醒着做梦，车厢是木头椅子，灯忽明忽暗，像随时会停电。轨道直接贴着海面走，浪会拍到窗框。每次我想下车，门就会变成镜子，照出我小时候的样子。后来我走到车厢连接处，看到前一节车厢空无一人，只贴着一张写着“下一站：遗忘”的纸。我没有害怕，只是一直在默记站名，怕醒来后它们全都不见。"
        ),
        DreamCardSnapshot(
            recordedAt: makeDate(day: 6, month: 12, year: 2025, hour: 2, minute: 38),
            dreamTitle: "玻璃花园",
            dreamSummary: "我梦见自己一个人在玻璃温室里修一只会发光的小鸟，它的翅膀像碎掉的灯泡，一碰就往下掉渣。我蹲在地上一片片把碎片拼回去，手被割出很多细口子，但怎么都停不下来。温室外面有人影来回走，我听得见脚步，却一直看不清他们的脸。",
            moodEmoji: "🕊️",
            moodLabel: "紧张",
            sceneTag: "修复",
            heroMedia: .none,
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
            originalBody: "温室里的植物全是玻璃做的，风一吹就像在互相碰杯。我把那只鸟放在工作台上，用线缝它翅膀边缘，每缝一针它就亮一点，也更烫一点。后来我发现桌上的玻璃碎片其实是我自己指尖掉下来的壳，越修手越轻，像要变透明。最后门开了，我想把鸟递出去，但外面的人全都背对着我。"
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
