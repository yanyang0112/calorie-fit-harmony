import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { FoodRecord, MEAL_TYPES } from '../model/FoodRecord';
import { addRecord, formatDate } from '../store/FoodStore';

@Entry
@Component
struct AddFood {
  @State foodName: string = '';
  @State calorieText: string = '';
  @State mealType: string = '早餐';

  async save(): Promise<void> {
    const calories = Number(this.calorieText);

    if (this.foodName.length > 40) {
      promptAction.showToast({ message: '食物名称太长' });
      return;
    }

    const record: FoodRecord = {
      id: `${Date.now()}`,
      name: this.foodName,
      calories: calories,
      mealType: this.mealType,
      date: formatDate(new Date())
    };

    const context = getContext(this) as common.UIAbilityContext;
    await addRecord(context, record);
    promptAction.showToast({ message: '已保存' });
    router.back();
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .backgroundColor('#E7F6EF')
          .fontColor('#247B55')
          .onClick(() => router.back())
        Text('添加饮食')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 22 })

      Column() {
        Text('食物名称')
          .fontSize(15)
          .fontColor('#374151')
          .width('100%')
        TextInput({ placeholder: '例如：鸡胸肉沙拉', text: this.foodName })
          .height(48)
          .margin({ top: 8, bottom: 18 })
          .onChange((value: string) => {
            this.foodName = value;
          })

        Text('热量 kcal')
          .fontSize(15)
          .fontColor('#374151')
          .width('100%')
        TextInput({ placeholder: '例如：320', text: this.calorieText })
          .type(InputType.Number)
          .height(48)
          .margin({ top: 8, bottom: 18 })
          .onChange((value: string) => {
            this.calorieText = value;
          })

        Text('餐次')
          .fontSize(15)
          .fontColor('#374151')
          .width('100%')
          .margin({ bottom: 8 })
        Row() {
          ForEach(MEAL_TYPES, (meal: string) => {
            Button(meal)
              .fontSize(14)
              .fontColor(this.mealType === meal ? '#FFFFFF' : '#247B55')
              .backgroundColor(this.mealType === meal ? '#39B980' : '#E7F6EF')
              .margin({ right: 8 })
              .onClick(() => {
                this.mealType = meal;
              })
          })
        }
        .width('100%')
        .margin({ bottom: 28 })

        Button('保存记录')
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
