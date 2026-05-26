// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return 'Версія $version';
  }

  @override
  String get navDashboard => 'Головна';

  @override
  String get navOrders => 'Замовлення';

  @override
  String get navClients => 'Клієнти';

  @override
  String get navCalendar => 'Календар';

  @override
  String get navInventory => 'Склад';

  @override
  String get navStats => 'Статистика';

  @override
  String get navPhotos => 'Фото';

  @override
  String get navMarketing => 'Маркетинг';

  @override
  String get navSettings => 'Налаштування';

  @override
  String get inventoryEmptyTitle => 'Склад порожній';

  @override
  String get inventoryEmptySubtitle => 'Додайте хімію кнопкою нижче';

  @override
  String get showAllCategories => 'Показати всі категорії';

  @override
  String get chemicalsButton => 'ХІМІЯ';

  @override
  String get cancel => 'Скасувати';

  @override
  String get add => 'Додати';

  @override
  String get save => 'Зберегти';

  @override
  String get noOrdersTitle => 'Немає замовлень';

  @override
  String get noOrdersSubtitle => 'Додайте перше замовлення';

  @override
  String get addOrder => 'Додати послугу';

  @override
  String get orderButton => 'ЗАМОВЛЕННЯ';

  @override
  String get deleteOrderTitle => 'Видалити замовлення?';

  @override
  String deleteOrderMessage(Object car) {
    return 'Замовлення \"$car\" буде видалено без можливості відновлення.';
  }

  @override
  String deletedOrderSnack(Object car) {
    return 'Замовлення \"$car\" видалено';
  }

  @override
  String get undo => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get carLabel => 'Авто';

  @override
  String clientLabel(Object client) {
    return 'Клієнт: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return 'Послуга: $service ($duration хв)';
  }

  @override
  String get statusScheduled => 'Заплановано';

  @override
  String get statusInProgress => 'У роботі';

  @override
  String get statusReady => 'Готово';

  @override
  String get statusPaid => 'Оплачено';

  @override
  String get statusCompleted => 'Завершено';

  @override
  String get edit => 'Редагувати';

  @override
  String get start => 'Почати';

  @override
  String get markDone => 'Готово';

  @override
  String get markPaid => 'Оплачено';

  @override
  String get statusChangedTitle => 'Статус замовлення змінено';

  @override
  String statusChangedMessage(Object car, Object status) {
    return 'Замовлення \"$car\" тепер $status';
  }

  @override
  String get newChemicalTitle => 'Новий засіб';

  @override
  String get nameLabel => 'Назва *';

  @override
  String get brandLabel => 'Бренд';

  @override
  String get categoryLabel => 'Категорія';

  @override
  String get volumeLabel => 'Об\'єм (мл)';

  @override
  String get deleteItemTitle => 'Видалити?';

  @override
  String deleteItemMessage(Object item) {
    return 'Видалити \"$item\" зі складу?';
  }

  @override
  String get unnamedItem => 'Без назви';

  @override
  String get replenish => 'Поповнити';

  @override
  String get languageLabel => 'Мова';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Російська';

  @override
  String get goodMorning => 'Доброго ранку!';

  @override
  String get goodAfternoon => 'Добрий день!';

  @override
  String get goodEvening => 'Добрий вечір!';

  @override
  String get statsTodayOrders => 'Записів сьогодні';

  @override
  String get statsInWork => 'У роботі';

  @override
  String get statsTodayRevenue => 'Виручка сьогодні';

  @override
  String get statsTotalClients => 'Клієнтів';

  @override
  String get noCars => 'Немає авто';

  @override
  String get quickActions => 'Швидкі дії';

  @override
  String get newOrder => 'Новий запис';

  @override
  String get newClient => 'Новий клієнт';

  @override
  String get todayOrdersTitle => 'Сьогоднішні записи';

  @override
  String get calendarTitle => 'Календар';

  @override
  String get monthJanuary => 'Січень';

  @override
  String get monthFebruary => 'Лютий';

  @override
  String get monthMarch => 'Березень';

  @override
  String get monthApril => 'Квітень';

  @override
  String get monthMay => 'Травень';

  @override
  String get monthJune => 'Червень';

  @override
  String get monthJuly => 'Липень';

  @override
  String get monthAugust => 'Серпень';

  @override
  String get monthSeptember => 'Вересень';

  @override
  String get monthOctober => 'Жовтень';

  @override
  String get monthNovember => 'Листопад';

  @override
  String get monthDecember => 'Грудень';

  @override
  String get statsTitle => 'Статистика';

  @override
  String get statsRevenue => 'Виручка';

  @override
  String get statsOrders => 'Замовлення';

  @override
  String get statsPeriodWeek => 'Тиждень';

  @override
  String get statsPeriodMonth => 'Місяць';

  @override
  String get statsPeriodYear => 'Рік';

  @override
  String get photosTitle => 'Фотографії';

  @override
  String get orderBeforePhotosTitle => 'До';

  @override
  String get orderAfterPhotosTitle => 'Після';

  @override
  String get photosAdd => 'Додати фото';

  @override
  String get photosEmpty => 'Фотографій поки немає';

  @override
  String get photosSelectCar => 'Оберіть авто';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get visits => 'Візитів';

  @override
  String get totalSpent => 'Загальний чек';

  @override
  String get orderHistoryTitle => 'Історія замовлень';

  @override
  String get orderHistoryEmpty => 'Історія замовлень порожня';

  @override
  String get call => 'Зателефонувати';

  @override
  String get message => 'Написати';

  @override
  String get photoReport => 'Фотозвіт';

  @override
  String get photosNotAdded => 'Фотографії не додавалися';

  @override
  String get editOrderTitle => 'Редагувати замовлення';

  @override
  String get newOrderTitle => 'Нове замовлення';

  @override
  String get clientFieldLabel => 'Клієнт *';

  @override
  String get selectClient => 'Оберіть клієнта';

  @override
  String get carHint => 'Марка і держномер';

  @override
  String get enterCar => 'Вкажіть авто';

  @override
  String get serviceFieldLabel => 'Послуга *';

  @override
  String get selectService => 'Оберіть послугу';

  @override
  String get orderMaterialCostLabel => 'Вартість матеріалів';

  @override
  String get orderLaborCostLabel => 'Вартість роботи';

  @override
  String get orderTotalCostLabel => 'Собівартість';

  @override
  String get orderProfitLabel => 'Прибуток';

  @override
  String get statsProfit => 'Прибуток';

  @override
  String get orderNotesLabel => 'Примітки до замовлення';

  @override
  String get createOrderButton => 'Створити замовлення';

  @override
  String get orderUpdated => 'Замовлення оновлено';

  @override
  String get orderCreated => 'Замовлення успішно створено';

  @override
  String errorMessage(Object error) {
    return 'Помилка: $error';
  }

  @override
  String get editClient => 'Редагувати клієнта';

  @override
  String get clientNameLabel => 'Ім\'я клієнта *';

  @override
  String get enterName => 'Введіть ім\'я';

  @override
  String get phoneLabel => 'Телефон';

  @override
  String get phoneHint => '+380 (__) ___-__-__';

  @override
  String get enterValidPhone => 'Введіть коректний номер телефону';

  @override
  String get carsLabel => 'Автомобілі *';

  @override
  String get addCar => 'Додати';

  @override
  String get addAtLeastOneCar => 'Додайте хоча б один автомобіль';

  @override
  String get addCarDialogTitle => 'Додати авто';

  @override
  String get carExample => 'Наприклад: BMW X5 А777АА77';

  @override
  String get carAlreadyAdded => 'Це авто вже додано';

  @override
  String get saveChanges => 'Зберегти зміни';

  @override
  String get saveClient => 'Зберегти клієнта';

  @override
  String get clientUpdated => 'Клієнта оновлено';

  @override
  String get clientAdded => 'Клієнта успішно додано';

  @override
  String get otherCategory => 'Інше';

  @override
  String replenishItemTitle(Object item) {
    return 'Поповнити \"$item\"';
  }

  @override
  String get howManyToAdd => 'Скільки додати?';

  @override
  String get ml => 'мл';

  @override
  String currentStockTitle(Object item) {
    return 'Залишок: \"$item\"';
  }

  @override
  String get currentStockLabel => 'Поточний об\'єм на полиці';

  @override
  String get inactiveClients => 'Неактивних клієнтів';

  @override
  String get promotions => 'Акції та знижки';

  @override
  String get promotionsDescription => 'Створюйте акції для залучення клієнтів';

  @override
  String get loyaltyProgram => 'Програма лояльності';

  @override
  String get loyaltyDescription => 'Нагороджуйте постійних клієнтів бонусами';

  @override
  String get smsBroadcast => 'SMS-розсилання';

  @override
  String get smsDescription => 'Надсилайте нагадування та новини клієнтам';

  @override
  String get reviews => 'Відгуки';

  @override
  String get reviewsDescription => 'Збирайте відгуки та покращуйте сервіс';

  @override
  String get comingSoon => 'Функція в розробці';

  @override
  String get gotIt => 'Зрозуміло';

  @override
  String get ordersChannelName => 'Замовлення';

  @override
  String get ordersChannelDescription => 'Сповіщення про замовлення';

  @override
  String get currencyLabel => 'Валюта';

  @override
  String get searchClientsHint => 'Пошук за іменем або авто...';

  @override
  String get crmFilterAll => 'Усі';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => 'У зоні ризику';

  @override
  String get crmFilterInactive => 'Неактивні';

  @override
  String get crmTagsLabel => 'Теги';

  @override
  String get crmTagsHint => 'VIP, автопарк, за рекомендацією';

  @override
  String get crmSegmentLabel => 'Сегмент';

  @override
  String get crmLastVisitLabel => 'Останній візит';

  @override
  String get crmAtRiskLabel => 'Потрібен контакт';

  @override
  String get crmReminderButton => 'Надіслати нагадування';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return 'Вітаємо, $client! Це дружнє нагадування від студії детейлінгу. Можемо записати вас на $service у зручний час.';
  }

  @override
  String get crmBulkReminderButton => 'CRM-розсилка';

  @override
  String get crmBulkReminderTitle => 'Оберіть отримувачів';

  @override
  String get crmBulkReminderToggleAll => 'Усі';

  @override
  String get crmBulkReminderSendSelected => 'Надіслати обраним';

  @override
  String get crmBulkReminderEmpty =>
      'У цьому списку немає клієнтів з телефоном.';

  @override
  String get crmBulkReminderTemplate =>
      'Вітаємо! Нагадуємо від студії детейлінгу. Ви можете записатися на наступний візит у зручний час.';

  @override
  String get crmSegmentNew => 'Новий';

  @override
  String get crmSegmentReturning => 'Повертається';

  @override
  String get crmSegmentLoyal => 'Постійний';

  @override
  String get clientsNotFound => 'Клієнтів не знайдено';

  @override
  String get openCallFailed => 'Не вдалося відкрити дзвінок.';

  @override
  String get openWhatsAppFailed => 'Не вдалося відкрити додаток SMS.';

  @override
  String get sortTooltip => 'Сортування';

  @override
  String get sortByNameAsc => 'Ім\'я: A-Z';

  @override
  String get sortByNameDesc => 'Ім\'я: Z-A';

  @override
  String get sortByNewest => 'Спочатку нові';

  @override
  String get permissionDeniedTitle => 'Недостатньо прав';

  @override
  String get permissionCreateOrderDenied =>
      'Недостатньо прав для створення замовлення.';

  @override
  String get permissionDeleteOrderDenied =>
      'Видалення замовлень доступне лише директору або власнику.';

  @override
  String get permissionEditOrderDenied =>
      'Недостатньо прав для редагування замовлення.';

  @override
  String get permissionSaveOrderDenied =>
      'Недостатньо прав для збереження замовлення.';

  @override
  String get permissionCreateClientDenied =>
      'Недостатньо прав для створення клієнта.';

  @override
  String get permissionDeleteClientDenied =>
      'Недостатньо прав для видалення клієнта.';

  @override
  String get permissionEditClientDenied =>
      'Недостатньо прав для редагування клієнта.';

  @override
  String get permissionSaveClientDenied =>
      'Недостатньо прав для збереження клієнта.';

  @override
  String get permissionModifyInventoryDenied =>
      'Недостатньо прав для зміни складу.';

  @override
  String get permissionEditInventoryStockDenied =>
      'Недостатньо прав для зміни залишків.';

  @override
  String get permissionEditInventoryDenied =>
      'Недостатньо прав для редагування складу.';

  @override
  String get clientDeleted => 'Клієнта видалено';

  @override
  String get clientGarageTitle => 'Гараж клієнта';

  @override
  String get navTeamChats => 'Чати команди';

  @override
  String get navCommunityChat => 'Чат спільноти';

  @override
  String get orderDefaultTitle => 'Замовлення';

  @override
  String get completeOrderAndConsumePrompt =>
      'Завершити роботу та списати хімію зі складу?';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: Виконано';
  }

  @override
  String get appointmentReminderTitle => 'Скоро запис';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car о $time';
  }

  @override
  String get inventoryFirstItemHint =>
      'Додайте першу позицію складу: хімію, витратні матеріали, аксесуари або обладнання.';

  @override
  String get inventoryFilteredEmpty =>
      'За вибраними фільтрами позиції не знайдено.';

  @override
  String get inventoryItemLabel => 'ПОЗИЦІЯ';

  @override
  String inventoryLowStockMore(Object count) {
    return ' і ще $count';
  }

  @override
  String get inventoryLowStockTitle => 'Низький залишок на складі';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items потребують уваги.';
  }

  @override
  String get inventoryNotificationsChannelName => 'Складські сповіщення';

  @override
  String get inventoryNotificationsChannelDescription =>
      'Сповіщення про низький залишок на складі';

  @override
  String get inventoryEditItemTitle => 'Редагувати позицію';

  @override
  String get inventoryNewItemTitle => 'Нова позиція складу';

  @override
  String get inventoryItemTypeLabel => 'Тип позиції';

  @override
  String get inventoryUnitLabel => 'Одиниця обліку';

  @override
  String get inventoryCurrentStockLabel => 'Поточний залишок';

  @override
  String get inventoryMinStockLabel => 'Мінімальний залишок';

  @override
  String get inventoryLocationLabel => 'Місце зберігання';

  @override
  String get inventoryUsageLabel => 'Призначення';

  @override
  String inventoryLowStockCount(Object count) {
    return 'Низький залишок: $count';
  }

  @override
  String inventoryLowStockItemLine(
    Object amount,
    Object item,
    Object minStock,
    Object unit,
  ) {
    return '$item: $amount $unit за мінімуму $minStock $unit';
  }

  @override
  String get inventoryAllTypes => 'Усі типи';

  @override
  String get inventoryBelowMin => 'Нижче мінімуму';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return 'Мін: $minStock $unit';
  }

  @override
  String get chatProfileSaved => 'Профіль чату збережено';

  @override
  String get chatUnavailableShort =>
      'Firebase не налаштовано. Чат тимчасово недоступний.';

  @override
  String get chatCreateDialogTitle => 'Новий діалог';

  @override
  String get chatCreateExternalTitle => 'Новий зовнішній чат';

  @override
  String get chatPeerIdLabelTeam => 'ID майстра';

  @override
  String get chatPeerIdLabelExternal => 'ID студії/майстра';

  @override
  String get chatPeerNameLabelTeam => 'Ім\'я майстра';

  @override
  String get chatPeerNameLabelExternal => 'Ім\'я студії або майстра';

  @override
  String get chatCreateAction => 'Створити';

  @override
  String get chatDialogTitle => 'Діалог';

  @override
  String get chatScreenTitleTeam => 'Внутрішній чат команди';

  @override
  String get chatScreenTitleExternal => 'Зовнішній чат спільноти';

  @override
  String get chatNewChatButton => 'Новий чат';

  @override
  String get chatMyIdLabel => 'Ваш ID';

  @override
  String get chatMyIdHint => 'Наприклад: master_001';

  @override
  String get chatMyNameLabel => 'Ваше ім\'я';

  @override
  String get chatMyNameHint => 'Наприклад: Олексій';

  @override
  String get chatUnavailableTitle => 'Чат тимчасово недоступний';

  @override
  String get chatUnavailableSubtitle =>
      'Firebase не налаштовано для цієї збірки. Додайте конфігурацію Firebase.';

  @override
  String get chatProfileFillTitleTeam => 'Заповніть профіль чату';

  @override
  String get chatProfileFillTitleExternal => 'Заповніть профіль спільноти';

  @override
  String get chatProfileFillSubtitleTeam =>
      'Вкажіть свій ID та ім\'я, потім натисніть \"Зберегти\"';

  @override
  String get chatProfileFillSubtitleExternal =>
      'Вкажіть ID та ім\'я для спілкування з іншими студіями й майстрами.';

  @override
  String get chatErrorTitle => 'Чат недоступний';

  @override
  String get chatErrorSubtitle =>
      'Перевірте налаштування Firebase (google-services і initializeApp).';

  @override
  String get chatEmptyTitle => 'Діалогів поки немає';

  @override
  String get chatEmptySubtitle => 'Створіть перший чат кнопкою \"Новий чат\".';

  @override
  String get chatNoMessages => 'Повідомлень поки немає';

  @override
  String get chatOpenAfterFirebase =>
      'Чат стане доступний після налаштування Firebase.';

  @override
  String get chatConnectionError => 'Помилка підключення до чату';

  @override
  String get chatMessageHint => 'Введіть повідомлення';

  @override
  String get chatAttachPhoto => 'Прикріпити фото';

  @override
  String get chatAttachFile => 'Прикріпити файл';

  @override
  String get chatAttachmentFile => 'Файл';

  @override
  String get chatFileOpenFailed => 'Не вдалося відкрити файл.';

  @override
  String chatUploadFailed(Object error) {
    return 'Помилка завантаження: $error';
  }

  @override
  String get durationMinutesShort => 'хв';

  @override
  String get inventoryTypeChemistry => 'Хімія';

  @override
  String get inventoryTypeConsumable => 'Витратний матеріал';

  @override
  String get inventoryTypeAccessory => 'Аксесуар';

  @override
  String get inventoryTypeEquipment => 'Обладнання';

  @override
  String get emailLabel => 'Email';

  @override
  String get authEnterEmail => 'Введіть email';

  @override
  String get authInvalidEmail => 'Некоректний email';

  @override
  String get authEnterPassword => 'Введіть пароль';

  @override
  String get authPasswordMin => 'Мінімум 8 символів';

  @override
  String get authFirebaseGuestOnly =>
      'Firebase не налаштовано. Доступний вхід як гість.';

  @override
  String get authSignInFailed => 'Не вдалося виконати вхід. Спробуйте ще раз.';

  @override
  String get authPasswordsMismatch => 'Паролі не збігаються';

  @override
  String get authJoinSuccess => 'Ви успішно приєдналися до команди!';

  @override
  String authInviteRejected(Object error) {
    return 'Реєстрацію завершено, але код не прийнято: $error';
  }

  @override
  String get authRegisterFailed =>
      'Не вдалося завершити реєстрацію. Спробуйте ще раз.';

  @override
  String get authGuestName => 'Гість';

  @override
  String get authGoogleSoon => 'Вхід через Google буде додано пізніше';

  @override
  String get authInvalidEmailFormat => 'Невірний формат email';

  @override
  String get authWrongCredentials => 'Невірний email або пароль';

  @override
  String get authEmailInUse => 'Цей email уже використовується';

  @override
  String get authWeakPassword => 'Занадто простий пароль';

  @override
  String get authTooManyRequests => 'Занадто багато спроб. Повторіть пізніше';

  @override
  String get authAuthorizationError => 'Помилка авторизації';

  @override
  String get authWelcome => 'Ласкаво просимо';

  @override
  String get authSubtitle => 'Увійдіть до облікового запису або зареєструйтеся';

  @override
  String get authTabSignIn => 'Вхід';

  @override
  String get authTabRegister => 'Реєстрація';

  @override
  String get authContinueWithGoogle => 'Продовжити з Google';

  @override
  String get authContinueAsGuest => 'Продовжити як гість';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authConfirmPasswordLabel => 'Підтвердження пароля';

  @override
  String get authInviteCodeOptional => 'Код запрошення (необов\'язково)';

  @override
  String get authInviteHint => 'Якщо вас запросив директор';

  @override
  String get authRegisterButton => 'Зареєструватися';

  @override
  String get businessModeQuestion => 'Як ви працюєте?';

  @override
  String get businessModeSubtitle => 'Оберіть режим роботи додатка.';

  @override
  String get businessModeSoloTitle => 'Я працюю сам';

  @override
  String get businessModeSoloSubtitle =>
      'Для майстра: замовлення, клієнти, склад, фінанси та зовнішній чат.';

  @override
  String get businessModeTeamTitle => 'У нас команда';

  @override
  String get businessModeTeamSubtitle =>
      'Для студії: ролі, внутрішній чат, задачі майстрів і контроль директора.';

  @override
  String get photosGallerySaveFailed =>
      'Фото додано до додатка, але не вдалося зберегти в галерею.';

  @override
  String get photosCameraUnsupported =>
      'Камера доступна лише на Android/iOS або у web-версії.';

  @override
  String get photosAddedAndSaved => 'Фото додано та збережено в галерею.';

  @override
  String get photosAddedFromGallery => 'Фото додано з галереї.';

  @override
  String get photosAddFromGallery => 'Додати з галереї';

  @override
  String get photosTakePhoto => 'Зробити фото';

  @override
  String get photosDeleteDenied => 'Недостатньо прав для видалення фото.';

  @override
  String get settingsProfileAndOrgTitle => 'Профіль та організація';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => 'Гість';

  @override
  String get settingsBusinessModeTitle => 'Режим роботи';

  @override
  String get settingsUserRoleTitle => 'Роль користувача';

  @override
  String get settingsInviteMasterTitle => 'Запросити майстра';

  @override
  String get settingsInviteMasterSubtitle =>
      'Створити одноразовий код запрошення';

  @override
  String get settingsServicesSection => 'Послуги';

  @override
  String get settingsLogoutButton => 'Вийти з акаунта';

  @override
  String get settingsBusinessModeTeam => 'Команда (студія)';

  @override
  String get settingsBusinessModeSolo => 'Соло (один майстер)';

  @override
  String get settingsRoleDirector => 'Директор';

  @override
  String get settingsRoleMaster => 'Майстер';

  @override
  String get settingsRoleMasterOwner => 'Майстер-власник';

  @override
  String get settingsSelectModeTitle => 'Оберіть режим';

  @override
  String get settingsModeSoloTitle => 'Соло';

  @override
  String get settingsModeSoloSubtitle => 'Один майстер';

  @override
  String get settingsModeTeamTitle => 'Команда';

  @override
  String get settingsModeTeamSubtitle => 'Студія зі співробітниками';

  @override
  String get settingsModeUpdated => 'Режим оновлено.';

  @override
  String get settingsOrgNotFound =>
      'Організацію не знайдено. Збережіть налаштування.';

  @override
  String settingsInviteGenerateError(Object error) {
    return 'Помилка генерації коду: $error';
  }

  @override
  String get settingsInviteDialogTitle => 'Код запрошення для майстра';

  @override
  String get settingsInviteDialogDescription =>
      'Надішліть код майстру. Він одноразовий і згорає після використання.';

  @override
  String get settingsCopy => 'Скопіювати';

  @override
  String get settingsCodeCopied => 'Код скопійовано в буфер';

  @override
  String get settingsInviteRegistrationHint =>
      'Майстер вводить код у полі \"Код запрошення\" під час реєстрації';

  @override
  String get settingsClose => 'Закрити';

  @override
  String get settingsSelectRoleTitle => 'Оберіть роль';

  @override
  String get settingsRoleUpdated => 'Роль оновлено.';

  @override
  String get settingsLogoutTitle => 'Вихід';

  @override
  String get settingsLogoutMessage => 'Вийти з поточного акаунта?';

  @override
  String get settingsLogoutConfirm => 'Вийти';

  @override
  String get settingsLoggedOut => 'Ви вийшли з акаунта.';

  @override
  String get settingsAccessDenied => 'Недостатньо прав для цієї дії.';

  @override
  String get settingsResetWarning =>
      'УВАГА: Усі замовлення, клієнти та склад буде видалено!';

  @override
  String get settingsServiceDeleteDenied =>
      'Недостатньо прав для видалення послуги.';

  @override
  String get settingsServiceEditDenied =>
      'Недостатньо прав для редагування послуги.';

  @override
  String get legalTitle => 'Юридична інформація';

  @override
  String get legalPrivacyTab => 'Політика конфіденційності';

  @override
  String get legalTermsTab => 'Умови користування';

  @override
  String get legalPrivacySummaryTitle =>
      'Коротко про політику конфіденційності';

  @override
  String get legalTermsSummaryTitle => 'Коротко про умови користування';

  @override
  String get legalSummarySubtitle =>
      'Коротка версія у додатку. Повна юридична версія доступна на опублікованій сторінці.';

  @override
  String get legalOpenFullPrivacy => 'Відкрити повну політику';

  @override
  String get legalOpenFullTerms => 'Відкрити повні умови користування';

  @override
  String get legalOpenLinkError => 'Не вдалося відкрити посилання на документ.';

  @override
  String get legalPrivacySection1Title => '1. Що робить додаток';

  @override
  String get legalPrivacySection1Body =>
      'DetailingPro Business допомагає командам детейлінгу керувати клієнтами, замовленнями, розкладом, складом, внутрішнім чатом і медіафайлами.';

  @override
  String get legalPrivacySection2Title => '2. Які дані обробляються';

  @override
  String get legalPrivacySection2Body =>
      'Додаток може обробляти дані акаунта, клієнтів і замовлень, послуг, складу, повідомлень чату, вкладень і технічних ідентифікаторів, наприклад токенів сповіщень.';

  @override
  String get legalPrivacySection3Title => '3. Навіщо використовуються дані';

  @override
  String get legalPrivacySection3Body =>
      'Дані використовуються для роботи функцій додатка, синхронізації між пристроями, нагадувань, спільної роботи та підвищення надійності й безпеки сервісу.';

  @override
  String get legalPrivacySection4Title => '4. Дозволи і доступ';

  @override
  String get legalPrivacySection4Body =>
      'Доступ до камери та медіафайлів запитується лише для фото й вкладень. Дозвіл на сповіщення використовується для нагадувань і push-сповіщень.';

  @override
  String get legalPrivacySection5Title => '5. Інфраструктура та провайдери';

  @override
  String get legalPrivacySection5Body =>
      'Додаток використовує сервіси Firebase (Authentication, Firestore, Storage, Messaging). Дані обробляються на інфраструктурі цих провайдерів.';

  @override
  String get legalPrivacySection6Title => '6. Зберігання, видалення та права';

  @override
  String get legalPrivacySection6Body =>
      'Дані зберігаються стільки, скільки потрібно для роботи сервісу. Користувачі можуть запитувати доступ, виправлення та видалення даних у межах застосовного законодавства.';

  @override
  String get legalPrivacySection7Title => '7. Контакти';

  @override
  String get legalPrivacySection7Body =>
      'З питань конфіденційності: support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. Сфера сервісу';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro - бізнес-додаток для керування замовленнями, клієнтами, медіа, внутрішнім чатом та операційними даними.';

  @override
  String get legalTermsSection2Title => '2. Акаунти і доступ';

  @override
  String get legalTermsSection2Body =>
      'Користувачі зобов\'язані захищати свої дані входу та використовувати додаток лише в межах прав своєї ролі.';

  @override
  String get legalTermsSection3Title => '3. Дозволене використання';

  @override
  String get legalTermsSection3Body =>
      'Сервіс не повинен використовуватися для незаконної обробки даних, зловживань, несанкціонованого доступу або дій, що порушують закон.';

  @override
  String get legalTermsSection4Title => '4. Доступність';

  @override
  String get legalTermsSection4Body =>
      'Сервіс може змінюватися з часом. Функції можуть додаватися, змінюватися або видалятися в міру розвитку продукту.';

  @override
  String get legalTermsSection5Title => '5. Платні плани';

  @override
  String get legalTermsSection5Body =>
      'Перед публічним релізом розділ має бути оновлений фінальними умовами оплати, продовження, пробного періоду, скасування та повернень у Google Play.';

  @override
  String get legalTermsSection6Title => '6. Обмеження відповідальності';

  @override
  String get legalTermsSection6Body =>
      'До публічного релізу замініть цей чернетковий текст фінальною юридичною версією для вашої юрисдикції та структури бізнесу.';

  @override
  String get legalTermsSection7Title => '7. Правова інформація';

  @override
  String get legalTermsSection7Body =>
      'Перед публікацією вкажіть зареєстровані реквізити бізнесу та застосовне право.';

  @override
  String get invoiceCompanyDataTitle => 'Дані компанії';

  @override
  String get invoiceCompanyDataSubtitle => 'Для рахунків';

  @override
  String get invoiceCompanyName => 'Назва компанії';

  @override
  String get invoiceCompanyAddress => 'Адреса';

  @override
  String get invoiceCompanyPostalCode => 'Поштовий індекс';

  @override
  String get invoiceCompanyCity => 'Місто';

  @override
  String get invoiceGenerateButton => 'Створити рахунок';

  @override
  String get invoiceVatRate => 'Ставка ПДВ';

  @override
  String get settingsBookingLinkTitle => 'Посилання для онлайн-запису';

  @override
  String get settingsBookingRequestsTitle => 'Онлайн-заявки';

  @override
  String get settingsBookingLinkDialogTitle =>
      'Ваше посилання для онлайн-запису';

  @override
  String get settingsBookingLinkCopied => 'Посилання скопійовано';

  @override
  String get settingsBookingLinkAuthRequired =>
      'Увійдіть, щоб створити посилання.';

  @override
  String get settingsBookingLinkOpen => 'Відкрити';

  @override
  String get settingsWorkingHoursTitle => 'Робочі години';

  @override
  String get settingsWorkingHoursSlotLabel => 'Слот';

  @override
  String get settingsWorkingHoursMinNoticeLabel => 'Мін. попередження';

  @override
  String get settingsWorkingHoursBreakLabel => 'Перерва';

  @override
  String get settingsWorkingHoursNotice1Hour => '1 година';

  @override
  String get settingsWorkingHoursNotice2Hours => '2 години';

  @override
  String get settingsWorkingHoursNotice24Hours => '24 години';

  @override
  String get bookingRequestsTitle => 'Онлайн-заявки';

  @override
  String get bookingRequestsFirebaseUnavailable =>
      'Firebase не налаштовано для онлайн-запису.';

  @override
  String get bookingRequestsSignInRequired =>
      'Увійдіть, щоб переглянути заявки.';

  @override
  String bookingRequestsError(Object error) {
    return 'Помилка завантаження заявок: $error';
  }

  @override
  String get bookingRequestsEmpty => 'Онлайн-заявок поки немає.';

  @override
  String get bookingRequestServiceLabel => 'Послуга';

  @override
  String get bookingRequestScheduleLabel => 'Бажані дата та час';

  @override
  String get bookingRequestPhoneLabel => 'Телефон';

  @override
  String get bookingRequestCarLabel => 'Автомобіль';

  @override
  String get bookingRequestNoteLabel => 'Коментар';

  @override
  String get bookingRequestAccept => 'Прийняти';

  @override
  String get bookingRequestDecline => 'Відхилити';

  @override
  String get bookingRequestCall => 'Зателефонувати';

  @override
  String get bookingRequestStatusPending => 'Очікує';

  @override
  String get bookingRequestStatusAccepted => 'Прийнято';

  @override
  String get bookingRequestStatusDeclined => 'Відхилено';

  @override
  String get bookingRequestsFilterAll => 'Усі';

  @override
  String get bookingRequestsEmptyNew => 'Нових заявок немає';

  @override
  String get bookingRequestsAcceptedFeedback =>
      'Заявку прийнято — замовлення буде створено автоматично';

  @override
  String get bookingRequestsDeclinedFeedback => 'Заявку відхилено';

  @override
  String get bookingRequestsDeclineConfirmContent => 'Відхилити цю заявку?';

  @override
  String get enterServiceName => 'Введіть назву послуги';

  @override
  String get invalidPrice => 'Введіть коректну ціну (0 або більше)';

  @override
  String get invoiceTitle => 'РАХУНОК-ФАКТУРА';

  @override
  String get invoiceNumberPrefix => 'РФ';

  @override
  String get invoiceSeller => 'ПРОДАВЕЦЬ';

  @override
  String get invoiceBuyer => 'ПОКУПЕЦЬ';

  @override
  String get invoiceIssueDateLabel => 'Дата виставлення';

  @override
  String get invoiceServiceDateLabel => 'Дата послуги';

  @override
  String get invoiceDescriptionLabel => 'Найменування послуги';

  @override
  String get invoiceQtyLabel => 'К-сть';

  @override
  String get invoiceNetPriceLabel => 'Ціна без ПДВ';

  @override
  String get invoiceVatPctLabel => 'ПДВ %';

  @override
  String get invoiceVatAmountLabel => 'Сума ПДВ';

  @override
  String get invoiceGrossPriceLabel => 'Ціна з ПДВ';

  @override
  String get invoiceNetTotalLabel => 'Разом без ПДВ:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return 'ПДВ $rate:';
  }

  @override
  String get invoiceTotalDueLabel => 'ДО СПЛАТИ:';

  @override
  String get invoiceFillCompanyLabel => 'Заповніть дані компанії';

  @override
  String get invoiceIssuedByLabel => 'Рахунок виставлено';

  @override
  String get invoicePrimaryIdLabel => 'ЄДРПОУ';

  @override
  String get invoiceSecondaryIdLabel => 'ІПН';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total місць';
  }

  @override
  String get syncOfflineWarning =>
      'Немає підключення до інтернету. Дані можуть бути застарілими.';

  @override
  String get forceUpdateTitle => 'Потрібне оновлення';

  @override
  String get forceUpdateMessage =>
      'Доступна нова версія застосунку. Оновіть Detailing Pro, щоб продовжити роботу.';

  @override
  String get forceUpdateButton => 'Оновити';

  @override
  String get storageStartupTitle => 'Локальне сховище недоступне';

  @override
  String get storageStartupBody =>
      'Не вдалося відкрити зашифровану базу даних Detailing Pro. Дані на пристрої можуть бути захищені або пошкоджені.';

  @override
  String get storageStartupHint =>
      'Повністю закрийте застосунок і відкрийте знову. Якщо помилка повторюється, перевстановіть застосунок (хмарні дані збережуться при вході в той самий обліковий запис).';

  @override
  String get storageStartupCloseApp => 'Закрити застосунок';

  @override
  String get settingsSyncStatusTitle => 'Хмарна синхронізація';

  @override
  String settingsSyncPendingMessage(int count) {
    return 'Очікують синхронізації: $count';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return 'Не вдалося синхронізувати: $count';
  }

  @override
  String get settingsSyncRetryButton => 'Повторити синхронізацію';

  @override
  String get settingsSyncDiscardButton => 'Видалити невдалі зміни';
}
