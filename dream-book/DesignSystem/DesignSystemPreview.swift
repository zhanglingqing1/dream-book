//
//  DesignSystemPreview.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 NavigationStack，依赖 ThemeStore 全局主题状态，依赖 DesignSystemHomeView 页面结构
 * [OUTPUT]: 对外提供 DesignSystemPreview 组件（设计系统页面总入口），透传主题绑定给页面层
 * [POS]: DesignSystem/ 的预览入口文件，被 ContentView 挂载并消费全局主题系统
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

struct DesignSystemPreview: View {
    @EnvironmentObject private var themeStore: ThemeStore

    var body: some View {
        NavigationStack {
            DesignSystemHomeView(
                themeMode: Binding(
                    get: { themeStore.mode },
                    set: { themeStore.mode = $0 }
                )
            )
        }
    }
}

#Preview {
    DesignSystemPreview()
        .environmentObject(ThemeStore())
}
