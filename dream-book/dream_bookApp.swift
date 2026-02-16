//
//  dream_bookApp.swift
//  dream-book
//
//  Created by 张凌青 on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI App 生命周期框架，依赖 ContentView 根页面，依赖 ThemeStore 全局主题状态
 * [OUTPUT]: 对外提供 dream_bookApp 应用入口并初始化 WindowGroup，同时注入全局亮暗模式
 * [POS]: dream-book/ 的应用启动文件，连接系统生命周期、界面树与主题系统
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

@main
struct dream_bookApp: App {
    @StateObject private var themeStore = ThemeStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeStore)
                .preferredColorScheme(themeStore.mode.colorScheme)
        }
    }
}
