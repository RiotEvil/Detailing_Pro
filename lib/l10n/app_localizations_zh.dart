// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return '版本 $version';
  }

  @override
  String get navDashboard => '首页';

  @override
  String get navOrders => '订单';

  @override
  String get navClients => '客户';

  @override
  String get navCalendar => '日历';

  @override
  String get navInventory => '库存';

  @override
  String get navStats => '统计';

  @override
  String get navPhotos => '照片';

  @override
  String get navMarketing => '营销';

  @override
  String get navSettings => '设置';

  @override
  String get inventoryEmptyTitle => '库存为空';

  @override
  String get inventoryEmptySubtitle => '点击下方按钮添加产品';

  @override
  String get showAllCategories => '显示所有分类';

  @override
  String get chemicalsButton => '产品';

  @override
  String get cancel => '取消';

  @override
  String get add => '添加';

  @override
  String get save => '保存';

  @override
  String get noOrdersTitle => '暂无订单';

  @override
  String get noOrdersSubtitle => '添加首个订单以开始工作';

  @override
  String get addOrder => '添加服务';

  @override
  String get orderButton => '订单';

  @override
  String get deleteOrderTitle => '删除订单？';

  @override
  String deleteOrderMessage(Object car) {
    return '订单 \"$car\" 将被永久删除。';
  }

  @override
  String deletedOrderSnack(Object car) {
    return '订单 \"$car\" 已删除';
  }

  @override
  String get undo => '撤销';

  @override
  String get delete => '删除';

  @override
  String get carLabel => '车辆';

  @override
  String clientLabel(Object client) {
    return '客户: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return '服务: $service ($duration 分钟)';
  }

  @override
  String get statusScheduled => '已预约';

  @override
  String get statusInProgress => '施工中';

  @override
  String get statusReady => '已完工';

  @override
  String get statusPaid => '已付款';

  @override
  String get statusCompleted => '已完成';

  @override
  String get edit => '编辑';

  @override
  String get start => '开始';

  @override
  String get markDone => '完成';

  @override
  String get markPaid => '已付';

  @override
  String get statusChangedTitle => '状态已更新';

  @override
  String statusChangedMessage(Object car, Object status) {
    return '订单 \"$car\" 当前状态: $status';
  }

  @override
  String get newChemicalTitle => '新产品';

  @override
  String get nameLabel => '名称 *';

  @override
  String get brandLabel => '品牌';

  @override
  String get categoryLabel => '分类';

  @override
  String get volumeLabel => '容量 (ml)';

  @override
  String get deleteItemTitle => '删除？';

  @override
  String deleteItemMessage(Object item) {
    return '确认从库存中删除 \"$item\"？';
  }

  @override
  String get unnamedItem => '未命名';

  @override
  String get replenish => '补充库存';

  @override
  String get languageLabel => '语言';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get goodMorning => '早上好！';

  @override
  String get goodAfternoon => '下午好！';

  @override
  String get goodEvening => '晚上好！';

  @override
  String get statsTodayOrders => '今日预约';

  @override
  String get statsInWork => '施工中';

  @override
  String get statsTodayRevenue => '今日营收';

  @override
  String get statsTotalClients => '客户总数';

  @override
  String get noCars => '暂无车辆';

  @override
  String get quickActions => '快速操作';

  @override
  String get newOrder => '新建预约';

  @override
  String get newClient => '新建客户';

  @override
  String get todayOrdersTitle => '今日订单';

  @override
  String get calendarTitle => '日历';

  @override
  String get monthJanuary => '一月';

  @override
  String get monthFebruary => '二月';

  @override
  String get monthMarch => '三月';

  @override
  String get monthApril => '四月';

  @override
  String get monthMay => '五月';

  @override
  String get monthJune => '六月';

  @override
  String get monthJuly => '七月';

  @override
  String get monthAugust => '八月';

  @override
  String get monthSeptember => '九月';

  @override
  String get monthOctober => '十月';

  @override
  String get monthNovember => '十一月';

  @override
  String get monthDecember => '十二月';

  @override
  String get statsTitle => '统计数据';

  @override
  String get statsRevenue => '营收';

  @override
  String get statsOrders => '订单数';

  @override
  String get statsPeriodWeek => '周';

  @override
  String get statsPeriodMonth => '月';

  @override
  String get statsPeriodYear => '年';

  @override
  String get photosTitle => '照片墙';

  @override
  String get orderBeforePhotosTitle => '之前';

  @override
  String get orderAfterPhotosTitle => '之后';

  @override
  String get photosAdd => '添加照片';

  @override
  String get photosEmpty => '暂无照片';

  @override
  String get photosSelectCar => '选择车辆';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get visits => '到店次数';

  @override
  String get totalSpent => '累计消费';

  @override
  String get orderHistoryTitle => '订单历史';

  @override
  String get orderHistoryEmpty => '历史记录为空';

  @override
  String get call => '致电';

  @override
  String get message => '发消息';

  @override
  String get photoReport => '施工报告';

  @override
  String get photosNotAdded => '未添加照片';

  @override
  String get editOrderTitle => '编辑订单';

  @override
  String get newOrderTitle => '新订单';

  @override
  String get clientFieldLabel => '客户 *';

  @override
  String get selectClient => '选择客户';

  @override
  String get carHint => '品牌及车牌号';

  @override
  String get enterCar => '输入车辆信息';

  @override
  String get serviceFieldLabel => '服务项目 *';

  @override
  String get selectService => '选择服务';

  @override
  String get orderMaterialCostLabel => '材料成本';

  @override
  String get orderLaborCostLabel => '人工成本';

  @override
  String get orderTotalCostLabel => '总成本';

  @override
  String get orderProfitLabel => '利润';

  @override
  String get statsProfit => '利润';

  @override
  String get orderNotesLabel => '订单备注';

  @override
  String get createOrderButton => '创建订单';

  @override
  String get orderUpdated => '订单已更新';

  @override
  String get orderCreated => '订单创建成功';

  @override
  String errorMessage(Object error) {
    return '错误: $error';
  }

  @override
  String get editClient => '编辑客户';

  @override
  String get clientNameLabel => '客户姓名 *';

  @override
  String get enterName => '输入姓名';

  @override
  String get phoneLabel => '电话';

  @override
  String get phoneHint => '输入手机号';

  @override
  String get enterValidPhone => '请输入有效的手机号';

  @override
  String get carsLabel => '名下车辆 *';

  @override
  String get addCar => '添加';

  @override
  String get addAtLeastOneCar => '请至少添加一辆车';

  @override
  String get addCarDialogTitle => '添加车辆';

  @override
  String get carExample => '例如: 奔驰 S级 沪A88888';

  @override
  String get carAlreadyAdded => '该车辆已存在';

  @override
  String get saveChanges => '保存修改';

  @override
  String get saveClient => '保存客户';

  @override
  String get clientUpdated => '客户信息已更新';

  @override
  String get clientAdded => '客户添加成功';

  @override
  String get otherCategory => '其他';

  @override
  String replenishItemTitle(Object item) {
    return '补充 \"$item\"';
  }

  @override
  String get howManyToAdd => '补充数量？';

  @override
  String get ml => 'ml';

  @override
  String currentStockTitle(Object item) {
    return '库存: \"$item\"';
  }

  @override
  String get currentStockLabel => '当前剩余容量';

  @override
  String get inactiveClients => '流失客户';

  @override
  String get promotions => '活动与优惠';

  @override
  String get promotionsDescription => '创建活动吸引客户';

  @override
  String get loyaltyProgram => '会员计划';

  @override
  String get loyaltyDescription => '奖励忠实客户';

  @override
  String get smsBroadcast => '短信群发';

  @override
  String get smsDescription => '发送提醒和新闻';

  @override
  String get reviews => '客户评价';

  @override
  String get reviewsDescription => '收集评价提升服务';

  @override
  String get comingSoon => '功能开发中';

  @override
  String get gotIt => '知道了';

  @override
  String get ordersChannelName => '订单通知';

  @override
  String get ordersChannelDescription => '有关订单的所有通知';

  @override
  String get currencyLabel => '货币';

  @override
  String get searchClientsHint => '按客户或车辆搜索...';

  @override
  String get crmFilterAll => '全部';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => '有流失风险';

  @override
  String get crmFilterInactive => '不活跃';

  @override
  String get crmTagsLabel => '标签';

  @override
  String get crmTagsHint => 'VIP, 车队, 推荐';

  @override
  String get crmSegmentLabel => '客户分群';

  @override
  String get crmLastVisitLabel => '最近到店';

  @override
  String get crmAtRiskLabel => '需要跟进';

  @override
  String get crmReminderButton => '发送提醒';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return '您好，$client！这是来自精洗门店的温馨提醒。我们可以为您安排 $service，时间可按您方便预约。';
  }

  @override
  String get crmBulkReminderButton => 'CRM群发';

  @override
  String get crmBulkReminderTitle => '选择收件人';

  @override
  String get crmBulkReminderToggleAll => '全部';

  @override
  String get crmBulkReminderSendSelected => '发送给所选客户';

  @override
  String get crmBulkReminderEmpty => '当前列表中没有可用手机号客户。';

  @override
  String get crmBulkReminderTemplate => '您好！这里是精洗门店提醒。您可以预约一个方便的时间进行下一次服务。';

  @override
  String get crmSegmentNew => '新客户';

  @override
  String get crmSegmentReturning => '回访客户';

  @override
  String get crmSegmentLoyal => '忠诚客户';

  @override
  String get clientsNotFound => '未找到客户';

  @override
  String get openCallFailed => '无法打开通话。';

  @override
  String get openWhatsAppFailed => '无法打开短信应用。';

  @override
  String get sortTooltip => '排序';

  @override
  String get sortByNameAsc => '姓名: A-Z';

  @override
  String get sortByNameDesc => '姓名: Z-A';

  @override
  String get sortByNewest => '最新优先';

  @override
  String get permissionDeniedTitle => '权限不足';

  @override
  String get permissionCreateOrderDenied => '没有创建订单的权限。';

  @override
  String get permissionDeleteOrderDenied => '只有主管或所有者可以删除订单。';

  @override
  String get permissionEditOrderDenied => '没有编辑订单的权限。';

  @override
  String get permissionSaveOrderDenied => '没有保存订单的权限。';

  @override
  String get permissionCreateClientDenied => '没有创建客户的权限。';

  @override
  String get permissionDeleteClientDenied => '没有删除客户的权限。';

  @override
  String get permissionEditClientDenied => '没有编辑客户的权限。';

  @override
  String get permissionSaveClientDenied => '没有保存客户的权限。';

  @override
  String get permissionModifyInventoryDenied => '没有修改库存的权限。';

  @override
  String get permissionEditInventoryStockDenied => '没有修改库存数量的权限。';

  @override
  String get permissionEditInventoryDenied => '没有编辑库存的权限。';

  @override
  String get clientDeleted => '客户已删除';

  @override
  String get clientGarageTitle => '客户车辆';

  @override
  String get navTeamChats => '团队聊天';

  @override
  String get navCommunityChat => '社区聊天';

  @override
  String get orderDefaultTitle => '订单';

  @override
  String get completeOrderAndConsumePrompt => '完成服务并从库存扣减化学品吗？';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: 已完成';
  }

  @override
  String get appointmentReminderTitle => '即将到来的预约';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car，时间 $time';
  }

  @override
  String get inventoryFirstItemHint => '添加第一条库存：化学品、耗材、配件或设备。';

  @override
  String get inventoryFilteredEmpty => '所选筛选条件下没有找到项目。';

  @override
  String get inventoryItemLabel => '项目';

  @override
  String inventoryLowStockMore(Object count) {
    return ' 以及另外 $count 个';
  }

  @override
  String get inventoryLowStockTitle => '库存不足';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items 需要关注。';
  }

  @override
  String get inventoryNotificationsChannelName => '库存提醒';

  @override
  String get inventoryNotificationsChannelDescription => '低库存提醒通知';

  @override
  String get inventoryEditItemTitle => '编辑项目';

  @override
  String get inventoryNewItemTitle => '新库存项目';

  @override
  String get inventoryItemTypeLabel => '项目类型';

  @override
  String get inventoryUnitLabel => '单位';

  @override
  String get inventoryCurrentStockLabel => '当前库存';

  @override
  String get inventoryMinStockLabel => '最小库存';

  @override
  String get inventoryLocationLabel => '存放位置';

  @override
  String get inventoryUsageLabel => '用途';

  @override
  String inventoryLowStockCount(Object count) {
    return '低库存: $count';
  }

  @override
  String inventoryLowStockItemLine(
    Object amount,
    Object item,
    Object minStock,
    Object unit,
  ) {
    return '$item: $amount $unit，最低 $minStock $unit';
  }

  @override
  String get inventoryAllTypes => '所有类型';

  @override
  String get inventoryBelowMin => '低于最小值';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return '最小: $minStock $unit';
  }

  @override
  String get chatProfileSaved => '聊天资料已保存';

  @override
  String get chatUnavailableShort => 'Firebase 未配置。聊天暂时不可用。';

  @override
  String get chatCreateDialogTitle => '新对话';

  @override
  String get chatCreateExternalTitle => '新外部聊天';

  @override
  String get chatPeerIdLabelTeam => '技师 ID';

  @override
  String get chatPeerIdLabelExternal => '门店/技师 ID';

  @override
  String get chatPeerNameLabelTeam => '技师姓名';

  @override
  String get chatPeerNameLabelExternal => '门店或技师名称';

  @override
  String get chatCreateAction => '创建';

  @override
  String get chatDialogTitle => '对话';

  @override
  String get chatScreenTitleTeam => '团队内部聊天';

  @override
  String get chatScreenTitleExternal => '社区外部聊天';

  @override
  String get chatNewChatButton => '新聊天';

  @override
  String get chatMyIdLabel => '你的 ID';

  @override
  String get chatMyIdHint => '例如: master_001';

  @override
  String get chatMyNameLabel => '你的姓名';

  @override
  String get chatMyNameHint => '例如: Alex';

  @override
  String get chatUnavailableTitle => '聊天暂时不可用';

  @override
  String get chatUnavailableSubtitle =>
      '当前构建未配置 Firebase。请添加 Firebase 配置以启用聊天。';

  @override
  String get chatProfileFillTitleTeam => '填写聊天资料';

  @override
  String get chatProfileFillTitleExternal => '填写社区资料';

  @override
  String get chatProfileFillSubtitleTeam => '请输入你的 ID 和姓名，然后点击保存。';

  @override
  String get chatProfileFillSubtitleExternal => '请输入你的 ID 和姓名，以便与其他门店和技师聊天。';

  @override
  String get chatErrorTitle => '聊天不可用';

  @override
  String get chatErrorSubtitle =>
      '请检查 Firebase 配置（google-services 和 Firebase.initializeApp）。';

  @override
  String get chatEmptyTitle => '暂无对话';

  @override
  String get chatEmptySubtitle => '点击“新聊天”创建第一个对话。';

  @override
  String get chatNoMessages => '暂无消息';

  @override
  String get chatOpenAfterFirebase => 'Firebase 未配置。请在配置完成后打开聊天。';

  @override
  String get chatConnectionError => '聊天连接错误';

  @override
  String get chatMessageHint => '输入消息';

  @override
  String get chatAttachPhoto => '添加照片';

  @override
  String get chatAttachFile => '添加文件';

  @override
  String get chatAttachmentFile => '文件';

  @override
  String get chatFileOpenFailed => '无法打开文件。';

  @override
  String chatUploadFailed(Object error) {
    return '上传失败：$error';
  }

  @override
  String get durationMinutesShort => '分钟';

  @override
  String get inventoryTypeChemistry => '化学品';

  @override
  String get inventoryTypeConsumable => '耗材';

  @override
  String get inventoryTypeAccessory => '配件';

  @override
  String get inventoryTypeEquipment => '设备';

  @override
  String get emailLabel => '邮箱';

  @override
  String get authEnterEmail => '请输入邮箱';

  @override
  String get authInvalidEmail => '邮箱格式不正确';

  @override
  String get authEnterPassword => '请输入密码';

  @override
  String get authPasswordMin => '至少 8 个字符';

  @override
  String get authFirebaseGuestOnly => 'Firebase 未配置。可使用游客模式。';

  @override
  String get authSignInFailed => '登录失败，请重试。';

  @override
  String get authPasswordsMismatch => '两次输入的密码不一致';

  @override
  String get authJoinSuccess => '你已成功加入团队！';

  @override
  String authInviteRejected(Object error) {
    return '注册已完成，但邀请码无效：$error';
  }

  @override
  String get authRegisterFailed => '注册未完成，请重试。';

  @override
  String get authGuestName => '游客';

  @override
  String get authGoogleSoon => 'Google 登录将稍后添加';

  @override
  String get authInvalidEmailFormat => '邮箱格式无效';

  @override
  String get authWrongCredentials => '邮箱或密码错误';

  @override
  String get authEmailInUse => '该邮箱已被使用';

  @override
  String get authWeakPassword => '密码强度太弱';

  @override
  String get authTooManyRequests => '尝试次数过多，请稍后再试';

  @override
  String get authAuthorizationError => '授权错误';

  @override
  String get authWelcome => '欢迎';

  @override
  String get authSubtitle => '登录账号或注册新账号';

  @override
  String get authTabSignIn => '登录';

  @override
  String get authTabRegister => '注册';

  @override
  String get authContinueWithGoogle => '使用 Google 继续';

  @override
  String get authContinueAsGuest => '以游客身份继续';

  @override
  String get authPasswordLabel => '密码';

  @override
  String get authConfirmPasswordLabel => '确认密码';

  @override
  String get authInviteCodeOptional => '邀请码（可选）';

  @override
  String get authInviteHint => '如果你是由主管邀请';

  @override
  String get authRegisterButton => '注册';

  @override
  String get businessModeQuestion => '你的工作模式是？';

  @override
  String get businessModeSubtitle => '选择模式后，应用只显示你需要的模块。';

  @override
  String get businessModeSoloTitle => '我独立工作';

  @override
  String get businessModeSoloSubtitle => '适合个人技师：订单、客户、库存、财务和外部聊天。';

  @override
  String get businessModeTeamTitle => '我们有团队';

  @override
  String get businessModeTeamSubtitle => '适合门店团队：员工角色、内部聊天、按技师分配任务和主管管控。';

  @override
  String get photosGallerySaveFailed => '照片已添加到应用，但无法保存到相册。';

  @override
  String get photosCameraUnsupported => '相机仅在 Android/iOS 或 Web 版本可用。';

  @override
  String get photosAddedAndSaved => '照片已添加并保存到相册。';

  @override
  String get photosAddedFromGallery => '已从相册添加照片。';

  @override
  String get photosAddFromGallery => '从相册添加';

  @override
  String get photosTakePhoto => '拍照';

  @override
  String get photosDeleteDenied => '没有权限删除照片。';

  @override
  String get settingsProfileAndOrgTitle => '个人资料与组织';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => '游客';

  @override
  String get settingsBusinessModeTitle => '工作模式';

  @override
  String get settingsUserRoleTitle => '用户角色';

  @override
  String get settingsInviteMasterTitle => '邀请技师';

  @override
  String get settingsInviteMasterSubtitle => '生成一次性邀请码';

  @override
  String get settingsServicesSection => '服务';

  @override
  String get settingsLogoutButton => '退出账号';

  @override
  String get settingsBusinessModeTeam => '团队（门店）';

  @override
  String get settingsBusinessModeSolo => '单人（单技师）';

  @override
  String get settingsRoleDirector => '主管';

  @override
  String get settingsRoleMaster => '技师';

  @override
  String get settingsRoleMasterOwner => '店主技师';

  @override
  String get settingsSelectModeTitle => '选择模式';

  @override
  String get settingsModeSoloTitle => '单人';

  @override
  String get settingsModeSoloSubtitle => '一个技师';

  @override
  String get settingsModeTeamTitle => '团队';

  @override
  String get settingsModeTeamSubtitle => '有员工的门店';

  @override
  String get settingsModeUpdated => '模式已更新。';

  @override
  String get settingsOrgNotFound => '未找到组织，请先保存设置。';

  @override
  String settingsInviteGenerateError(Object error) {
    return '生成邀请码出错：$error';
  }

  @override
  String get settingsInviteDialogTitle => '技师邀请码';

  @override
  String get settingsInviteDialogDescription => '请将此码发送给技师。该码仅可使用一次，使用后失效。';

  @override
  String get settingsCopy => '复制';

  @override
  String get settingsCodeCopied => '代码已复制到剪贴板';

  @override
  String get settingsInviteRegistrationHint => '技师在注册时，在邀请码字段中输入该代码。';

  @override
  String get settingsClose => '关闭';

  @override
  String get settingsSelectRoleTitle => '选择角色';

  @override
  String get settingsRoleUpdated => '角色已更新。';

  @override
  String get settingsLogoutTitle => '退出';

  @override
  String get settingsLogoutMessage => '要退出当前账号吗？';

  @override
  String get settingsLogoutConfirm => '退出';

  @override
  String get settingsLoggedOut => '你已退出账号。';

  @override
  String get settingsAccessDenied => '没有执行此操作的权限。';

  @override
  String get settingsResetWarning => '警告：所有订单、客户和库存将被删除！';

  @override
  String get settingsServiceDeleteDenied => '没有权限删除服务。';

  @override
  String get settingsServiceEditDenied => '没有权限编辑服务。';

  @override
  String get legalTitle => '法律信息';

  @override
  String get legalPrivacyTab => '隐私政策';

  @override
  String get legalTermsTab => '服务条款';

  @override
  String get legalPrivacySummaryTitle => '隐私政策摘要';

  @override
  String get legalTermsSummaryTitle => '服务条款摘要';

  @override
  String get legalSummarySubtitle => '应用内快速摘要。完整法律版本可在已发布页面查看。';

  @override
  String get legalOpenFullPrivacy => '打开完整隐私政策';

  @override
  String get legalOpenFullTerms => '打开完整条款';

  @override
  String get legalOpenLinkError => '无法打开文档链接。';

  @override
  String get legalPrivacySection1Title => '1. 应用的功能';

  @override
  String get legalPrivacySection1Body =>
      'DetailingPro Business 帮助汽车美容团队管理客户、订单、日程、库存、团队聊天和附件媒体。';

  @override
  String get legalPrivacySection2Title => '2. 我们处理的数据';

  @override
  String get legalPrivacySection2Body =>
      '应用可能处理账户数据、客户和订单数据、服务记录、库存条目、团队消息、附件以及通知令牌等技术标识符。';

  @override
  String get legalPrivacySection3Title => '3. 数据用途';

  @override
  String get legalPrivacySection3Body =>
      '这些数据用于运行核心功能、跨设备同步、发送提醒、支持协作，并维护服务的可靠性与安全性。';

  @override
  String get legalPrivacySection4Title => '4. 权限与访问';

  @override
  String get legalPrivacySection4Body =>
      '相机和媒体权限仅在照片与文件附件等功能中请求。通知权限用于提醒和推送消息。';

  @override
  String get legalPrivacySection5Title => '5. 基础设施与提供方';

  @override
  String get legalPrivacySection5Body =>
      '应用使用 Firebase 服务（Authentication、Firestore、Storage、Messaging）。数据在这些提供方的基础设施上处理。';

  @override
  String get legalPrivacySection6Title => '6. 保留、删除与权利';

  @override
  String get legalPrivacySection6Body =>
      '数据将在提供服务所需期间内保留。用户可根据适用法律请求访问、更正或删除数据。';

  @override
  String get legalPrivacySection7Title => '7. 联系方式';

  @override
  String get legalPrivacySection7Body =>
      '隐私相关问题：support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. 服务范围';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro 是一款业务效率应用，用于管理预约、客户、媒体、内部聊天和运营数据。';

  @override
  String get legalTermsSection2Title => '2. 账户与访问';

  @override
  String get legalTermsSection2Body => '用户有责任妥善保管登录凭据，并仅在其角色授权范围内使用本应用。';

  @override
  String get legalTermsSection3Title => '3. 可接受使用';

  @override
  String get legalTermsSection3Body =>
      '本服务不得用于非法数据处理、滥用消息、未授权访问尝试或任何违反适用法律的活动。';

  @override
  String get legalTermsSection4Title => '4. 可用性';

  @override
  String get legalTermsSection4Body => '服务可能随时间发生变化。随着产品演进，功能可能被新增、修改或移除。';

  @override
  String get legalTermsSection5Title => '5. 付费方案';

  @override
  String get legalTermsSection5Body =>
      '在正式发布前，本节应更新为最终计费条款、续订规则、试用细则、取消条件以及 Google Play 订阅退款处理方式。';

  @override
  String get legalTermsSection6Title => '6. 责任限制';

  @override
  String get legalTermsSection6Body => '在公开发布前，请将本草案替换为适用于你所在司法辖区和企业结构的最终法律版本。';

  @override
  String get legalTermsSection7Title => '7. 法律信息';

  @override
  String get legalTermsSection7Body => '发布到商店前，请将本节替换为你已注册的业务信息和适用法律信息。';

  @override
  String get invoiceCompanyDataTitle => '公司信息';

  @override
  String get invoiceCompanyDataSubtitle => '用于开票';

  @override
  String get invoiceCompanyName => '公司名称';

  @override
  String get invoiceCompanyAddress => '地址';

  @override
  String get invoiceCompanyPostalCode => '邮政编码';

  @override
  String get invoiceCompanyCity => '城市';

  @override
  String get invoiceGenerateButton => '生成发票';

  @override
  String get invoiceVatRate => '税率';

  @override
  String get settingsBookingLinkTitle => '在线预约链接';

  @override
  String get settingsBookingRequestsTitle => '在线预约请求';

  @override
  String get settingsBookingLinkDialogTitle => '你的预约链接';

  @override
  String get settingsBookingLinkCopied => '链接已复制';

  @override
  String get settingsBookingLinkAuthRequired => '请先登录以生成预约链接。';

  @override
  String get settingsBookingLinkOpen => '打开';

  @override
  String get settingsWorkingHoursTitle => '工作时间';

  @override
  String get settingsWorkingHoursSlotLabel => '时间间隔';

  @override
  String get settingsWorkingHoursMinNoticeLabel => '最短提前时间';

  @override
  String get settingsWorkingHoursBreakLabel => '休息';

  @override
  String get settingsWorkingHoursNotice1Hour => '1小时';

  @override
  String get settingsWorkingHoursNotice2Hours => '2小时';

  @override
  String get settingsWorkingHoursNotice24Hours => '24小时';

  @override
  String get bookingRequestsTitle => '在线预约请求';

  @override
  String get bookingRequestsFirebaseUnavailable => 'Firebase 未配置在线预约。';

  @override
  String get bookingRequestsSignInRequired => '请登录后查看预约请求。';

  @override
  String bookingRequestsError(Object error) {
    return '加载预约请求时出错：$error';
  }

  @override
  String get bookingRequestsEmpty => '暂无在线预约请求。';

  @override
  String get bookingRequestServiceLabel => '服务';

  @override
  String get bookingRequestScheduleLabel => '期望日期/时间';

  @override
  String get bookingRequestPhoneLabel => '电话';

  @override
  String get bookingRequestCarLabel => '车辆';

  @override
  String get bookingRequestNoteLabel => '备注';

  @override
  String get bookingRequestAccept => '接受';

  @override
  String get bookingRequestDecline => '拒绝';

  @override
  String get bookingRequestCall => '拨打';

  @override
  String get bookingRequestStatusPending => '待处理';

  @override
  String get bookingRequestStatusAccepted => '已接受';

  @override
  String get bookingRequestStatusDeclined => '已拒绝';

  @override
  String get bookingRequestsFilterAll => '全部';

  @override
  String get bookingRequestsEmptyNew => '暂无新预约请求';

  @override
  String get bookingRequestsAcceptedFeedback => '请求已接受 — 订单将自动创建';

  @override
  String get bookingRequestsDeclinedFeedback => '请求已拒绝';

  @override
  String get bookingRequestsDeclineConfirmContent => '拒绝此预约请求？';

  @override
  String get enterServiceName => '请输入服务名称';

  @override
  String get invalidPrice => '请输入有效价格（0或以上）';

  @override
  String get invoiceTitle => '发票';

  @override
  String get invoiceNumberPrefix => 'INV';

  @override
  String get invoiceSeller => '销售方';

  @override
  String get invoiceBuyer => '买方';

  @override
  String get invoiceIssueDateLabel => '开票日期';

  @override
  String get invoiceServiceDateLabel => '服务日期';

  @override
  String get invoiceDescriptionLabel => '项目描述';

  @override
  String get invoiceQtyLabel => '数量';

  @override
  String get invoiceNetPriceLabel => '净价';

  @override
  String get invoiceVatPctLabel => '税率%';

  @override
  String get invoiceVatAmountLabel => '税额';

  @override
  String get invoiceGrossPriceLabel => '含税价';

  @override
  String get invoiceNetTotalLabel => '净额合计:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return '税额 $rate:';
  }

  @override
  String get invoiceTotalDueLabel => '应付总额:';

  @override
  String get invoiceFillCompanyLabel => '请填写公司信息';

  @override
  String get invoiceIssuedByLabel => '开票方';

  @override
  String get invoicePrimaryIdLabel => '税号';

  @override
  String get invoiceSecondaryIdLabel => '工商注册号';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total 个成员';
  }

  @override
  String get syncOfflineWarning => '无网络连接，数据可能已过期。';

  @override
  String get forceUpdateTitle => '需要更新';

  @override
  String get forceUpdateMessage => '有新版本可用。请更新 Detailing Pro 以继续使用。';

  @override
  String get forceUpdateButton => '更新';

  @override
  String get storageStartupTitle => '本地存储不可用';

  @override
  String get storageStartupBody => 'Detailing Pro 无法打开加密数据库。此设备上的数据可能受保护或已损坏。';

  @override
  String get storageStartupHint =>
      '请完全关闭应用后重新打开。若问题仍存在，请重新安装应用（使用同一账号登录后云端数据仍会保留）。';

  @override
  String get storageStartupCloseApp => '关闭应用';

  @override
  String get settingsSyncStatusTitle => '云同步';

  @override
  String settingsSyncPendingMessage(int count) {
    return '有 $count 项更改等待同步';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return '有 $count 项更改未能同步到云端';
  }

  @override
  String get settingsSyncRetryButton => '重试同步';

  @override
  String get settingsSyncDiscardButton => '丢弃失败的更改';
}
