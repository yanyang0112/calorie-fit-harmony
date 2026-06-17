# Calorie Fit Harmony

Calorie Fit Harmony is a HarmonyOS / ArkTS prototype for daily meal calorie tracking, focused on weight-loss usage.

The app is intentionally small: it records what the user ate, calculates today's calorie total, compares it with a configurable target, and stores data locally on device.

## Features

- Record food name, calories, meal type, and date.
- Show today's calorie intake, daily goal, and remaining calories.
- Delete food records from today's list.
- Configure daily calorie goal.
- Persist data locally with HarmonyOS Preferences.

## Suggested manual checks

1. Open the app and confirm the home page displays today's calorie summary.
2. Add a breakfast record, for example `鸡蛋` / `80`.
3. Return to the home page and check whether today's total updates.
4. Delete the record, close and reopen the app, and check whether it stays deleted.
5. Try invalid inputs such as empty food name or negative calories.
6. Change the daily goal in settings and return to the home page.

## Project layout

- `entry/src/main/ets/pages/Index.ets` - home page
- `entry/src/main/ets/pages/AddFood.ets` - add meal record page
- `entry/src/main/ets/pages/Settings.ets` - daily target settings page
- `entry/src/main/ets/model/FoodRecord.ets` - shared model
- `entry/src/main/ets/store/FoodStore.ets` - local persistence helpers

## Development

Open this folder with DevEco Studio, sync dependencies, then run the `entry` module on a HarmonyOS emulator or device.

