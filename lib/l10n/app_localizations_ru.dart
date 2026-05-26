// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return 'Версия $version';
  }

  @override
  String get navDashboard => 'Главная';

  @override
  String get navOrders => 'Заказы';

  @override
  String get navClients => 'Клиенты';

  @override
  String get navCalendar => 'Календарь';

  @override
  String get navInventory => 'Склад';

  @override
  String get navStats => 'Статистика';

  @override
  String get navPhotos => 'Фото';

  @override
  String get navMarketing => 'Маркетинг';

  @override
  String get navSettings => 'Настройки';

  @override
  String get inventoryEmptyTitle => 'Склад пуст';

  @override
  String get inventoryEmptySubtitle => 'Добавьте химию кнопкой ниже';

  @override
  String get showAllCategories => 'Показать все категории';

  @override
  String get chemicalsButton => 'ХИМИЯ';

  @override
  String get cancel => 'Отмена';

  @override
  String get add => 'Добавить';

  @override
  String get save => 'Сохранить';

  @override
  String get noOrdersTitle => 'Нет заказов';

  @override
  String get noOrdersSubtitle => 'Добавьте первый заказ, чтобы начать работу';

  @override
  String get addOrder => 'Добавить услугу';

  @override
  String get orderButton => 'ЗАКАЗ';

  @override
  String get deleteOrderTitle => 'Удалить заказ?';

  @override
  String deleteOrderMessage(Object car) {
    return 'Заказ \"$car\" будет удален без возможности восстановления.';
  }

  @override
  String deletedOrderSnack(Object car) {
    return 'Заказ \"$car\" удален';
  }

  @override
  String get undo => 'Отменить';

  @override
  String get delete => 'Удалить';

  @override
  String get carLabel => 'Авто';

  @override
  String clientLabel(Object client) {
    return 'Клиент: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return 'Услуга: $service ($duration мин)';
  }

  @override
  String get statusScheduled => 'Записан';

  @override
  String get statusInProgress => 'В работе';

  @override
  String get statusReady => 'Готово';

  @override
  String get statusPaid => 'Оплачено';

  @override
  String get statusCompleted => 'Завершено';

  @override
  String get edit => 'Редактировать';

  @override
  String get start => 'Начать';

  @override
  String get markDone => 'Готово';

  @override
  String get markPaid => 'Оплачено';

  @override
  String get statusChangedTitle => 'Статус заказа изменён';

  @override
  String statusChangedMessage(Object car, Object status) {
    return 'Заказ \"$car\" теперь $status';
  }

  @override
  String get newChemicalTitle => 'Новое средство';

  @override
  String get nameLabel => 'Название *';

  @override
  String get brandLabel => 'Бренд';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get volumeLabel => 'Объем (мл)';

  @override
  String get deleteItemTitle => 'Удалить?';

  @override
  String deleteItemMessage(Object item) {
    return 'Удалить \"$item\" со склада?';
  }

  @override
  String get unnamedItem => 'Без названия';

  @override
  String get replenish => 'Пополнить';

  @override
  String get languageLabel => 'Язык';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get goodMorning => 'Доброе утро!';

  @override
  String get goodAfternoon => 'Добрый день!';

  @override
  String get goodEvening => 'Добрый вечер!';

  @override
  String get statsTodayOrders => 'Записей сегодня';

  @override
  String get statsInWork => 'В работе';

  @override
  String get statsTodayRevenue => 'Выручка сегодня';

  @override
  String get statsTotalClients => 'Клиентов';

  @override
  String get noCars => 'Нет авто';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get newOrder => 'Новая запись';

  @override
  String get newClient => 'Новый клиент';

  @override
  String get todayOrdersTitle => 'Сегодняшние записи';

  @override
  String get calendarTitle => 'Календарь';

  @override
  String get monthJanuary => 'Январь';

  @override
  String get monthFebruary => 'Февраль';

  @override
  String get monthMarch => 'Март';

  @override
  String get monthApril => 'Апрель';

  @override
  String get monthMay => 'Май';

  @override
  String get monthJune => 'Июнь';

  @override
  String get monthJuly => 'Июль';

  @override
  String get monthAugust => 'Август';

  @override
  String get monthSeptember => 'Сентябрь';

  @override
  String get monthOctober => 'Октябрь';

  @override
  String get monthNovember => 'Ноябрь';

  @override
  String get monthDecember => 'Декабрь';

  @override
  String get statsTitle => 'Статистика';

  @override
  String get statsRevenue => 'Выручка';

  @override
  String get statsOrders => 'Заказы';

  @override
  String get statsPeriodWeek => 'Неделя';

  @override
  String get statsPeriodMonth => 'Месяц';

  @override
  String get statsPeriodYear => 'Год';

  @override
  String get photosTitle => 'Фотографии';

  @override
  String get orderBeforePhotosTitle => 'До';

  @override
  String get orderAfterPhotosTitle => 'После';

  @override
  String get photosAdd => 'Добавить фото';

  @override
  String get photosEmpty => 'Фотографий пока нет';

  @override
  String get photosSelectCar => 'Выберите авто';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get visits => 'Визитов';

  @override
  String get totalSpent => 'Общий чек';

  @override
  String get orderHistoryTitle => 'История заказов';

  @override
  String get orderHistoryEmpty => 'История заказов пуста';

  @override
  String get call => 'Позвонить';

  @override
  String get message => 'Написать';

  @override
  String get photoReport => 'Фото отчёт';

  @override
  String get photosNotAdded => 'Фотографии не добавлялись';

  @override
  String get editOrderTitle => 'Редактировать заказ';

  @override
  String get newOrderTitle => 'Новый заказ';

  @override
  String get clientFieldLabel => 'Клиент *';

  @override
  String get selectClient => 'Выберите клиента';

  @override
  String get carHint => 'Марка и госномер';

  @override
  String get enterCar => 'Укажите авто';

  @override
  String get serviceFieldLabel => 'Услуга *';

  @override
  String get selectService => 'Выберите услугу';

  @override
  String get orderMaterialCostLabel => 'Расход материалов';

  @override
  String get orderLaborCostLabel => 'Стоимость работы';

  @override
  String get orderTotalCostLabel => 'Себестоимость';

  @override
  String get orderProfitLabel => 'Прибыль';

  @override
  String get statsProfit => 'Прибыль';

  @override
  String get orderNotesLabel => 'Примечания к заказу';

  @override
  String get createOrderButton => 'Создать заказ';

  @override
  String get orderUpdated => 'Заказ обновлён';

  @override
  String get orderCreated => 'Заказ успешно создан';

  @override
  String errorMessage(Object error) {
    return 'Ошибка: $error';
  }

  @override
  String get editClient => 'Редактировать клиента';

  @override
  String get clientNameLabel => 'Имя клиента *';

  @override
  String get enterName => 'Введите имя';

  @override
  String get phoneLabel => 'Телефон';

  @override
  String get phoneHint => '+7 (___) ___-__-__';

  @override
  String get enterValidPhone => 'Введите корректный номер телефона';

  @override
  String get carsLabel => 'Автомобили *';

  @override
  String get addCar => 'Добавить';

  @override
  String get addAtLeastOneCar => 'Добавьте хотя бы один автомобиль';

  @override
  String get addCarDialogTitle => 'Добавить авто';

  @override
  String get carExample => 'Например: BMW X5 А777АА77';

  @override
  String get carAlreadyAdded => 'Это авто уже добавлено';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get saveClient => 'Сохранить клиента';

  @override
  String get clientUpdated => 'Клиент обновлён';

  @override
  String get clientAdded => 'Клиент успешно добавлен';

  @override
  String get otherCategory => 'Другое';

  @override
  String replenishItemTitle(Object item) {
    return 'Пополнить \"$item\"';
  }

  @override
  String get howManyToAdd => 'Сколько добавить?';

  @override
  String get ml => 'мл';

  @override
  String currentStockTitle(Object item) {
    return 'Остаток: \"$item\"';
  }

  @override
  String get currentStockLabel => 'Текущий объем на полке';

  @override
  String get inactiveClients => 'Неактивных клиентов';

  @override
  String get promotions => 'Акции и скидки';

  @override
  String get promotionsDescription =>
      'Создавайте акции для привлечения клиентов';

  @override
  String get loyaltyProgram => 'Программа лояльности';

  @override
  String get loyaltyDescription => 'Награждайте постоянных клиентов бонусами';

  @override
  String get smsBroadcast => 'SMS-рассылка';

  @override
  String get smsDescription => 'Отправляйте напоминания и новости клиентам';

  @override
  String get reviews => 'Отзывы';

  @override
  String get reviewsDescription => 'Собирайте отзывы и улучшайте сервис';

  @override
  String get comingSoon => 'Функция в разработке';

  @override
  String get gotIt => 'Понятно';

  @override
  String get ordersChannelName => 'Заказы';

  @override
  String get ordersChannelDescription => 'Уведомления о заказах';

  @override
  String get currencyLabel => 'Валюта';

  @override
  String get searchClientsHint => 'Поиск по имени или авто...';

  @override
  String get crmFilterAll => 'Все';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => 'Под риском';

  @override
  String get crmFilterInactive => 'Неактивные';

  @override
  String get crmTagsLabel => 'Теги';

  @override
  String get crmTagsHint => 'VIP, корпоративный, по рекомендации';

  @override
  String get crmSegmentLabel => 'Сегмент';

  @override
  String get crmLastVisitLabel => 'Последний визит';

  @override
  String get crmAtRiskLabel => 'Нужен контакт';

  @override
  String get crmReminderButton => 'Отправить напоминание';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return 'Здравствуйте, $client! Напоминаем о студии детейлинга. Можем записать вас на $service в удобное время.';
  }

  @override
  String get crmBulkReminderButton => 'CRM-рассылка';

  @override
  String get crmBulkReminderTitle => 'Выберите получателей';

  @override
  String get crmBulkReminderToggleAll => 'Все';

  @override
  String get crmBulkReminderSendSelected => 'Отправить выбранным';

  @override
  String get crmBulkReminderEmpty => 'В этом списке нет клиентов с телефоном.';

  @override
  String get crmBulkReminderTemplate =>
      'Здравствуйте! Напоминаем о студии детейлинга. Вы можете записаться на следующий визит в удобное время.';

  @override
  String get crmSegmentNew => 'Новый';

  @override
  String get crmSegmentReturning => 'Возвращающийся';

  @override
  String get crmSegmentLoyal => 'Постоянный';

  @override
  String get clientsNotFound => 'Клиенты не найдены';

  @override
  String get openCallFailed => 'Не удалось открыть звонок.';

  @override
  String get openWhatsAppFailed => 'Не удалось открыть приложение SMS.';

  @override
  String get sortTooltip => 'Сортировка';

  @override
  String get sortByNameAsc => 'Имя: A-Z';

  @override
  String get sortByNameDesc => 'Имя: Z-A';

  @override
  String get sortByNewest => 'Сначала новые';

  @override
  String get permissionDeniedTitle => 'Недостаточно прав';

  @override
  String get permissionCreateOrderDenied =>
      'Недостаточно прав для создания заказа.';

  @override
  String get permissionDeleteOrderDenied =>
      'Удаление заказов доступно только директору или владельцу.';

  @override
  String get permissionEditOrderDenied =>
      'Недостаточно прав для редактирования заказа.';

  @override
  String get permissionSaveOrderDenied =>
      'Недостаточно прав для сохранения заказа.';

  @override
  String get permissionCreateClientDenied =>
      'Недостаточно прав для создания клиента.';

  @override
  String get permissionDeleteClientDenied =>
      'Недостаточно прав для удаления клиента.';

  @override
  String get permissionEditClientDenied =>
      'Недостаточно прав для редактирования клиента.';

  @override
  String get permissionSaveClientDenied =>
      'Недостаточно прав для сохранения клиента.';

  @override
  String get permissionModifyInventoryDenied =>
      'Недостаточно прав для изменения склада.';

  @override
  String get permissionEditInventoryStockDenied =>
      'Недостаточно прав для изменения остатков.';

  @override
  String get permissionEditInventoryDenied =>
      'Недостаточно прав для редактирования склада.';

  @override
  String get clientDeleted => 'Клиент удален';

  @override
  String get clientGarageTitle => 'Гараж клиента';

  @override
  String get navTeamChats => 'Чаты команды';

  @override
  String get navCommunityChat => 'Чат сообщества';

  @override
  String get orderDefaultTitle => 'Заказ';

  @override
  String get completeOrderAndConsumePrompt =>
      'Завершить работу и списать химию со склада?';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: Выполнено';
  }

  @override
  String get appointmentReminderTitle => 'Скоро запись';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car в $time';
  }

  @override
  String get inventoryFirstItemHint =>
      'Добавьте первую позицию склада: химию, расходники, аксессуары или оборудование.';

  @override
  String get inventoryFilteredEmpty =>
      'По выбранным фильтрам позиции не найдены.';

  @override
  String get inventoryItemLabel => 'ПОЗИЦИЯ';

  @override
  String inventoryLowStockMore(Object count) {
    return ' и еще $count';
  }

  @override
  String get inventoryLowStockTitle => 'Низкий остаток на складе';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items требуют внимания.';
  }

  @override
  String get inventoryNotificationsChannelName => 'Складские уведомления';

  @override
  String get inventoryNotificationsChannelDescription =>
      'Оповещения о низком остатке на складе';

  @override
  String get inventoryEditItemTitle => 'Редактировать позицию';

  @override
  String get inventoryNewItemTitle => 'Новая позиция склада';

  @override
  String get inventoryItemTypeLabel => 'Тип позиции';

  @override
  String get inventoryUnitLabel => 'Единица учета';

  @override
  String get inventoryCurrentStockLabel => 'Текущий остаток';

  @override
  String get inventoryMinStockLabel => 'Минимальный остаток';

  @override
  String get inventoryLocationLabel => 'Место хранения';

  @override
  String get inventoryUsageLabel => 'Назначение';

  @override
  String inventoryLowStockCount(Object count) {
    return 'Низкий остаток: $count';
  }

  @override
  String inventoryLowStockItemLine(
    Object amount,
    Object item,
    Object minStock,
    Object unit,
  ) {
    return '$item: $amount $unit при минимуме $minStock $unit';
  }

  @override
  String get inventoryAllTypes => 'Все типы';

  @override
  String get inventoryBelowMin => 'Ниже минимума';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return 'Мин: $minStock $unit';
  }

  @override
  String get chatProfileSaved => 'Профиль чата сохранен';

  @override
  String get chatUnavailableShort =>
      'Firebase не настроен. Чат временно недоступен.';

  @override
  String get chatCreateDialogTitle => 'Новый диалог';

  @override
  String get chatCreateExternalTitle => 'Новый внешний чат';

  @override
  String get chatPeerIdLabelTeam => 'ID мастера';

  @override
  String get chatPeerIdLabelExternal => 'ID студии/мастера';

  @override
  String get chatPeerNameLabelTeam => 'Имя мастера';

  @override
  String get chatPeerNameLabelExternal => 'Имя студии или мастера';

  @override
  String get chatCreateAction => 'Создать';

  @override
  String get chatDialogTitle => 'Диалог';

  @override
  String get chatScreenTitleTeam => 'Внутренний чат команды';

  @override
  String get chatScreenTitleExternal => 'Внешний чат сообщества';

  @override
  String get chatNewChatButton => 'Новый чат';

  @override
  String get chatMyIdLabel => 'Ваш ID';

  @override
  String get chatMyIdHint => 'Например: master_001';

  @override
  String get chatMyNameLabel => 'Ваше имя';

  @override
  String get chatMyNameHint => 'Например: Алексей';

  @override
  String get chatUnavailableTitle => 'Чат временно недоступен';

  @override
  String get chatUnavailableSubtitle =>
      'Firebase не настроен для этой сборки. Добавьте конфиги Firebase, чтобы включить чат.';

  @override
  String get chatProfileFillTitleTeam => 'Заполните профиль чата';

  @override
  String get chatProfileFillTitleExternal => 'Заполните профиль сообщества';

  @override
  String get chatProfileFillSubtitleTeam =>
      'Укажите свой ID и имя, затем нажмите \"Сохранить\".';

  @override
  String get chatProfileFillSubtitleExternal =>
      'Укажите свой ID и имя, чтобы общаться с другими студиями и мастерами.';

  @override
  String get chatErrorTitle => 'Чат недоступен';

  @override
  String get chatErrorSubtitle =>
      'Проверьте подключение Firebase (google-services и Firebase.initializeApp).';

  @override
  String get chatEmptyTitle => 'Пока нет диалогов';

  @override
  String get chatEmptySubtitle =>
      'Создайте первый чат через кнопку \"Новый чат\".';

  @override
  String get chatNoMessages => 'Сообщений пока нет';

  @override
  String get chatOpenAfterFirebase =>
      'Firebase не настроен. Откройте чат после подключения Firebase.';

  @override
  String get chatConnectionError => 'Ошибка подключения к чату';

  @override
  String get chatMessageHint => 'Введите сообщение';

  @override
  String get chatAttachPhoto => 'Прикрепить фото';

  @override
  String get chatAttachFile => 'Прикрепить файл';

  @override
  String get chatAttachmentFile => 'Файл';

  @override
  String get chatFileOpenFailed => 'Не удалось открыть файл.';

  @override
  String chatUploadFailed(Object error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String get durationMinutesShort => 'мин';

  @override
  String get inventoryTypeChemistry => 'Химия';

  @override
  String get inventoryTypeConsumable => 'Расходник';

  @override
  String get inventoryTypeAccessory => 'Аксессуар';

  @override
  String get inventoryTypeEquipment => 'Оборудование';

  @override
  String get emailLabel => 'Email';

  @override
  String get authEnterEmail => 'Введите email';

  @override
  String get authInvalidEmail => 'Некорректный email';

  @override
  String get authEnterPassword => 'Введите пароль';

  @override
  String get authPasswordMin => 'Минимум 8 символов';

  @override
  String get authFirebaseGuestOnly =>
      'Firebase не настроен. Доступен вход как гость.';

  @override
  String get authSignInFailed => 'Не удалось выполнить вход. Попробуйте снова.';

  @override
  String get authPasswordsMismatch => 'Пароли не совпадают';

  @override
  String get authJoinSuccess => 'Вы успешно присоединились к команде!';

  @override
  String authInviteRejected(Object error) {
    return 'Регистрация прошла, но код не принят: $error';
  }

  @override
  String get authRegisterFailed =>
      'Не удалось завершить регистрацию. Попробуйте снова.';

  @override
  String get authGuestName => 'Гость';

  @override
  String get authGoogleSoon => 'Вход через Google будет добавлен позже';

  @override
  String get authInvalidEmailFormat => 'Неверный формат email';

  @override
  String get authWrongCredentials => 'Неверный email или пароль';

  @override
  String get authEmailInUse => 'Этот email уже используется';

  @override
  String get authWeakPassword => 'Слишком простой пароль';

  @override
  String get authTooManyRequests => 'Слишком много попыток. Повторите позже';

  @override
  String get authAuthorizationError => 'Ошибка авторизации';

  @override
  String get authWelcome => 'Добро пожаловать';

  @override
  String get authSubtitle => 'Войдите в аккаунт или зарегистрируйтесь';

  @override
  String get authTabSignIn => 'Вход';

  @override
  String get authTabRegister => 'Регистрация';

  @override
  String get authContinueWithGoogle => 'Продолжить с Google';

  @override
  String get authContinueAsGuest => 'Продолжить как гость';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authConfirmPasswordLabel => 'Подтверждение пароля';

  @override
  String get authInviteCodeOptional => 'Код приглашения (необязательно)';

  @override
  String get authInviteHint => 'Если вас пригласил директор';

  @override
  String get authRegisterButton => 'Зарегистрироваться';

  @override
  String get businessModeQuestion => 'Как вы работаете?';

  @override
  String get businessModeSubtitle =>
      'Выберите режим, чтобы приложение показало только нужные модули.';

  @override
  String get businessModeSoloTitle => 'Я работаю один';

  @override
  String get businessModeSoloSubtitle =>
      'Для мастера-одиночки: заказы, клиенты, склад, финансы и внешний чат.';

  @override
  String get businessModeTeamTitle => 'У нас команда';

  @override
  String get businessModeTeamSubtitle =>
      'Для студии: роли сотрудников, внутренний чат, задачи по мастерам и контроль директора.';

  @override
  String get photosGallerySaveFailed =>
      'Фото добавлено в приложение, но не удалось сохранить в галерею.';

  @override
  String get photosCameraUnsupported =>
      'Камера доступна только на Android/iOS или в web-версии.';

  @override
  String get photosAddedAndSaved => 'Фото добавлено и сохранено в галерею.';

  @override
  String get photosAddedFromGallery => 'Фото добавлено из галереи.';

  @override
  String get photosAddFromGallery => 'Добавить из галереи';

  @override
  String get photosTakePhoto => 'Сделать фото';

  @override
  String get photosDeleteDenied => 'Недостаточно прав для удаления фото.';

  @override
  String get settingsProfileAndOrgTitle => 'Профиль и организация';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => 'Гость';

  @override
  String get settingsBusinessModeTitle => 'Режим работы';

  @override
  String get settingsUserRoleTitle => 'Роль пользователя';

  @override
  String get settingsInviteMasterTitle => 'Пригласить мастера';

  @override
  String get settingsInviteMasterSubtitle =>
      'Сгенерировать одноразовый инвайт-код';

  @override
  String get settingsServicesSection => 'Услуги';

  @override
  String get settingsLogoutButton => 'Выйти из аккаунта';

  @override
  String get settingsBusinessModeTeam => 'Команда (студия)';

  @override
  String get settingsBusinessModeSolo => 'Соло (один мастер)';

  @override
  String get settingsRoleDirector => 'Директор';

  @override
  String get settingsRoleMaster => 'Мастер';

  @override
  String get settingsRoleMasterOwner => 'Мастер-владелец';

  @override
  String get settingsSelectModeTitle => 'Выберите режим';

  @override
  String get settingsModeSoloTitle => 'Соло';

  @override
  String get settingsModeSoloSubtitle => 'Один мастер';

  @override
  String get settingsModeTeamTitle => 'Команда';

  @override
  String get settingsModeTeamSubtitle => 'Студия с сотрудниками';

  @override
  String get settingsModeUpdated => 'Режим обновлен.';

  @override
  String get settingsOrgNotFound =>
      'Организация не найдена. Сохраните настройки.';

  @override
  String settingsInviteGenerateError(Object error) {
    return 'Ошибка генерации кода: $error';
  }

  @override
  String get settingsInviteDialogTitle => 'Инвайт-код для мастера';

  @override
  String get settingsInviteDialogDescription =>
      'Отправьте этот код мастеру. Код одноразовый и сгорает после использования.';

  @override
  String get settingsCopy => 'Скопировать';

  @override
  String get settingsCodeCopied => 'Код скопирован в буфер';

  @override
  String get settingsInviteRegistrationHint =>
      'Мастер вводит код в поле \"Код приглашения\" при регистрации.';

  @override
  String get settingsClose => 'Закрыть';

  @override
  String get settingsSelectRoleTitle => 'Выберите роль';

  @override
  String get settingsRoleUpdated => 'Роль обновлена.';

  @override
  String get settingsLogoutTitle => 'Выход';

  @override
  String get settingsLogoutMessage => 'Выйти из текущего аккаунта?';

  @override
  String get settingsLogoutConfirm => 'Выйти';

  @override
  String get settingsLoggedOut => 'Вы вышли из аккаунта.';

  @override
  String get settingsAccessDenied => 'Недостаточно прав для этого действия.';

  @override
  String get settingsResetWarning =>
      'ВНИМАНИЕ: Все заказы, клиенты и склад будут удалены!';

  @override
  String get settingsServiceDeleteDenied =>
      'Недостаточно прав для удаления услуги.';

  @override
  String get settingsServiceEditDenied =>
      'Недостаточно прав для редактирования услуги.';

  @override
  String get legalTitle => 'Юридическая информация';

  @override
  String get legalPrivacyTab => 'Политика конфиденциальности';

  @override
  String get legalTermsTab => 'Условия';

  @override
  String get legalPrivacySummaryTitle => 'Кратко о политике конфиденциальности';

  @override
  String get legalTermsSummaryTitle => 'Кратко об условиях использования';

  @override
  String get legalSummarySubtitle =>
      'Краткая версия в приложении. Полная юридическая версия доступна на опубликованной странице.';

  @override
  String get legalOpenFullPrivacy => 'Открыть полную политику';

  @override
  String get legalOpenFullTerms => 'Открыть полные условия';

  @override
  String get legalOpenLinkError => 'Не удалось открыть ссылку на документ.';

  @override
  String get legalPrivacySection1Title => '1. Что делает приложение';

  @override
  String get legalPrivacySection1Body =>
      'DetailingPro Business помогает командам детейлинга управлять клиентами, заказами, расписанием, складом, внутренним чатом и медиафайлами.';

  @override
  String get legalPrivacySection2Title => '2. Какие данные обрабатываются';

  @override
  String get legalPrivacySection2Body =>
      'Приложение может обрабатывать данные аккаунта, клиентов и заказов, услуги, склад, сообщения чата, вложения и технические идентификаторы, например токены уведомлений.';

  @override
  String get legalPrivacySection3Title => '3. Зачем используются данные';

  @override
  String get legalPrivacySection3Body =>
      'Данные используются для работы функций приложения, синхронизации между устройствами, напоминаний, совместной работы и повышения надежности и безопасности сервиса.';

  @override
  String get legalPrivacySection4Title => '4. Разрешения и доступ';

  @override
  String get legalPrivacySection4Body =>
      'Доступ к камере и медиа запрашивается только для фото и вложений. Разрешение на уведомления используется для напоминаний и push-уведомлений.';

  @override
  String get legalPrivacySection5Title => '5. Инфраструктура и провайдеры';

  @override
  String get legalPrivacySection5Body =>
      'Приложение использует сервисы Firebase (Authentication, Firestore, Storage, Messaging). Данные обрабатываются на инфраструктуре этих провайдеров.';

  @override
  String get legalPrivacySection6Title => '6. Хранение, удаление и права';

  @override
  String get legalPrivacySection6Body =>
      'Данные хранятся столько, сколько нужно для работы сервиса. Пользователи могут запрашивать доступ, исправление и удаление данных в рамках применимого законодательства.';

  @override
  String get legalPrivacySection7Title => '7. Контакты';

  @override
  String get legalPrivacySection7Body =>
      'По вопросам конфиденциальности: support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. Сфера сервиса';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro - бизнес-приложение для управления заказами, клиентами, медиа, внутренним чатом и операционными данными.';

  @override
  String get legalTermsSection2Title => '2. Аккаунты и доступ';

  @override
  String get legalTermsSection2Body =>
      'Пользователи обязаны защищать свои данные входа и использовать приложение только в рамках прав своей роли.';

  @override
  String get legalTermsSection3Title => '3. Допустимое использование';

  @override
  String get legalTermsSection3Body =>
      'Сервис не должен использоваться для незаконной обработки данных, злоупотреблений, несанкционированного доступа или действий, нарушающих закон.';

  @override
  String get legalTermsSection4Title => '4. Доступность';

  @override
  String get legalTermsSection4Body =>
      'Сервис может изменяться со временем. Функции могут добавляться, изменяться или удаляться по мере развития продукта.';

  @override
  String get legalTermsSection5Title => '5. Платные планы';

  @override
  String get legalTermsSection5Body =>
      'Перед публичным релизом раздел должен быть обновлен финальными условиями оплаты, продления, пробного периода, отмены и возвратов в Google Play.';

  @override
  String get legalTermsSection6Title => '6. Ограничение ответственности';

  @override
  String get legalTermsSection6Body =>
      'До публичного релиза замените этот черновик финальной юридической версией для вашей юрисдикции и структуры бизнеса.';

  @override
  String get legalTermsSection7Title => '7. Правовая информация';

  @override
  String get legalTermsSection7Body =>
      'Перед публикацией укажите зарегистрированные реквизиты бизнеса и применимое право.';

  @override
  String get invoiceCompanyDataTitle => 'Данные компании';

  @override
  String get invoiceCompanyDataSubtitle => 'Для счетов-фактур';

  @override
  String get invoiceCompanyName => 'Название компании';

  @override
  String get invoiceCompanyAddress => 'Адрес';

  @override
  String get invoiceCompanyPostalCode => 'Почтовый индекс';

  @override
  String get invoiceCompanyCity => 'Город';

  @override
  String get invoiceGenerateButton => 'Создать счёт';

  @override
  String get invoiceVatRate => 'Ставка НДС';

  @override
  String get settingsBookingLinkTitle => 'Ссылка на онлайн-запись';

  @override
  String get settingsBookingRequestsTitle => 'Онлайн-заявки';

  @override
  String get settingsBookingLinkDialogTitle => 'Ваша ссылка для записи';

  @override
  String get settingsBookingLinkCopied => 'Ссылка скопирована';

  @override
  String get settingsBookingLinkAuthRequired =>
      'Войдите, чтобы создать ссылку для записи.';

  @override
  String get settingsBookingLinkOpen => 'Открыть';

  @override
  String get settingsWorkingHoursTitle => 'Рабочие часы';

  @override
  String get settingsWorkingHoursSlotLabel => 'Слот';

  @override
  String get settingsWorkingHoursMinNoticeLabel => 'Мин. предупреждение';

  @override
  String get settingsWorkingHoursBreakLabel => 'Перерыв';

  @override
  String get settingsWorkingHoursNotice1Hour => '1 час';

  @override
  String get settingsWorkingHoursNotice2Hours => '2 часа';

  @override
  String get settingsWorkingHoursNotice24Hours => '24 часа';

  @override
  String get bookingRequestsTitle => 'Онлайн-заявки';

  @override
  String get bookingRequestsFirebaseUnavailable =>
      'Firebase не настроен для онлайн-записи.';

  @override
  String get bookingRequestsSignInRequired =>
      'Войдите, чтобы просматривать заявки.';

  @override
  String bookingRequestsError(Object error) {
    return 'Ошибка загрузки заявок: $error';
  }

  @override
  String get bookingRequestsEmpty => 'Онлайн-заявок пока нет.';

  @override
  String get bookingRequestServiceLabel => 'Услуга';

  @override
  String get bookingRequestScheduleLabel => 'Желаемые дата и время';

  @override
  String get bookingRequestPhoneLabel => 'Телефон';

  @override
  String get bookingRequestCarLabel => 'Автомобиль';

  @override
  String get bookingRequestNoteLabel => 'Комментарий';

  @override
  String get bookingRequestAccept => 'Принять';

  @override
  String get bookingRequestDecline => 'Отклонить';

  @override
  String get bookingRequestCall => 'Позвонить';

  @override
  String get bookingRequestStatusPending => 'Ожидает';

  @override
  String get bookingRequestStatusAccepted => 'Принята';

  @override
  String get bookingRequestStatusDeclined => 'Отклонено';

  @override
  String get bookingRequestsFilterAll => 'Все';

  @override
  String get bookingRequestsEmptyNew => 'Новых заявок нет';

  @override
  String get bookingRequestsAcceptedFeedback =>
      'Заявка принята — заказ будет создан автоматически';

  @override
  String get bookingRequestsDeclinedFeedback => 'Заявка отклонена';

  @override
  String get bookingRequestsDeclineConfirmContent => 'Отклонить эту заявку?';

  @override
  String get enterServiceName => 'Введите название услуги';

  @override
  String get invalidPrice => 'Введите корректную цену (0 или больше)';

  @override
  String get invoiceTitle => 'СЧЁТ-ФАКТУРА';

  @override
  String get invoiceNumberPrefix => 'СФ';

  @override
  String get invoiceSeller => 'ПРОДАВЕЦ';

  @override
  String get invoiceBuyer => 'ПОКУПАТЕЛЬ';

  @override
  String get invoiceIssueDateLabel => 'Дата выставления';

  @override
  String get invoiceServiceDateLabel => 'Дата услуги';

  @override
  String get invoiceDescriptionLabel => 'Наименование услуги';

  @override
  String get invoiceQtyLabel => 'Кол-во';

  @override
  String get invoiceNetPriceLabel => 'Цена без НДС';

  @override
  String get invoiceVatPctLabel => 'НДС %';

  @override
  String get invoiceVatAmountLabel => 'Сумма НДС';

  @override
  String get invoiceGrossPriceLabel => 'Цена с НДС';

  @override
  String get invoiceNetTotalLabel => 'Итого без НДС:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return 'НДС $rate:';
  }

  @override
  String get invoiceTotalDueLabel => 'К ОПЛАТЕ:';

  @override
  String get invoiceFillCompanyLabel => 'Заполните данные компании';

  @override
  String get invoiceIssuedByLabel => 'Счёт выставлен';

  @override
  String get invoicePrimaryIdLabel => 'ИНН';

  @override
  String get invoiceSecondaryIdLabel => 'ОГРН';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total мест';
  }

  @override
  String get syncOfflineWarning =>
      'Нет подключения к интернету. Данные могут быть устаревшими.';

  @override
  String get forceUpdateTitle => 'Требуется обновление';

  @override
  String get forceUpdateMessage =>
      'Доступна новая версия приложения. Обновите Detailing Pro, чтобы продолжить работу.';

  @override
  String get forceUpdateButton => 'Обновить';

  @override
  String get storageStartupTitle => 'Локальное хранилище недоступно';

  @override
  String get storageStartupBody =>
      'Не удалось открыть зашифрованную базу данных Detailing Pro. Данные на устройстве могут быть защищены или повреждены.';

  @override
  String get storageStartupHint =>
      'Полностью закройте приложение и откройте снова. Если ошибка повторяется, переустановите приложение (облачные данные сохранятся при входе в тот же аккаунт).';

  @override
  String get storageStartupCloseApp => 'Закрыть приложение';

  @override
  String get settingsSyncStatusTitle => 'Облачная синхронизация';

  @override
  String settingsSyncPendingMessage(int count) {
    return 'Ожидают синхронизации: $count';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return 'Не удалось синхронизировать: $count';
  }

  @override
  String get settingsSyncRetryButton => 'Повторить синхронизацию';

  @override
  String get settingsSyncDiscardButton => 'Удалить неудачные изменения';
}
