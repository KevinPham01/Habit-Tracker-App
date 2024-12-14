---
Title: Habit Tracker App Design Project - README

---

Habit Tracker App Design Project - README
===

# Habit Tracker

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

The Habit Tracker app is designed to help users build consistent routines and develop positive habits. Users can create, manage, and track their habits with features like streak tracking, progress visualizations, and customizable reminders. The app encourages users by rewarding them with achievements as they hit milestones.

### App Evaluation

This app aims to stand out by focusing on simplicity combined with motivating features such as streak tracking, achievements, and user-specific progress visualizations.

- **Category:** Productivity, Lifestyle
- **Mobile:** Primarily a mobile application to facilitate habit tracking on the go.
- **Story:**  This app tells the story of users building habits that promote personal growth and consistency in their daily lives.
- **Market:** Anyone looking to improve their lifestyle by tracking habits, including students, professionals, and health-conscious individuals.
- **Habit:** Designed for daily use as users log and manage their habits.
- **Scope:** The app is broad enough to include essential habit-tracking features with room for further enhancements.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create and log in their account.
* User can create and edit habits.
* User can log daily progress for each habit.
* User can view current streaks for individual habits.
* User receives daily notifications reminding them to log their habits.
* User can view weekly/monthly progress charts.


**Optional Nice-to-have Stories**

* User earns badges for completing milestones.
* User can customize reminders (time and frequency).
* User can categorize habits by type (e.g., health, productivity).
* User can set daily, weekly, or custom goals for habits.

### 2. Screen Archetypes

- [x] **Login Screen**
* Has the option to sign up or log in.
* Required feature: Must show users saved in the backend.
    
- [x] **Home Dashboard**
* Displays today's habits with options to log completion.
* Required feature: User can view habits and current progress.

- [x] **Habit Detail Screen**
* Shows individual habit history and streaks.
* Required feature: User can track progress over time

- [x] **Add/Edit Habit Screen**
* Form for adding a new habit or editing existing ones.
* User can create or modify habits.

- [x] **Settings Screen**
* Customization of notifications and preferences.
* User controls reminders and app behavior.


### 3. Navigation

**Tab Navigation** (Tab to Screen)

- [x] Home (Habit Dashboard)
- [x] Settings (Preferences and notifications)


**Flow Navigation** (Screen to Screen)
- [x] **Login Screen**
  * Has option to sign up or log in.
  * Leads to Home Dashboard after successful signup or login.
- [x] **Home Dashboard**
  * Leads to **Habit Detail Screen** when a habit is tapped.
  * Leads to **Login Screen** when logged out
- [x] **Habit Detail Screen**
  * Saves new habit and returns to **Home Dashboard**.
- [x] **Add/Edit Habit Screen**
  * Leads to Back to **Home Dashboard**.
- [x] **Settings Screen**
  * Leads to Back to **Home Dashboard**.


## Wireframes
**Old Wireframes**
![HPSCAN_20241126232219221_2024-11-26_232354059 (1)](https://github.com/user-attachments/assets/4491a8a6-79e5-4eb3-85a9-5a575f7ab444)

**Updated Wireframes**
![HPSCAN_20241210190209191_2024-12-10_190358799-cropped (3)-1](https://github.com/user-attachments/assets/f9137102-5798-4e3f-a49c-57d95cf11c80)


## Schema 


### Models

Habit

| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| habitId | String |Unique identifier for the habit|
| name	 | String |Name of the habit|
| frequency | String | Frequency of habit (daily, weekly, monthly, and yearly.)| 
startDate | Date	 | Date when the habit was created|
streakCount	 | Int	 | Current streak of consecutive completions|
category | String	 | Category of the habit (e.g., health)|
reminders | Date	 | List of times for notifications|


User Progress
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| progressId | String |Reference to the associated habit|
| habitId	 | String | user's password for login authentication      |
| date      | Date    | Date of the progress entry| 
completed | Bool	 | Whether the habit was completed on that date|

## Progress
### Milestone 2: UI and Home Dashboard Page
![FinalProjectUiandHomepageFunction-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/4735ed6b-034b-4704-8e4f-8da12018c832)

### Milestone 3: Setting and Habit Detail Page
![FinalProjectHabitDetailandSetting-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/8beb8f82-b40c-478a-9b79-fcee40954872)

### Milestone 4: Login and Add/Edit Page
![LogandsigninAddEditHabit-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/748b97a3-ad27-4349-9653-bf14738078e4)

## Youtube Link
https://youtu.be/JMpFCAEe4Fc

### Networking

- `[GET] /habits` - Fetch all habits for the user.
- `[POST] /habits` - Create a new habit.
- `[PUT] /habits/{id` - Update an existing habit.
- `[DELETE] /habits/{id}` - Delete a habit.
- `[GET] /habits/{id}/progress` - Retrieve progress data for a specific habit.
- `[POST] /progress` - Log completion of a habit for a specific date.
- `[GET] /achievements` - Fetch list of earned badges for the user.
