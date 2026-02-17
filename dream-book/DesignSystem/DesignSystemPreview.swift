//
//  DesignSystemPreview.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 的 NavigationStack，依赖 DreamBookFoundationPreview 页面
 * [OUTPUT]: 对外提供 DesignSystemPreview 组件（梦之书设计系统预览入口）
 * [POS]: DesignSystem/ 的预览入口文件，被 ContentView 挂载并承接设计系统迭代
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

struct DesignSystemPreview: View {
    var body: some View {
        NavigationStack {
            DreamBookFoundationPreview()
        }
    }
}

#Preview {
    DesignSystemPreview()
        .environmentObject(ThemeStore())
}
