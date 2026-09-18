// Settings.ets
// DSH HarmonyOS Client - 设置页面（独立入口）

import { router } from '@kit.ArkUI';

@Entry
@Component
struct SettingsPage {
  build() {
    Column() {
      // 状态栏占位
      Row()
        .height(54)
        .width('100%')

      // 标题栏
      Row() {
        Text('⚙️ 应用设置')
          .fontSize(17)
          .fontWeight(600)
          .fontColor('#e8e8ed')
          .padding({ left: 20 })
      }
      .width('100%')
      .height(52)

      // 设置列表
      Scroll() {
        Column() {
          // 通用设置分组
          this.SectionHeader('通用')
          this.SettingsGroup() {
            this.SettingsItem({ icon: '🌐', iconBg: 'rgba(74,158,255,0.12)', label: '语言', value: '简体中文' })
            Divider().color('rgba(255,255,255,0.06)')
            this.SettingsItem({ icon: '🎨', iconBg: 'rgba(167,139,250,0.12)', label: '外观', value: '深色' })
            Divider().color('rgba(255,255,255,0.06)')
            this.SettingsItem({ icon: '🔤', iconBg: 'rgba(52,211,153,0.12)', label: '字体大小', value: '标准' })
          }

          // 服务器连接分组
          this.SectionHeader('服务器连接')
          this.SettingsGroup() {
            Row() {
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

              Text('dsh-server')
                .fontSize(15)
                .fontColor('#e8e8ed')
                .layoutWeight(1)
                .margin({ left: 12 })

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

          // 关于分组
          this.SectionHeader('关于')
          this.SettingsGroup() {
            this.SettingsItem({ icon: 'ℹ️', iconBg: 'rgba(251,191,36,0.12)', label: '版本', value: '1.0.0 (Build 1)' })
            Divider().color('rgba(255,255,255,0.06)')
            this.SettingsItem({ icon: '📜', iconBg: 'rgba(239,68,68,0.12)', label: '开源许可', value: '›' })
          }
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

  @Builder
  SectionHeader(title: string) {
    Text(title)
      .fontSize(12)
      .fontWeight(600)
      .fontColor('#4a4a5a')
      .width('100%')
      .padding({ left: 20, right: 20, top: 16, bottom: 8 })
  }

  @Builder
  SettingsGroup() {
    Column() {
      { ... }
    }
    .width('100%')
    .margin({ left: 12, right: 12 })
    .backgroundColor('#1a1a24')
    .borderRadius(14)
    .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
    .margin({ bottom: 12 })
  }

  @Builder
  SettingsItem(params: { icon: string, iconBg: string, label: string, value: string }) {
    Row() {
      Column() {
        Text(params.icon)
          .fontSize(15)
      }
      .width(30)
      .height(30)
      .borderRadius(8)
      .backgroundColor(params.iconBg)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Text(params.label)
        .fontSize(15)
        .fontColor('#e8e8ed')
        .layoutWeight(1)
        .margin({ left: 12 })

      Text(params.value)
        .fontSize(13)
        .fontColor('#5c5c6e')

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
