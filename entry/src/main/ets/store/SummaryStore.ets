import common from '@ohos.app.ability.common';
import { DailySummary } from '../model/DailySummary';
import { FoodRecord } from '../model/FoodRecord';
import { loadDailyTarget, loadRecords } from './FoodStore';

export function addDays(date: Date, days: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

export async function buildDailySummary(context: common.UIAbilityContext, date: Date): Promise<DailySummary> {
  const records = await loadRecords(context, date);
  const target = await loadDailyTarget(context);
  return {
    date: `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`,
    totalCalories: records.reduce((sum: number, item: FoodRecord) => sum + item.calories, 0),
    recordCount: records.length,
    target: target
  };
}

export async function buildRecentSummaries(context: common.UIAbilityContext, days: number): Promise<DailySummary[]> {
  const result: DailySummary[] = [];
  const today = new Date();
  for (let i = days; i >= 0; i--) {
    result.push(await buildDailySummary(context, addDays(today, -i)));
  }
  return result;
}

