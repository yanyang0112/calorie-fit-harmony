import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { FoodTemplate } from '../model/FoodTemplate';
import { FoodRecord } from '../model/FoodRecord';
import { addRecord, formatDate } from '../store/FoodStore';
import { addTemplate, loadTemplates } from '../store/TemplateStore';

@Entry
@Component
struct Templates {
  @State templates: FoodTemplate[] = [];
  @State name: string = '';
  @State calories: string = '';

  aboutToAppear(): void {
    this.loadData();
  }

  async loadData(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    this.templates = await loadTemplates(context);
  }

  async quickAdd(template: FoodTemplate): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    const record: FoodRecord = {
      id: template.id,
      name: template.name,
      calories: template.calories,
      mealType: template.mealType,
      date: formatDate(new Date())
    };
    await addRecord(context, record);
    promptAction.showToast({ message: '已加入今日记录' });
  }

  async createTemplate(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    const value = Number(this.calories);
    if (!this.name || !value) {
      promptAction.showToast({ message: '请填写食物和热量' });
      return;
    }

    await addTemplate(context, {
      id: `${this.name}_${Date.now()}`,
      name: this.name,
      calories: value,
      mealType: '加餐'
    });
    this.name = '';
    this.calories = '';
    await this.loadData();
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .backgroundColor('#E7F6EF')
          .fontColor('#247B55')
          .onClick(() => router.back())
        Text('常用食物')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 18 })

      Column() {
        Text('新增模板')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('100%')
        TextInput({ placeholder: '食物名称', text: this.name })
          .height(44)
          .margin({ top: 10 })
          .onChange((value: string) => this.name = value)
        TextInput({ placeholder: '热量 kcal', text: this.calories })
          .type(InputType.Number)
          .height(44)
          .margin({ top: 10, bottom: 12 })
          .onChange((value: string) => this.calories = value)
        Button('保存为常用食物')
          .width('100%')
          .height(44)
          .backgroundColor('#111827')
          .fontColor('#FFFFFF')
          .onClick(() => this.createTemplate())
      }
      .width('90%')
      .padding(16)
      .borderRadius(18)
      .backgroundColor('#FFFFFF')
      .margin({ bottom: 16 })

      List() {
        ForEach(this.templates, (item: FoodTemplate) => {
          ListItem() {
            Row() {
              Column() {
                Text(item.name)
                  .fontSize(17)
                  .fontWeight(FontWeight.Medium)
                Text(`${item.mealType} · ${item.calories} kcal`)
                  .fontSize(13)
                  .fontColor('#6B7280')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              Button('加入今日')
                .fontSize(13)
                .backgroundColor('#E7F6EF')
                .fontColor('#247B55')
                .onClick(() => this.quickAdd(item))
            }
            .width('100%')
            .padding(16)
            .borderRadius(16)
            .backgroundColor('#FFFFFF')
            .margin({ bottom: 10 })
          }
        }, (item: FoodTemplate) => item.id)
      }
      .width('90%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6FFF9')
  }
}

