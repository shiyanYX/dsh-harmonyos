// Index.ets
// DSH HarmonyOS Client - 主页面框架
// HdsNavigation + HdsTabs 沉浸光感框架
// 参考文档: harmonyos-guides/ui-design-hds-component-material
// 参考文档: best-practices/bpta-spatiality-immersive

import {
  HdsNavigation,
  HdsNavigationTitleMode,
  HdsTabs,
  HdsTabsController,
  hdsMaterial,
  ScrollEffectType
} from '@kit.UIDesignKit';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import { LengthMetrics } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

// ===== Tab 配置 =====
const TAB_CONFIG = [
  {
    label: '服务器',
    icon: 'sys.symbol.rectangle_grid_2x2',
    selectedIcon: 'sys.symbol.rectangle_grid_2x2_fill'
  },
  {
    label: '收藏',
    icon: 'sys.symbol.star',
    selectedIcon: 'sys.symbol.star_fill'
  },
  {
    label: '设置',
    icon: 'sys.symbol.gearshape',
    selectedIcon: 'sys.symbol.gearshape_fill'
  }
];

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @State currentTab: string = 'workspace';
  private controller: HdsTabsController = new HdsTabsController();

  build() {
    Column() {
      HdsNavigation() {
        // 内容区使用 Tabs
        HdsTabs({ controller: this.controller, barPosition: BarPosition.End }) {
          // Tab 0: 工作区
          TabContent() {
            WorkspacePage()
          }
          .tabBar(new BottomTabBarStyle(
            new SymbolGlyphModifier($r('sys.symbol.rectangle_grid_2x2'))
              .fontColor([$r('sys.color.ohos_id_color_bottom_tab_icon_off'),
                $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off02')]),
            new SymbolGlyphModifier($r('sys.symbol.rectangle_grid_2x2_fill'))
              .fontColor([$r('sys.color.ohos_id_color_activated'),
                $r('sys.color.ohos_id_color_primary_contrary')]),
            TAB_CONFIG[0].label
          ))

          // Tab 1: 收藏
          TabContent() {
            FavoritesPage()
          }
          .tabBar(new BottomTabBarStyle(
            new SymbolGlyphModifier($r('sys.symbol.star'))
              .fontColor([$r('sys.color.ohos_id_color_bottom_tab_icon_off'),
                $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off02')]),
            new SymbolGlyphModifier($r('sys.symbol.star_fill'))
              .fontColor([$r('sys.color.ohos_id_color_activated'),
                $r('sys.color.ohos_id_color_primary_contrary')]),
            TAB_CONFIG[1].label
          ))

          // Tab 2: 设置
          TabContent() {
            SettingsPage()
          }
          .tabBar(new BottomTabBarStyle(
            new SymbolGlyphModifier($r('sys.symbol.gearshape'))
              .fontColor([$r('sys.color.ohos_id_color_bottom_tab_icon_off'),
                $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off02')]),
            new SymbolGlyphModifier($r('sys.symbol.gearshape_fill'))
              .fontColor([$r('sys.color.ohos_id_color_activated'),
                $r('sys.color.ohos_id_color_primary_contrary')]),
            TAB_CONFIG[2].label
          ))
        }
        .onChange((index: number) => {
          this.currentIndex = index;
          if (index === 0) this.currentTab = 'workspace';
          else if (index === 1) this.currentTab = 'favorites';
          else if (index === 2) this.currentTab = 'settings';
        })
        .barOverlap(true)
        .vertical(false)
        .barPosition(BarPosition.End)
        .barFloatingStyle({
          barBottomMargin: 28,
          systemMaterialEffect: {
            materialType: hdsMaterial.MaterialType.IMMERSIVE,
            materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
          }
        })
      }
      .mode(NavigationMode.Stack)
      .titleBar({
        content: {
          title: {
            mainTitle: this.getTitle()
          }
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
      .hideBackButton(true)
      .titleMode(HdsNavigationTitleMode.MINI)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('100%')
  }

  // 根据当前 Tab 返回标题
  private getTitle(): string {
    switch (this.currentTab) {
      case 'workspace': return 'DSH · 服务器';
      case 'favorites': return '⭐ 收藏';
      case 'settings': return '⚙️ 应用设置';
      default: return 'DSH';
    }
  }
}

// ===== 工作区页面组件 =====
@Component
struct WorkspacePage {
  @State searchQuery: string = '';

  build() {
    Scroll() {
      Column() {
        // 搜索栏
        Row() {
          SymbolGlyph($r('sys.symbol.magnifyingglass'))
            .fontSize(16)
            .fontColor(['#5c5c6e'])
          Text('搜索会话...')
            .fontSize(14)
            .fontColor('#5c5c6e')
            .layoutWeight(1)
        }
        .width('100%')
        .height(46)
        .padding({ left: 14, right: 14 })
        .backgroundColor('rgba(255,255,255,0.05)')
        .borderRadius(12)
        .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
        .margin({ left: 12, right: 12, top: 8, bottom: 8 })

        // 会话分组列表
        ForEach(mockWorkspaces, (workspace: Workspace) => {
          SessionGroup({ workspace: workspace })
        })
      }
      .width('100%')
      .padding({ bottom: 100 })
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}

// ===== 会话分组组件 =====
@Component
struct SessionGroup {
  @Prop workspace!: Workspace;
  @State isExpanded: boolean = true;

  build() {
    Column() {
      // 分组标题
      Text(`${this.workspace.icon}  ${this.workspace.name}`)
        .fontSize(12)
        .fontWeight(600)
        .fontColor('#4a4a5a')
        .width('100%')
        .padding({ left: 20, right: 20, top: 16, bottom: 8 })

      // 会话列表卡片
      Column() {
        ForEach(this.workspace.sessions, (session: Session, index: number) => {
          SessionItem({ session: session })
          if (index < this.workspace.sessions.length - 1) {
            Divider()
              .color('rgba(255,255,255,0.06)')
          }
        })
      }
      .width('100%')
      .margin({ left: 12, right: 12 })
      .backgroundColor('#1a1a24')
      .borderRadius(14)
      .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
    }
    .width('100%')
    .margin({ bottom: 12 })
  }
}

// ===== 会话项组件 =====
@Component
struct SessionItem {
  @Prop session!: Session;

  build() {
    Row() {
      // 状态点
      Circle()
        .width(7)
        .height(7)
        .fill(this.session.status === 'active' ? '#34d399' : '#5c5c6e')

      // 会话信息
      Column() {
        Text(this.session.title)
          .fontSize(14)
          .fontColor('#e8e8ed')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
        Row() {
          Text(this.getTimeAgo())
            .fontSize(12)
            .fontColor('#5c5c6e')
          Text(' · ')
            .fontSize(12)
            .fontColor('#5c5c6e')
          Text(this.session.model)
            .fontSize(12)
            .fontColor('#5c5c6e')
        }
        .margin({ top: 2 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })

      // 收藏星标或消息数
      if (this.session.isFavorite) {
        Text('⭐')
          .fontSize(14)
      } else {
        Text(`${this.session.messageCount}`)
          .fontSize(11)
          .fontColor('#5c5c6e')
          .backgroundColor('rgba(255,255,255,0.04)')
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .borderRadius(8)
      }
    }
    .width('100%')
    .height(52)
    .padding({ left: 14, right: 14 })
    .onClick(() => {
      // 跳转到聊天页面
      router.pushUrl({
        url: 'pages/Chat',
        params: {
          sessionId: this.session.id,
          title: this.session.title,
          model: this.session.model
        }
      });
    })
  }

  private getTimeAgo(): string {
    const now = new Date();
    const updated = new Date(this.session.updatedAt);
    const diffMs = now.getTime() - updated.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMins / 60);
    const diffDays = Math.floor(diffHours / 24);

    if (diffMins < 1) return '刚刚';
    if (diffMins < 60) return `${diffMins} 分钟前`;
    if (diffHours < 24) return `${diffHours} 小时前`;
    return `${diffDays} 天前`;
  }
}

// ===== 收藏页面组件 =====
@Component
struct FavoritesPage {
  build() {
    Scroll() {
      Column() {
        // 分组标题
        Text('跨服务器收藏 · 2 项')
          .fontSize(12)
          .fontWeight(600)
          .fontColor('#4a4a5a')
          .width('100%')
          .padding({ left: 20, right: 20, top: 16, bottom: 8 })

        // 收藏列表
        Column() {
          ForEach(mockFavorites, (fav: FavoriteRecord, index: number) => {
            FavoriteItem({ favorite: fav })
            if (index < mockFavorites.length - 1) {
              Divider()
                .color('rgba(255,255,255,0.06)')
            }
          })
        }
        .width('100%')
        .margin({ left: 12, right: 12 })
        .backgroundColor('#1a1a24')
        .borderRadius(14)
        .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
      }
      .width('100%')
      .padding({ bottom: 100 })
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}

// ===== 收藏项组件 =====
@Component
struct FavoriteItem {
  @Prop favorite!: FavoriteRecord;

  build() {
    Row() {
      // 图标
      Column() {
        Text('📁')
          .fontSize(15)
      }
      .width(32)
      .height(32)
      .borderRadius(10)
      .backgroundColor('linear-gradient(135deg, #4a9eff, #7c5cfc)')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 信息
      Column() {
        Text(this.favorite.title)
          .fontSize(14)
          .fontColor('#e8e8ed')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(`${this.favorite.serverName} · ${this.favorite.model} · ${this.favorite.turnCount} turns`)
          .fontSize(12)
          .fontColor('#5c5c6e')
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })

      // 星标
      Text('⭐')
        .fontSize(16)
        .fontColor('#fbbf24')
    }
    .width('100%')
    .height(56)
    .padding({ left: 14, right: 14 })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/Chat',
        params: {
          sessionId: this.favorite.sessionId,
          title: this.favorite.title,
          model: this.favorite.model
        }
      });
    })
  }
}

// ===== 设置页面组件 =====
@Component
struct SettingsPage {
  build() {
    Scroll() {
      Column() {
        // 通用设置分组
        Text('通用')
          .fontSize(12)
          .fontWeight(600)
          .fontColor('#4a4a5a')
          .width('100%')
          .padding({ left: 20, right: 20, top: 16, bottom: 8 })

        Column() {
          SettingsItem({ icon: '🌐', iconBg: 'rgba(74,158,255,0.12)', label: '语言', value: '简体中文' })
          Divider().color('rgba(255,255,255,0.06)')
          SettingsItem({ icon: '🎨', iconBg: 'rgba(167,139,250,0.12)', label: '外观', value: '深色' })
          Divider().color('rgba(255,255,255,0.06)')
          SettingsItem({ icon: '🔤', iconBg: 'rgba(52,211,153,0.12)', label: '字体大小', value: '标准' })
        }
        .width('100%')
        .margin({ left: 12, right: 12 })
        .backgroundColor('#1a1a24')
        .borderRadius(14)
        .border({ width: 1, color: 'rgba(255,255,255,0.06)' })

        // 服务器连接分组
        Text('服务器连接')
          .fontSize(12)
          .fontWeight(600)
          .fontColor('#4a4a5a')
          .width('100%')
          .padding({ left: 20, right: 20, top: 16, bottom: 8 })

        Column() {
          ServerSettingsItem()
        }
        .width('100%')
        .margin({ left: 12, right: 12 })
        .backgroundColor('#1a1a24')
        .borderRadius(14)
        .border({ width: 1, color: 'rgba(255,255,255,0.06)' })

        // 关于分组
        Text('关于')
          .fontSize(12)
          .fontWeight(600)
          .fontColor('#4a4a5a')
          .width('100%')
          .padding({ left: 20, right: 20, top: 16, bottom: 8 })

        Column() {
          SettingsItem({ icon: 'ℹ️', iconBg: 'rgba(251,191,36,0.12)', label: '版本', value: '1.0.0 (Build 1)' })
          Divider().color('rgba(255,255,255,0.06)')
          SettingsItem({ icon: '📜', iconBg: 'rgba(239,68,68,0.12)', label: '开源许可', value: '›' })
        }
        .width('100%')
        .margin({ left: 12, right: 12 })
        .backgroundColor('#1a1a24')
        .borderRadius(14)
        .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
      }
      .width('100%')
      .padding({ bottom: 100 })
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}

// ===== 设置项组件 =====
@Component
struct SettingsItem {
  @Prop icon: string = '';
  @Prop iconBg: string = 'rgba(255,255,255,0.06)';
  @Prop label: string = '';
  @Prop value: string = '';

  build() {
    Row() {
      // 图标
      Column() {
        Text(this.icon)
          .fontSize(15)
      }
      .width(30)
      .height(30)
      .borderRadius(8)
      .backgroundColor(this.iconBg)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 标签
      Text(this.label)
        .fontSize(15)
        .fontColor('#e8e8ed')
        .layoutWeight(1)
        .margin({ left: 12 })

      // 值
      Text(this.value)
        .fontSize(13)
        .fontColor('#5c5c6e')

      // 箭头
      Text('›')
        .fontSize(16)
        .fontColor('#5c5c6e')
        .margin({ left: 4 })
    }
    .width('100%')
    .height(50)
    .padding({ left: 14, right: 14 })
  }
}

// ===== 服务器设置项组件 =====
@Component
struct ServerSettingsItem {
  build() {
    Row() {
      // 图标
      Column() {
        Text('🖥️')
          .fontSize(15)
      }
      .width(30)
      .height(30)
      .borderRadius(8)
      .backgroundColor('rgba(74,158,255,0.12)')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 标签
      Text('dsh-server')
        .fontSize(15)
        .fontColor('#e8e8ed')
        .layoutWeight(1)
        .margin({ left: 12 })

      // 连接状态
      Row() {
        Circle()
          .width(7)
          .height(7)
          .fill('#34d399')
        Text('已连接')
          .fontSize(13)
          .fontColor('#34d399')
          .margin({ left: 6 })
      }

      // 箭头
      Text('›')
        .fontSize(16)
        .fontColor('#5c5c6e')
        .margin({ left: 8 })
    }
    .width('100%')
    .height(50)
    .padding({ left: 14, right: 14 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/ServerDetail' });
    })
  }
}
