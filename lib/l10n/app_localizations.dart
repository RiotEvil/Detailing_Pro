import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
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
    Locale('uk'),
    Locale('ru'),
    Locale('de'),
    Locale('es'),
    Locale('it'),
    Locale('pl'),
    Locale('pt'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Detailing Pro'**
  String get appTitle;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(Object version);

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get navClients;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get navPhotos;

  /// No description provided for @navMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get navMarketing;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @inventoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory is empty'**
  String get inventoryEmptyTitle;

  /// No description provided for @inventoryEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add chemicals using the button below'**
  String get inventoryEmptySubtitle;

  /// No description provided for @showAllCategories.
  ///
  /// In en, this message translates to:
  /// **'Show all categories'**
  String get showAllCategories;

  /// No description provided for @chemicalsButton.
  ///
  /// In en, this message translates to:
  /// **'CHEMICALS'**
  String get chemicalsButton;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get noOrdersTitle;

  /// No description provided for @noOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first order to get started'**
  String get noOrdersSubtitle;

  /// No description provided for @addOrder.
  ///
  /// In en, this message translates to:
  /// **'Add services'**
  String get addOrder;

  /// No description provided for @orderButton.
  ///
  /// In en, this message translates to:
  /// **'ORDER'**
  String get orderButton;

  /// No description provided for @deleteOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete order?'**
  String get deleteOrderTitle;

  /// No description provided for @deleteOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'Order \"{car}\" will be permanently deleted.'**
  String deleteOrderMessage(Object car);

  /// No description provided for @deletedOrderSnack.
  ///
  /// In en, this message translates to:
  /// **'Order \"{car}\" deleted'**
  String deletedOrderSnack(Object car);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @carLabel.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get carLabel;

  /// No description provided for @clientLabel.
  ///
  /// In en, this message translates to:
  /// **'Client: {client}'**
  String clientLabel(Object client);

  /// No description provided for @serviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service: {service} ({duration} min)'**
  String serviceLabel(Object duration, Object service);

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get statusScheduled;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get markDone;

  /// No description provided for @markPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get markPaid;

  /// No description provided for @statusChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order status updated'**
  String get statusChangedTitle;

  /// No description provided for @statusChangedMessage.
  ///
  /// In en, this message translates to:
  /// **'Order \"{car}\" is now {status}'**
  String statusChangedMessage(Object car, Object status);

  /// No description provided for @newChemicalTitle.
  ///
  /// In en, this message translates to:
  /// **'New chemical'**
  String get newChemicalTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get nameLabel;

  /// No description provided for @brandLabel.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brandLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @volumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume (ml)'**
  String get volumeLabel;

  /// No description provided for @deleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteItemTitle;

  /// No description provided for @deleteItemMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{item}\" from inventory?'**
  String deleteItemMessage(Object item);

  /// No description provided for @unnamedItem.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get unnamedItem;

  /// No description provided for @replenish.
  ///
  /// In en, this message translates to:
  /// **'Replenish'**
  String get replenish;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning!'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon!'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening!'**
  String get goodEvening;

  /// No description provided for @statsTodayOrders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s orders'**
  String get statsTodayOrders;

  /// No description provided for @statsInWork.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statsInWork;

  /// No description provided for @statsTodayRevenue.
  ///
  /// In en, this message translates to:
  /// **'Today\'s revenue'**
  String get statsTodayRevenue;

  /// No description provided for @statsTotalClients.
  ///
  /// In en, this message translates to:
  /// **'Total clients'**
  String get statsTotalClients;

  /// No description provided for @noCars.
  ///
  /// In en, this message translates to:
  /// **'No cars'**
  String get noCars;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get newOrder;

  /// No description provided for @newClient.
  ///
  /// In en, this message translates to:
  /// **'New client'**
  String get newClient;

  /// No description provided for @todayOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s appointments'**
  String get todayOrdersTitle;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @statsRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get statsRevenue;

  /// No description provided for @statsOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get statsOrders;

  /// No description provided for @statsPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get statsPeriodWeek;

  /// No description provided for @statsPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get statsPeriodMonth;

  /// No description provided for @statsPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get statsPeriodYear;

  /// No description provided for @photosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosTitle;

  /// No description provided for @orderBeforePhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get orderBeforePhotosTitle;

  /// No description provided for @orderAfterPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get orderAfterPhotosTitle;

  /// No description provided for @photosAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get photosAdd;

  /// No description provided for @photosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photos yet'**
  String get photosEmpty;

  /// No description provided for @photosSelectCar.
  ///
  /// In en, this message translates to:
  /// **'Select car'**
  String get photosSelectCar;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get totalSpent;

  /// No description provided for @orderHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get orderHistoryTitle;

  /// No description provided for @orderHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Order history is empty'**
  String get orderHistoryEmpty;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @photoReport.
  ///
  /// In en, this message translates to:
  /// **'Photo report'**
  String get photoReport;

  /// No description provided for @photosNotAdded.
  ///
  /// In en, this message translates to:
  /// **'No photos added'**
  String get photosNotAdded;

  /// No description provided for @editOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit order'**
  String get editOrderTitle;

  /// No description provided for @newOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get newOrderTitle;

  /// No description provided for @clientFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Client *'**
  String get clientFieldLabel;

  /// No description provided for @selectClient.
  ///
  /// In en, this message translates to:
  /// **'Select client'**
  String get selectClient;

  /// No description provided for @carHint.
  ///
  /// In en, this message translates to:
  /// **'Model and plate number'**
  String get carHint;

  /// No description provided for @enterCar.
  ///
  /// In en, this message translates to:
  /// **'Enter car details'**
  String get enterCar;

  /// No description provided for @serviceFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Service *'**
  String get serviceFieldLabel;

  /// No description provided for @selectService.
  ///
  /// In en, this message translates to:
  /// **'Select service'**
  String get selectService;

  /// No description provided for @orderMaterialCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Material cost'**
  String get orderMaterialCostLabel;

  /// No description provided for @orderLaborCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Labor cost'**
  String get orderLaborCostLabel;

  /// No description provided for @orderTotalCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Total cost'**
  String get orderTotalCostLabel;

  /// No description provided for @orderProfitLabel.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get orderProfitLabel;

  /// No description provided for @statsProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get statsProfit;

  /// No description provided for @orderNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Order notes'**
  String get orderNotesLabel;

  /// No description provided for @createOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get createOrderButton;

  /// No description provided for @orderUpdated.
  ///
  /// In en, this message translates to:
  /// **'Order updated'**
  String get orderUpdated;

  /// No description provided for @orderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order created successfully'**
  String get orderCreated;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(Object error);

  /// No description provided for @editClient.
  ///
  /// In en, this message translates to:
  /// **'Edit client'**
  String get editClient;

  /// No description provided for @clientNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Client name *'**
  String get clientNameLabel;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+1 (___) ___-____'**
  String get phoneHint;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enterValidPhone;

  /// No description provided for @carsLabel.
  ///
  /// In en, this message translates to:
  /// **'Cars *'**
  String get carsLabel;

  /// No description provided for @addCar.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addCar;

  /// No description provided for @addAtLeastOneCar.
  ///
  /// In en, this message translates to:
  /// **'Add at least one car'**
  String get addAtLeastOneCar;

  /// No description provided for @addCarDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add car'**
  String get addCarDialogTitle;

  /// No description provided for @carExample.
  ///
  /// In en, this message translates to:
  /// **'Example: BMW X5 ABC1234'**
  String get carExample;

  /// No description provided for @carAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'This car is already added'**
  String get carAlreadyAdded;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @saveClient.
  ///
  /// In en, this message translates to:
  /// **'Save client'**
  String get saveClient;

  /// No description provided for @clientUpdated.
  ///
  /// In en, this message translates to:
  /// **'Client updated'**
  String get clientUpdated;

  /// No description provided for @clientAdded.
  ///
  /// In en, this message translates to:
  /// **'Client added successfully'**
  String get clientAdded;

  /// No description provided for @otherCategory.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherCategory;

  /// No description provided for @replenishItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Replenish \"{item}\"'**
  String replenishItemTitle(Object item);

  /// No description provided for @howManyToAdd.
  ///
  /// In en, this message translates to:
  /// **'How much to add?'**
  String get howManyToAdd;

  /// No description provided for @ml.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get ml;

  /// No description provided for @currentStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock: \"{item}\"'**
  String currentStockTitle(Object item);

  /// No description provided for @currentStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Current volume on shelf'**
  String get currentStockLabel;

  /// No description provided for @inactiveClients.
  ///
  /// In en, this message translates to:
  /// **'Inactive clients'**
  String get inactiveClients;

  /// No description provided for @promotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions & Discounts'**
  String get promotions;

  /// No description provided for @promotionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Create promotions to attract customers'**
  String get promotionsDescription;

  /// No description provided for @loyaltyProgram.
  ///
  /// In en, this message translates to:
  /// **'Loyalty program'**
  String get loyaltyProgram;

  /// No description provided for @loyaltyDescription.
  ///
  /// In en, this message translates to:
  /// **'Reward regular customers with bonuses'**
  String get loyaltyDescription;

  /// No description provided for @smsBroadcast.
  ///
  /// In en, this message translates to:
  /// **'SMS broadcast'**
  String get smsBroadcast;

  /// No description provided for @smsDescription.
  ///
  /// In en, this message translates to:
  /// **'Send reminders and news to clients'**
  String get smsDescription;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @reviewsDescription.
  ///
  /// In en, this message translates to:
  /// **'Collect reviews and improve service'**
  String get reviewsDescription;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get comingSoon;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @ordersChannelName.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersChannelName;

  /// No description provided for @ordersChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Order notifications'**
  String get ordersChannelDescription;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @searchClientsHint.
  ///
  /// In en, this message translates to:
  /// **'Search clients or cars...'**
  String get searchClientsHint;

  /// No description provided for @crmFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get crmFilterAll;

  /// No description provided for @crmFilterVip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get crmFilterVip;

  /// No description provided for @crmFilterAtRisk.
  ///
  /// In en, this message translates to:
  /// **'At risk'**
  String get crmFilterAtRisk;

  /// No description provided for @crmFilterInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get crmFilterInactive;

  /// No description provided for @crmTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get crmTagsLabel;

  /// No description provided for @crmTagsHint.
  ///
  /// In en, this message translates to:
  /// **'VIP, fleet, referral'**
  String get crmTagsHint;

  /// No description provided for @crmSegmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Segment'**
  String get crmSegmentLabel;

  /// No description provided for @crmLastVisitLabel.
  ///
  /// In en, this message translates to:
  /// **'Last visit'**
  String get crmLastVisitLabel;

  /// No description provided for @crmAtRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Needs follow-up'**
  String get crmAtRiskLabel;

  /// No description provided for @crmReminderButton.
  ///
  /// In en, this message translates to:
  /// **'Send reminder'**
  String get crmReminderButton;

  /// No description provided for @crmReminderTemplate.
  ///
  /// In en, this message translates to:
  /// **'Hi, {client}! This is a friendly reminder from the detailing studio. We can book you for {service} at a convenient time.'**
  String crmReminderTemplate(Object client, Object service);

  /// No description provided for @crmBulkReminderButton.
  ///
  /// In en, this message translates to:
  /// **'Campaign reminder'**
  String get crmBulkReminderButton;

  /// No description provided for @crmBulkReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Select recipients'**
  String get crmBulkReminderTitle;

  /// No description provided for @crmBulkReminderToggleAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get crmBulkReminderToggleAll;

  /// No description provided for @crmBulkReminderSendSelected.
  ///
  /// In en, this message translates to:
  /// **'Send to selected'**
  String get crmBulkReminderSendSelected;

  /// No description provided for @crmBulkReminderEmpty.
  ///
  /// In en, this message translates to:
  /// **'No clients with phone in this list.'**
  String get crmBulkReminderEmpty;

  /// No description provided for @crmBulkReminderTemplate.
  ///
  /// In en, this message translates to:
  /// **'Hello! This is a reminder from the detailing studio. You can book a convenient time for your next service.'**
  String get crmBulkReminderTemplate;

  /// No description provided for @crmSegmentNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get crmSegmentNew;

  /// No description provided for @crmSegmentReturning.
  ///
  /// In en, this message translates to:
  /// **'Returning'**
  String get crmSegmentReturning;

  /// No description provided for @crmSegmentLoyal.
  ///
  /// In en, this message translates to:
  /// **'Loyal'**
  String get crmSegmentLoyal;

  /// No description provided for @clientsNotFound.
  ///
  /// In en, this message translates to:
  /// **'No clients found'**
  String get clientsNotFound;

  /// No description provided for @openCallFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open call.'**
  String get openCallFailed;

  /// No description provided for @openWhatsAppFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open SMS app.'**
  String get openWhatsAppFailed;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortTooltip;

  /// No description provided for @sortByNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name: A-Z'**
  String get sortByNameAsc;

  /// No description provided for @sortByNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name: Z-A'**
  String get sortByNameDesc;

  /// No description provided for @sortByNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortByNewest;

  /// No description provided for @permissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get permissionDeniedTitle;

  /// No description provided for @permissionCreateOrderDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to create an order.'**
  String get permissionCreateOrderDenied;

  /// No description provided for @permissionDeleteOrderDenied.
  ///
  /// In en, this message translates to:
  /// **'Deleting orders is available only for director or owner.'**
  String get permissionDeleteOrderDenied;

  /// No description provided for @permissionEditOrderDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to edit an order.'**
  String get permissionEditOrderDenied;

  /// No description provided for @permissionSaveOrderDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to save an order.'**
  String get permissionSaveOrderDenied;

  /// No description provided for @permissionCreateClientDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to create a client.'**
  String get permissionCreateClientDenied;

  /// No description provided for @permissionDeleteClientDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to delete a client.'**
  String get permissionDeleteClientDenied;

  /// No description provided for @permissionEditClientDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to edit a client.'**
  String get permissionEditClientDenied;

  /// No description provided for @permissionSaveClientDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to save a client.'**
  String get permissionSaveClientDenied;

  /// No description provided for @permissionModifyInventoryDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to modify inventory.'**
  String get permissionModifyInventoryDenied;

  /// No description provided for @permissionEditInventoryStockDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to change stock levels.'**
  String get permissionEditInventoryStockDenied;

  /// No description provided for @permissionEditInventoryDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to edit inventory.'**
  String get permissionEditInventoryDenied;

  /// No description provided for @clientDeleted.
  ///
  /// In en, this message translates to:
  /// **'Client was deleted'**
  String get clientDeleted;

  /// No description provided for @clientGarageTitle.
  ///
  /// In en, this message translates to:
  /// **'Client garage'**
  String get clientGarageTitle;

  /// No description provided for @navTeamChats.
  ///
  /// In en, this message translates to:
  /// **'Team chats'**
  String get navTeamChats;

  /// No description provided for @navCommunityChat.
  ///
  /// In en, this message translates to:
  /// **'Community chat'**
  String get navCommunityChat;

  /// No description provided for @orderDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get orderDefaultTitle;

  /// No description provided for @completeOrderAndConsumePrompt.
  ///
  /// In en, this message translates to:
  /// **'Complete the order and deduct chemicals from inventory?'**
  String get completeOrderAndConsumePrompt;

  /// No description provided for @orderCompletedSnack.
  ///
  /// In en, this message translates to:
  /// **'{car}: Completed'**
  String orderCompletedSnack(Object car);

  /// No description provided for @appointmentReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming appointment'**
  String get appointmentReminderTitle;

  /// No description provided for @appointmentReminderBody.
  ///
  /// In en, this message translates to:
  /// **'{car} at {time}'**
  String appointmentReminderBody(Object car, Object time);

  /// No description provided for @inventoryFirstItemHint.
  ///
  /// In en, this message translates to:
  /// **'Add the first inventory item: chemicals, consumables, accessories, or equipment.'**
  String get inventoryFirstItemHint;

  /// No description provided for @inventoryFilteredEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items found for selected filters.'**
  String get inventoryFilteredEmpty;

  /// No description provided for @inventoryItemLabel.
  ///
  /// In en, this message translates to:
  /// **'ITEM'**
  String get inventoryItemLabel;

  /// No description provided for @inventoryLowStockMore.
  ///
  /// In en, this message translates to:
  /// **' and {count} more'**
  String inventoryLowStockMore(Object count);

  /// No description provided for @inventoryLowStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Low stock in inventory'**
  String get inventoryLowStockTitle;

  /// No description provided for @inventoryLowStockBody.
  ///
  /// In en, this message translates to:
  /// **'{items} require attention.'**
  String inventoryLowStockBody(Object items);

  /// No description provided for @inventoryNotificationsChannelName.
  ///
  /// In en, this message translates to:
  /// **'Inventory alerts'**
  String get inventoryNotificationsChannelName;

  /// No description provided for @inventoryNotificationsChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Alerts about low stock in inventory'**
  String get inventoryNotificationsChannelDescription;

  /// No description provided for @inventoryEditItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get inventoryEditItemTitle;

  /// No description provided for @inventoryNewItemTitle.
  ///
  /// In en, this message translates to:
  /// **'New inventory item'**
  String get inventoryNewItemTitle;

  /// No description provided for @inventoryItemTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Item type'**
  String get inventoryItemTypeLabel;

  /// No description provided for @inventoryUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get inventoryUnitLabel;

  /// No description provided for @inventoryCurrentStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Current stock'**
  String get inventoryCurrentStockLabel;

  /// No description provided for @inventoryMinStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum stock'**
  String get inventoryMinStockLabel;

  /// No description provided for @inventoryLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Storage location'**
  String get inventoryLocationLabel;

  /// No description provided for @inventoryUsageLabel.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get inventoryUsageLabel;

  /// No description provided for @inventoryLowStockCount.
  ///
  /// In en, this message translates to:
  /// **'Low stock: {count}'**
  String inventoryLowStockCount(Object count);

  /// No description provided for @inventoryLowStockItemLine.
  ///
  /// In en, this message translates to:
  /// **'{item}: {amount} {unit}, minimum {minStock} {unit}'**
  String inventoryLowStockItemLine(
    Object amount,
    Object item,
    Object minStock,
    Object unit,
  );

  /// No description provided for @inventoryAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get inventoryAllTypes;

  /// No description provided for @inventoryBelowMin.
  ///
  /// In en, this message translates to:
  /// **'Below minimum'**
  String get inventoryBelowMin;

  /// No description provided for @inventoryMinChip.
  ///
  /// In en, this message translates to:
  /// **'Min: {minStock} {unit}'**
  String inventoryMinChip(Object minStock, Object unit);

  /// No description provided for @chatProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Chat profile saved'**
  String get chatProfileSaved;

  /// No description provided for @chatUnavailableShort.
  ///
  /// In en, this message translates to:
  /// **'Firebase is not configured. Chat is temporarily unavailable.'**
  String get chatUnavailableShort;

  /// No description provided for @chatCreateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'New dialog'**
  String get chatCreateDialogTitle;

  /// No description provided for @chatCreateExternalTitle.
  ///
  /// In en, this message translates to:
  /// **'New external chat'**
  String get chatCreateExternalTitle;

  /// No description provided for @chatPeerIdLabelTeam.
  ///
  /// In en, this message translates to:
  /// **'Master ID'**
  String get chatPeerIdLabelTeam;

  /// No description provided for @chatPeerIdLabelExternal.
  ///
  /// In en, this message translates to:
  /// **'Studio/Master ID'**
  String get chatPeerIdLabelExternal;

  /// No description provided for @chatPeerNameLabelTeam.
  ///
  /// In en, this message translates to:
  /// **'Master name'**
  String get chatPeerNameLabelTeam;

  /// No description provided for @chatPeerNameLabelExternal.
  ///
  /// In en, this message translates to:
  /// **'Studio or master name'**
  String get chatPeerNameLabelExternal;

  /// No description provided for @chatCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get chatCreateAction;

  /// No description provided for @chatDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Dialog'**
  String get chatDialogTitle;

  /// No description provided for @chatScreenTitleTeam.
  ///
  /// In en, this message translates to:
  /// **'Internal team chat'**
  String get chatScreenTitleTeam;

  /// No description provided for @chatScreenTitleExternal.
  ///
  /// In en, this message translates to:
  /// **'External community chat'**
  String get chatScreenTitleExternal;

  /// No description provided for @chatNewChatButton.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get chatNewChatButton;

  /// No description provided for @chatMyIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Your ID'**
  String get chatMyIdLabel;

  /// No description provided for @chatMyIdHint.
  ///
  /// In en, this message translates to:
  /// **'For example: master_001'**
  String get chatMyIdHint;

  /// No description provided for @chatMyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get chatMyNameLabel;

  /// No description provided for @chatMyNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Alex'**
  String get chatMyNameHint;

  /// No description provided for @chatUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat is temporarily unavailable'**
  String get chatUnavailableTitle;

  /// No description provided for @chatUnavailableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Firebase is not configured for this build. Add Firebase configs to enable chat.'**
  String get chatUnavailableSubtitle;

  /// No description provided for @chatProfileFillTitleTeam.
  ///
  /// In en, this message translates to:
  /// **'Fill in your chat profile'**
  String get chatProfileFillTitleTeam;

  /// No description provided for @chatProfileFillTitleExternal.
  ///
  /// In en, this message translates to:
  /// **'Fill in your community profile'**
  String get chatProfileFillTitleExternal;

  /// No description provided for @chatProfileFillSubtitleTeam.
  ///
  /// In en, this message translates to:
  /// **'Enter your ID and name, then press Save.'**
  String get chatProfileFillSubtitleTeam;

  /// No description provided for @chatProfileFillSubtitleExternal.
  ///
  /// In en, this message translates to:
  /// **'Enter your ID and name to chat with other studios and masters.'**
  String get chatProfileFillSubtitleExternal;

  /// No description provided for @chatErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat unavailable'**
  String get chatErrorTitle;

  /// No description provided for @chatErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check Firebase setup (google-services and Firebase.initializeApp).'**
  String get chatErrorSubtitle;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No dialogs yet'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first chat with the New chat button.'**
  String get chatEmptySubtitle;

  /// No description provided for @chatNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatNoMessages;

  /// No description provided for @chatOpenAfterFirebase.
  ///
  /// In en, this message translates to:
  /// **'Firebase is not configured. Open chat after Firebase setup.'**
  String get chatOpenAfterFirebase;

  /// No description provided for @chatConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Chat connection error'**
  String get chatConnectionError;

  /// No description provided for @chatMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get chatMessageHint;

  /// No description provided for @chatAttachPhoto.
  ///
  /// In en, this message translates to:
  /// **'Attach photo'**
  String get chatAttachPhoto;

  /// No description provided for @chatAttachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach file'**
  String get chatAttachFile;

  /// No description provided for @chatAttachmentFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get chatAttachmentFile;

  /// No description provided for @chatFileOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open file.'**
  String get chatFileOpenFailed;

  /// No description provided for @chatUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed: {error}'**
  String chatUploadFailed(Object error);

  /// No description provided for @durationMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get durationMinutesShort;

  /// No description provided for @inventoryTypeChemistry.
  ///
  /// In en, this message translates to:
  /// **'Chemistry'**
  String get inventoryTypeChemistry;

  /// No description provided for @inventoryTypeConsumable.
  ///
  /// In en, this message translates to:
  /// **'Consumable'**
  String get inventoryTypeConsumable;

  /// No description provided for @inventoryTypeAccessory.
  ///
  /// In en, this message translates to:
  /// **'Accessory'**
  String get inventoryTypeAccessory;

  /// No description provided for @inventoryTypeEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get inventoryTypeEquipment;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @authEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get authEnterEmail;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get authInvalidEmail;

  /// No description provided for @authEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get authEnterPassword;

  /// No description provided for @authPasswordMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get authPasswordMin;

  /// No description provided for @authFirebaseGuestOnly.
  ///
  /// In en, this message translates to:
  /// **'Firebase is not configured. Guest mode is available.'**
  String get authFirebaseGuestOnly;

  /// No description provided for @authSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in. Please try again.'**
  String get authSignInFailed;

  /// No description provided for @authPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsMismatch;

  /// No description provided for @authJoinSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have successfully joined the team!'**
  String get authJoinSuccess;

  /// No description provided for @authInviteRejected.
  ///
  /// In en, this message translates to:
  /// **'Registration completed, but invite code was rejected: {error}'**
  String authInviteRejected(Object error);

  /// No description provided for @authRegisterFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete registration. Please try again.'**
  String get authRegisterFailed;

  /// No description provided for @authGuestName.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get authGuestName;

  /// No description provided for @authGoogleSoon.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in will be added later'**
  String get authGoogleSoon;

  /// No description provided for @authInvalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get authInvalidEmailFormat;

  /// No description provided for @authWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get authWrongCredentials;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get authWeakPassword;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later'**
  String get authTooManyRequests;

  /// No description provided for @authAuthorizationError.
  ///
  /// In en, this message translates to:
  /// **'Authorization error'**
  String get authAuthorizationError;

  /// No description provided for @authWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get authWelcome;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account or register'**
  String get authSubtitle;

  /// No description provided for @authTabSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authTabSignIn;

  /// No description provided for @authTabRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authTabRegister;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get authContinueAsGuest;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authInviteCodeOptional.
  ///
  /// In en, this message translates to:
  /// **'Invite code (optional)'**
  String get authInviteCodeOptional;

  /// No description provided for @authInviteHint.
  ///
  /// In en, this message translates to:
  /// **'If you were invited by the director'**
  String get authInviteHint;

  /// No description provided for @authRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegisterButton;

  /// No description provided for @businessModeQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do you work?'**
  String get businessModeQuestion;

  /// No description provided for @businessModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a mode so the app shows only the modules you need.'**
  String get businessModeSubtitle;

  /// No description provided for @businessModeSoloTitle.
  ///
  /// In en, this message translates to:
  /// **'I work alone'**
  String get businessModeSoloTitle;

  /// No description provided for @businessModeSoloSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For a solo specialist: orders, clients, inventory, finance, and external chat.'**
  String get businessModeSoloSubtitle;

  /// No description provided for @businessModeTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'We have a team'**
  String get businessModeTeamTitle;

  /// No description provided for @businessModeTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For a studio: staff roles, internal chat, tasks by specialist, and director control.'**
  String get businessModeTeamSubtitle;

  /// No description provided for @photosGallerySaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Photo was added to the app, but could not be saved to gallery.'**
  String get photosGallerySaveFailed;

  /// No description provided for @photosCameraUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Camera is available only on Android/iOS or in web version.'**
  String get photosCameraUnsupported;

  /// No description provided for @photosAddedAndSaved.
  ///
  /// In en, this message translates to:
  /// **'Photo added and saved to gallery.'**
  String get photosAddedAndSaved;

  /// No description provided for @photosAddedFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo added from gallery.'**
  String get photosAddedFromGallery;

  /// No description provided for @photosAddFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Add from gallery'**
  String get photosAddFromGallery;

  /// No description provided for @photosTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get photosTakePhoto;

  /// No description provided for @photosDeleteDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to delete photo.'**
  String get photosDeleteDenied;

  /// No description provided for @settingsProfileAndOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile and organization'**
  String get settingsProfileAndOrgTitle;

  /// No description provided for @settingsProfileAndOrgSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{mode} | {user}'**
  String settingsProfileAndOrgSubtitle(Object mode, Object user);

  /// No description provided for @settingsAuthModeFirebase.
  ///
  /// In en, this message translates to:
  /// **'Firebase'**
  String get settingsAuthModeFirebase;

  /// No description provided for @settingsAuthModeGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get settingsAuthModeGuest;

  /// No description provided for @settingsBusinessModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Work mode'**
  String get settingsBusinessModeTitle;

  /// No description provided for @settingsUserRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'User role'**
  String get settingsUserRoleTitle;

  /// No description provided for @settingsInviteMasterTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite specialist'**
  String get settingsInviteMasterTitle;

  /// No description provided for @settingsInviteMasterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate one-time invite code'**
  String get settingsInviteMasterSubtitle;

  /// No description provided for @settingsServicesSection.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get settingsServicesSection;

  /// No description provided for @settingsLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsLogoutButton;

  /// No description provided for @settingsBusinessModeTeam.
  ///
  /// In en, this message translates to:
  /// **'Team (studio)'**
  String get settingsBusinessModeTeam;

  /// No description provided for @settingsBusinessModeSolo.
  ///
  /// In en, this message translates to:
  /// **'Solo (single specialist)'**
  String get settingsBusinessModeSolo;

  /// No description provided for @settingsRoleDirector.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get settingsRoleDirector;

  /// No description provided for @settingsRoleMaster.
  ///
  /// In en, this message translates to:
  /// **'Specialist'**
  String get settingsRoleMaster;

  /// No description provided for @settingsRoleMasterOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner specialist'**
  String get settingsRoleMasterOwner;

  /// No description provided for @settingsSelectModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose mode'**
  String get settingsSelectModeTitle;

  /// No description provided for @settingsModeSoloTitle.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get settingsModeSoloTitle;

  /// No description provided for @settingsModeSoloSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One specialist'**
  String get settingsModeSoloSubtitle;

  /// No description provided for @settingsModeTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get settingsModeTeamTitle;

  /// No description provided for @settingsModeTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Studio with employees'**
  String get settingsModeTeamSubtitle;

  /// No description provided for @settingsModeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Mode updated.'**
  String get settingsModeUpdated;

  /// No description provided for @settingsOrgNotFound.
  ///
  /// In en, this message translates to:
  /// **'Organization not found. Save settings first.'**
  String get settingsOrgNotFound;

  /// No description provided for @settingsInviteGenerateError.
  ///
  /// In en, this message translates to:
  /// **'Error generating code: {error}'**
  String settingsInviteGenerateError(Object error);

  /// No description provided for @settingsInviteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite code for specialist'**
  String get settingsInviteDialogTitle;

  /// No description provided for @settingsInviteDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Send this code to the specialist. It is one-time and expires after use.'**
  String get settingsInviteDialogDescription;

  /// No description provided for @settingsCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get settingsCopy;

  /// No description provided for @settingsCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get settingsCodeCopied;

  /// No description provided for @settingsInviteRegistrationHint.
  ///
  /// In en, this message translates to:
  /// **'The specialist enters the code in the Invite code field during registration.'**
  String get settingsInviteRegistrationHint;

  /// No description provided for @settingsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settingsClose;

  /// No description provided for @settingsSelectRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose role'**
  String get settingsSelectRoleTitle;

  /// No description provided for @settingsRoleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Role updated.'**
  String get settingsRoleUpdated;

  /// No description provided for @settingsLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsLogoutTitle;

  /// No description provided for @settingsLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign out of the current account?'**
  String get settingsLogoutMessage;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'You have signed out.'**
  String get settingsLoggedOut;

  /// No description provided for @settingsAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions for this action.'**
  String get settingsAccessDenied;

  /// No description provided for @settingsResetWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING: All orders, clients, and inventory will be deleted!'**
  String get settingsResetWarning;

  /// No description provided for @settingsServiceDeleteDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to delete service.'**
  String get settingsServiceDeleteDenied;

  /// No description provided for @settingsServiceEditDenied.
  ///
  /// In en, this message translates to:
  /// **'Not enough permissions to edit service.'**
  String get settingsServiceEditDenied;

  /// No description provided for @legalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalTitle;

  /// No description provided for @legalPrivacyTab.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalPrivacyTab;

  /// No description provided for @legalTermsTab.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get legalTermsTab;

  /// No description provided for @legalPrivacySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy Summary'**
  String get legalPrivacySummaryTitle;

  /// No description provided for @legalTermsSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service Summary'**
  String get legalTermsSummaryTitle;

  /// No description provided for @legalSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick in-app summary. Full legal version is available on the published page.'**
  String get legalSummarySubtitle;

  /// No description provided for @legalOpenFullPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Open full Privacy Policy'**
  String get legalOpenFullPrivacy;

  /// No description provided for @legalOpenFullTerms.
  ///
  /// In en, this message translates to:
  /// **'Open full Terms'**
  String get legalOpenFullTerms;

  /// No description provided for @legalOpenLinkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to open document link.'**
  String get legalOpenLinkError;

  /// No description provided for @legalPrivacySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. What the app does'**
  String get legalPrivacySection1Title;

  /// No description provided for @legalPrivacySection1Body.
  ///
  /// In en, this message translates to:
  /// **'DetailingPro Business helps detailing teams manage clients, orders, schedules, inventory, team chat and attached media.'**
  String get legalPrivacySection1Body;

  /// No description provided for @legalPrivacySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Data we process'**
  String get legalPrivacySection2Title;

  /// No description provided for @legalPrivacySection2Body.
  ///
  /// In en, this message translates to:
  /// **'The app may process account data, customer and order data, service records, inventory entries, team messages, attachments, and technical identifiers such as notification tokens.'**
  String get legalPrivacySection2Body;

  /// No description provided for @legalPrivacySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Why this data is used'**
  String get legalPrivacySection3Title;

  /// No description provided for @legalPrivacySection3Body.
  ///
  /// In en, this message translates to:
  /// **'Data is used to run core features, sync across devices, deliver reminders, support collaboration and maintain service reliability and security.'**
  String get legalPrivacySection3Body;

  /// No description provided for @legalPrivacySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Permissions and access'**
  String get legalPrivacySection4Title;

  /// No description provided for @legalPrivacySection4Body.
  ///
  /// In en, this message translates to:
  /// **'Camera/media permissions are requested only for features such as photo and file attachments. Notification permission is used for reminders and push alerts.'**
  String get legalPrivacySection4Body;

  /// No description provided for @legalPrivacySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Infrastructure and providers'**
  String get legalPrivacySection5Title;

  /// No description provided for @legalPrivacySection5Body.
  ///
  /// In en, this message translates to:
  /// **'The app uses Firebase services (Authentication, Firestore, Storage, Messaging). Data is processed on infrastructure operated by these providers.'**
  String get legalPrivacySection5Body;

  /// No description provided for @legalPrivacySection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Retention, deletion and rights'**
  String get legalPrivacySection6Title;

  /// No description provided for @legalPrivacySection6Body.
  ///
  /// In en, this message translates to:
  /// **'Data is retained while needed to provide the service. Users can request access, correction or deletion according to applicable law and product capabilities.'**
  String get legalPrivacySection6Body;

  /// No description provided for @legalPrivacySection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Contact'**
  String get legalPrivacySection7Title;

  /// No description provided for @legalPrivacySection7Body.
  ///
  /// In en, this message translates to:
  /// **'Privacy questions: support@detailingpro-business.com'**
  String get legalPrivacySection7Body;

  /// No description provided for @legalTermsSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Service scope'**
  String get legalTermsSection1Title;

  /// No description provided for @legalTermsSection1Body.
  ///
  /// In en, this message translates to:
  /// **'Detailing Pro is a business productivity application for managing appointments, clients, media, internal chat and operations data.'**
  String get legalTermsSection1Body;

  /// No description provided for @legalTermsSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Accounts and access'**
  String get legalTermsSection2Title;

  /// No description provided for @legalTermsSection2Body.
  ///
  /// In en, this message translates to:
  /// **'Users are responsible for keeping login credentials secure and for using the app only within the permissions granted to their role inside the organization.'**
  String get legalTermsSection2Body;

  /// No description provided for @legalTermsSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Acceptable use'**
  String get legalTermsSection3Title;

  /// No description provided for @legalTermsSection3Body.
  ///
  /// In en, this message translates to:
  /// **'The service must not be used for unlawful data processing, abusive messaging, unauthorized access attempts or any activity that violates applicable law.'**
  String get legalTermsSection3Body;

  /// No description provided for @legalTermsSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Availability'**
  String get legalTermsSection4Title;

  /// No description provided for @legalTermsSection4Body.
  ///
  /// In en, this message translates to:
  /// **'The service may change over time. Features can be added, modified or removed as the product evolves.'**
  String get legalTermsSection4Body;

  /// No description provided for @legalTermsSection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Paid plans'**
  String get legalTermsSection5Title;

  /// No description provided for @legalTermsSection5Body.
  ///
  /// In en, this message translates to:
  /// **'Before launch, this section should be updated with final billing terms, renewal rules, trial details, cancellation terms and refund handling for Google Play subscriptions.'**
  String get legalTermsSection5Body;

  /// No description provided for @legalTermsSection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Limitation of liability'**
  String get legalTermsSection6Title;

  /// No description provided for @legalTermsSection6Body.
  ///
  /// In en, this message translates to:
  /// **'Before public release, replace this draft with a final legal version reviewed for your jurisdiction and business structure.'**
  String get legalTermsSection6Body;

  /// No description provided for @legalTermsSection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Governing information'**
  String get legalTermsSection7Title;

  /// No description provided for @legalTermsSection7Body.
  ///
  /// In en, this message translates to:
  /// **'Replace this section with your registered business details and governing law information before publishing to the store.'**
  String get legalTermsSection7Body;

  /// No description provided for @invoiceCompanyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Company data'**
  String get invoiceCompanyDataTitle;

  /// No description provided for @invoiceCompanyDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For VAT invoices'**
  String get invoiceCompanyDataSubtitle;

  /// No description provided for @invoiceCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get invoiceCompanyName;

  /// No description provided for @invoiceCompanyAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get invoiceCompanyAddress;

  /// No description provided for @invoiceCompanyPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get invoiceCompanyPostalCode;

  /// No description provided for @invoiceCompanyCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get invoiceCompanyCity;

  /// No description provided for @invoiceGenerateButton.
  ///
  /// In en, this message translates to:
  /// **'Generate invoice'**
  String get invoiceGenerateButton;

  /// No description provided for @invoiceVatRate.
  ///
  /// In en, this message translates to:
  /// **'VAT rate'**
  String get invoiceVatRate;

  /// No description provided for @settingsBookingLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Online booking link'**
  String get settingsBookingLinkTitle;

  /// No description provided for @settingsBookingRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Online booking requests'**
  String get settingsBookingRequestsTitle;

  /// No description provided for @settingsBookingLinkDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Your booking link'**
  String get settingsBookingLinkDialogTitle;

  /// No description provided for @settingsBookingLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get settingsBookingLinkCopied;

  /// No description provided for @settingsBookingLinkAuthRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in to generate a booking link.'**
  String get settingsBookingLinkAuthRequired;

  /// No description provided for @settingsBookingLinkOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get settingsBookingLinkOpen;

  /// No description provided for @settingsWorkingHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get settingsWorkingHoursTitle;

  /// No description provided for @settingsWorkingHoursSlotLabel.
  ///
  /// In en, this message translates to:
  /// **'Slot'**
  String get settingsWorkingHoursSlotLabel;

  /// No description provided for @settingsWorkingHoursMinNoticeLabel.
  ///
  /// In en, this message translates to:
  /// **'Min notice'**
  String get settingsWorkingHoursMinNoticeLabel;

  /// No description provided for @settingsWorkingHoursBreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get settingsWorkingHoursBreakLabel;

  /// No description provided for @settingsWorkingHoursNotice1Hour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get settingsWorkingHoursNotice1Hour;

  /// No description provided for @settingsWorkingHoursNotice2Hours.
  ///
  /// In en, this message translates to:
  /// **'2 hours'**
  String get settingsWorkingHoursNotice2Hours;

  /// No description provided for @settingsWorkingHoursNotice24Hours.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get settingsWorkingHoursNotice24Hours;

  /// No description provided for @bookingRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Online booking requests'**
  String get bookingRequestsTitle;

  /// No description provided for @bookingRequestsFirebaseUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Firebase is not configured for online booking.'**
  String get bookingRequestsFirebaseUnavailable;

  /// No description provided for @bookingRequestsSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view booking requests.'**
  String get bookingRequestsSignInRequired;

  /// No description provided for @bookingRequestsError.
  ///
  /// In en, this message translates to:
  /// **'Error loading requests: {error}'**
  String bookingRequestsError(Object error);

  /// No description provided for @bookingRequestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No booking requests yet.'**
  String get bookingRequestsEmpty;

  /// No description provided for @bookingRequestServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get bookingRequestServiceLabel;

  /// No description provided for @bookingRequestScheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred date/time'**
  String get bookingRequestScheduleLabel;

  /// No description provided for @bookingRequestPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get bookingRequestPhoneLabel;

  /// No description provided for @bookingRequestCarLabel.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get bookingRequestCarLabel;

  /// No description provided for @bookingRequestNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get bookingRequestNoteLabel;

  /// No description provided for @bookingRequestAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get bookingRequestAccept;

  /// No description provided for @bookingRequestDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get bookingRequestDecline;

  /// No description provided for @bookingRequestCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get bookingRequestCall;

  /// No description provided for @bookingRequestStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingRequestStatusPending;

  /// No description provided for @bookingRequestStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get bookingRequestStatusAccepted;

  /// No description provided for @bookingRequestStatusDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get bookingRequestStatusDeclined;

  /// No description provided for @bookingRequestsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bookingRequestsFilterAll;

  /// No description provided for @bookingRequestsEmptyNew.
  ///
  /// In en, this message translates to:
  /// **'No new requests'**
  String get bookingRequestsEmptyNew;

  /// No description provided for @bookingRequestsAcceptedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Request accepted — order will be created automatically'**
  String get bookingRequestsAcceptedFeedback;

  /// No description provided for @bookingRequestsDeclinedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get bookingRequestsDeclinedFeedback;

  /// No description provided for @bookingRequestsDeclineConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Decline this booking request?'**
  String get bookingRequestsDeclineConfirmContent;

  /// No description provided for @enterServiceName.
  ///
  /// In en, this message translates to:
  /// **'Service name is required'**
  String get enterServiceName;

  /// No description provided for @invalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price (0 or more)'**
  String get invalidPrice;

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'INVOICE'**
  String get invoiceTitle;

  /// No description provided for @invoiceNumberPrefix.
  ///
  /// In en, this message translates to:
  /// **'INV'**
  String get invoiceNumberPrefix;

  /// No description provided for @invoiceSeller.
  ///
  /// In en, this message translates to:
  /// **'SELLER'**
  String get invoiceSeller;

  /// No description provided for @invoiceBuyer.
  ///
  /// In en, this message translates to:
  /// **'BUYER'**
  String get invoiceBuyer;

  /// No description provided for @invoiceIssueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue date'**
  String get invoiceIssueDateLabel;

  /// No description provided for @invoiceServiceDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Service date'**
  String get invoiceServiceDateLabel;

  /// No description provided for @invoiceDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get invoiceDescriptionLabel;

  /// No description provided for @invoiceQtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get invoiceQtyLabel;

  /// No description provided for @invoiceNetPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Net price'**
  String get invoiceNetPriceLabel;

  /// No description provided for @invoiceVatPctLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT %'**
  String get invoiceVatPctLabel;

  /// No description provided for @invoiceVatAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT amount'**
  String get invoiceVatAmountLabel;

  /// No description provided for @invoiceGrossPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Gross price'**
  String get invoiceGrossPriceLabel;

  /// No description provided for @invoiceNetTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Net total:'**
  String get invoiceNetTotalLabel;

  /// No description provided for @invoiceVatLineLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT {rate}:'**
  String invoiceVatLineLabel(Object rate);

  /// No description provided for @invoiceTotalDueLabel.
  ///
  /// In en, this message translates to:
  /// **'TOTAL DUE:'**
  String get invoiceTotalDueLabel;

  /// No description provided for @invoiceFillCompanyLabel.
  ///
  /// In en, this message translates to:
  /// **'Fill in company data'**
  String get invoiceFillCompanyLabel;

  /// No description provided for @invoiceIssuedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice issued by'**
  String get invoiceIssuedByLabel;

  /// No description provided for @invoicePrimaryIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax ID'**
  String get invoicePrimaryIdLabel;

  /// No description provided for @invoiceSecondaryIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Business ID'**
  String get invoiceSecondaryIdLabel;

  /// No description provided for @settingsSeatUsage.
  ///
  /// In en, this message translates to:
  /// **'{used} / {total} seats'**
  String settingsSeatUsage(Object total, Object used);

  /// No description provided for @syncOfflineWarning.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Data may be outdated.'**
  String get syncOfflineWarning;

  /// No description provided for @forceUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get forceUpdateTitle;

  /// No description provided for @forceUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. Please update to continue using Detailing Pro.'**
  String get forceUpdateMessage;

  /// No description provided for @forceUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get forceUpdateButton;

  /// No description provided for @storageStartupTitle.
  ///
  /// In en, this message translates to:
  /// **'Local storage unavailable'**
  String get storageStartupTitle;

  /// No description provided for @storageStartupBody.
  ///
  /// In en, this message translates to:
  /// **'Detailing Pro could not open its encrypted database. Your data on this device may be protected or corrupted.'**
  String get storageStartupBody;

  /// No description provided for @storageStartupHint.
  ///
  /// In en, this message translates to:
  /// **'Try fully closing the app and opening it again. If the problem continues, reinstall the app (cloud data will remain if you sign in with the same account).'**
  String get storageStartupHint;

  /// No description provided for @storageStartupCloseApp.
  ///
  /// In en, this message translates to:
  /// **'Close app'**
  String get storageStartupCloseApp;

  /// No description provided for @settingsSyncStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get settingsSyncStatusTitle;

  /// No description provided for @settingsSyncPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} changes waiting to sync'**
  String settingsSyncPendingMessage(int count);

  /// No description provided for @settingsSyncFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} changes could not sync to the cloud'**
  String settingsSyncFailedMessage(int count);

  /// No description provided for @settingsSyncRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry sync'**
  String get settingsSyncRetryButton;

  /// No description provided for @settingsSyncDiscardButton.
  ///
  /// In en, this message translates to:
  /// **'Discard failed changes'**
  String get settingsSyncDiscardButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'it',
    'pl',
    'pt',
    'ru',
    'tr',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
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
