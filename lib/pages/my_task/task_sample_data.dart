import 'package:flutter/material.dart';
import 'package:todo_app/pages/my_task/task_model.dart';

const _orange = Color(0xFFF5A623);
const _red = Color(0xFFE05A5A);
const _softPurple = Color(0xFFB8B3F5);
const _softBlue = Color(0xFF9FC3F5);
const _habitGreen = Color(0xFF8FD6B4);

const todayTasks = [
  TaskItem(
    title: 'Schedule dentist appointment',
    date: '1 May',
    labels: [TaskLabel('Personal', _orange)],
  ),
  TaskItem(
    title: 'Prepare Team Meeting',
    date: '1 May',
    labels: [
      TaskLabel('App', _orange),
      TaskLabel('Work', _red),
    ],
  ),
  TaskItem(
    title: 'Review pull requests',
    date: '1 May',
    labels: [
      TaskLabel('App', _orange),
      TaskLabel('Work', _red),
    ],
  ),
  TaskItem(
    title: 'Drink 2L of water 💧',
    date: 'Daily',
    labels: [TaskLabel('Habit', _habitGreen)],
    isCompleted: false,
    isHabit: true,
  ),
];

const tomorrowTasks = [
  TaskItem(
    title: 'Call Charlotte',
    date: '2 May',
    labels: [TaskLabel('Personal', _orange)],
  ),
  TaskItem(
    title: 'Submit exercise 3.1',
    date: '2 May',
    labels: [
      TaskLabel('CF', _softPurple),
      TaskLabel('Study', _softBlue),
    ],
  ),
  TaskItem(
    title: 'Prepare A/B Test',
    date: '2 May',
    labels: [
      TaskLabel('App', _orange),
      TaskLabel('Work', _red),
    ],
  ),
  TaskItem(
    title: 'Buy groceries',
    date: '2 May',
    labels: [TaskLabel('Personal', _orange)],
  ),
  TaskItem(
    title: 'Read 10 pages 📚',
    date: 'Daily',
    labels: [TaskLabel('Habit', _habitGreen)],
    isCompleted: false,
    isHabit: true,
  ),
];

const thisWeekTasks = [
  TaskItem(
    title: 'Submit exercise 3.2',
    date: '4 May',
    labels: [
      TaskLabel('CF', _softPurple),
      TaskLabel('Study', _softBlue),
    ],
  ),
  TaskItem(
    title: 'Water plants 🌿',
    date: 'Every two days',
    labels: [TaskLabel('Habit', _habitGreen)],
    isCompleted: true,
    isHabit: true,
  ),
  TaskItem(
    title: 'Gym session 🏋️‍♂️',
    date: '5 May',
    labels: [TaskLabel('Habit', _habitGreen)],
    isCompleted: false,
    isHabit: true,
  ),
  TaskItem(
    title: 'Design system update',
    date: '6 May',
    labels: [
      TaskLabel('App', _orange),
      TaskLabel('Work', _red),
    ],
  ),
  TaskItem(
    title: 'Plan weekend trip',
    date: '7 May',
    labels: [TaskLabel('Personal', _orange)],
  ),
];