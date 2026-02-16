//
//  BellyBookFoundationPreview.swift
//  dream-book
//
//  Created by Codex on 2026/2/16.
//

/**
 * [INPUT]: 依赖 SwiftUI 与 BellyBookFoundation 令牌/基础组件能力
 * [OUTPUT]: 对外提供 BellyBookFoundationPreview 页面，用于验证“胃之书”基础令牌提取结果
 * [POS]: DesignSystem/Preview/ 的胃之书专项预览页，承接深度复刻的第一阶段可视化验收
 * [PROTOCOL]: 变更时更新此头部，然后检查 CLAUDE.md
 */

import SwiftUI

struct BellyBookFoundationPreview: View {
    @EnvironmentObject private var themeStore: ThemeStore

    private let colorSpecs: [FoundationColorSpec] = [
        .init(name: "Canvas", color: BBColor.canvas),
        .init(name: "Surface", color: BBColor.surface),
        .init(name: "Card", color: BBColor.card),
        .init(name: "Stroke", color: BBColor.stroke),
        .init(name: "Premium", color: BBColor.premiumFill),
        .init(name: "FAB", color: BBColor.fabFill)
    ]

    var body: some View {
        ZStack {
            BBColor.canvas
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: BBSpacing.xxl) {
                    HeaderStrip()
                    ColorTokenSection(specs: colorSpecs)
                    TypographyTokenSection()
                    SurfacePrimitiveSection()
                }
                .padding(.horizontal, BBSpacing.l)
                .padding(.top, BBSpacing.s)
                .padding(.bottom, BBSpacing.xxxl + 78)
            }

            VStack {
                Spacer()
                BottomDockShowcase()
                    .padding(.horizontal, BBSpacing.l)
                    .padding(.bottom, BBSpacing.l)
            }
        }
        .navigationTitle("胃之书基础层")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { themeStore.toggle() }) {
                    HStack(spacing: BBSpacing.xs) {
                        Image(systemName: themeStore.mode.icon)
                            .font(.system(size: 13, weight: .semibold))
                        Text(themeStore.mode.title)
                            .bbRole(.caption)
                    }
                    .foregroundColor(BBColor.textPrimary)
                    .padding(.horizontal, BBSpacing.s)
                    .padding(.vertical, BBSpacing.xs)
                    .background(
                        Capsule(style: .continuous)
                            .fill(BBColor.surface)
                    )
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(BBColor.stroke.opacity(0.72), lineWidth: BBStroke.hairline)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("切换亮暗主题")
            }
        }
    }
}

// ============================================================
// MARK: - 页面分区
// ============================================================

private struct HeaderStrip: View {
    var body: some View {
        HStack {
            Circle()
                .fill(BBColor.surface)
                .frame(width: 54, height: 54)
                .overlay(
                    Image(systemName: "scribble.variable")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(BBColor.textSecondary)
                )
                .bbCardShadow()

            Spacer()

            Text("数据")
                .bbRole(.navTitle)
                .foregroundColor(BBColor.textPrimary)

            Spacer()

            BBPremiumPill()
        }
    }
}

private struct ColorTokenSection: View {
    let specs: [FoundationColorSpec]
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: BBSpacing.m) {
            SectionTitle("颜色提取")

            LazyVGrid(columns: columns, spacing: BBSpacing.s) {
                ForEach(specs) { spec in
                    ColorTokenCell(spec: spec)
                }
            }
        }
    }
}

private struct TypographyTokenSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: BBSpacing.m) {
            SectionTitle("排版提取")

            VStack(alignment: .leading, spacing: BBSpacing.s) {
                Text("首页")
                    .bbRole(.navTitle)
                Text("近期饮食")
                    .bbRole(.cardTitle)
                Text("酸菜鱼起源于四川民间，约在20世纪90年代流行开来。")
                    .bbRole(.body)
                Text("@BjMDQ0XFe5T")
                    .bbRole(.caption)
                Text("320")
                    .bbRole(.metric)
            }
            .foregroundColor(BBColor.textPrimary)
            .padding(BBSpacing.l)
            .background(BBSurfaceCard(radius: BBCornerRadius.lg, fill: BBColor.cardStrong))
            .bbCardShadow()
        }
    }
}

private struct SurfacePrimitiveSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: BBSpacing.m) {
            SectionTitle("基础表面组件")

            VStack(alignment: .leading, spacing: BBSpacing.s) {
                BBNeonPhotoFrame(radius: BBCornerRadius.md) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    BBColor.textTertiary.opacity(0.2),
                                    BBColor.textPrimary.opacity(0.45)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 210)
                        .overlay(alignment: .bottomLeading) {
                            Text("识别图像")
                                .bbRole(.bodyStrong)
                                .foregroundColor(BBColor.inverseText)
                                .padding(BBSpacing.l)
                        }
                }

                RoundedRectangle(cornerRadius: BBCornerRadius.sm, style: .continuous)
                    .fill(BBGradient.photoRing)
                    .frame(height: 18)
                    .overlay(
                        RoundedRectangle(cornerRadius: BBCornerRadius.sm, style: .continuous)
                            .stroke(BBColor.stroke.opacity(0.55), lineWidth: BBStroke.hairline)
                    )
            }
            .padding(BBSpacing.l)
            .background(BBSurfaceCard(radius: BBCornerRadius.lg))
            .bbCardShadow()
        }
    }
}

private struct BottomDockShowcase: View {
    var body: some View {
        ZStack(alignment: .trailing) {
            BBDockPlate()
                .frame(height: 72)
                .bbDockShadow()

            HStack(spacing: BBSpacing.xl) {
                dockIcon("house")
                dockIcon("cup.and.saucer")
                dockIcon("square.grid.2x2")
                dockIcon("gift")
            }
            .padding(.leading, BBSpacing.xxl)
            .padding(.trailing, 108)
            .frame(maxWidth: .infinity, alignment: .leading)

            BBFloatingPlusButton()
                .frame(width: 84, height: 84)
                .padding(.trailing, BBSpacing.xxs)
        }
    }

    private func dockIcon(_ symbol: String) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 26, weight: .regular))
            .foregroundColor(BBColor.textTertiary)
            .frame(width: 44, height: 44)
    }
}

// ============================================================
// MARK: - 小型原子
// ============================================================

private struct FoundationColorSpec: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

private struct ColorTokenCell: View {
    let spec: FoundationColorSpec

    var body: some View {
        VStack(alignment: .leading, spacing: BBSpacing.xs) {
            RoundedRectangle(cornerRadius: BBCornerRadius.sm, style: .continuous)
                .fill(spec.color)
                .overlay(
                    RoundedRectangle(cornerRadius: BBCornerRadius.sm, style: .continuous)
                        .stroke(BBColor.stroke.opacity(0.60), lineWidth: BBStroke.hairline)
                )
                .frame(height: 54)

            Text(spec.name)
                .bbRole(.caption)
                .foregroundColor(BBColor.textSecondary)
        }
        .padding(BBSpacing.xs)
        .background(BBSurfaceCard(radius: BBCornerRadius.md, fill: BBColor.cardStrong))
        .bbCardShadow()
    }
}

private struct SectionTitle: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .bbRole(.bodyStrong)
            .foregroundColor(BBColor.textPrimary)
    }
}

#Preview {
    NavigationStack {
        BellyBookFoundationPreview()
    }
    .environmentObject(ThemeStore())
}
