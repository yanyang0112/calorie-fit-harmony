import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { UserGoal } from '../model/UserGoal';
import { loadUserGoal, saveUserGoal } from '../store/GoalStore';

@Entry
@Component
struct GoalProfile {
  @State currentWeight: string = '70';
  @State targetWeight: string = '62';
  @State dailyTarget: string = '1500';

  aboutToAppear(): void {
    this.loadData();
  }

  async loadData(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    const goal = await loadUserGoal(context);
    this.currentWeight = `${goal.currentWeight}`;
    this.targetWeight = `${goal.targetWeight}`;
    this.dailyTarget = `${goal.dailyTarget}`;
  }

  async save(): Promise<void> {
    const current = Number(this.currentWeight);
    const target = Number(this.targetWeight);
    const calories = Number(this.dailyTarget);

    if (!current || !target || !calories) {
      promptAction.showToast({ message: '请完整填写目标信息' });
      return;
    }

    const goal: UserGoal = {
      currentWeight: current,
      targetWeight: target,
      dailyTarget: calories,
      startDate: ''
    };

    const context = getContext(this) as common.UIAbilityContext;
    await saveUserGoal(context, goal);
    promptAction.showToast({ message: '目标档案已保存' });
    router.back();
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .backgroundColor('#E7F6EF')
          .fontColor('#247B55')
          .onClick(() => router.back())
        Text('目标档案')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 18 })

      Column() {
        Text('当前体重 kg')
          .fontSize(15)
          .width('100%')
        TextInput({ placeholder: '70', text: this.currentWeight })
          .type(InputType.Number)
          .height(48)
          .margin({ top: 8, bottom: 16 })
          .onChange((value: string) => this.currentWeight = value)

        Text('目标体重 kg')
          .fontSize(15)
          .width('100%')
        TextInput({ placeholder: '62', text: this.targetWeight })
          .type(InputType.Number)
          .height(48)
          .margin({ top: 8, bottom: 16 })
          .onChange((value: string) => this.targetWeight = value)

        Text('每日目标热量 kcal')
          .fontSize(15)
          .width('100%')
        TextInput({ placeholder: '1500', text: this.dailyTarget })
          .type(InputType.Number)
          .height(48)
          .margin({ top: 8, bottom: 24 })
          .onChange((value: string) => this.dailyTarget = value)

        Button('保存档案')
          .width('100%')
          .height(50)
          .backgroundColor('#111827')
          .fontColor('#FFFFFF')
          .onClick(() => this.save())
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

