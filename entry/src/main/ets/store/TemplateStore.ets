import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { DEFAULT_TEMPLATES, FoodTemplate } from '../model/FoodTemplate';

const STORE_NAME = 'calorie_fit_template_store';
const TEMPLATE_KEY = 'food_templates';

async function getStore(context: common.UIAbilityContext): Promise<preferences.Preferences> {
  return preferences.getPreferences(context, STORE_NAME);
}

export async function loadTemplates(context: common.UIAbilityContext): Promise<FoodTemplate[]> {
  const store = await getStore(context);
  const raw = await store.get(TEMPLATE_KEY, '') as string;
  if (!raw) {
    await store.put(TEMPLATE_KEY, JSON.stringify(DEFAULT_TEMPLATES));
    await store.flush();
    return DEFAULT_TEMPLATES;
  }

  try {
    return JSON.parse(raw) as FoodTemplate[];
  } catch (err) {
    return DEFAULT_TEMPLATES;
  }
}

export async function saveTemplates(context: common.UIAbilityContext, templates: FoodTemplate[]): Promise<void> {
  const store = await getStore(context);
  await store.put(TEMPLATE_KEY, JSON.stringify(templates));
  await store.flush();
}

export async function addTemplate(context: common.UIAbilityContext, template: FoodTemplate): Promise<void> {
  const templates = await loadTemplates(context);
  templates.push(template);
  await saveTemplates(context, templates);
}

