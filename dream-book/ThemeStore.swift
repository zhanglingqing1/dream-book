//
//  ThemeStore.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 ObservableObject 与 UserDefaults 持久化能力
 * [OUTPUT]: 对外提供 ThemeMode 与 ThemeStore，全局管理亮暗模式状态、切换与持久化
 * [POS]: dream-book/ 的全局主题状态中心，被 dream_bookApp 注入并被各页面消费
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI
import Combine

enum ThemeMode: String, CaseIterable, Identifiable {
    case dark
    case light

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dark: return "暗色"
        case .light: return "亮色"
        }
    }

    var icon: String {
        switch self {
        case .dark: return "moon.stars.fill"
        case .light: return "sun.max.fill"
        }
    }

    var colorScheme: ColorScheme {
        switch self {
        case .dark: return .dark
        case .light: return .light
        }
    }

    var toggled: ThemeMode {
        switch self {
        case .dark: return .light
        case .light: return .dark
        }
    }
}

@MainActor
final class ThemeStore: ObservableObject {
    @Published var mode: ThemeMode {
        didSet {
            UserDefaults.standard.set(mode.rawValue, forKey: Self.storageKey)
        }
    }

    private static let storageKey = "dreambook.theme.mode"

    init() {
        let rawValue = UserDefaults.standard.string(forKey: Self.storageKey)
        self.mode = ThemeMode(rawValue: rawValue ?? "") ?? .dark
    }

    func toggle() {
        mode = mode.toggled
    }
}
