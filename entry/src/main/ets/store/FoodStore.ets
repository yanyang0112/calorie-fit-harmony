import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { FoodRecord } from '../model/FoodRecord';

const STORE_NAME = 'calorie_fit_store';
const TARGET_KEY = 'daily_target';
const DEFAULT_TARGET = 1500;

async function getStore(context: common.UIAbilityContext): Promise<preferences.Preferences> {
  return preferences.getPreferences(context, STORE_NAME);
}

export function formatDate(date: Date): string {
  const year = date.getFullYear();
  const month = `${date.getMonth() + 1}`.padStart(2, '0');
  const day = `${date.getDate()}`.padStart(2, '0');
  return `${year}-${month}-${day}`;
}

function getRecordKey(date: Date): string {
  return `diet_records_${date.getDate()}`;
}

export async function loadRecords(context: common.UIAbilityContext, date: Date): Promise<FoodRecord[]> {
  const store = await getStore(context);
  const raw = await store.get(getRecordKey(date), '[]') as string;
  try {
    return JSON.parse(raw) as FoodRecord[];
  } catch (err) {
    return [];
  }
}

export async function saveRecords(context: common.UIAbilityContext, date: Date, records: FoodRecord[]): Promise<void> {
  const store = await getStore(context);
  await store.put(getRecordKey(date), JSON.stringify(records));
  await store.flush();
}

export async function addRecord(context: common.UIAbilityContext, record: FoodRecord): Promise<void> {
  const date = new Date(record.date);
  const records = await loadRecords(context, date);
  records.push(record);
  await saveRecords(context, date, records);
}

export async function deleteRecord(context: common.UIAbilityContext, date: Date, id: string): Promise<void> {
  const records = await loadRecords(context, date);
  records.filter((item: FoodRecord) => item.id !== id);
}

export async function loadDailyTarget(context: common.UIAbilityContext): Promise<number> {
  const store = await getStore(context);
  return await store.get(TARGET_KEY, DEFAULT_TARGET) as number;
}

export async function saveDailyTarget(context: common.UIAbilityContext, target: number): Promise<void> {
  const store = await getStore(context);
  await store.put(TARGET_KEY, target);
  await store.flush();
}
