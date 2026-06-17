import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { loadDailyTarget, saveDailyTarget } from '../store/FoodStore';

@Entry
@Component
struct Settings {
  @State targetText: string = '1500';

  aboutToAppear(): void {
    this.loadTarget();
  }

  async loadTarget(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    this.targetText = `${await loadDailyTarget(context)}`;
  }

  async saveTarget(): Promise<void> {
    const target = Number(this.targetText);
    if (!target || target < 800 || target > 5000) {
      promptAction.showToast({ message: '请输入 800-5000 之间的目标热量' });
      return;
    }

    const context = getContext(this) as common.UIAbilityContext;
    await saveDailyTarget(context, target);
    promptAction.showToast({ message: '目标已保存' });
    router.back();
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .backgroundColor('#E7F6EF')
          .fontColor('#247B55')
          .onClick(() => router.back())
        Text('减脂目标')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 22 })

      Column() {
        Text('每日目标热量')
          .fontSize(16)
          .fontColor('#374151')
          .width('100%')
        TextInput({ placeholder: '1500', text: this.targetText })
          .type(InputType.Number)
          .height(48)
          .margin({ top: 8, bottom: 10 })
          .onChange((value: string) => {
            this.targetText = value;
          })

        Text('建议根据身高、体重、运动量设置。这里先提供一个简单本地配置。')
          .fontSize(13)
          .fontColor('#6B7280')
          .width('100%')
          .margin({ bottom: 26 })

        Button('保存目标')
          .width('100%')
          .height(50)
          .backgroundColor('#111827')
          .fontColor('#FFFFFF')
          .onClick(() => this.saveTarget())
      }
      .width('90%')
      .padding(20)
      .borderRadius(20)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6FFF9')
  }
}

