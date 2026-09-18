// ServerDetail.ets
// DSH HarmonyOS Client - 服务器详情页面

import { router } from '@kit.ArkUI';
import { mockServer, mockModels } from '../model/DataModel';
import type { ModelInfo } from '../model/DataModel';

@Entry
@Component
struct ServerDetailPage {
  @State currentTab: string = 'general';
  @State selectedModel: string = 'mimo-v2.5';

  build() {
    Column() {
      // 状态栏占位
      Row()
        .height(54)
        .width('100%')

      // 标题栏
      Row() {
        // 返回按钮
        Button() {
          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontSize(22)
            .fontColor(['#e8e8ed'])
        }
        .width(44)
        .height(44)
        .borderRadius(22)
        .backgroundColor('transparent')
        .onClick(() => {
          router.back();
        })

        // 标题
        Text('dsh-server 设置')
          .fontSize(17)
          .fontWeight(600)
          .fontColor('#e8e8ed')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 占位
        Row()
          .width(44)
      }
      .width('100%')
      .height(52)
      .padding({ left: 4, right: 4 })

      // 内容区（侧边导航 + 内容）
      Row() {
        // 侧边导航
        Column() {
          this.NavItem('⚙️', '通用', 'general')
          this.NavItem('📊', '模型', 'models')
          this.NavItem('🤖', 'Agent', 'agent')
        }
        .width(72)
        .height('100%')
        .backgroundColor('#121218')
        .border({ width: { right: 1 }, color: 'rgba(255,255,255,0.06)' })
        .padding({ top: 12 })

        // 内容区
        Scroll() {
          Column() {
            if (this.currentTab === 'general') {
              this.GeneralContent()
            } else if (this.currentTab === 'models') {
              this.ModelsContent()
            } else if (this.currentTab === 'agent') {
              this.AgentContent()
            }
          }
          .width('100%')
          .padding(16)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0a0a0f')
  }

  @Builder
  NavItem(icon: string, label: string, tabId: string) {
    Column() {
      Text(icon)
        .fontSize(20)
      Text(label)
        .fontSize(10)
        .fontColor(this.currentTab === tabId ? '#4a9eff' : '#9898a6')
        .margin({ top: 3 })
    }
    .width(56)
    .height(56)
    .borderRadius(14)
    .backgroundColor(this.currentTab === tabId ? 'rgba(74,158,255,0.12)' : 'transparent')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .margin({ left: 8, right: 8, bottom: 4 })
    .onClick(() => {
      this.currentTab = tabId;
    })
  }

  @Builder
  Card(title: string) {
    Column() {
      Text(title)
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#9898a6')
        .width('100%')
        .margin({ bottom: 10 })

      { ... }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#1a1a24')
    .borderRadius(14)
    .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
    .margin({ bottom: 12 })
  }

  @Builder
  DetailRow(label: string, value: string, valueColor: string = '#e8e8ed') {
    Row() {
      Text(label)
        .fontSize(13)
        .fontColor('#9898a6')
        .layoutWeight(1)

      Text(value)
        .fontSize(13)
        .fontColor(valueColor)
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
    .border({ width: { top: 1 }, color: 'rgba(255,255,255,0.06)' })
  }

  @Builder
  GeneralContent() {
    // 连接状态卡片
    Column() {
      Text('连接状态')
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#9898a6')
        .width('100%')
        .margin({ bottom: 10 })

      this.DetailRow('状态', '🟢 已连接', '#34d399')
      this.DetailRow('地址', mockServer.url)
      this.DetailRow('工作区', mockServer.workspace!)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#1a1a24')
    .borderRadius(14)
    .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
    .margin({ bottom: 12 })

    // 权限预设说明
    Column() {
      Text('权限预设')
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#9898a6')
        .width('100%')
        .margin({ bottom: 10 })

      Text('权限预设是每会话独立的设置，在对话界面的输入工具行中切换。')
        .fontSize(12)
        .fontColor('#4a4a5a')
        .lineHeight(17)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#1a1a24')
    .borderRadius(14)
    .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
  }

  @Builder
  ModelsContent() {
    // 当前模型卡片
    Column() {
      Text('当前模型')
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#9898a6')
        .width('100%')
        .margin({ bottom: 10 })

      this.DetailRow('模型', this.selectedModel, '#4a9eff')
      this.DetailRow('上下文窗口', '128K tokens')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#1a1a24')
    .borderRadius(14)
    .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
    .margin({ bottom: 12 })

    // 可用模型列表
    Column() {
      Text('可用模型')
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#9898a6')
        .width('100%')
        .margin({ bottom: 10 })

      ForEach(mockModels, (model: ModelInfo, index: number) => {
        Row() {
          // 选中指示器
          Column()
            .width(16)
            .height(16)
            .borderRadius(8)
            .border({ width: 1.5, color: this.selectedModel === model.id ? '#4a9eff' : 'rgba(255,255,255,0.1)' })
            .backgroundColor(this.selectedModel === model.id ? 'rgba(74,158,255,0.15)' : 'transparent')

          // 模型信息
          Column() {
            Text(model.name)
              .fontSize(14)
              .fontColor(this.selectedModel === model.id ? '#e8e8ed' : '#e8e8ed')
              .fontWeight(this.selectedModel === model.id ? 500 : 400)
            Text(model.description)
              .fontSize(11)
              .fontColor('#5c5c6e')
              .margin({ top: 2 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 10 })
        }
        .width('100%')
        .height(52)
        .onClick(() => {
          this.selectedModel = model.id;
        })

        if (index < mockModels.length - 1) {
          Divider()
            .color('rgba(255,255,255,0.06)')
        }
      })
    }
    .width('100%')
    .padding(14)
    .backgroundColor('#1a1a24')
    .borderRadius(14)
    .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
  }

  @Builder
  AgentContent() {
    // 当前 Agent 预设
    Column() {
      Text('当前 Agent 预设')
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#9898a6')
        .width('100%')
        .margin({ bottom: 10 })

      this.DetailRow('预设', 'Default', '#4a9eff')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#1a1a24')
    .borderRadius(14)
    .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
    .margin({ bottom: 12 })

    // 可用预设列表
    Column() {
      Text('可用预设')
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#9898a6')
        .width('100%')
        .margin({ bottom: 10 })

      // Default
      Row() {
        Column()
          .width(16)
          .height(16)
          .borderRadius(8)
          .border({ width: 1.5, color: '#4a9eff' })
          .backgroundColor('rgba(74,158,255,0.15)')
        Column() {
          Text('Default')
            .fontSize(14)
            .fontColor('#e8e8ed')
            .fontWeight(500)
          Text('平衡的通用预设')
            .fontSize(11)
            .fontColor('#5c5c6e')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 10 })
      }
      .width('100%')
      .height(52)

      Divider().color('rgba(255,255,255,0.06)')

      // Coder
      Row() {
        Column()
          .width(16)
          .height(16)
          .borderRadius(8)
          .border({ width: 1.5, color: 'rgba(255,255,255,0.1)' })
        Column() {
          Text('Coder')
            .fontSize(14)
            .fontColor('#e8e8ed')
          Text('代码优先，高权限')
            .fontSize(11)
            .fontColor('#5c5c6e')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 10 })
      }
      .width('100%')
      .height(52)

      Divider().color('rgba(255,255,255,0.06)')

      // Research
      Row() {
        Column()
          .width(16)
          .height(16)
          .borderRadius(8)
          .border({ width: 1.5, color: 'rgba(255,255,255,0.1)' })
        Column() {
          Text('Research')
            .fontSize(14)
            .fontColor('#e8e8ed')
          Text('只读分析，最小权限')
            .fontSize(11)
            .fontColor('#5c5c6e')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 10 })
      }
      .width('100%')
      .height(52)
    }
    .width('100%')
    .padding(14)
    .backgroundColor('#1a1a24')
    .borderRadius(14)
    .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
  }
}
