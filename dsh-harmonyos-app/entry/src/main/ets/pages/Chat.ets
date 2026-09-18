// Chat.ets
// DSH HarmonyOS Client - 全屏沉浸聊天页面
// 无底部 Tab，全屏沉浸式设计
// 参考文档: docs/chat-interface-spec.md

import { router } from '@kit.ArkUI';
import { mockMessages, mockModels, mockPermissionPresets } from '../model/DataModel';
import type { Message, ToolCall } from '../model/DataModel';

@Entry
@Component
struct ChatPage {
  @State sessionId: string = '';
  @State title: string = 'HarmonyOS NEXT 开发';
  @State model: string = 'mimo-v2.5';
  @State inputText: string = '';
  @State currentPermission: string = '工作区';
  @State showApproval: boolean = true;
  @State messages: Message[] = mockMessages;
  @State showModelMenu: boolean = false;
  @State showPermMenu: boolean = false;
  @State showMainMenu: boolean = false;
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    // 获取路由参数
    const params = router.getParams() as Record<string, string>;
    if (params) {
      this.sessionId = params['sessionId'] || '';
      this.title = params['title'] || 'HarmonyOS NEXT 开发';
      this.model = params['model'] || 'mimo-v2.5';
    }
  }

  build() {
    Column() {
      // 状态栏占位
      Row()
        .height(54)
        .width('100%')

      // 标题栏（沉浸光感 ULTRA_THIN）
      this.TitleBarBuilder()

      // 消息流区域
      this.MessageListBuilder()

      // 权限审批卡片（条件显示）
      if (this.showApproval) {
        this.ApprovalCardBuilder()
      }

      // 输入区域
      this.ComposerBuilder()

      // 统计栏
      Row() {
        Text('32 turns')
          .fontSize(12)
          .fontColor('#4a4a5a')
        Text(' · ')
          .fontSize(12)
          .fontColor('#4a4a5a')
        Text('1.2k steps')
          .fontSize(12)
          .fontColor('#4a4a5a')
        Text(' · ')
          .fontSize(12)
          .fontColor('#4a4a5a')
        Text('2.4s TTFT')
          .fontSize(12)
          .fontColor('#4a4a5a')
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding({ top: 8, bottom: 4 })

      // Home Indicator
      Row()
        .width(134)
        .height(5)
        .borderRadius(3)
        .backgroundColor('rgba(255,255,255,0.15)')
        .margin({ bottom: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0a0a0f')
  }

  // ===== 标题栏构建器 =====
  @Builder
  TitleBarBuilder() {
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
      Text(this.title)
        .fontSize(17)
        .fontWeight(600)
        .fontColor('#e8e8ed')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 菜单按钮
      Button() {
        SymbolGlyph($r('sys.symbol.ellipsis'))
          .fontSize(22)
          .fontColor(['#e8e8ed'])
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .backgroundColor('transparent')
      .onClick(() => {
        this.showMainMenu = !this.showMainMenu;
      })
    }
    .width('100%')
    .height(52)
    .padding({ left: 4, right: 4 })
    .backgroundColor('rgba(10,10,15,0.2)')
  }

  // ===== 消息列表构建器 =====
  @Builder
  MessageListBuilder() {
    List({ scroller: this.scroller }) {
      // 系统消息
      ListItem() {
        Row() {
          Text('新会话已创建 · ${this.model}')
            .fontSize(13)
            .fontColor('#5c5c6e')
            .backgroundColor('rgba(255,255,255,0.03)')
            .padding({ left: 14, right: 14, top: 4, bottom: 4 })
            .borderRadius(12)
            .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ top: 8, bottom: 8 })
      }

      // 消息列表
      ForEach(this.messages, (msg: Message) => {
        ListItem() {
          if (msg.role === 'user') {
            this.UserMessageBuilder(msg)
          } else if (msg.role === 'assistant') {
            this.AssistantMessageBuilder(msg)
          }
        }
      })
    }
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .onAppear(() => {
      // 滚动到底部
      this.scroller.scrollToPage(this.messages.length - 1);
    })
  }

  // ===== 用户消息构建器 =====
  @Builder
  UserMessageBuilder(msg: Message) {
    Row() {
      Blank()
      Text(msg.content)
        .fontSize(15)
        .fontColor('#e8e8ed')
        .lineHeight(22)
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .backgroundColor('#1e3a5f')
        .borderRadius(20)
        .borderTopRightRadius(4)
        .maxWidth('78%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .justifyContent(FlexAlign.End)
  }

  // ===== Assistant 消息构建器 =====
  @Builder
  AssistantMessageBuilder(msg: Message) {
    Row() {
      // 头像
      Column() {
        Text('🤖')
          .fontSize(14)
      }
      .width(30)
      .height(30)
      .borderRadius(15)
      .backgroundColor('linear-gradient(135deg, #4a9eff, #7c5cfc)')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 内容
      Column() {
        // 文字内容
        if (msg.content) {
          Text(msg.content)
            .fontSize(15)
            .fontColor('#e8e8ed')
            .lineHeight(23)
            .width('100%')
        }

        // 工具调用卡片
        if (msg.toolCalls && msg.toolCalls.length > 0) {
          ForEach(msg.toolCalls, (tc: ToolCall) => {
            this.ToolCallCardBuilder(tc)
          })
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .alignItems(VerticalAlign.Top)
  }

  // ===== 工具调用卡片构建器 =====
  @Builder
  ToolCallCardBuilder(tc: ToolCall) {
    Column() {
      // 工具头部
      Row() {
        // 类型图标
        Column() {
          Text(this.getToolIcon(tc.type))
            .fontSize(12)
        }
        .width(22)
        .height(22)
        .borderRadius(6)
        .backgroundColor(this.getToolBgColor(tc.type))
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        // 工具名称
        Text(tc.name)
          .fontSize(13)
          .fontWeight(500)
          .fontColor('#9898a6')
          .margin({ left: 8 })
      }
      .width('100%')

      // 文件路径
      if (tc.filePath) {
        Text(tc.filePath)
          .fontSize(12)
          .fontFamily('monospace')
          .fontColor('#5c5c6e')
          .margin({ top: 8 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
      }

      // 代码内容
      if (tc.content) {
        Scroll() {
          Text(tc.content)
            .fontSize(12)
            .fontFamily('monospace')
            .fontColor('#9898a6')
            .lineHeight(17)
            .padding(12)
            .backgroundColor('rgba(0,0,0,0.3)')
            .borderRadius(8)
            .width('100%')
        }
        .margin({ top: 8 })
        .scrollBar(BarState.Auto)
      }

      // 状态指示
      Row() {
        Circle()
          .width(6)
          .height(6)
          .fill('#34d399')
        Text(`已完成 · ${tc.duration ? tc.duration / 1000 : 0}s`)
          .fontSize(12)
          .fontColor('#34d399')
          .margin({ left: 6 })
      }
      .margin({ top: 8 })
    }
    .width('100%')
    .padding(14)
    .margin({ top: 10 })
    .backgroundColor('#151520')
    .borderRadius(12)
    .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
  }

  // ===== 权限审批卡片构建器 =====
  @Builder
  ApprovalCardBuilder() {
    Column() {
      // 头部
      Row() {
        Text('⚠️')
          .fontSize(14)
        Text('Agent 请求权限')
          .fontSize(13)
          .fontWeight(500)
          .fontColor('#fbbf24')
          .margin({ left: 8 })
      }
      .width('100%')

      // 操作描述
      Text('bash · hvigorw assembleHap')
        .fontSize(12)
        .fontFamily('monospace')
        .fontColor('#5c5c6e')
        .margin({ top: 8, bottom: 10 })

      // 操作按钮
      Row() {
        Blank()
        Button('拒绝')
          .fontSize(13)
          .fontColor('#9898a6')
          .backgroundColor('transparent')
          .border({ width: 1, color: 'rgba(255,255,255,0.1)' })
          .borderRadius(10)
          .height(32)
          .onClick(() => {
            this.showApproval = false;
          })
        Button('允许')
          .fontSize(13)
          .fontColor('#4a9eff')
          .backgroundColor('rgba(74,158,255,0.12)')
          .border({ width: 1, color: 'rgba(74,158,255,0.25)' })
          .borderRadius(10)
          .height(32)
          .margin({ left: 8 })
          .onClick(() => {
            this.showApproval = false;
          })
      }
      .width('100%')
    }
    .width('calc(100% - 24px)')
    .margin({ left: 12, right: 12, bottom: 8 })
    .padding(14)
    .backgroundColor('rgba(40,35,20,0.88)')
    .borderRadius(14)
    .border({ width: 1, color: 'rgba(251,191,36,0.15)' })
    .shadow({
      radius: 32,
      color: 'rgba(0,0,0,0.4)',
      offsetX: 0,
      offsetY: 8
    })
  }

  // ===== 输入区域构建器 =====
  @Builder
  ComposerBuilder() {
    Column() {
      // 输入框
      TextArea({ placeholder: '输入消息...', text: this.inputText })
        .fontSize(15)
        .fontColor('#e8e8ed')
        .placeholderColor('#5c5c6e')
        .backgroundColor('transparent')
        .border({ width: 0 })
        .padding({ left: 16, right: 16, top: 12, bottom: 4 })
        .layoutWeight(1)
        .height(42)
        .maxHeight(160)
        .onChange((value: string) => {
          this.inputText = value;
        })

      // 工具行
      Row() {
        // 左侧工具
        Row() {
          // 附加文件
          Button() {
            SymbolGlyph($r('sys.symbol.paperclip'))
              .fontSize(16)
              .fontColor(['#9898a6'])
          }
          .width(32)
          .height(32)
          .borderRadius(16)
          .backgroundColor('transparent')

          // 权限预设
          Button() {
            Text(this.currentPermission)
              .fontSize(13)
              .fontColor('#9898a6')
              .margin({ left: 4 })
          }
          .height(32)
          .borderRadius(16)
          .backgroundColor('rgba(255,255,255,0.05)')
          .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
          .onClick(() => {
            this.showPermMenu = !this.showPermMenu;
          })
        }
        .layoutWeight(1)

        // 右侧工具
        Row() {
          // 模型选择
          Button() {
            Text(this.model)
              .fontSize(13)
              .fontColor('#9898a6')
          }
          .height(32)
          .borderRadius(16)
          .backgroundColor('rgba(255,255,255,0.05)')
          .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
          .onClick(() => {
            this.showModelMenu = !this.showModelMenu;
          })

          // 上下文百分比
          Text('32%')
            .fontSize(12)
            .fontColor('#5c5c6e')
            .margin({ left: 8 })

          // 发送按钮
          Button() {
            SymbolGlyph($r('sys.symbol.arrow_up'))
              .fontSize(16)
              .fontColor(['#ffffff'])
          }
          .width(32)
          .height(32)
          .borderRadius(16)
          .backgroundColor(this.inputText.trim() ? '#4a9eff' : 'rgba(255,255,255,0.04)')
          .margin({ left: 8 })
          .onClick(() => {
            if (this.inputText.trim()) {
              this.sendMessage();
            }
          })
        }
      }
      .width('100%')
      .padding({ left: 8, right: 8, bottom: 8 })
    }
    .width('100%')
    .backgroundColor('rgba(20,20,28,0.82)')
    .borderRadius(20)
    .border({ width: 1, color: 'rgba(255,255,255,0.07)' })
    .margin({ left: 12, right: 12, bottom: 4 })
  }

  // ===== 工具方法 =====

  private getToolIcon(type: string): string {
    switch (type) {
      case 'read_file': return '📄';
      case 'write_file': return '✏️';
      case 'bash': return '💻';
      case 'search': return '🔍';
      default: return '🔧';
    }
  }

  private getToolBgColor(type: string): string {
    switch (type) {
      case 'read_file': return 'rgba(74,158,255,0.15)';
      case 'write_file': return 'rgba(52,211,153,0.15)';
      case 'bash': return 'rgba(167,139,250,0.15)';
      case 'search': return 'rgba(74,158,255,0.15)';
      default: return 'rgba(255,255,255,0.06)';
    }
  }

  private sendMessage(): void {
    const newMsg: Message = {
      id: `m${this.messages.length + 1}`,
      sessionId: this.sessionId,
      role: 'user',
      content: this.inputText.trim(),
      timestamp: new Date().toISOString()
    };
    this.messages.push(newMsg);
    this.inputText = '';

    // 模拟 Assistant 响应
    setTimeout(() => {
      const responseMsg: Message = {
        id: `m${this.messages.length + 1}`,
        sessionId: this.sessionId,
        role: 'assistant',
        content: '正在思考中...',
        timestamp: new Date().toISOString()
      };
      this.messages.push(responseMsg);
      this.scroller.scrollToPage(this.messages.length - 1);
    }, 800);
  }
}
