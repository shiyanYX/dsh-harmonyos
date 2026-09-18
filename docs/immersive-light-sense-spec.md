# DSH HarmonyOS Client — 沉浸光感组件设计规格

> 本文档基于 HarmonyOS 6.1.0(23)+ 官方文档调研，固化了 DSH HarmonyOS 客户端所有沉浸光感组件的样式规划，作为 ArkTS/ArkUI 开发的视觉规范参考。

---

## 1. 材质体系总览

### 1.1 材质类型 (MaterialType)

| 枚举值 | 名称 | 说明 |
|--------|------|------|
| 0 | NONE | 无材质效果 |
| 100 | ADAPTIVE | 自适应系统材质（**推荐**） |
| 101 | IMMERSIVE | 沉浸式材质（6.1.0(23)+ 新增，更高质量） |

### 1.2 材质等级 (MaterialLevel)

| 枚举值 | 名称 | 说明 | 适用设备 |
|--------|------|------|---------|
| 0 | EXQUISITE | 精美，完整效果 | 高算力设备 |
| 1 | GENTLE | 轻柔，平衡效果与性能 | 中算力设备 |
| 2 | SMOOTH | 流畅，轻量级效果 | 低算力设备 |
| 10 | ADAPTIVE | 系统自适应（**推荐**） | 所有设备 |

### 1.3 材质样式（5 级透明度）

| 样式 | 透明度 | 说明 | 适用场景 |
|------|--------|------|---------|
| **ULTRA_THIN** | 极高 | 材质层具有很强的透明效果 | 浮动工具栏、导航标题栏 |
| **THIN** | 高 | 材质层具有较强的透明效果 | 搜索框、底部页签 |
| **REGULAR** | 中 | 材质层厚度常规 | 通用场景 |
| **THICK** | 低 | 模糊效果强 | 菜单 |
| **ULTRA_THICK** | 极低 | 模糊效果很强 | 弹窗 |

---

## 2. 视觉特性清单

| 特性 | 鸿蒙说明 | CSS 模拟方式 |
|------|---------|-------------|
| **通透材质** | 毛玻璃背景，内容透过材质层自然透出 | `backdrop-filter:blur() saturate()` |
| **渐变模糊** | 标题栏随页面滑动产生渐变模糊效果 | 滚动监听 + 动态调整 blur 值 |
| **按压弹性反馈** | 按压时产生弹性缩放动画 | `transition:transform 0.18s cubic-bezier(0.34,1.56,0.64,1)` + `:active{transform:scale(0.88)}` |
| **按压点光源** | 按压时在触点位置产生光晕扩散 | `::after` + `radial-gradient(circle, rgba(color, 0.2))` + 脉冲动画 |
| **材质流光** | 组件表面呈现微妙的流光效果 | `::before` 渐变边框伪元素 + 脉冲动画 |
| **智能反色** | 文字随底层内容自动调整颜色 | 深色背景上用亮色文字确保可读性 |

---

## 3. 空间动效清单

| 动效类型 | 说明 | 适用组件 | CSS 模拟方式 |
|---------|------|---------|-------------|
| **非线性形变** | 光影形体的动态蜕变，打破规整边界 | AlertDialog、CustomDialog、ActionSheet、菜单 | `@keyframes` + `translateY` + `scale` + 弹性曲线 |
| **边缘流光** | 流光塑造视觉焦点与层级秩序 | AlertDialog、CustomDialog、菜单 | `::before` 渐变边框 + 脉冲动画 |
| **粒子动画** | 粒子光点传递信息变化 | Slider | 暂不涉及 |

---

## 4. 组件→材质映射表

### 4.1 导航类组件

| 组件 | 鸿蒙组件 | 材质样式 | 特殊效果 | 实现要点 |
|------|---------|---------|---------|---------|
| **标题栏** | `HdsNavigation` MINI mode | ULTRA_THIN | 渐变模糊 + 智能反色 | `titleBar({ style: { scrollEffectOpts: { enableScrollEffect: true, scrollEffectType: ScrollEffectType.IMMERSIVE_GRADIENT_BLUR }, systemMaterialEffect: { materialType: hdsMaterial.MaterialType.IMMERSIVE, materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE } } })` |
| **底部悬浮 Tab** | `HdsTabs` | THIN | 悬浮胶囊 + 按压点光源 | `barOverlap(true).vertical(false).barPosition(BarPosition.End).barFloatingStyle({ barBottomMargin: 28, systemMaterialEffect: { materialType: hdsMaterial.MaterialType.IMMERSIVE, materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE } })` |
| **搜索栏** | `Search` (组件级 systemMaterial) | THIN | 通透背景 | 通过 `systemMaterial` 通用属性设置 |

### 4.2 弹窗类组件

| 组件 | 鸿蒙组件 | 材质样式 | 特殊效果 | 实现要点 |
|------|---------|---------|---------|---------|
| **权限下拉菜单** | `Menu` + `promptAction.openMenu` | THICK | 非线性形变 + 边缘流光 | 菜单组件自动获得沉浸光感 |
| **模型下拉菜单** | `Menu` + `promptAction.openMenu` | THICK | 非线性形变 + 边缘流光 | 同上 |
| **⋯ 主菜单** | `Menu` + `promptAction.openMenu` | THICK | 非线性形变 + 边缘流光 | 同上 |
| **工具确认弹窗** | `CustomDialog` / `AlertDialog` | ULTRA_THICK | 非线性形变 + 边缘流光 | 弹窗组件自动获得沉浸光感 |

### 4.3 按钮与选择类组件

| 组件 | 鸿蒙组件 | 材质样式 | 特殊效果 | 实现要点 |
|------|---------|---------|---------|---------|
| **发送按钮** | `Button` | — | 按压弹性 + 点光源脉冲 | `hdsEffect.PointLight` 或自定义动画 |
| **工具行按钮** | `Button` | THIN | 按压弹性反馈 | `hdsEffect.PressElastic` |
| **权限切换** | `Select` / 自定义 | THIN | 按压弹性 | `hdsEffect.PressElastic` |

### 4.4 其余组件

| 组件 | 鸿蒙组件 | 材质样式 | 特殊效果 | 实现要点 |
|------|---------|---------|---------|---------|
| **输入卡片** | `Column` + systemMaterial | REGULAR | 通透边框 | 通过 `systemMaterial` 通用属性设置（仅在 Navigation 标题栏或底部 TabBar 中生效） |
| **消息气泡** | `Column` / `Text` | — | 按压阴影 | `hdsEffect.PressShadow` |
| **FAB 按钮** | `Button` | — | 点光源脉冲 | 自定义动画或 `hdsEffect.PointLight` |

---

## 5. 标题栏详细规格

### 5.1 HdsNavigation MINI 模式（最常用）

**结构**：返回按钮（左）+ 标题文字（中）+ 菜单图标（右）

**关键理解**：标题栏**不是**占满整行的实心条，而是按钮+文字组合**浮在内容上方**。ULTRA_THIN 材质层几乎不可见，视觉重心在交互元素上。

**沉浸光感配置**：
```typescript
HdsNavigation()
  .titleBar({
    content: {
      title: {
        mainTitle: 'DSH · 服务器',
      },
      menu: { /* 菜单项 */ }
    },
    style: {
      scrollEffectOpts: {
        enableScrollEffect: true,
        scrollEffectType: ScrollEffectType.IMMERSIVE_GRADIENT_BLUR,
        blurEffectiveStartOffset: LengthMetrics.vp(0),
        blurEffectiveEndOffset: LengthMetrics.vp(20)
      },
      systemMaterialEffect: {
        materialType: hdsMaterial.MaterialType.IMMERSIVE,
        materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
      }
    },
    avoidLayoutSafeArea: false,
    enableComponentSafeArea: false
  })
  .bindToScrollable([scroller])
  .hideBackButton(false)
  .titleMode(HdsNavigationTitleMode.MINI)
  .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
```

### 5.2 标题栏滚动效果

- `ScrollEffectType.IMMERSIVE_GRADIENT_BLUR`：标题文字和图标从白色到黑色线性过渡（6.1.0(23)+ 推荐）
- `ScrollEffectType.GRADIENT_BLUR`：普通渐变模糊（非沉浸式列表场景）
- `blurEffectiveStartOffset` / `blurEffectiveEndOffset`：控制模糊过渡的起止位置

---

## 6. 底部悬浮 Tab 详细规格

### 6.1 悬浮样式生效条件（三条件缺一不可）

1. `barOverlap(true)` — 内容延伸到 Tab 栏后方
2. `vertical(false)` — 水平排列
3. `barPosition(BarPosition.End)` — 底部

### 6.2 沉浸光感配置

```typescript
HdsTabs({ controller: this.controller })
  .barOverlap(true)
  .vertical(false)
  .barPosition(BarPosition.End)
  .barFloatingStyle({
    barBottomMargin: 28,  // 悬浮间距
    systemMaterialEffect: {
      materialType: hdsMaterial.MaterialType.IMMERSIVE,
      materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
    }
  })
```

### 6.3 注意事项

- 设置悬浮材质后，**不建议**再通过 `barBackgroundColor`、`barBackgroundBlurStyle` 为 TabBar 设置背景色或背景模糊，避免遮挡材质效果
- TabContent **不支持**设置沉浸光感
- `barBottomMargin` 需要考虑 Home Indicator 高度（`globalInfoModel.naviIndicatorHeight`）

---

## 7. 菜单与弹窗详细规格

### 7.1 菜单（THICK 材质 + 非线性形变 + 边缘流光）

菜单组件通过 `promptAction.openMenu` 或 `Menu` 组件触发时，自动获得沉浸光感效果。

**视觉效果**：
- 材质：THICK 级别，强模糊背景
- 弹出：非线性形变动画（translateY + scale + 弹性曲线）
- 边框：边缘流光效果（渐变边框 + 脉冲动画）

### 7.2 工具确认弹窗（ULTRA_THICK 材质 + 非线性形变 + 边缘流光）

**视觉效果**：
- 材质：ULTRA_THICK 级别，几乎完全遮挡背景
- 弹出：非线性形变动画（更大幅度的 translateY + scale）
- 边框：暖色调边缘流光（工具确认场景）

---

## 8. 按钮交互详细规格

### 8.1 按压弹性反馈

```css
/* CSS 模拟 */
transition: transform 0.18s cubic-bezier(0.34, 1.56, 0.64, 1);
&:active { transform: scale(0.88); }
```

鸿蒙原生实现：`hdsEffect.PressElastic`

### 8.2 按压点光源

```css
/* CSS 模拟 */
&::after {
  content: '';
  position: absolute;
  inset: -4px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(74,158,255,0.2) 0%, transparent 70%);
  animation: pointLight 2s ease-in-out infinite;
}
@keyframes pointLight {
  0%, 100% { opacity: 0.5; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.15); }
}
```

鸿蒙原生实现：`hdsEffect.PointLight`

---

## 9. 原型文件对照

| 原型文件 | 说明 |
|---------|------|
| `dsh-harmonyos-prototype.html` | 完整 5 屏仿真（Workspace / Favorites / Settings / Server Detail / Chat），已应用全部沉浸光感样式 |
| `prototype-chat.html` | 早期聊天界面原型（完整版，含菜单） |
| `prototype-chat-slim.html` | 早期聊天界面原型（精简版） |

---

## 10. 待办事项

- [ ] 在 ArkTS 中实现 `HdsNavigation` + `HdsTabs` 的沉浸光感配置
- [ ] 实现菜单的非线性形变 + 边缘流发动效
- [ ] 实现工具确认弹窗的 ULTRA_THICK 材质效果
- [ ] 实现按钮的按压弹性 + 点光源反馈
- [ ] 测试不同设备算力下的材质降级策略
- [ ] 适配 Tablet 横屏布局（Split 模式）

---

## 参考文档

| 文档 | doc_id |
|------|--------|
| HdsNavigation API | `harmonyos-references/ui-design-hdsnavigation` |
| HdsTabs API | `harmonyos-references/ui-design-hdstabs` |
| hdsMaterial API | `harmonyos-references/ui-design-hdsmaterial` |
| 沉浸光感简介 | `harmonyos-guides/arkts-immersive-light-sense-overview` |
| 组件适配沉浸光感 | `harmonyos-guides/arkts-immersive-light-sense-component-adaptation` |
| 沉浸式系统材质视效 | `harmonyos-guides/arkts-immersive-light-sense-common-capability` |
| HDS 沉浸光感材质 | `harmonyos-guides/ui-design-hds-component-material` |
| 沉浸光感空间化最佳实践 | `best-practices/bpta-spatiality-immersive` |
| HdsNavigation 与 HdsTabs 沉浸光感 FAQ | `harmonyos-faqs/faqs-arkui-1095` |
