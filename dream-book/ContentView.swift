//
//  ContentView.swift
//  dream-book
//
//  Created by 张凌青 on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI，依赖 DesignSystemPreview 页面入口
 * [OUTPUT]: 对外提供 ContentView 根视图，当前承载设计系统页面
 * [POS]: dream-book/ 的主界面入口文件，被 dream_bookApp 挂载
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

struct ContentView: View {
    var body: some View {
        DesignSystemPreview()
    }
}

#Preview {
    ContentView()
}
