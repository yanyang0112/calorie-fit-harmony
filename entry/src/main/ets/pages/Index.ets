import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { FoodRecord } from '../model/FoodRecord';
import { deleteRecord, formatDate, loadDailyTarget, loadRecords } from '../store/FoodStore';

@Entry
@Component
struct Index {
  @State records: FoodRecord[] = [];
  @State todayTotal: number = 0;
  @State dailyTarget: number = 1500;
  @State selectedDate: Date = new Date();

  aboutToAppear(): void {
    this.loadPageData();
  }

  onPageShow(): void {
    this.loadRecordsOnly();
  }

  async loadPageData(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    this.dailyTarget = await loadDailyTarget(context);
    await this.loadRecordsOnly();
  }

  async loadRecordsOnly(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    this.records = await loadRecords(context, this.selectedDate);
    this.todayTotal = this.records.reduce((sum: number, item: FoodRecord) => sum + item.calories, 0);
  }

  async removeRecord(id: string): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    await deleteRecord(context, this.selectedDate, id);
    this.records = this.records.filter((item: FoodRecord) => item.id !== id);
    this.todayTotal = this.records.reduce((sum: number, item: FoodRecord) => sum + item.calories, 0);
  }

  build() {
    Column() {
      Row() {
        Text('轻卡减脂')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202124')
        Blank()
        Button('设置')
          .fontSize(14)
          .backgroundColor('#E7F6EF')
          .fontColor('#247B55')
          .onClick(() => router.pushUrl({ url: 'pages/Settings' }))
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18 })

      Text(formatDate(this.selectedDate))
        .fontSize(14)
        .fontColor('#6B7280')
        .margin({ top: 4, bottom: 12 })
        .width('100%')
        .padding({ left: 20 })

      Column() {
        Text('今日摄入')
          .fontSize(15)
          .fontColor('#FFFFFF')
        Text(`${this.todayTotal} / ${this.dailyTarget} kcal`)
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .margin({ top: 8 })
        Text(`剩余 ${this.dailyTarget - this.todayTotal} kcal`)
          .fontSize(18)
          .fontColor('#E8FFF3')
          .margin({ top: 6 })
      }
      .width('90%')
      .padding(22)
      .borderRadius(24)
      .backgroundColor('#39B980')

      Row() {
        Button('添加饮食记录')
          .width('90%')
          .height(48)
          .backgroundColor('#111827')
          .fontColor('#FFFFFF')
          .onClick(() => router.pushUrl({ url: 'pages/AddFood' }))
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 18, bottom: 10 })

      Grid() {
        GridItem() {
          Button('历史')
            .width('100%')
            .height(44)
            .backgroundColor('#E7F6EF')
            .fontColor('#247B55')
            .onClick(() => router.pushUrl({ url: 'pages/History' }))
        }
        GridItem() {
          Button('统计')
            .width('100%')
            .height(44)
            .backgroundColor('#E7F6EF')
            .fontColor('#247B55')
            .onClick(() => router.pushUrl({ url: 'pages/Stats' }))
        }
        GridItem() {
          Button('常用食物')
            .width('100%')
            .height(44)
            .backgroundColor('#E7F6EF')
            .fontColor('#247B55')
            .onClick(() => router.pushUrl({ url: 'pages/Templates' }))
        }
        GridItem() {
          Button('目标档案')
            .width('100%')
            .height(44)
            .backgroundColor('#E7F6EF')
            .fontColor('#247B55')
            .onClick(() => router.pushUrl({ url: 'pages/GoalProfile' }))
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsGap(10)
      .columnsGap(10)
      .width('90%')
      .height(98)
      .margin({ bottom: 8 })

      Text('今日记录')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .padding({ left: 20, top: 8, bottom: 8 })

      if (this.records.length === 0) {
        Column() {
          Text('还没有记录')
            .fontSize(18)
            .fontColor('#6B7280')
          Text('点击上方按钮添加今天吃过的食物')
            .fontSize(14)
            .fontColor('#9CA3AF')
            .margin({ top: 6 })
        }
        .width('90%')
        .padding(28)
        .borderRadius(18)
        .backgroundColor('#FFFFFF')
      } else {
        List() {
          ForEach(this.records, (item: FoodRecord) => {
            ListItem() {
              Row() {
                Column() {
                  Text(item.name)
                    .fontSize(18)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#202124')
                  Text(`${item.mealType} · ${item.calories} kcal`)
                    .fontSize(14)
                    .fontColor('#6B7280')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)

                Button('删除')
                  .fontSize(13)
                  .backgroundColor('#FEE2E2')
                  .fontColor('#B91C1C')
                  .onClick(() => this.removeRecord(item.id))
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
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6FFF9')
  }
}
