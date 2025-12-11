// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get changingAccountTypeNotAllowed => '不允许更改账户类型';

  @override
  String get allowSelfHomeworkManagement => '允许自主管理作业';

  @override
  String get taskManageSelfHomework => '允许自主管理作业';

  @override
  String get homepage => '首页';

  @override
  String get appTitle => '智趣•作业管理';

  @override
  String get appDescription => '学习的好伙伴';

  @override
  String get users => '用户';

  @override
  String get language => '语言';

  @override
  String get profile => '个人资料';

  @override
  String get settings => '设置';

  @override
  String get serverSettings => '服务器';

  @override
  String get admin => '管理';

  @override
  String get createTask => '创建任务';

  @override
  String get taskPrint => '打印';

  @override
  String get tasks => '任务';

  @override
  String get taskName => '任务名称';

  @override
  String get taskDescription => '任务描述';

  @override
  String get taskTags => '标签';

  @override
  String get taskDueDate => '截止日期';

  @override
  String get taskDueDuration => '截止时长';

  @override
  String get taskExpectedCompletionDuration => '预计所需时长';

  @override
  String get taskExpectedCompletionDurationHint => '您预计需要多长时间来完成此任务？';

  @override
  String get taskExpectedCompletionDurationRequired => '预计所需时长是必填项';

  @override
  String get rpHourly => '每小时';

  @override
  String get rpWeekly => '每周';

  @override
  String get rpDaily => '每天';

  @override
  String get rpMonthly => '每月';

  @override
  String get rpYearly => '每年';

  @override
  String get rpEvery => '每';

  @override
  String get rpEveryWeek => '每周';

  @override
  String get rpHourlyAt => '第';

  @override
  String get rpNext => '下次';

  @override
  String get rpNextStart => '开始';

  @override
  String get rpNextDue => '截止';

  @override
  String get year => '年';

  @override
  String get months => '月';

  @override
  String get days => '天';

  @override
  String get hours => '小时';

  @override
  String get minutes => '分钟';

  @override
  String get rpMonday => '周一';

  @override
  String get rpTuesday => '周二';

  @override
  String get rpWednesday => '周三';

  @override
  String get rpThursday => '周四';

  @override
  String get rpFriday => '周五';

  @override
  String get rpSaturday => '周六';

  @override
  String get rpSunday => '周日';

  @override
  String get rpMondayBrief => '一';

  @override
  String get rpTuesdayBrief => '二';

  @override
  String get rpWednesdayBrief => '三';

  @override
  String get rpThursdayBrief => '四';

  @override
  String get rpFridayBrief => '五';

  @override
  String get rpSaturdayBrief => '六';

  @override
  String get rpSundayBrief => '日';

  @override
  String get rpTimePointRequired => '至少需要一个时间点。';

  @override
  String get rpStartDate => '开始日期';

  @override
  String get rpEndDate => '结束日期';

  @override
  String get rpTimeAlreadySelected => '时间点已被选择';

  @override
  String get rpLastDayOfMonth => '月底';

  @override
  String get rpOnce => '单次';

  @override
  String get taskReward => '奖励';

  @override
  String get taskOtherReward => '其它奖励';

  @override
  String get taskPenalty => '惩罚';

  @override
  String get taskCreate => '创建任务';

  @override
  String get taskUpdate => '更新任务';

  @override
  String get taskSave => '保存任务';

  @override
  String get taskEdit => '编辑任务';

  @override
  String get taskDelete => '删除任务';

  @override
  String get taskDetails => '任务详情';

  @override
  String taskAttachmentExceedsLimit(num maxSize) {
    return '附件超过限制大小 $maxSize MB。';
  }

  @override
  String get taskStatusCompleted => '已完成';

  @override
  String get taskStatusNotStarted => '未开始';

  @override
  String get taskStatusInProgress => '待完成';

  @override
  String get taskStatusOverdue => '已逾期';

  @override
  String get taskStatusAwaitGrading => '待评分';

  @override
  String get taskStatusGraded => '已评分';

  @override
  String get taskStatusCancelled => '已取消';

  @override
  String get taskCancelTitle => '取消任务';

  @override
  String get taskCancelConfirmation => '您确定要取消此任务吗？';

  @override
  String get taskCancelSuccess => '任务取消成功';

  @override
  String get taskCancelError => '取消任务失败，请重试。';

  @override
  String get taskCreated => '任务创建成功';

  @override
  String get taskCreateError => '创建任务失败';

  @override
  String get taskUpdated => '任务更新成功';

  @override
  String get taskUpdateError => '任务更新失败';

  @override
  String get taskDeleted => '任务删除成功';

  @override
  String get taskDeleteError => '删除任务失败';

  @override
  String get taskDueDuratonRequired => '截止时长是必填项';

  @override
  String get taskUpcomingInstance => '即将到来';

  @override
  String get taskDeleteConfirmation => '您确定要删除此任务吗？';

  @override
  String get taskAssignedUsersRequired => '需要分配给至少一个用户';

  @override
  String get taskAssignedUsers => '分配给';

  @override
  String get taskErrorLoadingChildren => '加载孩子列表时出错';

  @override
  String get taskCreateChildAccountFirst => '请先创建一个孩子账户';

  @override
  String get taskRemindTitle => '提前提醒';

  @override
  String get taskSubmitIconTooltip => '提交任务';

  @override
  String get taskSubmitTitle => '提交任务';

  @override
  String get taskSubmitSuccess => '任务提交成功';

  @override
  String get taskAlreadySubmitted => '任务已提交';

  @override
  String get taskSubmitRequired => '需手动提交';

  @override
  String get taskSubmitError => '提交任务失败，请重试。';

  @override
  String get taskSubmitDateTime => '完成时间';

  @override
  String get taskHowWouldYouRate => '您如何评价此任务完成情况？';

  @override
  String get taskAreYouSureToGiveZeroStar => '您确定要给此任务打零分吗？';

  @override
  String get taskAssignedTo => '分配给';

  @override
  String get taskStartAt => '开始于';

  @override
  String get taskDueAt => '截止于';

  @override
  String get taskSubmittedFiles => '已提交文件';

  @override
  String get taskCompletedAt => '完成于';

  @override
  String get taskRating => '评分';

  @override
  String get taskGradedAt => '评分时间';

  @override
  String get taskGradedBy => '评分人';

  @override
  String get taskNotFound => '任务未找到';

  @override
  String get taskSubmitionHeader => '提交任务';

  @override
  String get taskAttachmentRequired => '需上传附件';

  @override
  String get taskInstanceListTitle => '任务列表';

  @override
  String get selectFilesOptional => '选择附件（可选）';

  @override
  String get selectFilesRequired => '选择附件（必须）';

  @override
  String get goBackButtonText => '返回';

  @override
  String get grade => '评分';

  @override
  String get submit => '提交';

  @override
  String get unsubmit => '撤销提交';

  @override
  String get noTasks => '没有任务';

  @override
  String get taskTemplates => '任务模版';

  @override
  String get taskFilter => '筛选';

  @override
  String get signIn => '登录';

  @override
  String get signOut => '登出';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get signInError => '登录失败，请检查用户名和密码。';

  @override
  String get signInSuccess => '登录成功！';

  @override
  String get signInRequireUsername => '请输入用户名';

  @override
  String get signInRequirePassword => '请输入密码';

  @override
  String get signup => '注册';

  @override
  String get signUpSuccess => '注册成功！';

  @override
  String get signUpError => '注册失败，请重试。';

  @override
  String get signupFirstAccount => '创建第一个家长账户';

  @override
  String get checkingSignupAllowed => '正在检查是否允许注册...';

  @override
  String get signupNotAllowedMessage => '当前不允许注册。要创建账户，请联系已有账户的家长。';

  @override
  String get createAccount => '创建';

  @override
  String get createAccountTitle => '创建账户';

  @override
  String get createAccountSuccess => '账户创建成功！';

  @override
  String get createAccountError => '账户创建失败，请重试。';

  @override
  String get deleteAccountError => '删除账户失败，请重试。';

  @override
  String get deleteAccountSuccess => '账户删除成功！';

  @override
  String get failToFetchUser => '获取用户信息失败，请重试。';

  @override
  String get userDetailTitle => '用户详情';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get save => '保存';

  @override
  String get update => '更新';

  @override
  String get recurrenceLabel => '重复';

  @override
  String get nextDueLabel => '下次执行';

  @override
  String get email => '电子邮件';

  @override
  String get mqtt => 'MQTT';

  @override
  String get sms => '短信';

  @override
  String get notificationSettings => '通知';

  @override
  String get notifyWhenAssigned => '分配时';

  @override
  String get notifyWhenOverdue => '截止时';

  @override
  String get notifyWhenGraded => '评分时';

  @override
  String get notifyWhenCompleted => '提交时';

  @override
  String get notifyWhenStarted => '开始时';

  @override
  String get filterByDate => '按日期筛选';

  @override
  String get filterByStatus => '按状态筛选';

  @override
  String get filterToday => '今天';

  @override
  String get filterTomorrow => '明天';

  @override
  String get filterThisWeek => '本周';

  @override
  String get filterNextWeek => '下周';

  @override
  String get filterThisWeekend => '本周末';

  @override
  String get filterByChild => '按孩子筛选';

  @override
  String get mqttBroker => 'MQTT 代理';

  @override
  String get mqttBrokerHost => '代理主机';

  @override
  String get mqttBrokerPort => '代理端口';

  @override
  String get mqttTopic => '主题';

  @override
  String get mqttClientId => '客户端 ID';

  @override
  String get mqttUsername => '用户名';

  @override
  String get mqttPassword => '密码';

  @override
  String get mqttConnection => 'MQTT 连接';

  @override
  String get mqttConnectionSettings => 'MQTT 连接设置';

  @override
  String get mqttConnectionTest => '测试连接';

  @override
  String get mqttConnectionTestSuccess => 'MQTT 连接测试成功';

  @override
  String get mqttConnectionTestError => 'MQTT 连接测试失败，请检查您的设置。';

  @override
  String get mqttConnectionStatus => 'MQTT 连接状态';

  @override
  String get mqttConnectionStatusConnected => '已连接';

  @override
  String get mqttConnectionStatusDisconnected => '已断开连接';

  @override
  String get mqttConnectionStatusConnecting => '连接中';

  @override
  String get mqttConnectionStatusError => '连接错误';

  @override
  String get mqttConnectionError => 'MQTT 连接错误，请检查您的设置。';

  @override
  String get mqttConnectionSuccess => '成功连接到 MQTT 代理';

  @override
  String get mqttSubscriptionError => 'MQTT 订阅错误，请检查您的设置。';

  @override
  String get sseConnection => 'SSE 连接';

  @override
  String get sseConnectionStatus => 'SSE 连接状态';

  @override
  String get connected => '已连接';

  @override
  String get disconnected => '已断开';

  @override
  String get refresh => '刷新';

  @override
  String get accountType => '账户类型';

  @override
  String get accountTypeParent => '家长';

  @override
  String get accountTypeChild => '孩子';

  @override
  String get accountTypeAdmin => '管理员';

  @override
  String get notAuthenticated => '您未认证。请登录以继续。';

  @override
  String get userList => '用户列表';

  @override
  String get errorFetchingUsers => '获取用户列表时出错，请重试。';

  @override
  String get userDeleted => '用户删除成功';

  @override
  String get userDeleteError => '删除用户失败，请重试。';

  @override
  String get passwordChanged => '密码更改成功';

  @override
  String get passwordChangeError => '更改密码失败，请重试。';

  @override
  String get changePassword => '更改密码';

  @override
  String get changeNickname => '更改昵称';

  @override
  String get nickname => '昵称';

  @override
  String get nickNameChanged => '昵称更改成功';

  @override
  String get currentPassword => '当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get passwordMismatch => '新密码和确认密码不匹配。';

  @override
  String get passwordRequired => '新密码是必填项。';

  @override
  String get passwordMinLength => '新密码至少需要 6 个字符。';

  @override
  String get passwordMaxLength => '新密码不能超过 20 个字符。';

  @override
  String get passwordStrengthWeak => '弱密码';

  @override
  String get passwordStrengthMedium => '中等密码';

  @override
  String get passwordStrengthStrong => '强密码';

  @override
  String get passwordStrength => '密码强度';

  @override
  String get passwordStrengthDescription => '密码强度描述';

  @override
  String get deleteUser => '删除用户';

  @override
  String deleteUserConfirmation(Object username) {
    return '您确定要删除用户 $username 吗？';
  }

  @override
  String get serverConnectionError => '服务器连接错误';

  @override
  String get host => '主机';

  @override
  String get port => '端口';

  @override
  String get purgeTasks => '清空任务';

  @override
  String get purgeTasksConfirmation => '确定要删除所有任务吗？此操作无法撤销。';

  @override
  String get purgeTasksSuccess => '任务清空成功';

  @override
  String get purgeTasksError => '清空任务失败';

  @override
  String get areYouSure => '确定吗？';

  @override
  String get serverUrl => '服务器地址';

  @override
  String get downloadClients => '下载客户端';

  @override
  String get downloadAndroid => '下载安卓应用';

  @override
  String get downloadMacOS => '下载苹果应用';

  @override
  String get downloadWindows => '下载Windows应用';

  @override
  String helloUser(Object username) {
    return '您好，$username';
  }

  @override
  String get notificationSettingsDescription => '管理通知的接收方式和内容';

  @override
  String get onAssigned => '任务分配时';

  @override
  String get onStarted => '任务开始时';

  @override
  String get onOverdue => '任务逾期时';

  @override
  String get onGraded => '任务评分时';

  @override
  String get onCompleted => '任务完成时';

  @override
  String get success => '成功';

  @override
  String get saving => '保存中...';

  @override
  String get disclaimerAndPrivacy => '条款与隐私';

  @override
  String get smartopia => '智趣';

  @override
  String get homeworkManager => '作业管理';

  @override
  String get dismiss => '关闭';

  @override
  String get adminSettings => '管理设置';

  @override
  String get pleaseLoginToAccessAdminSettings => '请登录以访问管理设置';

  @override
  String get pointSystemEnabled => '积分系统已启用';

  @override
  String get pointSystemDisabled => '积分系统已禁用';

  @override
  String get enablePointSystem => '启用积分系统';

  @override
  String get pointSystemDescription => '启用后,用户完成任务可获得积分';

  @override
  String get failedToUpdateSettings => '更新设置失败';

  @override
  String get export => '导出';

  @override
  String get import => '导入';

  @override
  String get purgeAllTemplates => '清空所有模版';

  @override
  String get purgeTaskTemplates => '清空任务模版';

  @override
  String get purgeTaskTemplatesConfirmation => '此操作将永久删除所有任务模版,无法撤销。';

  @override
  String get taskTemplatesPurgedSuccessfully => '任务模版清空成功';

  @override
  String failedToPurgeTaskTemplates(Object error) {
    return '清空任务模版失败:$error';
  }

  @override
  String get saveTaskTemplates => '保存任务模版';

  @override
  String get taskTemplatesExportedSuccessfully => '任务模版导出成功';

  @override
  String failedToExportTaskTemplates(Object error) {
    return '导出任务模版失败:$error';
  }

  @override
  String importedTaskTemplates(Object count) {
    return '已导入 $count 个任务模版';
  }

  @override
  String importedTaskTemplatesWithDuplicates(
    Object duplicateCount,
    Object importedCount,
  ) {
    return '已导入 $importedCount 个任务模版,跳过 $duplicateCount 个重复项';
  }

  @override
  String failedToImportTaskTemplates(Object error) {
    return '导入任务模版失败:$error';
  }

  @override
  String get saveTasks => '保存任务';

  @override
  String get tasksExportedSuccessfully => '任务导出成功';

  @override
  String failedToExportTasks(Object error) {
    return '导出任务失败:$error';
  }

  @override
  String importedTasks(Object count) {
    return '已导入 $count 个任务';
  }

  @override
  String importedTasksWithDuplicates(
    Object duplicateCount,
    Object importedCount,
  ) {
    return '已导入 $importedCount 个任务,跳过 $duplicateCount 个重复项';
  }

  @override
  String failedToImportTasks(Object error) {
    return '导入任务失败:$error';
  }

  @override
  String duplicateItemsNotImported(Object itemType) {
    return '重复的$itemType未导入';
  }

  @override
  String get noTitle => '无标题';

  @override
  String get assigned => '分配给';

  @override
  String get none => '无';

  @override
  String get start => '开始';

  @override
  String get helperWhatIsThis => '关于本应用';

  @override
  String get helperIntroduction =>
      '这是一个作业管理系统，帮助家长为孩子布置任务，并让孩子通过完成任务获得奖励。该应用旨在培养孩子的责任感，同时提供父母监督和激励机制。';

  @override
  String get helperForParents => '家长指南';

  @override
  String get helperParentStep1Title => '创建任务模版';

  @override
  String get helperParentStep1Desc =>
      '定义可重复使用的任务，如\'整理房间\'或\'完成作业\'。设置标题、描述、预计时长和奖励积分。';

  @override
  String get helperParentStep2Title => '为孩子分配任务';

  @override
  String get helperParentStep2Desc => '使用模版或创建自定义任务。选择孩子、设置截止时间，并根据需要添加说明或附件。';

  @override
  String get helperParentStep3Title => '监控进度';

  @override
  String get helperParentStep3Desc => '在任务列表中查看已分配、进行中和已完成的任务。您将收到状态更新的通知。';

  @override
  String get helperParentStep4Title => '审核提交';

  @override
  String get helperParentStep4Desc => '当孩子提交任务时，审核他们的工作。如果符合标准就批准，或者提供反馈拒绝返工。';

  @override
  String get helperParentStep5Title => '管理积分和奖励';

  @override
  String get helperParentStep5Desc => '追踪每个孩子的累积积分，并创建他们可以使用积分兑换的奖励。';

  @override
  String get helperForChildren => '孩子指南';

  @override
  String get helperChildStep1Title => '查看已分配的任务';

  @override
  String get helperChildStep1Desc => '登录后查看家长分配给您的任务。查看说明、截止时间和可获得的奖励积分。';

  @override
  String get helperChildStep2Title => '完成任务';

  @override
  String get helperChildStep2Desc => '开始处理任务,并根据需要添加进度备注。完成后，上传照片或文件作为证明。';

  @override
  String get helperChildStep3Title => '提交审核';

  @override
  String get helperChildStep3Desc => '提交已完成的任务供家长审核。如果获得批准，您将获得积分奖励!';

  @override
  String get helperChildStep4Title => '赚取积分';

  @override
  String get helperChildStep4Desc => '累积积分并使用它们兑换家长设置的特殊奖励和特权。';

  @override
  String get helperKeyFeatures => '主要功能';

  @override
  String get helperFeature1 => '实时通知:通过实时更新了解任务状态变化';

  @override
  String get helperFeature2 => '附件支持:上传照片或文件来记录任务完成情况';

  @override
  String get helperFeature3 => '任务模版:保存常用任务以便快速分配';

  @override
  String get helperFeature4 => '积分系统:通过激励机制激发孩子的积极性';

  @override
  String get helperFooter => '准备好开始了吗?家长可以从创建任务模版开始，孩子可以查看他们的任务!';

  @override
  String get heroTitle => '掌握课业，释放潜能';

  @override
  String get heroSubtitle => '家长和学生的终极工具，轻松管理作业，追踪进度，让学习充满乐趣。';

  @override
  String get getStarted => '立即开始';

  @override
  String get feature1Title => '轻松管理';

  @override
  String get feature1Desc => '轻松布置和追踪作业，不再错过任何截止日期。';

  @override
  String get feature2Title => '游戏化学习';

  @override
  String get feature2Desc => '完成任务赚取积分和奖励，让学习像冒险一样有趣。';

  @override
  String get feature3Title => '进度洞察';

  @override
  String get feature3Desc => '通过详细的图表和报告，可视化孩子的学业成长。';

  @override
  String get feature4Title => '家庭互联';

  @override
  String get feature4Desc => '通过实时更新，随时掌握孩子的学习动态。';

  @override
  String get connectToServer => '连接到服务器';

  @override
  String get connect => '连接';

  @override
  String get required => '必填项';

  @override
  String get title => '标题';

  @override
  String get description => '描述';

  @override
  String get imageUrl => '图片链接';

  @override
  String get pushNotification => '推送消息';

  @override
  String get taskMaxPoints => '最高积分';

  @override
  String get pointSystemSettingsDescription => '选择奖励积分的主题';

  @override
  String get selectPointSystem => '选择积分系统';

  @override
  String get pointSystemSettingChanged => '积分系统修改成功';

  @override
  String get pointSystemSettingFailed => '修改积分系统失败';

  @override
  String get shop => '商店';

  @override
  String get rewardsShop => '奖励商店';

  @override
  String get manageShopItems => '管理商品';

  @override
  String get redeem => '兑换';

  @override
  String get redeemedSuccessfully => '兑换成功！';

  @override
  String get notEnoughPoints => '积分不足';

  @override
  String get unavailable => '不可用';

  @override
  String get available => '可用';

  @override
  String get costPoints => '花费 (积分)';

  @override
  String get addItem => '添加商品';

  @override
  String get editItem => '编辑商品';

  @override
  String get redemptionHistory => '兑换记录';

  @override
  String get noRedemptions => '暂无兑换记录。';

  @override
  String get pleaseFillRequiredFields => '请填写所有必填项';

  @override
  String get titleRequired => '标题为必填项';

  @override
  String get costRequired => '积分为必填项';

  @override
  String get upload => '上传';

  @override
  String get unknownItem => '未知商品';

  @override
  String get noItemsAvailable => '暂无商品';
}
