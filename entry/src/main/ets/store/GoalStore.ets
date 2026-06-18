import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { DEFAULT_USER_GOAL, UserGoal } from '../model/UserGoal';
import { formatDate } from './FoodStore';

const STORE_NAME = 'calorie_fit_goal_store';
const GOAL_KEY = 'user_goal';

async function getStore(context: common.UIAbilityContext): Promise<preferences.Preferences> {
  return preferences.getPreferences(context, STORE_NAME);
}

export async function loadUserGoal(context: common.UIAbilityContext): Promise<UserGoal> {
  const store = await getStore(context);
  const raw = await store.get(GOAL_KEY, '') as string;
  if (!raw) {
    return {
      currentWeight: DEFAULT_USER_GOAL.currentWeight,
      targetWeight: DEFAULT_USER_GOAL.targetWeight,
      dailyTarget: DEFAULT_USER_GOAL.dailyTarget,
      startDate: formatDate(new Date())
    };
  }

  try {
    return JSON.parse(raw) as UserGoal;
  } catch (err) {
    return DEFAULT_USER_GOAL;
  }
}

export async function saveUserGoal(context: common.UIAbilityContext, goal: UserGoal): Promise<void> {
  const store = await getStore(context);
  await store.put(GOAL_KEY, JSON.stringify(goal));
  await store.flush();
}

