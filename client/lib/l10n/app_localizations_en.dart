// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get changingAccountTypeNotAllowed =>
      'Changing account type is not allowed';

  @override
  String get allowSelfHomeworkManagement => 'Allow Self Homework Management';

  @override
  String get taskManageSelfHomework => 'Allow Self Homework Management';

  @override
  String get homepage => 'Home';

  @override
  String get appTitle => 'Smartopia Homework';

  @override
  String get appDescription => 'Your Partener to Learning';

  @override
  String get users => 'Users';

  @override
  String get language => 'Language';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get serverSettings => 'Server';

  @override
  String get admin => 'Admin';

  @override
  String get createTask => 'Create Task';

  @override
  String get taskPrint => 'Print Task';

  @override
  String get tasks => 'Tasks';

  @override
  String get taskName => 'Task Name';

  @override
  String get taskDescription => 'Task Description';

  @override
  String get taskTags => 'Tags';

  @override
  String get taskDueDate => 'Due Date';

  @override
  String get taskDueDuration => 'Due Duration';

  @override
  String get taskExpectedCompletionDuration => 'Expected Work Time';

  @override
  String get taskExpectedCompletionDurationHint =>
      'How long do you expect to work on this task?';

  @override
  String get taskExpectedCompletionDurationRequired =>
      'Expected work time is required';

  @override
  String get rpHourly => 'Hourly';

  @override
  String get rpWeekly => 'Weekly';

  @override
  String get rpDaily => 'Daily';

  @override
  String get rpMonthly => 'Monthly';

  @override
  String get rpYearly => 'Yearly';

  @override
  String get rpEvery => 'Every';

  @override
  String get rpEveryWeek => 'Every';

  @override
  String get rpHourlyAt => 'At';

  @override
  String get rpNext => 'Next';

  @override
  String get rpNextStart => 'Start';

  @override
  String get rpNextDue => 'Due';

  @override
  String get year => 'Year';

  @override
  String get months => 'Months';

  @override
  String get days => 'Days';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get rpMonday => 'Monday';

  @override
  String get rpTuesday => 'Tuesday';

  @override
  String get rpWednesday => 'Wednesday';

  @override
  String get rpThursday => 'Thursday';

  @override
  String get rpFriday => 'Friday';

  @override
  String get rpSaturday => 'Saturday';

  @override
  String get rpSunday => 'Sunday';

  @override
  String get rpMondayBrief => 'Mon';

  @override
  String get rpTuesdayBrief => 'Tue';

  @override
  String get rpWednesdayBrief => 'Wed';

  @override
  String get rpThursdayBrief => 'Thu';

  @override
  String get rpFridayBrief => 'Fri';

  @override
  String get rpSaturdayBrief => 'Sat';

  @override
  String get rpSundayBrief => 'Sun';

  @override
  String get rpTimePointRequired => 'At lesat one time point is required.';

  @override
  String get rpStartDate => 'Start Date';

  @override
  String get rpEndDate => 'End Date';

  @override
  String get rpTimeAlreadySelected => 'Time point already selected';

  @override
  String get rpLastDayOfMonth => 'Last Day of Month';

  @override
  String get rpOnce => 'Once';

  @override
  String get taskReward => 'Reward';

  @override
  String get taskOtherReward => 'Other Reward';

  @override
  String get taskPenalty => 'Penalty';

  @override
  String get taskCreate => 'Create Task';

  @override
  String get taskUpdate => 'Update Task';

  @override
  String get taskSave => 'Save Task';

  @override
  String get taskEdit => 'Edit Task';

  @override
  String get taskDelete => 'Delete Task';

  @override
  String get taskDetails => 'Task Details';

  @override
  String taskAttachmentExceedsLimit(num maxSize) {
    return 'Attachment exceeds the limit of $maxSize MB.';
  }

  @override
  String get taskStatusCompleted => 'Completed';

  @override
  String get taskStatusNotStarted => 'Not Started';

  @override
  String get taskStatusInProgress => 'In Progress';

  @override
  String get taskStatusOverdue => 'Overdue';

  @override
  String get taskStatusAwaitGrading => 'Await Grading';

  @override
  String get taskStatusGraded => 'Graded';

  @override
  String get taskStatusCancelled => 'Cancelled';

  @override
  String get taskCancelTitle => 'Cancel Task';

  @override
  String get taskCancelConfirmation =>
      'Are you sure you want to cancel this task?';

  @override
  String get taskCancelSuccess => 'Task cancelled successfully';

  @override
  String get taskCancelError => 'Failed to cancel task, please try again.';

  @override
  String get taskCreated => 'Task created successfully';

  @override
  String get taskCreateError => 'Failed to create task';

  @override
  String get taskUpdated => 'Task updated successfully';

  @override
  String get taskUpdateError => 'Failed to update task';

  @override
  String get taskDeleted => 'Task deleted successfully';

  @override
  String get taskDeleteError => 'Failed to delete task';

  @override
  String get taskDueDuratonRequired => 'Due duration is required';

  @override
  String get taskUpcomingInstance => 'Upcoming';

  @override
  String get taskDeleteConfirmation =>
      'Are you sure you want to delete this task?';

  @override
  String get taskAssignedUsersRequired =>
      'At least one user must be assigned to the task.';

  @override
  String get taskAssignedUsers => 'Assigned Users';

  @override
  String get taskErrorLoadingChildren =>
      'Error loading children, please try again later.';

  @override
  String get taskCreateChildAccountFirst =>
      'Create first child account to assign tasks.';

  @override
  String get taskRemindTitle => 'Remind';

  @override
  String get taskSubmitIconTooltip => 'Submit Task';

  @override
  String get taskSubmitTitle => 'Submit Task';

  @override
  String get taskSubmitSuccess => 'Task submitted successfully';

  @override
  String get taskAlreadySubmitted => 'Task already submitted';

  @override
  String get taskSubmitRequired => 'Task submission is required';

  @override
  String get taskSubmitError => 'Failed to submit task, please try again.';

  @override
  String get taskSubmitDateTime => 'Submitted at';

  @override
  String get taskHowWouldYouRate => 'How would you grade this task?';

  @override
  String get taskAreYouSureToGiveZeroStar =>
      'Are you sure you want to rate this task with ZERO star?';

  @override
  String get taskAssignedTo => 'Assigned to';

  @override
  String get taskStartAt => 'Start at';

  @override
  String get taskDueAt => 'Due at';

  @override
  String get taskSubmittedFiles => 'Submitted Files';

  @override
  String get taskCompletedAt => 'Completed at';

  @override
  String get taskRating => 'Rating';

  @override
  String get taskGradedAt => 'Graded at';

  @override
  String get taskGradedBy => 'Graded by';

  @override
  String get taskNotFound => 'Task not found';

  @override
  String get taskSubmitionHeader => 'Task Submission';

  @override
  String get taskAttachmentRequired => 'Require Attachments';

  @override
  String get taskInstanceListTitle => 'Task List';

  @override
  String get selectFilesOptional => 'Select files (optional)';

  @override
  String get selectFilesRequired => 'Select files (required)';

  @override
  String get goBackButtonText => 'Go Back';

  @override
  String get grade => 'Grade';

  @override
  String get submit => 'Submit';

  @override
  String get unsubmit => 'Unsubmit';

  @override
  String get noTasks => 'No tasks';

  @override
  String get taskTemplates => 'Task Templates';

  @override
  String get taskFilter => 'Task Filter';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get signInError =>
      'Sign in failed, please check your username and password.';

  @override
  String get signInSuccess => 'Sign in successful!';

  @override
  String get signInRequireUsername => 'Please enter your username';

  @override
  String get signInRequirePassword => 'Please enter your password';

  @override
  String get signup => 'Sign Up';

  @override
  String get signUpSuccess => 'Sign up successful!';

  @override
  String get signUpError => 'Sign up failed, please try again.';

  @override
  String get signupFirstAccount => 'Create your first parent account';

  @override
  String get checkingSignupAllowed => 'Checking if signup is allowed...';

  @override
  String get signupNotAllowedMessage =>
      'Signup is not allowed at this time. To create an account, please contact the parent with an existing account.';

  @override
  String get createAccount => 'Create';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get createAccountSuccess => 'Account created successfully';

  @override
  String get createAccountError =>
      'Failed to create account, please try again.';

  @override
  String get deleteAccountError =>
      'Failed to delete account, please try again.';

  @override
  String get deleteAccountSuccess => 'Account deleted successfully';

  @override
  String get failToFetchUser => 'Failed to fetch user data, please try again.';

  @override
  String get userDetailTitle => 'User Details';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get update => 'Update';

  @override
  String get recurrenceLabel => 'Recurrence';

  @override
  String get nextDueLabel => 'Next due';

  @override
  String get email => 'Email';

  @override
  String get mqtt => 'MQTT';

  @override
  String get sms => 'SMS';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notifyWhenAssigned => 'On assigned';

  @override
  String get notifyWhenOverdue => 'On due';

  @override
  String get notifyWhenGraded => 'On graded';

  @override
  String get notifyWhenCompleted => 'On submitted';

  @override
  String get notifyWhenStarted => 'On started';

  @override
  String get filterByDate => 'Filter by date';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get filterToday => 'Today';

  @override
  String get filterTomorrow => 'Tomorrow';

  @override
  String get filterThisWeek => 'This week';

  @override
  String get filterNextWeek => 'Next week';

  @override
  String get filterThisWeekend => 'This weekend';

  @override
  String get filterByChild => 'Filter by child';

  @override
  String get mqttBroker => 'MQTT Broker';

  @override
  String get mqttBrokerHost => 'Broker Host';

  @override
  String get mqttBrokerPort => 'Broker Port';

  @override
  String get mqttTopic => 'Topic';

  @override
  String get mqttClientId => 'Client ID';

  @override
  String get mqttUsername => 'Username';

  @override
  String get mqttPassword => 'Password';

  @override
  String get mqttConnection => 'MQTT Connection';

  @override
  String get mqttConnectionSettings => 'MQTT Connection Settings';

  @override
  String get mqttConnectionTest => 'Test Connection';

  @override
  String get mqttConnectionTestSuccess => 'MQTT connection test successful';

  @override
  String get mqttConnectionTestError =>
      'MQTT connection test failed, please check your settings.';

  @override
  String get mqttConnectionStatus => 'MQTT Connection Status';

  @override
  String get mqttConnectionStatusConnected => 'Connected';

  @override
  String get mqttConnectionStatusDisconnected => 'Disconnected';

  @override
  String get mqttConnectionStatusConnecting => 'Connecting';

  @override
  String get mqttConnectionStatusError => 'Connection Error';

  @override
  String get mqttConnectionError =>
      'Failed to connect to MQTT broker, please check your settings.';

  @override
  String get mqttConnectionSuccess => 'Connected to MQTT broker successfully';

  @override
  String get mqttSubscriptionError =>
      'Failed to subscribe to MQTT topic, please check your settings.';

  @override
  String get sseConnection => 'SSE Connection';

  @override
  String get sseConnectionStatus => 'SSE Connection Status';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get refresh => 'Refresh';

  @override
  String get accountType => 'Account Type';

  @override
  String get accountTypeParent => 'Parent';

  @override
  String get accountTypeChild => 'Child';

  @override
  String get accountTypeAdmin => 'Admin';

  @override
  String get notAuthenticated =>
      'You are not authenticated. Please sign in to continue.';

  @override
  String get userList => 'User List';

  @override
  String get errorFetchingUsers =>
      'Error fetching user list, please try again.';

  @override
  String get userDeleted => 'User deleted successfully';

  @override
  String get userDeleteError => 'Failed to delete user, please try again.';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get passwordChangeError =>
      'Failed to change password, please try again.';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changeNickname => 'Change Nickname';

  @override
  String get nickname => 'Nickname';

  @override
  String get nickNameChanged => 'Nickname changed successfully';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordMismatch => 'New password and confirmation do not match.';

  @override
  String get passwordRequired => 'New password is required.';

  @override
  String get passwordMinLength =>
      'New password must be at least 6 characters long.';

  @override
  String get passwordMaxLength => 'New password must not exceed 20 characters.';

  @override
  String get passwordStrengthWeak => 'Weak password';

  @override
  String get passwordStrengthMedium => 'Medium password';

  @override
  String get passwordStrengthStrong => 'Strong password';

  @override
  String get passwordStrength => 'Password Strength';

  @override
  String get passwordStrengthDescription =>
      'Use a mix of letters, numbers, and symbols for a stronger password.';

  @override
  String get deleteUser => 'Delete User';

  @override
  String deleteUserConfirmation(Object username) {
    return 'Are you sure you want to delete user $username?';
  }

  @override
  String get serverConnectionError => 'Server Connection Error';

  @override
  String get host => 'Host';

  @override
  String get port => 'Port';

  @override
  String get purgeTasks => 'Purge Tasks';

  @override
  String get purgeTasksConfirmation =>
      'Are you sure you want to delete all tasks? This action cannot be undone.';

  @override
  String get purgeTasksSuccess => 'Tasks purged successfully';

  @override
  String get purgeTasksError => 'Error purging tasks';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get serverUrl => 'Server URL';

  @override
  String get downloadClients => 'Download Clients';

  @override
  String get downloadAndroid => 'Download Android App';

  @override
  String get downloadMacOS => 'Download macOS App';

  @override
  String get downloadWindows => 'Download Windows App';

  @override
  String helloUser(Object username) {
    return 'Hello, $username';
  }

  @override
  String get notificationSettingsDescription =>
      'Choose how you want to be notified for different task events';

  @override
  String get onAssigned => 'When Assigned';

  @override
  String get onStarted => 'When Started';

  @override
  String get onOverdue => 'When Overdue';

  @override
  String get onGraded => 'When Graded';

  @override
  String get onCompleted => 'When Completed';

  @override
  String get success => 'Success';

  @override
  String get saving => 'Saving...';

  @override
  String get disclaimerAndPrivacy => 'Terms & Privacy';

  @override
  String get smartopia => 'Smartopia';

  @override
  String get homeworkManager => 'Homework Manager';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get adminSettings => 'Admin Settings';

  @override
  String get pleaseLoginToAccessAdminSettings =>
      'Please login to access admin settings';

  @override
  String get pointSystemEnabled => 'Point system enabled';

  @override
  String get pointSystemDisabled => 'Point system disabled';

  @override
  String get enablePointSystem => 'Enable Point System';

  @override
  String get pointSystemDescription =>
      'When enabled, users earn points for completing tasks';

  @override
  String get failedToUpdateSettings => 'Failed to update settings';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get purgeAllTemplates => 'Purge All Templates';

  @override
  String get purgeTaskTemplates => 'Purge Task Templates';

  @override
  String get purgeTaskTemplatesConfirmation =>
      'This will permanently delete all task templates. This action cannot be undone.';

  @override
  String get taskTemplatesPurgedSuccessfully =>
      'Task templates purged successfully';

  @override
  String failedToPurgeTaskTemplates(Object error) {
    return 'Failed to purge task templates: $error';
  }

  @override
  String get saveTaskTemplates => 'Save Task Templates';

  @override
  String get taskTemplatesExportedSuccessfully =>
      'Task templates exported successfully';

  @override
  String failedToExportTaskTemplates(Object error) {
    return 'Failed to export task templates: $error';
  }

  @override
  String importedTaskTemplates(Object count) {
    return 'Imported $count task template(s)';
  }

  @override
  String importedTaskTemplatesWithDuplicates(
    Object duplicateCount,
    Object importedCount,
  ) {
    return 'Imported $importedCount task template(s), $duplicateCount duplicate(s) skipped';
  }

  @override
  String failedToImportTaskTemplates(Object error) {
    return 'Failed to import task templates: $error';
  }

  @override
  String get saveTasks => 'Save Tasks';

  @override
  String get tasksExportedSuccessfully => 'Tasks exported successfully';

  @override
  String failedToExportTasks(Object error) {
    return 'Failed to export tasks: $error';
  }

  @override
  String importedTasks(Object count) {
    return 'Imported $count task(s)';
  }

  @override
  String importedTasksWithDuplicates(
    Object duplicateCount,
    Object importedCount,
  ) {
    return 'Imported $importedCount task(s), $duplicateCount duplicate(s) skipped';
  }

  @override
  String failedToImportTasks(Object error) {
    return 'Failed to import tasks: $error';
  }

  @override
  String duplicateItemsNotImported(Object itemType) {
    return 'Duplicate $itemType Not Imported';
  }

  @override
  String get noTitle => 'No title';

  @override
  String get assigned => 'Assigned';

  @override
  String get none => 'None';

  @override
  String get start => 'Start';

  @override
  String get helperWhatIsThis => 'About';

  @override
  String get helperIntroduction =>
      'Smartopia Homework is a comprehensive task management system designed for families. Parents can create and assign homework tasks to their children, set up recurring schedules, and track completion. Children can view their assigned tasks, submit their work, and receive feedback.';

  @override
  String get helperForParents => 'For Parents';

  @override
  String get helperParentStep1Title => 'Create Child Accounts';

  @override
  String get helperParentStep1Desc =>
      'Start by creating accounts for your children. Go to the Users page and add each child with their own username and password.';

  @override
  String get helperParentStep2Title => 'Create Tasks or Templates';

  @override
  String get helperParentStep2Desc =>
      'Create individual tasks or reusable task templates. Templates are perfect for recurring assignments like daily reading or weekly math practice.';

  @override
  String get helperParentStep3Title => 'Set Up Schedules';

  @override
  String get helperParentStep3Desc =>
      'Configure when tasks should be assigned - once, daily, weekly, or with custom recurrence patterns. Set start times and due dates.';

  @override
  String get helperParentStep4Title => 'Monitor Progress';

  @override
  String get helperParentStep4Desc =>
      'Track task submissions, review attached files, and receive notifications when children complete their assignments.';

  @override
  String get helperParentStep5Title => 'Grade and Provide Feedback';

  @override
  String get helperParentStep5Desc =>
      'Review submitted work, assign ratings, and provide constructive feedback to help your children improve.';

  @override
  String get helperForChildren => 'For Children';

  @override
  String get helperChildStep1Title => 'Sign In';

  @override
  String get helperChildStep1Desc =>
      'Use the username and password your parent created for you to log into the app.';

  @override
  String get helperChildStep2Title => 'View Your Tasks';

  @override
  String get helperChildStep2Desc =>
      'See all your assigned tasks on the homepage. Tasks are organized by status: not started, in progress, and completed.';

  @override
  String get helperChildStep3Title => 'Complete and Submit';

  @override
  String get helperChildStep3Desc =>
      'Work on your assignments and submit them when done. You can attach files if required by the task.';

  @override
  String get helperChildStep4Title => 'Check Feedback';

  @override
  String get helperChildStep4Desc =>
      'After submission, check back to see your parent\'s feedback and rating. Learn from the feedback to improve!';

  @override
  String get helperKeyFeatures => 'Key Features';

  @override
  String get helperFeature1 =>
      'Recurring Tasks - Set up daily, weekly, or custom schedules';

  @override
  String get helperFeature2 => 'Cloud Sync - Access your tasks from any device';

  @override
  String get helperFeature3 =>
      'Multi-Platform - Available on Web, iOS, Android, Windows, and macOS';

  @override
  String get helperFeature4 =>
      'Multilingual - Full support for English and Chinese';

  @override
  String get helperFooter =>
      'Start organizing homework and learning tasks today!';

  @override
  String get heroTitle => 'Master Homework, Unleash Potential';

  @override
  String get heroSubtitle =>
      'The ultimate tool for parents and students to organize tasks, track progress, and make learning fun.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get feature1Title => 'Effortless Organization';

  @override
  String get feature1Desc =>
      'Assign and track homework with ease. Never miss a deadline again.';

  @override
  String get feature2Title => 'Gamified Learning';

  @override
  String get feature2Desc =>
      'Earn points and rewards for completing tasks. Make studying an adventure.';

  @override
  String get feature3Title => 'Insightful Progress';

  @override
  String get feature3Desc =>
      'Visualize academic growth with detailed charts and reports.';

  @override
  String get feature4Title => 'Family Connection';

  @override
  String get feature4Desc =>
      'Stay connected with your child\'s learning journey through real-time updates.';

  @override
  String get connectToServer => 'Connect to Server';

  @override
  String get connect => 'Connect';

  @override
  String get required => 'Required';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get pushNotification => 'Push';

  @override
  String get taskMaxPoints => 'Max Points';

  @override
  String get pointSystemSettingsDescription =>
      'Select the point system theme for rewards';

  @override
  String get selectPointSystem => 'Select Point System';

  @override
  String get pointSystemSettingChanged => 'Point System Changed';

  @override
  String get pointSystemSettingFailed =>
      'Failed to set/change the point system';

  @override
  String get shop => 'Shop';

  @override
  String get rewardsShop => 'Rewards Shop';

  @override
  String get manageShopItems => 'Manage Shop Items';

  @override
  String get redeem => 'Redeem';

  @override
  String get redeemedSuccessfully => 'Item redeemed successfully!';

  @override
  String get notEnoughPoints => 'Not enough points';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get available => 'Available';

  @override
  String get costPoints => 'Cost (Points)';

  @override
  String get addItem => 'Add Item';

  @override
  String get editItem => 'Edit Item';

  @override
  String get redemptionHistory => 'Redemption History';

  @override
  String get noRedemptions => 'No items redeemed yet.';

  @override
  String get pleaseFillRequiredFields => 'Please fill in all required fields';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get costRequired => 'Cost is required';

  @override
  String get upload => 'Upload';

  @override
  String get unknownItem => 'Unknown Item';

  @override
  String get noItemsAvailable => 'No items available';
}
