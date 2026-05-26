// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return 'Wersja $version';
  }

  @override
  String get navDashboard => 'Panel';

  @override
  String get navOrders => 'Zlecenia';

  @override
  String get navClients => 'Klienci';

  @override
  String get navCalendar => 'Kalendarz';

  @override
  String get navInventory => 'Magazyn';

  @override
  String get navStats => 'Statystyki';

  @override
  String get navPhotos => 'Zdjęcia';

  @override
  String get navMarketing => 'Marketing';

  @override
  String get navSettings => 'Ustawienia';

  @override
  String get inventoryEmptyTitle => 'Magazyn jest pusty';

  @override
  String get inventoryEmptySubtitle => 'Dodaj chemię przyciskiem poniżej';

  @override
  String get showAllCategories => 'Pokaż wszystkie kategorie';

  @override
  String get chemicalsButton => 'CHEMIA';

  @override
  String get cancel => 'Anuluj';

  @override
  String get add => 'Dodaj';

  @override
  String get save => 'Zapisz';

  @override
  String get noOrdersTitle => 'Brak zleceń';

  @override
  String get noOrdersSubtitle => 'Dodaj pierwsze zlecenie, aby rozpocząć';

  @override
  String get addOrder => 'Dodaj usługi';

  @override
  String get orderButton => 'ZLECENIE';

  @override
  String get deleteOrderTitle => 'Usunąć zlecenie?';

  @override
  String deleteOrderMessage(Object car) {
    return 'Zlecenie \"$car\" zostanie trwale usunięte.';
  }

  @override
  String deletedOrderSnack(Object car) {
    return 'Zlecenie \"$car\" zostało usunięte';
  }

  @override
  String get undo => 'Cofnij';

  @override
  String get delete => 'Usuń';

  @override
  String get carLabel => 'Samochód';

  @override
  String clientLabel(Object client) {
    return 'Klient: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return 'Usługa: $service ($duration min)';
  }

  @override
  String get statusScheduled => 'Zaplanowane';

  @override
  String get statusInProgress => 'W trakcie';

  @override
  String get statusReady => 'Gotowe';

  @override
  String get statusPaid => 'Opłacone';

  @override
  String get statusCompleted => 'Zakończone';

  @override
  String get edit => 'Edytuj';

  @override
  String get start => 'Rozpocznij';

  @override
  String get markDone => 'Gotowe';

  @override
  String get markPaid => 'Opłacone';

  @override
  String get statusChangedTitle => 'Status zaktualizowany';

  @override
  String statusChangedMessage(Object car, Object status) {
    return 'Zlecenie \"$car\" ma status: $status';
  }

  @override
  String get newChemicalTitle => 'Nowy środek';

  @override
  String get nameLabel => 'Nazwa *';

  @override
  String get brandLabel => 'Marka';

  @override
  String get categoryLabel => 'Kategoria';

  @override
  String get volumeLabel => 'Pojemność (ml)';

  @override
  String get deleteItemTitle => 'Usunąć?';

  @override
  String deleteItemMessage(Object item) {
    return 'Usunąć \"$item\" z magazynu?';
  }

  @override
  String get unnamedItem => 'Bez nazwy';

  @override
  String get replenish => 'Uzupełnij';

  @override
  String get languageLabel => 'Język';

  @override
  String get languageEnglish => 'Angielski';

  @override
  String get languageRussian => 'Rosyjski';

  @override
  String get goodMorning => 'Dzień dobry!';

  @override
  String get goodAfternoon => 'Dzień dobry!';

  @override
  String get goodEvening => 'Dobry wieczór!';

  @override
  String get statsTodayOrders => 'Dzisiejsze zlecenia';

  @override
  String get statsInWork => 'W pracy';

  @override
  String get statsTodayRevenue => 'Dzisiejszy przychód';

  @override
  String get statsTotalClients => 'Liczba klientów';

  @override
  String get noCars => 'Brak aut';

  @override
  String get quickActions => 'Szybkie akcje';

  @override
  String get newOrder => 'Nowe zlecenie';

  @override
  String get newClient => 'Nowy klient';

  @override
  String get todayOrdersTitle => 'Dzisiejsze wizyty';

  @override
  String get calendarTitle => 'Kalendarz';

  @override
  String get monthJanuary => 'Styczeń';

  @override
  String get monthFebruary => 'Luty';

  @override
  String get monthMarch => 'Marzec';

  @override
  String get monthApril => 'Kwiecień';

  @override
  String get monthMay => 'Maj';

  @override
  String get monthJune => 'Czerwiec';

  @override
  String get monthJuly => 'Lipiec';

  @override
  String get monthAugust => 'Sierpień';

  @override
  String get monthSeptember => 'Wrzesień';

  @override
  String get monthOctober => 'Październik';

  @override
  String get monthNovember => 'Listopad';

  @override
  String get monthDecember => 'Grudzień';

  @override
  String get statsTitle => 'Statystyki';

  @override
  String get statsRevenue => 'Przychód';

  @override
  String get statsOrders => 'Zlecenia';

  @override
  String get statsPeriodWeek => 'Tydzień';

  @override
  String get statsPeriodMonth => 'Miesiąc';

  @override
  String get statsPeriodYear => 'Rok';

  @override
  String get photosTitle => 'Zdjęcia';

  @override
  String get orderBeforePhotosTitle => 'Przed';

  @override
  String get orderAfterPhotosTitle => 'Po';

  @override
  String get photosAdd => 'Dodaj zdjęcie';

  @override
  String get photosEmpty => 'Brak zdjęć';

  @override
  String get photosSelectCar => 'Wybierz auto';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get visits => 'Wizyty';

  @override
  String get totalSpent => 'Suma wydatków';

  @override
  String get orderHistoryTitle => 'Historia zleceń';

  @override
  String get orderHistoryEmpty => 'Historia zleceń jest pusta';

  @override
  String get call => 'Zadzwoń';

  @override
  String get message => 'Napisz';

  @override
  String get photoReport => 'Raport foto';

  @override
  String get photosNotAdded => 'Nie dodano zdjęć';

  @override
  String get editOrderTitle => 'Edytuj zlecenie';

  @override
  String get newOrderTitle => 'Nowe zlecenie';

  @override
  String get clientFieldLabel => 'Klient *';

  @override
  String get selectClient => 'Wybierz klienta';

  @override
  String get carHint => 'Model i numer rej.';

  @override
  String get enterCar => 'Wprowadź dane auta';

  @override
  String get serviceFieldLabel => 'Usługa *';

  @override
  String get selectService => 'Wybierz usługę';

  @override
  String get orderMaterialCostLabel => 'Koszt materiałów';

  @override
  String get orderLaborCostLabel => 'Koszt pracy';

  @override
  String get orderTotalCostLabel => 'Łączny koszt';

  @override
  String get orderProfitLabel => 'Zysk';

  @override
  String get statsProfit => 'Zysk';

  @override
  String get orderNotesLabel => 'Uwagi do zlecenia';

  @override
  String get createOrderButton => 'Utwórz zlecenie';

  @override
  String get orderUpdated => 'Zlecenie zaktualizowane';

  @override
  String get orderCreated => 'Zlecenie utworzone pomyślnie';

  @override
  String errorMessage(Object error) {
    return 'Błąd: $error';
  }

  @override
  String get editClient => 'Edytuj klienta';

  @override
  String get clientNameLabel => 'Imię klienta *';

  @override
  String get enterName => 'Wpisz imię';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get phoneHint => '+48 ___ ___ ___';

  @override
  String get enterValidPhone => 'Wprowadź poprawny numer';

  @override
  String get carsLabel => 'Samochody *';

  @override
  String get addCar => 'Dodaj';

  @override
  String get addAtLeastOneCar => 'Dodaj przynajmniej jedno auto';

  @override
  String get addCarDialogTitle => 'Dodaj auto';

  @override
  String get carExample => 'Np: BMW X5 WA12345';

  @override
  String get carAlreadyAdded => 'To auto jest już dodane';

  @override
  String get saveChanges => 'Zapisz zmiany';

  @override
  String get saveClient => 'Zapisz klienta';

  @override
  String get clientUpdated => 'Klient zaktualizowany';

  @override
  String get clientAdded => 'Klient dodany pomyślnie';

  @override
  String get otherCategory => 'Inne';

  @override
  String replenishItemTitle(Object item) {
    return 'Uzupełnij \"$item\"';
  }

  @override
  String get howManyToAdd => 'Ile dodać?';

  @override
  String get ml => 'ml';

  @override
  String currentStockTitle(Object item) {
    return 'Stan: \"$item\"';
  }

  @override
  String get currentStockLabel => 'Aktualna ilość na półce';

  @override
  String get inactiveClients => 'Nieaktywni klienci';

  @override
  String get promotions => 'Promocje i rabaty';

  @override
  String get promotionsDescription =>
      'Twórz promocje, aby przyciągnąć klientów';

  @override
  String get loyaltyProgram => 'Program lojalnościowy';

  @override
  String get loyaltyDescription => 'Nagradzaj stałych klientów bonusami';

  @override
  String get smsBroadcast => 'Wysyłka SMS';

  @override
  String get smsDescription => 'Wysyłaj przypomnienia i nowości';

  @override
  String get reviews => 'Opinie';

  @override
  String get reviewsDescription => 'Zbieraj opinie i poprawiaj serwis';

  @override
  String get comingSoon => 'Funkcja w przygotowaniu';

  @override
  String get gotIt => 'Rozumiem';

  @override
  String get ordersChannelName => 'Zlecenia';

  @override
  String get ordersChannelDescription => 'Powiadomienia o zleceniach';

  @override
  String get currencyLabel => 'Waluta';

  @override
  String get searchClientsHint => 'Szukaj po kliencie lub aucie...';

  @override
  String get crmFilterAll => 'Wszystkie';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => 'Zagrożeni';

  @override
  String get crmFilterInactive => 'Nieaktywni';

  @override
  String get crmTagsLabel => 'Tagi';

  @override
  String get crmTagsHint => 'VIP, flota, z polecenia';

  @override
  String get crmSegmentLabel => 'Segment';

  @override
  String get crmLastVisitLabel => 'Ostatnia wizyta';

  @override
  String get crmAtRiskLabel => 'Wymaga kontaktu';

  @override
  String get crmReminderButton => 'Wyślij przypomnienie';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return 'Cześć, $client! To przypomnienie ze studia detailingu. Możemy umówić Cię na $service w dogodnym terminie.';
  }

  @override
  String get crmBulkReminderButton => 'Kampania CRM';

  @override
  String get crmBulkReminderTitle => 'Wybierz odbiorców';

  @override
  String get crmBulkReminderToggleAll => 'Wszyscy';

  @override
  String get crmBulkReminderSendSelected => 'Wyślij do wybranych';

  @override
  String get crmBulkReminderEmpty =>
      'Brak klientów z numerem telefonu na tej liście.';

  @override
  String get crmBulkReminderTemplate =>
      'Cześć! Przypomnienie ze studia detailingu. Możesz zarezerwować dogodny termin na kolejną usługę.';

  @override
  String get crmSegmentNew => 'Nowy';

  @override
  String get crmSegmentReturning => 'Powracający';

  @override
  String get crmSegmentLoyal => 'Stały';

  @override
  String get clientsNotFound => 'Nie znaleziono klientów';

  @override
  String get openCallFailed => 'Nie udało się otworzyć połączenia.';

  @override
  String get openWhatsAppFailed => 'Nie udało się otworzyć aplikacji SMS.';

  @override
  String get sortTooltip => 'Sortowanie';

  @override
  String get sortByNameAsc => 'Nazwa: A-Z';

  @override
  String get sortByNameDesc => 'Nazwa: Z-A';

  @override
  String get sortByNewest => 'Najnowsze najpierw';

  @override
  String get permissionDeniedTitle => 'Brak uprawnień';

  @override
  String get permissionCreateOrderDenied =>
      'Brak uprawnień do tworzenia zlecenia.';

  @override
  String get permissionDeleteOrderDenied =>
      'Usuwanie zleceń tylko dla dyrektora lub właściciela.';

  @override
  String get permissionEditOrderDenied => 'Brak uprawnień do edycji zlecenia.';

  @override
  String get permissionSaveOrderDenied => 'Brak uprawnień do zapisu zlecenia.';

  @override
  String get permissionCreateClientDenied =>
      'Brak uprawnień do tworzenia klienta.';

  @override
  String get permissionDeleteClientDenied =>
      'Brak uprawnień do usuwania klienta.';

  @override
  String get permissionEditClientDenied => 'Brak uprawnień do edycji klienta.';

  @override
  String get permissionSaveClientDenied => 'Brak uprawnień do zapisu klienta.';

  @override
  String get permissionModifyInventoryDenied =>
      'Brak uprawnień do modyfikacji magazynu.';

  @override
  String get permissionEditInventoryStockDenied =>
      'Brak uprawnień do zmiany stanów magazynowych.';

  @override
  String get permissionEditInventoryDenied =>
      'Brak uprawnień do edycji magazynu.';

  @override
  String get clientDeleted => 'Klient został usunięty';

  @override
  String get clientGarageTitle => 'Garaż klienta';

  @override
  String get navTeamChats => 'Czaty zespołu';

  @override
  String get navCommunityChat => 'Czat społeczności';

  @override
  String get orderDefaultTitle => 'Zlecenie';

  @override
  String get completeOrderAndConsumePrompt =>
      'Zakończyć pracę i odjąć chemię ze stanu?';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: Zakończono';
  }

  @override
  String get appointmentReminderTitle => 'Nadchodząca wizyta';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car o $time';
  }

  @override
  String get inventoryFirstItemHint =>
      'Dodaj pierwszą pozycję magazynową: chemia, materiały, akcesoria lub sprzęt.';

  @override
  String get inventoryFilteredEmpty => 'Brak pozycji dla wybranych filtrów.';

  @override
  String get inventoryItemLabel => 'POZYCJA';

  @override
  String inventoryLowStockMore(Object count) {
    return ' i jeszcze $count';
  }

  @override
  String get inventoryLowStockTitle => 'Niski stan magazynowy';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items wymagają uwagi.';
  }

  @override
  String get inventoryNotificationsChannelName => 'Powiadomienia magazynowe';

  @override
  String get inventoryNotificationsChannelDescription =>
      'Alerty o niskim stanie magazynu';

  @override
  String get inventoryEditItemTitle => 'Edytuj pozycję';

  @override
  String get inventoryNewItemTitle => 'Nowa pozycja magazynowa';

  @override
  String get inventoryItemTypeLabel => 'Typ pozycji';

  @override
  String get inventoryUnitLabel => 'Jednostka';

  @override
  String get inventoryCurrentStockLabel => 'Aktualny stan';

  @override
  String get inventoryMinStockLabel => 'Stan minimalny';

  @override
  String get inventoryLocationLabel => 'Miejsce przechowywania';

  @override
  String get inventoryUsageLabel => 'Przeznaczenie';

  @override
  String inventoryLowStockCount(Object count) {
    return 'Niski stan: $count';
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
  String get inventoryAllTypes => 'Wszystkie typy';

  @override
  String get inventoryBelowMin => 'Poniżej minimum';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return 'Min: $minStock $unit';
  }

  @override
  String get chatProfileSaved => 'Profil czatu zapisany';

  @override
  String get chatUnavailableShort =>
      'Firebase nie jest skonfigurowany. Czat jest chwilowo niedostępny.';

  @override
  String get chatCreateDialogTitle => 'Nowy dialog';

  @override
  String get chatCreateExternalTitle => 'Nowy czat zewnętrzny';

  @override
  String get chatPeerIdLabelTeam => 'ID pracownika';

  @override
  String get chatPeerIdLabelExternal => 'ID studia/pracownika';

  @override
  String get chatPeerNameLabelTeam => 'Imię pracownika';

  @override
  String get chatPeerNameLabelExternal => 'Nazwa studia lub imię pracownika';

  @override
  String get chatCreateAction => 'Utwórz';

  @override
  String get chatDialogTitle => 'Dialog';

  @override
  String get chatScreenTitleTeam => 'Wewnętrzny czat zespołu';

  @override
  String get chatScreenTitleExternal => 'Zewnętrzny czat społeczności';

  @override
  String get chatNewChatButton => 'Nowy czat';

  @override
  String get chatMyIdLabel => 'Twoje ID';

  @override
  String get chatMyIdHint => 'Na przykład: master_001';

  @override
  String get chatMyNameLabel => 'Twoje imię';

  @override
  String get chatMyNameHint => 'Na przykład: Alex';

  @override
  String get chatUnavailableTitle => 'Czat chwilowo niedostępny';

  @override
  String get chatUnavailableSubtitle =>
      'Firebase nie jest skonfigurowany dla tej kompilacji. Dodaj konfigurację Firebase.';

  @override
  String get chatProfileFillTitleTeam => 'Uzupełnij profil czatu';

  @override
  String get chatProfileFillTitleExternal => 'Uzupełnij profil społeczności';

  @override
  String get chatProfileFillSubtitleTeam =>
      'Wpisz swoje ID i imię, a potem kliknij Zapisz.';

  @override
  String get chatProfileFillSubtitleExternal =>
      'Wpisz swoje ID i imię, aby rozmawiać z innymi studiami i pracownikami.';

  @override
  String get chatErrorTitle => 'Czat niedostępny';

  @override
  String get chatErrorSubtitle =>
      'Sprawdź konfigurację Firebase (google-services i Firebase.initializeApp).';

  @override
  String get chatEmptyTitle => 'Brak dialogów';

  @override
  String get chatEmptySubtitle => 'Utwórz pierwszy czat przyciskiem Nowy czat.';

  @override
  String get chatNoMessages => 'Brak wiadomości';

  @override
  String get chatOpenAfterFirebase =>
      'Firebase nie jest skonfigurowany. Otwórz czat po konfiguracji Firebase.';

  @override
  String get chatConnectionError => 'Błąd połączenia z czatem';

  @override
  String get chatMessageHint => 'Wpisz wiadomość';

  @override
  String get chatAttachPhoto => 'Dołącz zdjęcie';

  @override
  String get chatAttachFile => 'Dołącz plik';

  @override
  String get chatAttachmentFile => 'Plik';

  @override
  String get chatFileOpenFailed => 'Nie udało się otworzyć pliku.';

  @override
  String chatUploadFailed(Object error) {
    return 'Błąd wysyłania: $error';
  }

  @override
  String get durationMinutesShort => 'min';

  @override
  String get inventoryTypeChemistry => 'Chemia';

  @override
  String get inventoryTypeConsumable => 'Materiał';

  @override
  String get inventoryTypeAccessory => 'Akcesorium';

  @override
  String get inventoryTypeEquipment => 'Sprzęt';

  @override
  String get emailLabel => 'Email';

  @override
  String get authEnterEmail => 'Wprowadź email';

  @override
  String get authInvalidEmail => 'Nieprawidłowy email';

  @override
  String get authEnterPassword => 'Wprowadź hasło';

  @override
  String get authPasswordMin => 'Minimum 8 znaków';

  @override
  String get authFirebaseGuestOnly =>
      'Firebase nie jest skonfigurowany. Dostępny jest tryb gościa.';

  @override
  String get authSignInFailed => 'Nie udało się zalogować. Spróbuj ponownie.';

  @override
  String get authPasswordsMismatch => 'Hasła nie są takie same';

  @override
  String get authJoinSuccess => 'Pomyślnie dołączono do zespołu!';

  @override
  String authInviteRejected(Object error) {
    return 'Rejestracja zakończona, ale kod zaproszenia odrzucono: $error';
  }

  @override
  String get authRegisterFailed =>
      'Nie udało się zakończyć rejestracji. Spróbuj ponownie.';

  @override
  String get authGuestName => 'Gość';

  @override
  String get authGoogleSoon => 'Logowanie Google zostanie dodane później';

  @override
  String get authInvalidEmailFormat => 'Nieprawidłowy format email';

  @override
  String get authWrongCredentials => 'Nieprawidłowy email lub hasło';

  @override
  String get authEmailInUse => 'Ten email jest już używany';

  @override
  String get authWeakPassword => 'Hasło jest zbyt słabe';

  @override
  String get authTooManyRequests => 'Zbyt wiele prób. Spróbuj ponownie później';

  @override
  String get authAuthorizationError => 'Błąd autoryzacji';

  @override
  String get authWelcome => 'Witamy';

  @override
  String get authSubtitle => 'Zaloguj się lub zarejestruj';

  @override
  String get authTabSignIn => 'Logowanie';

  @override
  String get authTabRegister => 'Rejestracja';

  @override
  String get authContinueWithGoogle => 'Kontynuuj z Google';

  @override
  String get authContinueAsGuest => 'Kontynuuj jako gość';

  @override
  String get authPasswordLabel => 'Hasło';

  @override
  String get authConfirmPasswordLabel => 'Potwierdź hasło';

  @override
  String get authInviteCodeOptional => 'Kod zaproszenia (opcjonalnie)';

  @override
  String get authInviteHint => 'Jeśli zaprosił Cię dyrektor';

  @override
  String get authRegisterButton => 'Zarejestruj się';

  @override
  String get businessModeQuestion => 'Jak pracujesz?';

  @override
  String get businessModeSubtitle =>
      'Wybierz tryb, aby aplikacja pokazała tylko potrzebne moduły.';

  @override
  String get businessModeSoloTitle => 'Pracuję sam';

  @override
  String get businessModeSoloSubtitle =>
      'Dla solo specjalisty: zlecenia, klienci, magazyn, finanse i czat zewnętrzny.';

  @override
  String get businessModeTeamTitle => 'Mamy zespół';

  @override
  String get businessModeTeamSubtitle =>
      'Dla studia: role pracowników, czat wewnętrzny, zadania i kontrola dyrektora.';

  @override
  String get photosGallerySaveFailed =>
      'Zdjęcie dodano do aplikacji, ale nie udało się zapisać w galerii.';

  @override
  String get photosCameraUnsupported =>
      'Aparat jest dostępny tylko na Android/iOS lub w wersji web.';

  @override
  String get photosAddedAndSaved => 'Zdjęcie dodane i zapisane w galerii.';

  @override
  String get photosAddedFromGallery => 'Zdjęcie dodane z galerii.';

  @override
  String get photosAddFromGallery => 'Dodaj z galerii';

  @override
  String get photosTakePhoto => 'Zrób zdjęcie';

  @override
  String get photosDeleteDenied => 'Brak uprawnień do usunięcia zdjęcia.';

  @override
  String get settingsProfileAndOrgTitle => 'Profil i organizacja';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => 'Gość';

  @override
  String get settingsBusinessModeTitle => 'Tryb pracy';

  @override
  String get settingsUserRoleTitle => 'Rola użytkownika';

  @override
  String get settingsInviteMasterTitle => 'Zaproś pracownika';

  @override
  String get settingsInviteMasterSubtitle =>
      'Wygeneruj jednorazowy kod zaproszenia';

  @override
  String get settingsServicesSection => 'Usługi';

  @override
  String get settingsLogoutButton => 'Wyloguj się';

  @override
  String get settingsBusinessModeTeam => 'Zespół (studio)';

  @override
  String get settingsBusinessModeSolo => 'Solo (jeden specjalista)';

  @override
  String get settingsRoleDirector => 'Dyrektor';

  @override
  String get settingsRoleMaster => 'Specjalista';

  @override
  String get settingsRoleMasterOwner => 'Właściciel-specjalista';

  @override
  String get settingsSelectModeTitle => 'Wybierz tryb';

  @override
  String get settingsModeSoloTitle => 'Solo';

  @override
  String get settingsModeSoloSubtitle => 'Jeden specjalista';

  @override
  String get settingsModeTeamTitle => 'Zespół';

  @override
  String get settingsModeTeamSubtitle => 'Studio z pracownikami';

  @override
  String get settingsModeUpdated => 'Tryb zaktualizowany.';

  @override
  String get settingsOrgNotFound =>
      'Nie znaleziono organizacji. Najpierw zapisz ustawienia.';

  @override
  String settingsInviteGenerateError(Object error) {
    return 'Błąd generowania kodu: $error';
  }

  @override
  String get settingsInviteDialogTitle => 'Kod zaproszenia dla pracownika';

  @override
  String get settingsInviteDialogDescription =>
      'Wyślij ten kod pracownikowi. Kod jest jednorazowy i wygasa po użyciu.';

  @override
  String get settingsCopy => 'Kopiuj';

  @override
  String get settingsCodeCopied => 'Kod skopiowano do schowka';

  @override
  String get settingsInviteRegistrationHint =>
      'Pracownik wpisuje kod w polu Kod zaproszenia podczas rejestracji.';

  @override
  String get settingsClose => 'Zamknij';

  @override
  String get settingsSelectRoleTitle => 'Wybierz rolę';

  @override
  String get settingsRoleUpdated => 'Rola zaktualizowana.';

  @override
  String get settingsLogoutTitle => 'Wylogowanie';

  @override
  String get settingsLogoutMessage => 'Wylogować się z bieżącego konta?';

  @override
  String get settingsLogoutConfirm => 'Wyloguj';

  @override
  String get settingsLoggedOut => 'Zostałeś wylogowany.';

  @override
  String get settingsAccessDenied => 'Brak uprawnień do tej akcji.';

  @override
  String get settingsResetWarning =>
      'UWAGA: Wszystkie zamówienia, klienci i magazyn zostaną usunięte!';

  @override
  String get settingsServiceDeleteDenied =>
      'Brak uprawnień do usunięcia usługi.';

  @override
  String get settingsServiceEditDenied => 'Brak uprawnień do edycji usługi.';

  @override
  String get legalTitle => 'Informacje prawne';

  @override
  String get legalPrivacyTab => 'Polityka prywatności';

  @override
  String get legalTermsTab => 'Regulamin';

  @override
  String get legalPrivacySummaryTitle => 'Skrót polityki prywatności';

  @override
  String get legalTermsSummaryTitle => 'Skrót warunków korzystania';

  @override
  String get legalSummarySubtitle =>
      'Skrócona wersja w aplikacji. Pełna wersja prawna jest dostępna na opublikowanej stronie.';

  @override
  String get legalOpenFullPrivacy => 'Otwórz pełną politykę prywatności';

  @override
  String get legalOpenFullTerms => 'Otwórz pełny regulamin';

  @override
  String get legalOpenLinkError => 'Nie udało się otworzyć linku do dokumentu.';

  @override
  String get legalPrivacySection1Title => '1. Co robi aplikacja';

  @override
  String get legalPrivacySection1Body =>
      'DetailingPro Business pomaga zespołom detailingowym zarządzać klientami, zleceniami, harmonogramem, magazynem, czatem i załącznikami.';

  @override
  String get legalPrivacySection2Title => '2. Jakie dane przetwarzamy';

  @override
  String get legalPrivacySection2Body =>
      'Aplikacja może przetwarzać dane konta, klientów i zamówień, usługi, magazyn, wiadomości czatu, załączniki oraz identyfikatory techniczne, np. tokeny powiadomień.';

  @override
  String get legalPrivacySection3Title => '3. Po co dane są używane';

  @override
  String get legalPrivacySection3Body =>
      'Dane są używane do działania funkcji aplikacji, synchronizacji między urządzeniami, przypomnień, współpracy zespołowej oraz poprawy niezawodności i bezpieczeństwa.';

  @override
  String get legalPrivacySection4Title => '4. Uprawnienia i dostęp';

  @override
  String get legalPrivacySection4Body =>
      'Dostęp do kamery i mediów jest wymagany tylko do zdjęć i załączników. Powiadomienia są używane do przypomnień i alertów push.';

  @override
  String get legalPrivacySection5Title => '5. Infrastruktura i dostawcy';

  @override
  String get legalPrivacySection5Body =>
      'Aplikacja korzysta z Firebase (Authentication, Firestore, Storage, Messaging). Dane są przetwarzane na infrastrukturze tych dostawców.';

  @override
  String get legalPrivacySection6Title => '6. Retencja, usuwanie i prawa';

  @override
  String get legalPrivacySection6Body =>
      'Dane są przechowywane tak długo, jak to konieczne do świadczenia usługi. Użytkownicy mogą żądać dostępu, poprawy i usunięcia danych zgodnie z prawem.';

  @override
  String get legalPrivacySection7Title => '7. Kontakt';

  @override
  String get legalPrivacySection7Body =>
      'Pytania o prywatność: support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. Zakres usługi';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro to aplikacja biznesowa do zarządzania zleceniami, klientami, mediami, czatem wewnętrznym i danymi operacyjnymi.';

  @override
  String get legalTermsSection2Title => '2. Konta i dostęp';

  @override
  String get legalTermsSection2Body =>
      'Użytkownicy są odpowiedzialni za ochronę danych logowania i korzystanie z aplikacji zgodnie z uprawnieniami roli.';

  @override
  String get legalTermsSection3Title => '3. Dozwolone użycie';

  @override
  String get legalTermsSection3Body =>
      'Usługa nie może być wykorzystywana do nielegalnego przetwarzania danych, nadużyć, nieautoryzowanego dostępu ani działań naruszających prawo.';

  @override
  String get legalTermsSection4Title => '4. Dostępność';

  @override
  String get legalTermsSection4Body =>
      'Usługa może się zmieniać. Funkcje mogą być dodawane, modyfikowane lub usuwane wraz z rozwojem produktu.';

  @override
  String get legalTermsSection5Title => '5. Plany płatne';

  @override
  String get legalTermsSection5Body =>
      'Przed publiczną publikacją ten rozdział powinien zawierać finalne zasady płatności, odnowień, okresów próbnych, anulowania i zwrotów Google Play.';

  @override
  String get legalTermsSection6Title => '6. Ograniczenie odpowiedzialności';

  @override
  String get legalTermsSection6Body =>
      'Przed wydaniem publicznym zastąp szkic finalną wersją prawną odpowiednią dla Twojej jurysdykcji i struktury firmy.';

  @override
  String get legalTermsSection7Title => '7. Informacje prawne';

  @override
  String get legalTermsSection7Body =>
      'Przed publikacją uzupełnij dane rejestrowe firmy oraz właściwe prawo.';

  @override
  String get invoiceCompanyDataTitle => 'Dane firmy';

  @override
  String get invoiceCompanyDataSubtitle => 'Dla faktur VAT';

  @override
  String get invoiceCompanyName => 'Nazwa firmy';

  @override
  String get invoiceCompanyAddress => 'Adres';

  @override
  String get invoiceCompanyPostalCode => 'Kod pocztowy';

  @override
  String get invoiceCompanyCity => 'Miasto';

  @override
  String get invoiceGenerateButton => 'Wystaw fakturę';

  @override
  String get invoiceVatRate => 'Stawka VAT';

  @override
  String get settingsBookingLinkTitle => 'Link do rezerwacji online';

  @override
  String get settingsBookingRequestsTitle => 'Zgłoszenia online';

  @override
  String get settingsBookingLinkDialogTitle => 'Twój link do rezerwacji';

  @override
  String get settingsBookingLinkCopied => 'Skopiowano link';

  @override
  String get settingsBookingLinkAuthRequired =>
      'Zaloguj się, aby wygenerować link do rezerwacji.';

  @override
  String get settingsBookingLinkOpen => 'Otwórz';

  @override
  String get settingsWorkingHoursTitle => 'Godziny pracy';

  @override
  String get settingsWorkingHoursSlotLabel => 'Slot';

  @override
  String get settingsWorkingHoursMinNoticeLabel => 'Min. wyprzedzenie';

  @override
  String get settingsWorkingHoursBreakLabel => 'Przerwa';

  @override
  String get settingsWorkingHoursNotice1Hour => '1 godzina';

  @override
  String get settingsWorkingHoursNotice2Hours => '2 godziny';

  @override
  String get settingsWorkingHoursNotice24Hours => '24 godziny';

  @override
  String get bookingRequestsTitle => 'Zgłoszenia online';

  @override
  String get bookingRequestsFirebaseUnavailable =>
      'Firebase nie jest skonfigurowany dla rezerwacji online.';

  @override
  String get bookingRequestsSignInRequired =>
      'Zaloguj się, aby zobaczyć zgłoszenia.';

  @override
  String bookingRequestsError(Object error) {
    return 'Błąd ładowania zgłoszeń: $error';
  }

  @override
  String get bookingRequestsEmpty => 'Brak zgłoszeń online.';

  @override
  String get bookingRequestServiceLabel => 'Usługa';

  @override
  String get bookingRequestScheduleLabel => 'Preferowany termin';

  @override
  String get bookingRequestPhoneLabel => 'Telefon';

  @override
  String get bookingRequestCarLabel => 'Samochód';

  @override
  String get bookingRequestNoteLabel => 'Uwagi';

  @override
  String get bookingRequestAccept => 'Akceptuj';

  @override
  String get bookingRequestDecline => 'Odrzuć';

  @override
  String get bookingRequestCall => 'Zadzwoń';

  @override
  String get bookingRequestStatusPending => 'Oczekuje';

  @override
  String get bookingRequestStatusAccepted => 'Zaakceptowano';

  @override
  String get bookingRequestStatusDeclined => 'Odrzucono';

  @override
  String get bookingRequestsFilterAll => 'Wszystkie';

  @override
  String get bookingRequestsEmptyNew => 'Brak nowych wniosków';

  @override
  String get bookingRequestsAcceptedFeedback =>
      'Wniosek zaakceptowany — zamówienie zostanie utworzone automatycznie';

  @override
  String get bookingRequestsDeclinedFeedback => 'Wniosek odrzucony';

  @override
  String get bookingRequestsDeclineConfirmContent =>
      'Odrzucić tę prośbę o rezerwację?';

  @override
  String get enterServiceName => 'Podaj nazwę usługi';

  @override
  String get invalidPrice => 'Podaj prawidłową cenę (0 lub więcej)';

  @override
  String get invoiceTitle => 'FAKTURA VAT';

  @override
  String get invoiceNumberPrefix => 'FV';

  @override
  String get invoiceSeller => 'SPRZEDAWCA';

  @override
  String get invoiceBuyer => 'NABYWCA';

  @override
  String get invoiceIssueDateLabel => 'Data wystawienia';

  @override
  String get invoiceServiceDateLabel => 'Data sprzedazy';

  @override
  String get invoiceDescriptionLabel => 'Nazwa uslugi / towaru';

  @override
  String get invoiceQtyLabel => 'Ilosc';

  @override
  String get invoiceNetPriceLabel => 'Cena netto';

  @override
  String get invoiceVatPctLabel => 'VAT %';

  @override
  String get invoiceVatAmountLabel => 'Kwota VAT';

  @override
  String get invoiceGrossPriceLabel => 'Cena brutto';

  @override
  String get invoiceNetTotalLabel => 'Razem netto:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return 'VAT $rate:';
  }

  @override
  String get invoiceTotalDueLabel => 'DO ZAPLATY:';

  @override
  String get invoiceFillCompanyLabel => 'Uzupelnij dane firmy';

  @override
  String get invoiceIssuedByLabel => 'Faktura wystawiona przez';

  @override
  String get invoicePrimaryIdLabel => 'NIP';

  @override
  String get invoiceSecondaryIdLabel => 'REGON';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total miejsc';
  }

  @override
  String get syncOfflineWarning =>
      'Brak połączenia z internetem. Dane mogą być nieaktualne.';

  @override
  String get forceUpdateTitle => 'Wymagana aktualizacja';

  @override
  String get forceUpdateMessage =>
      'Dostępna jest nowa wersja aplikacji. Zaktualizuj Detailing Pro, aby kontynuować.';

  @override
  String get forceUpdateButton => 'Aktualizuj';

  @override
  String get storageStartupTitle => 'Pamięć lokalna niedostępna';

  @override
  String get storageStartupBody =>
      'Detailing Pro nie mógł otworzyć zaszyfrowanej bazy danych. Dane na tym urządzeniu mogą być chronione lub uszkodzone.';

  @override
  String get storageStartupHint =>
      'Całkowicie zamknij aplikację i otwórz ponownie. Jeśli problem się powtarza, przeinstaluj aplikację (dane w chmurze pozostaną po zalogowaniu na to samo konto).';

  @override
  String get storageStartupCloseApp => 'Zamknij aplikację';

  @override
  String get settingsSyncStatusTitle => 'Synchronizacja w chmurze';

  @override
  String settingsSyncPendingMessage(int count) {
    return '$count zmian oczekuje na synchronizację';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return '$count zmian nie udało się zsynchronizować';
  }

  @override
  String get settingsSyncRetryButton => 'Ponów synchronizację';

  @override
  String get settingsSyncDiscardButton => 'Odrzuć nieudane zmiany';
}
