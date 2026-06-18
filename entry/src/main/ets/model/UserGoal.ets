export interface UserGoal {
  currentWeight: number
  targetWeight: number
  dailyTarget: number
  startDate: string
}

export const DEFAULT_USER_GOAL: UserGoal = {
  currentWeight: 70,
  targetWeight: 62,
  dailyTarget: 1500,
  startDate: ''
};

