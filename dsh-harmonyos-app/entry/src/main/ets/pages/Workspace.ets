// Workspace.ets
// DSH HarmonyOS Client - 工作区页面（独立入口）
// 实际使用时从 Index.ets 的 Tab 中加载

import { router } from '@kit.ArkUI';
import { mockWorkspaces } from '../model/DataModel';
import type { Workspace, Session } from '../model/DataModel';

@Entry
@Component
struct WorkspacePage {
  @State searchQuery: string = '';

  build() {
    Column() {
      // 状态栏占位
      Row()
        .height(54)
        .width('100%')

      // 标题栏
      Row() {
        Text('DSH · 服务器')
          .fontSize(17)
          .fontWeight(600)
          .fontColor('#e8e8ed')
          .padding({ left: 20 })
      }
      .width('100%')
      .height(52)
      .backgroundColor('rgba(10,10,15,0.2)')

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

      // 会话列表
      Scroll() {
        Column() {
          ForEach(mockWorkspaces, (workspace: Workspace) => {
            // 分组标题
            Text(`${workspace.icon}  ${workspace.name}`)
              .fontSize(12)
              .fontWeight(600)
              .fontColor('#4a4a5a')
              .width('100%')
              .padding({ left: 20, right: 20, top: 16, bottom: 8 })

            // 会话列表卡片
            Column() {
              ForEach(workspace.sessions, (session: Session, index: number) => {
                Row() {
                  Circle()
                    .width(7)
                    .height(7)
                    .fill(session.status === 'active' ? '#34d399' : '#5c5c6e')

                  Column() {
                    Text(session.title)
                      .fontSize(14)
                      .fontColor('#e8e8ed')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Row() {
                      Text(this.getTimeAgo(session.updatedAt))
                        .fontSize(12)
                        .fontColor('#5c5c6e')
                      Text(' · ')
                        .fontSize(12)
                        .fontColor('#5c5c6e')
                      Text(session.model)
                        .fontSize(12)
                        .fontColor('#5c5c6e')
                    }
                    .margin({ top: 2 })
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 10 })

                  if (session.isFavorite) {
                    Text('⭐')
                      .fontSize(14)
                  } else {
                    Text(`${session.messageCount}`)
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
                  router.pushUrl({
                    url: 'pages/Chat',
                    params: {
                      sessionId: session.id,
                      title: session.title,
                      model: session.model
                    }
                  });
                })

                if (index < workspace.sessions.length - 1) {
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
            .margin({ bottom: 12 })
          })
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

  private getTimeAgo(updatedAt: string): string {
    const now = new Date();
    const updated = new Date(updatedAt);
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
