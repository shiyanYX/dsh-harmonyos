// Favorites.ets
// DSH HarmonyOS Client - 收藏页面（独立入口）

import { router } from '@kit.ArkUI';
import { mockFavorites } from '../model/DataModel';
import type { FavoriteRecord } from '../model/DataModel';

@Entry
@Component
struct FavoritesPage {
  build() {
    Column() {
      // 状态栏占位
      Row()
        .height(54)
        .width('100%')

      // 标题栏
      Row() {
        Text('⭐ 收藏')
          .fontSize(17)
          .fontWeight(600)
          .fontColor('#e8e8ed')
          .padding({ left: 20 })
      }
      .width('100%')
      .height(52)

      // 收藏列表
      Scroll() {
        Column() {
          // 分组标题
          Text('跨服务器收藏 · 2 项')
            .fontSize(12)
            .fontWeight(600)
            .fontColor('#4a4a5a')
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 8 })

          // 收藏列表卡片
          Column() {
            ForEach(mockFavorites, (fav: FavoriteRecord, index: number) => {
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
                  Text(fav.title)
                    .fontSize(14)
                    .fontColor('#e8e8ed')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(`${fav.serverName} · ${fav.model} · ${fav.turnCount} turns`)
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
                    sessionId: fav.sessionId,
                    title: fav.title,
                    model: fav.model
                  }
                });
              })

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
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0a0a0f')
  }
}
