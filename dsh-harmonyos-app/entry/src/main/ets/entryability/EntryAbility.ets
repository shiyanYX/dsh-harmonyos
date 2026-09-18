// EntryAbility.ets
// DSH HarmonyOS Client - 应用入口
// 参考文档: harmonyos-guides/start-with-ets-stage

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, TAG, 'onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, 'onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(0x0000, TAG, 'onWindowStageCreate');

    // 设置沉浸式状态栏
    windowStage.getMainWindow().then((win: window.Window) => {
      // 设置状态栏为透明、沉浸式
      const sysBarProps: window.SystemBarProperties = {
        statusBarColor: '#00000000',
        statusBarContentColor: '#e8e8ed',
        navigationBarColor: '#00000000',
        navigationBarContentColor: '#e8e8ed'
      };
      win.setWindowSystemBarProperties(sysBarProps);

      // 设置全屏沉浸式
      win.setWindowLayoutFullScreen(true);
    }).catch((err: Error) => {
      hilog.error(0x0000, TAG, `Failed to set window properties: ${err.message}`);
    });

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, TAG, `Failed to load content: ${err.message}`);
        return;
      }
      hilog.info(0x0000, TAG, 'Content loaded successfully');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, TAG, 'onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(0x0000, TAG, 'onForeground');
  }

  onBackground(): void {
    hilog.info(0x0000, TAG, 'onBackground');
  }
}
