// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return 'Version $version';
  }

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navOrders => 'Orders';

  @override
  String get navClients => 'Clients';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navStats => 'Stats';

  @override
  String get navPhotos => 'Photos';

  @override
  String get navMarketing => 'Marketing';

  @override
  String get navSettings => 'Settings';

  @override
  String get inventoryEmptyTitle => 'Inventory is empty';

  @override
  String get inventoryEmptySubtitle => 'Add chemicals using the button below';

  @override
  String get showAllCategories => 'Show all categories';

  @override
  String get chemicalsButton => 'CHEMICALS';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get noOrdersTitle => 'No orders';

  @override
  String get noOrdersSubtitle => 'Add your first order to get started';

  @override
  String get addOrder => 'Add services';

  @override
  String get orderButton => 'ORDER';

  @override
  String get deleteOrderTitle => 'Delete order?';

  @override
  String deleteOrderMessage(Object car) {
    return 'Order \"$car\" will be permanently deleted.';
  }

  @override
  String deletedOrderSnack(Object car) {
    return 'Order \"$car\" deleted';
  }

  @override
  String get undo => 'Undo';

  @override
  String get delete => 'Delete';

  @override
  String get carLabel => 'Car';

  @override
  String clientLabel(Object client) {
    return 'Client: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return 'Service: $service ($duration min)';
  }

  @override
  String get statusScheduled => 'Scheduled';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get edit => 'Edit';

  @override
  String get start => 'Start';

  @override
  String get markDone => 'Done';

  @override
  String get markPaid => 'Paid';

  @override
  String get statusChangedTitle => 'Order status updated';

  @override
  String statusChangedMessage(Object car, Object status) {
    return 'Order \"$car\" is now $status';
  }

  @override
  String get newChemicalTitle => 'New chemical';

  @override
  String get nameLabel => 'Name *';

  @override
  String get brandLabel => 'Brand';

  @override
  String get categoryLabel => 'Category';

  @override
  String get volumeLabel => 'Volume (ml)';

  @override
  String get deleteItemTitle => 'Delete?';

  @override
  String deleteItemMessage(Object item) {
    return 'Delete \"$item\" from inventory?';
  }

  @override
  String get unnamedItem => 'Unnamed';

  @override
  String get replenish => 'Replenish';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Russian';

  @override
  String get goodMorning => 'Good morning!';

  @override
  String get goodAfternoon => 'Good afternoon!';

  @override
  String get goodEvening => 'Good evening!';

  @override
  String get statsTodayOrders => 'Today\'s orders';

  @override
  String get statsInWork => 'In progress';

  @override
  String get statsTodayRevenue => 'Today\'s revenue';

  @override
  String get statsTotalClients => 'Total clients';

  @override
  String get noCars => 'No cars';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get newOrder => 'New order';

  @override
  String get newClient => 'New client';

  @override
  String get todayOrdersTitle => 'Today\'s appointments';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsRevenue => 'Revenue';

  @override
  String get statsOrders => 'Orders';

  @override
  String get statsPeriodWeek => 'Week';

  @override
  String get statsPeriodMonth => 'Month';

  @override
  String get statsPeriodYear => 'Year';

  @override
  String get photosTitle => 'Photos';

  @override
  String get orderBeforePhotosTitle => 'Before';

  @override
  String get orderAfterPhotosTitle => 'After';

  @override
  String get photosAdd => 'Add Photo';

  @override
  String get photosEmpty => 'No photos yet';

  @override
  String get photosSelectCar => 'Select car';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get visits => 'Visits';

  @override
  String get totalSpent => 'Total spent';

  @override
  String get orderHistoryTitle => 'Order history';

  @override
  String get orderHistoryEmpty => 'Order history is empty';

  @override
  String get call => 'Call';

  @override
  String get message => 'Message';

  @override
  String get photoReport => 'Photo report';

  @override
  String get photosNotAdded => 'No photos added';

  @override
  String get editOrderTitle => 'Edit order';

  @override
  String get newOrderTitle => 'New order';

  @override
  String get clientFieldLabel => 'Client *';

  @override
  String get selectClient => 'Select client';

  @override
  String get carHint => 'Model and plate number';

  @override
  String get enterCar => 'Enter car details';

  @override
  String get serviceFieldLabel => 'Service *';

  @override
  String get selectService => 'Select service';

  @override
  String get orderMaterialCostLabel => 'Material cost';

  @override
  String get orderLaborCostLabel => 'Labor cost';

  @override
  String get orderTotalCostLabel => 'Total cost';

  @override
  String get orderProfitLabel => 'Profit';

  @override
  String get statsProfit => 'Profit';

  @override
  String get orderNotesLabel => 'Order notes';

  @override
  String get createOrderButton => 'Create order';

  @override
  String get orderUpdated => 'Order updated';

  @override
  String get orderCreated => 'Order created successfully';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get editClient => 'Edit client';

  @override
  String get clientNameLabel => 'Client name *';

  @override
  String get enterName => 'Enter name';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get phoneHint => '+1 (___) ___-____';

  @override
  String get enterValidPhone => 'Enter a valid phone number';

  @override
  String get carsLabel => 'Cars *';

  @override
  String get addCar => 'Add';

  @override
  String get addAtLeastOneCar => 'Add at least one car';

  @override
  String get addCarDialogTitle => 'Add car';

  @override
  String get carExample => 'Example: BMW X5 ABC1234';

  @override
  String get carAlreadyAdded => 'This car is already added';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saveClient => 'Save client';

  @override
  String get clientUpdated => 'Client updated';

  @override
  String get clientAdded => 'Client added successfully';

  @override
  String get otherCategory => 'Other';

  @override
  String replenishItemTitle(Object item) {
    return 'Replenish \"$item\"';
  }

  @override
  String get howManyToAdd => 'How much to add?';

  @override
  String get ml => 'ml';

  @override
  String currentStockTitle(Object item) {
    return 'Stock: \"$item\"';
  }

  @override
  String get currentStockLabel => 'Current volume on shelf';

  @override
  String get inactiveClients => 'Inactive clients';

  @override
  String get promotions => 'Promotions & Discounts';

  @override
  String get promotionsDescription => 'Create promotions to attract customers';

  @override
  String get loyaltyProgram => 'Loyalty program';

  @override
  String get loyaltyDescription => 'Reward regular customers with bonuses';

  @override
  String get smsBroadcast => 'SMS broadcast';

  @override
  String get smsDescription => 'Send reminders and news to clients';

  @override
  String get reviews => 'Reviews';

  @override
  String get reviewsDescription => 'Collect reviews and improve service';

  @override
  String get comingSoon => 'Feature coming soon';

  @override
  String get gotIt => 'Got it';

  @override
  String get ordersChannelName => 'Orders';

  @override
  String get ordersChannelDescription => 'Order notifications';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get searchClientsHint => 'Search clients or cars...';

  @override
  String get crmFilterAll => 'All';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => 'At risk';

  @override
  String get crmFilterInactive => 'Inactive';

  @override
  String get crmTagsLabel => 'Tags';

  @override
  String get crmTagsHint => 'VIP, fleet, referral';

  @override
  String get crmSegmentLabel => 'Segment';

  @override
  String get crmLastVisitLabel => 'Last visit';

  @override
  String get crmAtRiskLabel => 'Needs follow-up';

  @override
  String get crmReminderButton => 'Send reminder';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return 'Hi, $client! This is a friendly reminder from the detailing studio. We can book you for $service at a convenient time.';
  }

  @override
  String get crmBulkReminderButton => 'Campaign reminder';

  @override
  String get crmBulkReminderTitle => 'Select recipients';

  @override
  String get crmBulkReminderToggleAll => 'All';

  @override
  String get crmBulkReminderSendSelected => 'Send to selected';

  @override
  String get crmBulkReminderEmpty => 'No clients with phone in this list.';

  @override
  String get crmBulkReminderTemplate =>
      'Hello! This is a reminder from the detailing studio. You can book a convenient time for your next service.';

  @override
  String get crmSegmentNew => 'New';

  @override
  String get crmSegmentReturning => 'Returning';

  @override
  String get crmSegmentLoyal => 'Loyal';

  @override
  String get clientsNotFound => 'No clients found';

  @override
  String get openCallFailed => 'Could not open call.';

  @override
  String get openWhatsAppFailed => 'Could not open SMS app.';

  @override
  String get sortTooltip => 'Sort';

  @override
  String get sortByNameAsc => 'Name: A-Z';

  @override
  String get sortByNameDesc => 'Name: Z-A';

  @override
  String get sortByNewest => 'Newest first';

  @override
  String get permissionDeniedTitle => 'Access denied';

  @override
  String get permissionCreateOrderDenied =>
      'Not enough permissions to create an order.';

  @override
  String get permissionDeleteOrderDenied =>
      'Deleting orders is available only for director or owner.';

  @override
  String get permissionEditOrderDenied =>
      'Not enough permissions to edit an order.';

  @override
  String get permissionSaveOrderDenied =>
      'Not enough permissions to save an order.';

  @override
  String get permissionCreateClientDenied =>
      'Not enough permissions to create a client.';

  @override
  String get permissionDeleteClientDenied =>
      'Not enough permissions to delete a client.';

  @override
  String get permissionEditClientDenied =>
      'Not enough permissions to edit a client.';

  @override
  String get permissionSaveClientDenied =>
      'Not enough permissions to save a client.';

  @override
  String get permissionModifyInventoryDenied =>
      'Not enough permissions to modify inventory.';

  @override
  String get permissionEditInventoryStockDenied =>
      'Not enough permissions to change stock levels.';

  @override
  String get permissionEditInventoryDenied =>
      'Not enough permissions to edit inventory.';

  @override
  String get clientDeleted => 'Client was deleted';

  @override
  String get clientGarageTitle => 'Client garage';

  @override
  String get navTeamChats => 'Team chats';

  @override
  String get navCommunityChat => 'Community chat';

  @override
  String get orderDefaultTitle => 'Order';

  @override
  String get completeOrderAndConsumePrompt =>
      'Complete the order and deduct chemicals from inventory?';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: Completed';
  }

  @override
  String get appointmentReminderTitle => 'Upcoming appointment';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car at $time';
  }

  @override
  String get inventoryFirstItemHint =>
      'Add the first inventory item: chemicals, consumables, accessories, or equipment.';

  @override
  String get inventoryFilteredEmpty => 'No items found for selected filters.';

  @override
  String get inventoryItemLabel => 'ITEM';

  @override
  String inventoryLowStockMore(Object count) {
    return ' and $count more';
  }

  @override
  String get inventoryLowStockTitle => 'Low stock in inventory';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items require attention.';
  }

  @override
  String get inventoryNotificationsChannelName => 'Inventory alerts';

  @override
  String get inventoryNotificationsChannelDescription =>
      'Alerts about low stock in inventory';

  @override
  String get inventoryEditItemTitle => 'Edit item';

  @override
  String get inventoryNewItemTitle => 'New inventory item';

  @override
  String get inventoryItemTypeLabel => 'Item type';

  @override
  String get inventoryUnitLabel => 'Unit';

  @override
  String get inventoryCurrentStockLabel => 'Current stock';

  @override
  String get inventoryMinStockLabel => 'Minimum stock';

  @override
  String get inventoryLocationLabel => 'Storage location';

  @override
  String get inventoryUsageLabel => 'Usage';

  @override
  String inventoryLowStockCount(Object count) {
    return 'Low stock: $count';
  }

  @override
  String inventoryLowStockItemLine(
    Object amount,
    Object item,
    Object minStock,
    Object unit,
  ) {
    return '$item: $amount $unit, minimum $minStock $unit';
  }

  @override
  String get inventoryAllTypes => 'All types';

  @override
  String get inventoryBelowMin => 'Below minimum';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return 'Min: $minStock $unit';
  }

  @override
  String get chatProfileSaved => 'Chat profile saved';

  @override
  String get chatUnavailableShort =>
      'Firebase is not configured. Chat is temporarily unavailable.';

  @override
  String get chatCreateDialogTitle => 'New dialog';

  @override
  String get chatCreateExternalTitle => 'New external chat';

  @override
  String get chatPeerIdLabelTeam => 'Master ID';

  @override
  String get chatPeerIdLabelExternal => 'Studio/Master ID';

  @override
  String get chatPeerNameLabelTeam => 'Master name';

  @override
  String get chatPeerNameLabelExternal => 'Studio or master name';

  @override
  String get chatCreateAction => 'Create';

  @override
  String get chatDialogTitle => 'Dialog';

  @override
  String get chatScreenTitleTeam => 'Internal team chat';

  @override
  String get chatScreenTitleExternal => 'External community chat';

  @override
  String get chatNewChatButton => 'New chat';

  @override
  String get chatMyIdLabel => 'Your ID';

  @override
  String get chatMyIdHint => 'For example: master_001';

  @override
  String get chatMyNameLabel => 'Your name';

  @override
  String get chatMyNameHint => 'For example: Alex';

  @override
  String get chatUnavailableTitle => 'Chat is temporarily unavailable';

  @override
  String get chatUnavailableSubtitle =>
      'Firebase is not configured for this build. Add Firebase configs to enable chat.';

  @override
  String get chatProfileFillTitleTeam => 'Fill in your chat profile';

  @override
  String get chatProfileFillTitleExternal => 'Fill in your community profile';

  @override
  String get chatProfileFillSubtitleTeam =>
      'Enter your ID and name, then press Save.';

  @override
  String get chatProfileFillSubtitleExternal =>
      'Enter your ID and name to chat with other studios and masters.';

  @override
  String get chatErrorTitle => 'Chat unavailable';

  @override
  String get chatErrorSubtitle =>
      'Check Firebase setup (google-services and Firebase.initializeApp).';

  @override
  String get chatEmptyTitle => 'No dialogs yet';

  @override
  String get chatEmptySubtitle =>
      'Create your first chat with the New chat button.';

  @override
  String get chatNoMessages => 'No messages yet';

  @override
  String get chatOpenAfterFirebase =>
      'Firebase is not configured. Open chat after Firebase setup.';

  @override
  String get chatConnectionError => 'Chat connection error';

  @override
  String get chatMessageHint => 'Type a message';

  @override
  String get chatAttachPhoto => 'Attach photo';

  @override
  String get chatAttachFile => 'Attach file';

  @override
  String get chatAttachmentFile => 'File';

  @override
  String get chatFileOpenFailed => 'Could not open file.';

  @override
  String chatUploadFailed(Object error) {
    return 'Upload failed: $error';
  }

  @override
  String get durationMinutesShort => 'min';

  @override
  String get inventoryTypeChemistry => 'Chemistry';

  @override
  String get inventoryTypeConsumable => 'Consumable';

  @override
  String get inventoryTypeAccessory => 'Accessory';

  @override
  String get inventoryTypeEquipment => 'Equipment';

  @override
  String get emailLabel => 'Email';

  @override
  String get authEnterEmail => 'Enter email';

  @override
  String get authInvalidEmail => 'Invalid email';

  @override
  String get authEnterPassword => 'Enter password';

  @override
  String get authPasswordMin => 'Minimum 8 characters';

  @override
  String get authFirebaseGuestOnly =>
      'Firebase is not configured. Guest mode is available.';

  @override
  String get authSignInFailed => 'Failed to sign in. Please try again.';

  @override
  String get authPasswordsMismatch => 'Passwords do not match';

  @override
  String get authJoinSuccess => 'You have successfully joined the team!';

  @override
  String authInviteRejected(Object error) {
    return 'Registration completed, but invite code was rejected: $error';
  }

  @override
  String get authRegisterFailed =>
      'Failed to complete registration. Please try again.';

  @override
  String get authGuestName => 'Guest';

  @override
  String get authGoogleSoon => 'Google sign-in will be added later';

  @override
  String get authInvalidEmailFormat => 'Invalid email format';

  @override
  String get authWrongCredentials => 'Incorrect email or password';

  @override
  String get authEmailInUse => 'This email is already in use';

  @override
  String get authWeakPassword => 'Password is too weak';

  @override
  String get authTooManyRequests => 'Too many attempts. Try again later';

  @override
  String get authAuthorizationError => 'Authorization error';

  @override
  String get authWelcome => 'Welcome';

  @override
  String get authSubtitle => 'Sign in to your account or register';

  @override
  String get authTabSignIn => 'Sign In';

  @override
  String get authTabRegister => 'Register';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueAsGuest => 'Continue as guest';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authInviteCodeOptional => 'Invite code (optional)';

  @override
  String get authInviteHint => 'If you were invited by the director';

  @override
  String get authRegisterButton => 'Register';

  @override
  String get businessModeQuestion => 'How do you work?';

  @override
  String get businessModeSubtitle =>
      'Choose a mode so the app shows only the modules you need.';

  @override
  String get businessModeSoloTitle => 'I work alone';

  @override
  String get businessModeSoloSubtitle =>
      'For a solo specialist: orders, clients, inventory, finance, and external chat.';

  @override
  String get businessModeTeamTitle => 'We have a team';

  @override
  String get businessModeTeamSubtitle =>
      'For a studio: staff roles, internal chat, tasks by specialist, and director control.';

  @override
  String get photosGallerySaveFailed =>
      'Photo was added to the app, but could not be saved to gallery.';

  @override
  String get photosCameraUnsupported =>
      'Camera is available only on Android/iOS or in web version.';

  @override
  String get photosAddedAndSaved => 'Photo added and saved to gallery.';

  @override
  String get photosAddedFromGallery => 'Photo added from gallery.';

  @override
  String get photosAddFromGallery => 'Add from gallery';

  @override
  String get photosTakePhoto => 'Take photo';

  @override
  String get photosDeleteDenied => 'Not enough permissions to delete photo.';

  @override
  String get settingsProfileAndOrgTitle => 'Profile and organization';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => 'Guest';

  @override
  String get settingsBusinessModeTitle => 'Work mode';

  @override
  String get settingsUserRoleTitle => 'User role';

  @override
  String get settingsInviteMasterTitle => 'Invite specialist';

  @override
  String get settingsInviteMasterSubtitle => 'Generate one-time invite code';

  @override
  String get settingsServicesSection => 'Services';

  @override
  String get settingsLogoutButton => 'Sign out';

  @override
  String get settingsBusinessModeTeam => 'Team (studio)';

  @override
  String get settingsBusinessModeSolo => 'Solo (single specialist)';

  @override
  String get settingsRoleDirector => 'Director';

  @override
  String get settingsRoleMaster => 'Specialist';

  @override
  String get settingsRoleMasterOwner => 'Owner specialist';

  @override
  String get settingsSelectModeTitle => 'Choose mode';

  @override
  String get settingsModeSoloTitle => 'Solo';

  @override
  String get settingsModeSoloSubtitle => 'One specialist';

  @override
  String get settingsModeTeamTitle => 'Team';

  @override
  String get settingsModeTeamSubtitle => 'Studio with employees';

  @override
  String get settingsModeUpdated => 'Mode updated.';

  @override
  String get settingsOrgNotFound =>
      'Organization not found. Save settings first.';

  @override
  String settingsInviteGenerateError(Object error) {
    return 'Error generating code: $error';
  }

  @override
  String get settingsInviteDialogTitle => 'Invite code for specialist';

  @override
  String get settingsInviteDialogDescription =>
      'Send this code to the specialist. It is one-time and expires after use.';

  @override
  String get settingsCopy => 'Copy';

  @override
  String get settingsCodeCopied => 'Code copied to clipboard';

  @override
  String get settingsInviteRegistrationHint =>
      'The specialist enters the code in the Invite code field during registration.';

  @override
  String get settingsClose => 'Close';

  @override
  String get settingsSelectRoleTitle => 'Choose role';

  @override
  String get settingsRoleUpdated => 'Role updated.';

  @override
  String get settingsLogoutTitle => 'Sign out';

  @override
  String get settingsLogoutMessage => 'Sign out of the current account?';

  @override
  String get settingsLogoutConfirm => 'Sign out';

  @override
  String get settingsLoggedOut => 'You have signed out.';

  @override
  String get settingsAccessDenied => 'Not enough permissions for this action.';

  @override
  String get settingsResetWarning =>
      'WARNING: All orders, clients, and inventory will be deleted!';

  @override
  String get settingsServiceDeleteDenied =>
      'Not enough permissions to delete service.';

  @override
  String get settingsServiceEditDenied =>
      'Not enough permissions to edit service.';

  @override
  String get legalTitle => 'Legal';

  @override
  String get legalPrivacyTab => 'Privacy Policy';

  @override
  String get legalTermsTab => 'Terms';

  @override
  String get legalPrivacySummaryTitle => 'Privacy Policy Summary';

  @override
  String get legalTermsSummaryTitle => 'Terms of Service Summary';

  @override
  String get legalSummarySubtitle =>
      'Quick in-app summary. Full legal version is available on the published page.';

  @override
  String get legalOpenFullPrivacy => 'Open full Privacy Policy';

  @override
  String get legalOpenFullTerms => 'Open full Terms';

  @override
  String get legalOpenLinkError => 'Unable to open document link.';

  @override
  String get legalPrivacySection1Title => '1. What the app does';

  @override
  String get legalPrivacySection1Body =>
      'DetailingPro Business helps detailing teams manage clients, orders, schedules, inventory, team chat and attached media.';

  @override
  String get legalPrivacySection2Title => '2. Data we process';

  @override
  String get legalPrivacySection2Body =>
      'The app may process account data, customer and order data, service records, inventory entries, team messages, attachments, and technical identifiers such as notification tokens.';

  @override
  String get legalPrivacySection3Title => '3. Why this data is used';

  @override
  String get legalPrivacySection3Body =>
      'Data is used to run core features, sync across devices, deliver reminders, support collaboration and maintain service reliability and security.';

  @override
  String get legalPrivacySection4Title => '4. Permissions and access';

  @override
  String get legalPrivacySection4Body =>
      'Camera/media permissions are requested only for features such as photo and file attachments. Notification permission is used for reminders and push alerts.';

  @override
  String get legalPrivacySection5Title => '5. Infrastructure and providers';

  @override
  String get legalPrivacySection5Body =>
      'The app uses Firebase services (Authentication, Firestore, Storage, Messaging). Data is processed on infrastructure operated by these providers.';

  @override
  String get legalPrivacySection6Title => '6. Retention, deletion and rights';

  @override
  String get legalPrivacySection6Body =>
      'Data is retained while needed to provide the service. Users can request access, correction or deletion according to applicable law and product capabilities.';

  @override
  String get legalPrivacySection7Title => '7. Contact';

  @override
  String get legalPrivacySection7Body =>
      'Privacy questions: support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. Service scope';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro is a business productivity application for managing appointments, clients, media, internal chat and operations data.';

  @override
  String get legalTermsSection2Title => '2. Accounts and access';

  @override
  String get legalTermsSection2Body =>
      'Users are responsible for keeping login credentials secure and for using the app only within the permissions granted to their role inside the organization.';

  @override
  String get legalTermsSection3Title => '3. Acceptable use';

  @override
  String get legalTermsSection3Body =>
      'The service must not be used for unlawful data processing, abusive messaging, unauthorized access attempts or any activity that violates applicable law.';

  @override
  String get legalTermsSection4Title => '4. Availability';

  @override
  String get legalTermsSection4Body =>
      'The service may change over time. Features can be added, modified or removed as the product evolves.';

  @override
  String get legalTermsSection5Title => '5. Paid plans';

  @override
  String get legalTermsSection5Body =>
      'Before launch, this section should be updated with final billing terms, renewal rules, trial details, cancellation terms and refund handling for Google Play subscriptions.';

  @override
  String get legalTermsSection6Title => '6. Limitation of liability';

  @override
  String get legalTermsSection6Body =>
      'Before public release, replace this draft with a final legal version reviewed for your jurisdiction and business structure.';

  @override
  String get legalTermsSection7Title => '7. Governing information';

  @override
  String get legalTermsSection7Body =>
      'Replace this section with your registered business details and governing law information before publishing to the store.';

  @override
  String get invoiceCompanyDataTitle => 'Company data';

  @override
  String get invoiceCompanyDataSubtitle => 'For VAT invoices';

  @override
  String get invoiceCompanyName => 'Company name';

  @override
  String get invoiceCompanyAddress => 'Address';

  @override
  String get invoiceCompanyPostalCode => 'Postal code';

  @override
  String get invoiceCompanyCity => 'City';

  @override
  String get invoiceGenerateButton => 'Generate invoice';

  @override
  String get invoiceVatRate => 'VAT rate';

  @override
  String get settingsBookingLinkTitle => 'Online booking link';

  @override
  String get settingsBookingRequestsTitle => 'Online booking requests';

  @override
  String get settingsBookingLinkDialogTitle => 'Your booking link';

  @override
  String get settingsBookingLinkCopied => 'Link copied';

  @override
  String get settingsBookingLinkAuthRequired =>
      'Sign in to generate a booking link.';

  @override
  String get settingsBookingLinkOpen => 'Open';

  @override
  String get settingsWorkingHoursTitle => 'Working hours';

  @override
  String get settingsWorkingHoursSlotLabel => 'Slot';

  @override
  String get settingsWorkingHoursMinNoticeLabel => 'Min notice';

  @override
  String get settingsWorkingHoursBreakLabel => 'Break';

  @override
  String get settingsWorkingHoursNotice1Hour => '1 hour';

  @override
  String get settingsWorkingHoursNotice2Hours => '2 hours';

  @override
  String get settingsWorkingHoursNotice24Hours => '24 hours';

  @override
  String get bookingRequestsTitle => 'Online booking requests';

  @override
  String get bookingRequestsFirebaseUnavailable =>
      'Firebase is not configured for online booking.';

  @override
  String get bookingRequestsSignInRequired =>
      'Sign in to view booking requests.';

  @override
  String bookingRequestsError(Object error) {
    return 'Error loading requests: $error';
  }

  @override
  String get bookingRequestsEmpty => 'No booking requests yet.';

  @override
  String get bookingRequestServiceLabel => 'Service';

  @override
  String get bookingRequestScheduleLabel => 'Preferred date/time';

  @override
  String get bookingRequestPhoneLabel => 'Phone';

  @override
  String get bookingRequestCarLabel => 'Car';

  @override
  String get bookingRequestNoteLabel => 'Note';

  @override
  String get bookingRequestAccept => 'Accept';

  @override
  String get bookingRequestDecline => 'Decline';

  @override
  String get bookingRequestCall => 'Call';

  @override
  String get bookingRequestStatusPending => 'Pending';

  @override
  String get bookingRequestStatusAccepted => 'Accepted';

  @override
  String get bookingRequestStatusDeclined => 'Declined';

  @override
  String get bookingRequestsFilterAll => 'All';

  @override
  String get bookingRequestsEmptyNew => 'No new requests';

  @override
  String get bookingRequestsAcceptedFeedback =>
      'Request accepted — order will be created automatically';

  @override
  String get bookingRequestsDeclinedFeedback => 'Request declined';

  @override
  String get bookingRequestsDeclineConfirmContent =>
      'Decline this booking request?';

  @override
  String get enterServiceName => 'Service name is required';

  @override
  String get invalidPrice => 'Enter a valid price (0 or more)';

  @override
  String get invoiceTitle => 'INVOICE';

  @override
  String get invoiceNumberPrefix => 'INV';

  @override
  String get invoiceSeller => 'SELLER';

  @override
  String get invoiceBuyer => 'BUYER';

  @override
  String get invoiceIssueDateLabel => 'Issue date';

  @override
  String get invoiceServiceDateLabel => 'Service date';

  @override
  String get invoiceDescriptionLabel => 'Description';

  @override
  String get invoiceQtyLabel => 'Qty';

  @override
  String get invoiceNetPriceLabel => 'Net price';

  @override
  String get invoiceVatPctLabel => 'VAT %';

  @override
  String get invoiceVatAmountLabel => 'VAT amount';

  @override
  String get invoiceGrossPriceLabel => 'Gross price';

  @override
  String get invoiceNetTotalLabel => 'Net total:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return 'VAT $rate:';
  }

  @override
  String get invoiceTotalDueLabel => 'TOTAL DUE:';

  @override
  String get invoiceFillCompanyLabel => 'Fill in company data';

  @override
  String get invoiceIssuedByLabel => 'Invoice issued by';

  @override
  String get invoicePrimaryIdLabel => 'Tax ID';

  @override
  String get invoiceSecondaryIdLabel => 'Business ID';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total seats';
  }

  @override
  String get syncOfflineWarning =>
      'No internet connection. Data may be outdated.';

  @override
  String get forceUpdateTitle => 'Update required';

  @override
  String get forceUpdateMessage =>
      'A new version of the app is available. Please update to continue using Detailing Pro.';

  @override
  String get forceUpdateButton => 'Update';

  @override
  String get storageStartupTitle => 'Local storage unavailable';

  @override
  String get storageStartupBody =>
      'Detailing Pro could not open its encrypted database. Your data on this device may be protected or corrupted.';

  @override
  String get storageStartupHint =>
      'Try fully closing the app and opening it again. If the problem continues, reinstall the app (cloud data will remain if you sign in with the same account).';

  @override
  String get storageStartupCloseApp => 'Close app';

  @override
  String get settingsSyncStatusTitle => 'Cloud sync';

  @override
  String settingsSyncPendingMessage(int count) {
    return '$count changes waiting to sync';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return '$count changes could not sync to the cloud';
  }

  @override
  String get settingsSyncRetryButton => 'Retry sync';

  @override
  String get settingsSyncDiscardButton => 'Discard failed changes';
}
