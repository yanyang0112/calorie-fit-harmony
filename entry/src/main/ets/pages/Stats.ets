import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { DailySummary } from '../model/DailySummary';
import { buildRecentSummaries } from '../store/SummaryStore';

@Entry
@Component
struct Stats {
  @State summaries: DailySummary[] = [];
  @State averageCalories: number = 0;
  @State successDays: number = 0;

  aboutToAppear(): void {
    this.loadData();
  }

  async loadData(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    this.summaries = await buildRecentSummaries(context, 7);
    const total = this.summaries.reduce((sum: number, item: DailySummary) => sum + item.totalCalories, 0);
    this.averageCalories = Math.round(total / 7);
    this.successDays = this.summaries.filter((item: DailySummary) => item.totalCalories <= item.target).length;
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .backgroundColor('#E7F6EF')
          .fontColor('#247B55')
          .onClick(() => router.back())
        Text('七日统计')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 18 })

      Row() {
        Column() {
          Text(`${this.averageCalories}`)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor('#39B980')
          Text('平均 kcal')
            .fontSize(13)
            .fontColor('#6B7280')
        }
        .layoutWeight(1)
        Column() {
          Text(`${this.successDays}`)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor('#39B980')
          Text('达标天数')
            .fontSize(13)
            .fontColor('#6B7280')
        }
        .layoutWeight(1)
      }
      .width('90%')
      .padding(18)
      .borderRadius(18)
      .backgroundColor('#FFFFFF')
      .margin({ bottom: 16 })

      List() {
        ForEach(this.summaries, (item: DailySummary) => {
          ListItem() {
            Column() {
              Row() {
                Text(item.date)
                  .fontSize(15)
                  .fontColor('#374151')
                  .layoutWeight(1)
                Text(`${item.totalCalories}/${item.target} kcal`)
                  .fontSize(15)
                  .fontColor(item.totalCalories <= item.target ? '#39B980' : '#EF4444')
              }
              .width('100%')
              Stack({ alignContent: Alignment.Start }) {
                Row()
                  .width('100%')
                  .height(8)
                  .borderRadius(4)
                  .backgroundColor('#E5E7EB')
                Row()
                  .width(`${Math.min(100, Math.round(item.totalCalories / item.target * 100))}%`)
                  .height(8)
                  .borderRadius(4)
                  .backgroundColor(item.totalCalories <= item.target ? '#39B980' : '#EF4444')
              }
              .width('100%')
              .height(8)
              .margin({ top: 10 })
            }
            .width('100%')
            .padding(16)
            .borderRadius(16)
            .backgroundColor('#FFFFFF')
            .margin({ bottom: 10 })
          }
        }, (item: DailySummary) => item.date)
      }
      .width('90%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6FFF9')
  }
}

