//
//  DesignSystemPreview.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 NavigationStack 和 AppStorage，依赖 DesignSystemHomeView 页面结构
 * [OUTPUT]: 对外提供 DesignSystemPreview 组件（设计系统页面总入口）与 ThemeMode 模式枚举（亮/暗）
 * [POS]: DesignSystem/ 的预览入口文件，被 ContentView 挂载并持久化主题模式
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

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

    var colorScheme: ColorScheme {
        switch self {
        case .dark: return .dark
        case .light: return .light
        }
    }
}

struct DesignSystemPreview: View {
    @AppStorage("dreambook.theme.mode") private var themeModeRawValue = ThemeMode.dark.rawValue

    private var themeModeBinding: Binding<ThemeMode> {
        Binding(
            get: { ThemeMode(rawValue: themeModeRawValue) ?? .dark },
            set: { themeModeRawValue = $0.rawValue }
        )
    }

    var body: some View {
        NavigationStack {
            DesignSystemHomeView(themeMode: themeModeBinding)
        }
        .preferredColorScheme(themeModeBinding.wrappedValue.colorScheme)
    }
}

#Preview {
    DesignSystemPreview()
}
