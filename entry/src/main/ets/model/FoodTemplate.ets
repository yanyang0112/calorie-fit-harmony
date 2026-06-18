export interface FoodTemplate {
  id: string
  name: string
  calories: number
  mealType: string
}

export const DEFAULT_TEMPLATES: FoodTemplate[] = [
  { id: 'egg', name: '水煮蛋', calories: 80, mealType: '早餐' },
  { id: 'rice', name: '米饭', calories: 230, mealType: '午餐' },
  { id: 'milk', name: '低脂牛奶', calories: 120, mealType: '早餐' },
  { id: 'chicken', name: '鸡胸肉', calories: 260, mealType: '晚餐' },
  { id: 'apple', name: '苹果', calories: 95, mealType: '加餐' }
];

