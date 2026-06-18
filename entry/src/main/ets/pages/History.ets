import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { FoodRecord } from '../model/FoodRecord';
import { formatDate, loadRecords } from '../store/FoodStore';
import { addDays } from '../store/SummaryStore';

@Entry
@Component
struct History {
  @State selectedDate: Date = new Date();
  @State records: FoodRecord[] = [];
  @State total: number = 0;

  aboutToAppear(): void {
    this.loadData();
  }

  async loadData(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    this.records = await loadRecords(context, this.selectedDate);
    this.total = this.records.reduce((sum: number, item: FoodRecord) => sum + item.calories, 0);
  }

  async moveDay(days: number): Promise<void> {
    this.selectedDate = addDays(this.selectedDate, days);
    if (days < 0) {
      await this.loadData();
    }
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .backgroundColor('#E7F6EF')
          .fontColor('#247B55')
          .onClick(() => router.back())
        Text('历史记录')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 18 })

      Row() {
        Button('前一天')
          .backgroundColor('#E7F6EF')
          .fontColor('#247B55')
          .onClick(() => this.moveDay(-1))
        Text(formatDate(this.selectedDate))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Button('后一天')
          .backgroundColor('#E7F6EF')
          .fontColor('#247B55')
          .onClick(() => this.moveDay(1))
      }
      .width('90%')
      .margin({ bottom: 14 })

      Column() {
        Text(`${this.total} kcal`)
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#39B980')
        Text(`共 ${this.records.length} 条记录`)
          .fontSize(14)
          .fontColor('#6B7280')
          .margin({ top: 4 })
      }
      .width('90%')
      .padding(18)
      .borderRadius(18)
      .backgroundColor('#FFFFFF')

      List() {
        ForEach(this.records, (item: FoodRecord) => {
          ListItem() {
            Row() {
              Column() {
                Text(item.name)
                  .fontSize(17)
                  .fontWeight(FontWeight.Medium)
                Text(item.mealType)
                  .fontSize(13)
                  .fontColor('#6B7280')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              Text(`${item.calories} kcal`)
                .fontSize(16)
                .fontColor('#39B980')
            }
            .width('100%')
            .padding(16)
            .borderRadius(16)
            .backgroundColor('#FFFFFF')
            .margin({ bottom: 10 })
          }
        }, (item: FoodRecord) => item.id)
      }
      .width('90%')
      .layoutWeight(1)
      .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6FFF9')
  }
}

