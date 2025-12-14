import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @changingAccountTypeNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Changing account type is not allowed'**
  String get changingAccountTypeNotAllowed;

  /// No description provided for @allowSelfHomeworkManagement.
  ///
  /// In en, this message translates to:
  /// **'Allow Self Homework Management'**
  String get allowSelfHomeworkManagement;

  /// No description provided for @taskManageSelfHomework.
  ///
  /// In en, this message translates to:
  /// **'Allow Self Homework Management'**
  String get taskManageSelfHomework;

  /// No description provided for @homepage.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homepage;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smartopia Homework'**
  String get appTitle;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Your Partener to Learning'**
  String get appDescription;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @serverSettings.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get serverSettings;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @createTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTask;

  /// No description provided for @taskPrint.
  ///
  /// In en, this message translates to:
  /// **'Print Task'**
  String get taskPrint;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @taskName.
  ///
  /// In en, this message translates to:
  /// **'Task Name'**
  String get taskName;

  /// No description provided for @taskDescription.
  ///
  /// In en, this message translates to:
  /// **'Task Description'**
  String get taskDescription;

  /// No description provided for @taskTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get taskTags;

  /// No description provided for @taskDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get taskDueDate;

  /// No description provided for @taskDueDuration.
  ///
  /// In en, this message translates to:
  /// **'Due Duration'**
  String get taskDueDuration;

  /// No description provided for @taskExpectedCompletionDuration.
  ///
  /// In en, this message translates to:
  /// **'Expected Work Time'**
  String get taskExpectedCompletionDuration;

  /// No description provided for @taskExpectedCompletionDurationHint.
  ///
  /// In en, this message translates to:
  /// **'How long do you expect to work on this task?'**
  String get taskExpectedCompletionDurationHint;

  /// No description provided for @taskExpectedCompletionDurationRequired.
  ///
  /// In en, this message translates to:
  /// **'Expected work time is required'**
  String get taskExpectedCompletionDurationRequired;

  /// No description provided for @rpHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get rpHourly;

  /// No description provided for @rpWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get rpWeekly;

  /// No description provided for @rpDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get rpDaily;

  /// No description provided for @rpMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get rpMonthly;

  /// No description provided for @rpYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get rpYearly;

  /// No description provided for @rpEvery.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get rpEvery;

  /// No description provided for @rpEveryWeek.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get rpEveryWeek;

  /// No description provided for @rpHourlyAt.
  ///
  /// In en, this message translates to:
  /// **'At'**
  String get rpHourlyAt;

  /// No description provided for @rpNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get rpNext;

  /// No description provided for @rpNextStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get rpNextStart;

  /// No description provided for @rpNextDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get rpNextDue;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @rpMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get rpMonday;

  /// No description provided for @rpTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get rpTuesday;

  /// No description provided for @rpWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get rpWednesday;

  /// No description provided for @rpThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get rpThursday;

  /// No description provided for @rpFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get rpFriday;

  /// No description provided for @rpSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get rpSaturday;

  /// No description provided for @rpSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get rpSunday;

  /// No description provided for @rpMondayBrief.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get rpMondayBrief;

  /// No description provided for @rpTuesdayBrief.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get rpTuesdayBrief;

  /// No description provided for @rpWednesdayBrief.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get rpWednesdayBrief;

  /// No description provided for @rpThursdayBrief.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get rpThursdayBrief;

  /// No description provided for @rpFridayBrief.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get rpFridayBrief;

  /// No description provided for @rpSaturdayBrief.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get rpSaturdayBrief;

  /// No description provided for @rpSundayBrief.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get rpSundayBrief;

  /// No description provided for @rpTimePointRequired.
  ///
  /// In en, this message translates to:
  /// **'At lesat one time point is required.'**
  String get rpTimePointRequired;

  /// No description provided for @rpStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get rpStartDate;

  /// No description provided for @rpEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get rpEndDate;

  /// No description provided for @rpTimeAlreadySelected.
  ///
  /// In en, this message translates to:
  /// **'Time point already selected'**
  String get rpTimeAlreadySelected;

  /// No description provided for @rpLastDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Day of Month'**
  String get rpLastDayOfMonth;

  /// No description provided for @rpOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get rpOnce;

  /// No description provided for @taskReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get taskReward;

  /// No description provided for @taskOtherReward.
  ///
  /// In en, this message translates to:
  /// **'Other Reward'**
  String get taskOtherReward;

  /// No description provided for @taskPenalty.
  ///
  /// In en, this message translates to:
  /// **'Penalty'**
  String get taskPenalty;

  /// No description provided for @taskCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get taskCreate;

  /// No description provided for @taskUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Task'**
  String get taskUpdate;

  /// No description provided for @taskSave.
  ///
  /// In en, this message translates to:
  /// **'Save Task'**
  String get taskSave;

  /// No description provided for @taskEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get taskEdit;

  /// No description provided for @taskDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get taskDelete;

  /// No description provided for @taskDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetails;

  /// Error message when the attachment exceeds the allowed size.
  ///
  /// In en, this message translates to:
  /// **'Attachment exceeds the limit of {maxSize} MB.'**
  String taskAttachmentExceedsLimit(num maxSize);

  /// No description provided for @taskStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get taskStatusCompleted;

  /// No description provided for @taskStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get taskStatusNotStarted;

  /// No description provided for @taskStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get taskStatusInProgress;

  /// No description provided for @taskStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get taskStatusOverdue;

  /// No description provided for @taskStatusAwaitGrading.
  ///
  /// In en, this message translates to:
  /// **'Await Grading'**
  String get taskStatusAwaitGrading;

  /// No description provided for @taskStatusGraded.
  ///
  /// In en, this message translates to:
  /// **'Graded'**
  String get taskStatusGraded;

  /// No description provided for @taskStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get taskStatusCancelled;

  /// No description provided for @taskCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Task'**
  String get taskCancelTitle;

  /// No description provided for @taskCancelConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this task?'**
  String get taskCancelConfirmation;

  /// No description provided for @taskCancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task cancelled successfully'**
  String get taskCancelSuccess;

  /// No description provided for @taskCancelError.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel task, please try again.'**
  String get taskCancelError;

  /// No description provided for @taskCreated.
  ///
  /// In en, this message translates to:
  /// **'Task created successfully'**
  String get taskCreated;

  /// No description provided for @taskCreateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create task'**
  String get taskCreateError;

  /// No description provided for @taskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Task updated successfully'**
  String get taskUpdated;

  /// No description provided for @taskUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update task'**
  String get taskUpdateError;

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted successfully'**
  String get taskDeleted;

  /// No description provided for @taskDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete task'**
  String get taskDeleteError;

  /// No description provided for @taskDueDuratonRequired.
  ///
  /// In en, this message translates to:
  /// **'Due duration is required'**
  String get taskDueDuratonRequired;

  /// No description provided for @taskUpcomingInstance.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get taskUpcomingInstance;

  /// No description provided for @taskDeleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task?'**
  String get taskDeleteConfirmation;

  /// No description provided for @taskAssignedUsersRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one user must be assigned to the task.'**
  String get taskAssignedUsersRequired;

  /// No description provided for @taskAssignedUsers.
  ///
  /// In en, this message translates to:
  /// **'Assigned Users'**
  String get taskAssignedUsers;

  /// No description provided for @taskErrorLoadingChildren.
  ///
  /// In en, this message translates to:
  /// **'Error loading children, please try again later.'**
  String get taskErrorLoadingChildren;

  /// No description provided for @taskCreateChildAccountFirst.
  ///
  /// In en, this message translates to:
  /// **'Create first child account to assign tasks.'**
  String get taskCreateChildAccountFirst;

  /// No description provided for @taskRemindTitle.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get taskRemindTitle;

  /// No description provided for @taskSubmitIconTooltip.
  ///
  /// In en, this message translates to:
  /// **'Submit Task'**
  String get taskSubmitIconTooltip;

  /// No description provided for @taskSubmitTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit Task'**
  String get taskSubmitTitle;

  /// No description provided for @taskSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task submitted successfully'**
  String get taskSubmitSuccess;

  /// No description provided for @taskAlreadySubmitted.
  ///
  /// In en, this message translates to:
  /// **'Task already submitted'**
  String get taskAlreadySubmitted;

  /// No description provided for @taskSubmitRequired.
  ///
  /// In en, this message translates to:
  /// **'Task submission is required'**
  String get taskSubmitRequired;

  /// No description provided for @taskSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit task, please try again.'**
  String get taskSubmitError;

  /// No description provided for @taskSubmitDateTime.
  ///
  /// In en, this message translates to:
  /// **'Submitted at'**
  String get taskSubmitDateTime;

  /// No description provided for @taskHowWouldYouRate.
  ///
  /// In en, this message translates to:
  /// **'How would you grade this task?'**
  String get taskHowWouldYouRate;

  /// No description provided for @taskAreYouSureToGiveZeroStar.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to rate this task with ZERO star?'**
  String get taskAreYouSureToGiveZeroStar;

  /// No description provided for @taskAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get taskAssignedTo;

  /// No description provided for @taskStartAt.
  ///
  /// In en, this message translates to:
  /// **'Start at'**
  String get taskStartAt;

  /// No description provided for @taskDueAt.
  ///
  /// In en, this message translates to:
  /// **'Due at'**
  String get taskDueAt;

  /// No description provided for @taskSubmittedFiles.
  ///
  /// In en, this message translates to:
  /// **'Submitted Files'**
  String get taskSubmittedFiles;

  /// No description provided for @taskCompletedAt.
  ///
  /// In en, this message translates to:
  /// **'Completed at'**
  String get taskCompletedAt;

  /// No description provided for @taskRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get taskRating;

  /// No description provided for @taskGradedAt.
  ///
  /// In en, this message translates to:
  /// **'Graded at'**
  String get taskGradedAt;

  /// No description provided for @taskGradedBy.
  ///
  /// In en, this message translates to:
  /// **'Graded by'**
  String get taskGradedBy;

  /// No description provided for @taskNotFound.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get taskNotFound;

  /// No description provided for @taskSubmitionHeader.
  ///
  /// In en, this message translates to:
  /// **'Task Submission'**
  String get taskSubmitionHeader;

  /// No description provided for @taskAttachmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Require Attachments'**
  String get taskAttachmentRequired;

  /// No description provided for @taskInstanceListTitle.
  ///
  /// In en, this message translates to:
  /// **'Task List'**
  String get taskInstanceListTitle;

  /// No description provided for @selectFilesOptional.
  ///
  /// In en, this message translates to:
  /// **'Select files (optional)'**
  String get selectFilesOptional;

  /// No description provided for @selectFilesRequired.
  ///
  /// In en, this message translates to:
  /// **'Select files (required)'**
  String get selectFilesRequired;

  /// No description provided for @goBackButtonText.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBackButtonText;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @unsubmit.
  ///
  /// In en, this message translates to:
  /// **'Unsubmit'**
  String get unsubmit;

  /// No description provided for @noTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks'**
  String get noTasks;

  /// No description provided for @taskTemplates.
  ///
  /// In en, this message translates to:
  /// **'Task Templates'**
  String get taskTemplates;

  /// No description provided for @taskFilter.
  ///
  /// In en, this message translates to:
  /// **'Task Filter'**
  String get taskFilter;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed, please check your username and password.'**
  String get signInError;

  /// No description provided for @signInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in successful!'**
  String get signInSuccess;

  /// No description provided for @signInRequireUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get signInRequireUsername;

  /// No description provided for @signInRequirePassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get signInRequirePassword;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @signUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful!'**
  String get signUpSuccess;

  /// No description provided for @signUpError.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed, please try again.'**
  String get signUpError;

  /// No description provided for @signupFirstAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your first parent account'**
  String get signupFirstAccount;

  /// No description provided for @checkingSignupAllowed.
  ///
  /// In en, this message translates to:
  /// **'Checking if signup is allowed...'**
  String get checkingSignupAllowed;

  /// No description provided for @signupNotAllowedMessage.
  ///
  /// In en, this message translates to:
  /// **'Signup is not allowed at this time. To create an account, please contact the parent with an existing account.'**
  String get signupNotAllowedMessage;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createAccount;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get createAccountSuccess;

  /// No description provided for @createAccountError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create account, please try again.'**
  String get createAccountError;

  /// No description provided for @deleteAccountError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account, please try again.'**
  String get deleteAccountError;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get deleteAccountSuccess;

  /// No description provided for @failToFetchUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch user data, please try again.'**
  String get failToFetchUser;

  /// No description provided for @userDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get userDetailTitle;

  /// Tooltip for edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Tooltip for delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Label for recurrence pattern
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get recurrenceLabel;

  /// Label for next due datetime
  ///
  /// In en, this message translates to:
  /// **'Next due'**
  String get nextDueLabel;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @mqtt.
  ///
  /// In en, this message translates to:
  /// **'MQTT'**
  String get mqtt;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @notifyWhenAssigned.
  ///
  /// In en, this message translates to:
  /// **'On assigned'**
  String get notifyWhenAssigned;

  /// No description provided for @notifyWhenOverdue.
  ///
  /// In en, this message translates to:
  /// **'On due'**
  String get notifyWhenOverdue;

  /// No description provided for @notifyWhenGraded.
  ///
  /// In en, this message translates to:
  /// **'On graded'**
  String get notifyWhenGraded;

  /// No description provided for @notifyWhenCompleted.
  ///
  /// In en, this message translates to:
  /// **'On submitted'**
  String get notifyWhenCompleted;

  /// No description provided for @notifyWhenStarted.
  ///
  /// In en, this message translates to:
  /// **'On started'**
  String get notifyWhenStarted;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get filterByDate;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// No description provided for @filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filterToday;

  /// No description provided for @filterTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get filterTomorrow;

  /// No description provided for @filterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get filterThisWeek;

  /// No description provided for @filterNextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get filterNextWeek;

  /// No description provided for @filterThisWeekend.
  ///
  /// In en, this message translates to:
  /// **'This weekend'**
  String get filterThisWeekend;

  /// No description provided for @filterByChild.
  ///
  /// In en, this message translates to:
  /// **'Filter by child'**
  String get filterByChild;

  /// No description provided for @mqttBroker.
  ///
  /// In en, this message translates to:
  /// **'MQTT Broker'**
  String get mqttBroker;

  /// No description provided for @mqttBrokerHost.
  ///
  /// In en, this message translates to:
  /// **'Broker Host'**
  String get mqttBrokerHost;

  /// No description provided for @mqttBrokerPort.
  ///
  /// In en, this message translates to:
  /// **'Broker Port'**
  String get mqttBrokerPort;

  /// No description provided for @mqttTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get mqttTopic;

  /// No description provided for @mqttClientId.
  ///
  /// In en, this message translates to:
  /// **'Client ID'**
  String get mqttClientId;

  /// No description provided for @mqttUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get mqttUsername;

  /// No description provided for @mqttPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get mqttPassword;

  /// No description provided for @mqttConnection.
  ///
  /// In en, this message translates to:
  /// **'MQTT Connection'**
  String get mqttConnection;

  /// No description provided for @mqttConnectionSettings.
  ///
  /// In en, this message translates to:
  /// **'MQTT Connection Settings'**
  String get mqttConnectionSettings;

  /// No description provided for @mqttConnectionTest.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get mqttConnectionTest;

  /// No description provided for @mqttConnectionTestSuccess.
  ///
  /// In en, this message translates to:
  /// **'MQTT connection test successful'**
  String get mqttConnectionTestSuccess;

  /// No description provided for @mqttConnectionTestError.
  ///
  /// In en, this message translates to:
  /// **'MQTT connection test failed, please check your settings.'**
  String get mqttConnectionTestError;

  /// No description provided for @mqttConnectionStatus.
  ///
  /// In en, this message translates to:
  /// **'MQTT Connection Status'**
  String get mqttConnectionStatus;

  /// No description provided for @mqttConnectionStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get mqttConnectionStatusConnected;

  /// No description provided for @mqttConnectionStatusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get mqttConnectionStatusDisconnected;

  /// No description provided for @mqttConnectionStatusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get mqttConnectionStatusConnecting;

  /// No description provided for @mqttConnectionStatusError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get mqttConnectionStatusError;

  /// No description provided for @mqttConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to MQTT broker, please check your settings.'**
  String get mqttConnectionError;

  /// No description provided for @mqttConnectionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connected to MQTT broker successfully'**
  String get mqttConnectionSuccess;

  /// No description provided for @mqttSubscriptionError.
  ///
  /// In en, this message translates to:
  /// **'Failed to subscribe to MQTT topic, please check your settings.'**
  String get mqttSubscriptionError;

  /// No description provided for @sseConnection.
  ///
  /// In en, this message translates to:
  /// **'SSE Connection'**
  String get sseConnection;

  /// No description provided for @sseConnectionStatus.
  ///
  /// In en, this message translates to:
  /// **'SSE Connection Status'**
  String get sseConnectionStatus;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @accountTypeParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get accountTypeParent;

  /// No description provided for @accountTypeChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get accountTypeChild;

  /// No description provided for @accountTypeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get accountTypeAdmin;

  /// No description provided for @notAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'You are not authenticated. Please sign in to continue.'**
  String get notAuthenticated;

  /// No description provided for @userList.
  ///
  /// In en, this message translates to:
  /// **'User List'**
  String get userList;

  /// No description provided for @errorFetchingUsers.
  ///
  /// In en, this message translates to:
  /// **'Error fetching user list, please try again.'**
  String get errorFetchingUsers;

  /// No description provided for @userDeleted.
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get userDeleted;

  /// No description provided for @userDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete user, please try again.'**
  String get userDeleteError;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @passwordChangeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password, please try again.'**
  String get passwordChangeError;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changeNickname.
  ///
  /// In en, this message translates to:
  /// **'Change Nickname'**
  String get changeNickname;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @nickNameChanged.
  ///
  /// In en, this message translates to:
  /// **'Nickname changed successfully'**
  String get nickNameChanged;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'New password and confirmation do not match.'**
  String get passwordMismatch;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required.'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 6 characters long.'**
  String get passwordMinLength;

  /// No description provided for @passwordMaxLength.
  ///
  /// In en, this message translates to:
  /// **'New password must not exceed 20 characters.'**
  String get passwordMaxLength;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak password'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium password'**
  String get passwordStrengthMedium;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong password'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordStrength.
  ///
  /// In en, this message translates to:
  /// **'Password Strength'**
  String get passwordStrength;

  /// No description provided for @passwordStrengthDescription.
  ///
  /// In en, this message translates to:
  /// **'Use a mix of letters, numbers, and symbols for a stronger password.'**
  String get passwordStrengthDescription;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @deleteUserConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete user {username}?'**
  String deleteUserConfirmation(Object username);

  /// No description provided for @serverConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Server Connection Error'**
  String get serverConnectionError;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @purgeTasks.
  ///
  /// In en, this message translates to:
  /// **'Purge Tasks'**
  String get purgeTasks;

  /// No description provided for @purgeTasksConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all tasks? This action cannot be undone.'**
  String get purgeTasksConfirmation;

  /// No description provided for @purgeTasksSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tasks purged successfully'**
  String get purgeTasksSuccess;

  /// No description provided for @purgeTasksError.
  ///
  /// In en, this message translates to:
  /// **'Error purging tasks'**
  String get purgeTasksError;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// No description provided for @downloadClients.
  ///
  /// In en, this message translates to:
  /// **'Download Clients'**
  String get downloadClients;

  /// No description provided for @downloadAndroid.
  ///
  /// In en, this message translates to:
  /// **'Download Android App'**
  String get downloadAndroid;

  /// No description provided for @downloadMacOS.
  ///
  /// In en, this message translates to:
  /// **'Download macOS App'**
  String get downloadMacOS;

  /// No description provided for @downloadWindows.
  ///
  /// In en, this message translates to:
  /// **'Download Windows App'**
  String get downloadWindows;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {username}'**
  String helloUser(Object username);

  /// No description provided for @notificationSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to be notified for different task events'**
  String get notificationSettingsDescription;

  /// No description provided for @onAssigned.
  ///
  /// In en, this message translates to:
  /// **'When Assigned'**
  String get onAssigned;

  /// No description provided for @onStarted.
  ///
  /// In en, this message translates to:
  /// **'When Started'**
  String get onStarted;

  /// No description provided for @onOverdue.
  ///
  /// In en, this message translates to:
  /// **'When Overdue'**
  String get onOverdue;

  /// No description provided for @onGraded.
  ///
  /// In en, this message translates to:
  /// **'When Graded'**
  String get onGraded;

  /// No description provided for @onCompleted.
  ///
  /// In en, this message translates to:
  /// **'When Completed'**
  String get onCompleted;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @disclaimerAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get disclaimerAndPrivacy;

  /// No description provided for @smartopia.
  ///
  /// In en, this message translates to:
  /// **'Smartopia'**
  String get smartopia;

  /// No description provided for @homeworkManager.
  ///
  /// In en, this message translates to:
  /// **'Homework Manager'**
  String get homeworkManager;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @adminSettings.
  ///
  /// In en, this message translates to:
  /// **'Admin Settings'**
  String get adminSettings;

  /// No description provided for @pleaseLoginToAccessAdminSettings.
  ///
  /// In en, this message translates to:
  /// **'Please login to access admin settings'**
  String get pleaseLoginToAccessAdminSettings;

  /// No description provided for @pointSystemEnabled.
  ///
  /// In en, this message translates to:
  /// **'Point system enabled'**
  String get pointSystemEnabled;

  /// No description provided for @pointSystemDisabled.
  ///
  /// In en, this message translates to:
  /// **'Point system disabled'**
  String get pointSystemDisabled;

  /// No description provided for @enablePointSystem.
  ///
  /// In en, this message translates to:
  /// **'Enable Point System'**
  String get enablePointSystem;

  /// No description provided for @pointSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'When enabled, users earn points for completing tasks'**
  String get pointSystemDescription;

  /// No description provided for @failedToUpdateSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to update settings'**
  String get failedToUpdateSettings;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @purgeAllTemplates.
  ///
  /// In en, this message translates to:
  /// **'Purge All Templates'**
  String get purgeAllTemplates;

  /// No description provided for @purgeTaskTemplates.
  ///
  /// In en, this message translates to:
  /// **'Purge Task Templates'**
  String get purgeTaskTemplates;

  /// No description provided for @purgeTaskTemplatesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all task templates. This action cannot be undone.'**
  String get purgeTaskTemplatesConfirmation;

  /// No description provided for @taskTemplatesPurgedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task templates purged successfully'**
  String get taskTemplatesPurgedSuccessfully;

  /// No description provided for @failedToPurgeTaskTemplates.
  ///
  /// In en, this message translates to:
  /// **'Failed to purge task templates: {error}'**
  String failedToPurgeTaskTemplates(Object error);

  /// No description provided for @saveTaskTemplates.
  ///
  /// In en, this message translates to:
  /// **'Save Task Templates'**
  String get saveTaskTemplates;

  /// No description provided for @taskTemplatesExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task templates exported successfully'**
  String get taskTemplatesExportedSuccessfully;

  /// No description provided for @failedToExportTaskTemplates.
  ///
  /// In en, this message translates to:
  /// **'Failed to export task templates: {error}'**
  String failedToExportTaskTemplates(Object error);

  /// No description provided for @importedTaskTemplates.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} task template(s)'**
  String importedTaskTemplates(Object count);

  /// No description provided for @importedTaskTemplatesWithDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Imported {importedCount} task template(s), {duplicateCount} duplicate(s) skipped'**
  String importedTaskTemplatesWithDuplicates(
    Object duplicateCount,
    Object importedCount,
  );

  /// No description provided for @failedToImportTaskTemplates.
  ///
  /// In en, this message translates to:
  /// **'Failed to import task templates: {error}'**
  String failedToImportTaskTemplates(Object error);

  /// No description provided for @saveTasks.
  ///
  /// In en, this message translates to:
  /// **'Save Tasks'**
  String get saveTasks;

  /// No description provided for @tasksExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Tasks exported successfully'**
  String get tasksExportedSuccessfully;

  /// No description provided for @failedToExportTasks.
  ///
  /// In en, this message translates to:
  /// **'Failed to export tasks: {error}'**
  String failedToExportTasks(Object error);

  /// No description provided for @importedTasks.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} task(s)'**
  String importedTasks(Object count);

  /// No description provided for @importedTasksWithDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Imported {importedCount} task(s), {duplicateCount} duplicate(s) skipped'**
  String importedTasksWithDuplicates(
    Object duplicateCount,
    Object importedCount,
  );

  /// No description provided for @failedToImportTasks.
  ///
  /// In en, this message translates to:
  /// **'Failed to import tasks: {error}'**
  String failedToImportTasks(Object error);

  /// No description provided for @duplicateItemsNotImported.
  ///
  /// In en, this message translates to:
  /// **'Duplicate {itemType} Not Imported'**
  String duplicateItemsNotImported(Object itemType);

  /// No description provided for @noTitle.
  ///
  /// In en, this message translates to:
  /// **'No title'**
  String get noTitle;

  /// No description provided for @assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assigned;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @helperWhatIsThis.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get helperWhatIsThis;

  /// No description provided for @helperIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Smartopia Homework is a comprehensive task management system designed for families. Parents can create and assign homework tasks to their children, set up recurring schedules, and track completion. Children can view their assigned tasks, submit their work, and receive feedback.'**
  String get helperIntroduction;

  /// No description provided for @helperForParents.
  ///
  /// In en, this message translates to:
  /// **'For Parents'**
  String get helperForParents;

  /// No description provided for @helperParentStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Create Child Accounts'**
  String get helperParentStep1Title;

  /// No description provided for @helperParentStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Start by creating accounts for your children. Go to the Users page and add each child with their own username and password.'**
  String get helperParentStep1Desc;

  /// No description provided for @helperParentStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Create Tasks or Templates'**
  String get helperParentStep2Title;

  /// No description provided for @helperParentStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Create individual tasks or reusable task templates. Templates are perfect for recurring assignments like daily reading or weekly math practice.'**
  String get helperParentStep2Desc;

  /// No description provided for @helperParentStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Set Up Schedules'**
  String get helperParentStep3Title;

  /// No description provided for @helperParentStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Configure when tasks should be assigned - once, daily, weekly, or with custom recurrence patterns. Set start times and due dates.'**
  String get helperParentStep3Desc;

  /// No description provided for @helperParentStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Monitor Progress'**
  String get helperParentStep4Title;

  /// No description provided for @helperParentStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Track task submissions, review attached files, and receive notifications when children complete their assignments.'**
  String get helperParentStep4Desc;

  /// No description provided for @helperParentStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Grade and Provide Feedback'**
  String get helperParentStep5Title;

  /// No description provided for @helperParentStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Review submitted work, assign ratings, and provide constructive feedback to help your children improve.'**
  String get helperParentStep5Desc;

  /// No description provided for @helperForChildren.
  ///
  /// In en, this message translates to:
  /// **'For Children'**
  String get helperForChildren;

  /// No description provided for @helperChildStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get helperChildStep1Title;

  /// No description provided for @helperChildStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the username and password your parent created for you to log into the app.'**
  String get helperChildStep1Desc;

  /// No description provided for @helperChildStep2Title.
  ///
  /// In en, this message translates to:
  /// **'View Your Tasks'**
  String get helperChildStep2Title;

  /// No description provided for @helperChildStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'See all your assigned tasks on the homepage. Tasks are organized by status: not started, in progress, and completed.'**
  String get helperChildStep2Desc;

  /// No description provided for @helperChildStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Complete and Submit'**
  String get helperChildStep3Title;

  /// No description provided for @helperChildStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Work on your assignments and submit them when done. You can attach files if required by the task.'**
  String get helperChildStep3Desc;

  /// No description provided for @helperChildStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Check Feedback'**
  String get helperChildStep4Title;

  /// No description provided for @helperChildStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'After submission, check back to see your parent\'s feedback and rating. Learn from the feedback to improve!'**
  String get helperChildStep4Desc;

  /// No description provided for @helperKeyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get helperKeyFeatures;

  /// No description provided for @helperFeature1.
  ///
  /// In en, this message translates to:
  /// **'Recurring Tasks - Set up daily, weekly, or custom schedules'**
  String get helperFeature1;

  /// No description provided for @helperFeature2.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync - Access your tasks from any device'**
  String get helperFeature2;

  /// No description provided for @helperFeature3.
  ///
  /// In en, this message translates to:
  /// **'Multi-Platform - Available on Web, iOS, Android, Windows, and macOS'**
  String get helperFeature3;

  /// No description provided for @helperFeature4.
  ///
  /// In en, this message translates to:
  /// **'Multilingual - Full support for English and Chinese'**
  String get helperFeature4;

  /// No description provided for @helperFooter.
  ///
  /// In en, this message translates to:
  /// **'Start organizing homework and learning tasks today!'**
  String get helperFooter;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Homework, Unleash Potential'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The ultimate tool for parents and students to organize tasks, track progress, and make learning fun.'**
  String get heroSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @feature1Title.
  ///
  /// In en, this message translates to:
  /// **'Effortless Organization'**
  String get feature1Title;

  /// No description provided for @feature1Desc.
  ///
  /// In en, this message translates to:
  /// **'Assign and track homework with ease. Never miss a deadline again.'**
  String get feature1Desc;

  /// No description provided for @feature2Title.
  ///
  /// In en, this message translates to:
  /// **'Gamified Learning'**
  String get feature2Title;

  /// No description provided for @feature2Desc.
  ///
  /// In en, this message translates to:
  /// **'Earn points and rewards for completing tasks. Make studying an adventure.'**
  String get feature2Desc;

  /// No description provided for @feature3Title.
  ///
  /// In en, this message translates to:
  /// **'Insightful Progress'**
  String get feature3Title;

  /// No description provided for @feature3Desc.
  ///
  /// In en, this message translates to:
  /// **'Visualize academic growth with detailed charts and reports.'**
  String get feature3Desc;

  /// No description provided for @feature4Title.
  ///
  /// In en, this message translates to:
  /// **'Family Connection'**
  String get feature4Title;

  /// No description provided for @feature4Desc.
  ///
  /// In en, this message translates to:
  /// **'Stay connected with your child\'s learning journey through real-time updates.'**
  String get feature4Desc;

  /// No description provided for @connectToServer.
  ///
  /// In en, this message translates to:
  /// **'Connect to Server'**
  String get connectToServer;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @pushNotification.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get pushNotification;

  /// No description provided for @taskMaxPoints.
  ///
  /// In en, this message translates to:
  /// **'Max Points'**
  String get taskMaxPoints;

  /// No description provided for @pointSystemSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the point system theme for rewards'**
  String get pointSystemSettingsDescription;

  /// No description provided for @selectPointSystem.
  ///
  /// In en, this message translates to:
  /// **'Select Point System'**
  String get selectPointSystem;

  /// No description provided for @pointSystemSettingChanged.
  ///
  /// In en, this message translates to:
  /// **'Point System Changed'**
  String get pointSystemSettingChanged;

  /// No description provided for @pointSystemSettingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to set/change the point system'**
  String get pointSystemSettingFailed;

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// No description provided for @rewardsShop.
  ///
  /// In en, this message translates to:
  /// **'Rewards Shop'**
  String get rewardsShop;

  /// No description provided for @manageShopItems.
  ///
  /// In en, this message translates to:
  /// **'Manage Shop Items'**
  String get manageShopItems;

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @redeemedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Item redeemed successfully!'**
  String get redeemedSuccessfully;

  /// No description provided for @notEnoughPoints.
  ///
  /// In en, this message translates to:
  /// **'Not enough points'**
  String get notEnoughPoints;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @costPoints.
  ///
  /// In en, this message translates to:
  /// **'Cost (Points)'**
  String get costPoints;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @redemptionHistory.
  ///
  /// In en, this message translates to:
  /// **'Redemption History'**
  String get redemptionHistory;

  /// No description provided for @noRedemptions.
  ///
  /// In en, this message translates to:
  /// **'No items redeemed yet.'**
  String get noRedemptions;

  /// No description provided for @pleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get pleaseFillRequiredFields;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @costRequired.
  ///
  /// In en, this message translates to:
  /// **'Cost is required'**
  String get costRequired;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @unknownItem.
  ///
  /// In en, this message translates to:
  /// **'Unknown Item'**
  String get unknownItem;

  /// No description provided for @noItemsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No items available'**
  String get noItemsAvailable;

  /// No description provided for @taskRewardPoints.
  ///
  /// In en, this message translates to:
  /// **'Reward Points'**
  String get taskRewardPoints;

  /// No description provided for @taskReviewConfirmCreate.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Create All'**
  String get taskReviewConfirmCreate;

  /// No description provided for @taskReviewGlobalSettings.
  ///
  /// In en, this message translates to:
  /// **'Global Settings (Apply to All Tasks)'**
  String get taskReviewGlobalSettings;

  /// No description provided for @createTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTaskTitle;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @galleryFiles.
  ///
  /// In en, this message translates to:
  /// **'Gallery / Files'**
  String get galleryFiles;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @recordVoice.
  ///
  /// In en, this message translates to:
  /// **'Record Voice'**
  String get recordVoice;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @recordingSaved.
  ///
  /// In en, this message translates to:
  /// **'Recording Saved!'**
  String get recordingSaved;

  /// No description provided for @tapMicToRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap mic to record'**
  String get tapMicToRecord;

  /// No description provided for @useRecording.
  ///
  /// In en, this message translates to:
  /// **'Use Recording'**
  String get useRecording;

  /// No description provided for @reviewTasks.
  ///
  /// In en, this message translates to:
  /// **'Review Tasks'**
  String get reviewTasks;

  /// No description provided for @noTasksToReview.
  ///
  /// In en, this message translates to:
  /// **'No tasks to review'**
  String get noTasksToReview;

  /// No description provided for @errorSavingTasks.
  ///
  /// In en, this message translates to:
  /// **'Error saving tasks: {error}'**
  String errorSavingTasks(String error);

  /// No description provided for @failedToExtractTasks.
  ///
  /// In en, this message translates to:
  /// **'Failed to extract tasks: {error}'**
  String failedToExtractTasks(String error);

  /// No description provided for @applyGlobalRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Apply Global Recurrence'**
  String get applyGlobalRecurrence;

  /// No description provided for @applyGlobalRecurrenceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will override all individual task recurrence settings. Are you sure?'**
  String get applyGlobalRecurrenceConfirmation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
