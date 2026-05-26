// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return 'Version $version';
  }

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navOrders => 'Aufträge';

  @override
  String get navClients => 'Kunden';

  @override
  String get navCalendar => 'Kalender';

  @override
  String get navInventory => 'Lager';

  @override
  String get navStats => 'Statistiken';

  @override
  String get navPhotos => 'Fotos';

  @override
  String get navMarketing => 'Marketing';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get inventoryEmptyTitle => 'Lager ist leer';

  @override
  String get inventoryEmptySubtitle => 'Chemie mit der Taste unten hinzufügen';

  @override
  String get showAllCategories => 'Alle Kategorien anzeigen';

  @override
  String get chemicalsButton => 'CHEMIE';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get save => 'Speichern';

  @override
  String get noOrdersTitle => 'Keine Aufträge';

  @override
  String get noOrdersSubtitle => 'Ersten Auftrag hinzufügen, um zu starten';

  @override
  String get addOrder => 'Leistung hinzufügen';

  @override
  String get orderButton => 'AUFTRAG';

  @override
  String get deleteOrderTitle => 'Auftrag löschen?';

  @override
  String deleteOrderMessage(Object car) {
    return 'Auftrag \"$car\" wird unwiderruflich gelöscht.';
  }

  @override
  String deletedOrderSnack(Object car) {
    return 'Auftrag \"$car\" gelöscht';
  }

  @override
  String get undo => 'Rückgängig';

  @override
  String get delete => 'Löschen';

  @override
  String get carLabel => 'Auto';

  @override
  String clientLabel(Object client) {
    return 'Kunde: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return 'Leistung: $service ($duration Min)';
  }

  @override
  String get statusScheduled => 'Geplant';

  @override
  String get statusInProgress => 'In Arbeit';

  @override
  String get statusReady => 'Bereit';

  @override
  String get statusPaid => 'Bezahlt';

  @override
  String get statusCompleted => 'Abgeschlossen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get start => 'Starten';

  @override
  String get markDone => 'Fertig';

  @override
  String get markPaid => 'Bezahlt';

  @override
  String get statusChangedTitle => 'Status geändert';

  @override
  String statusChangedMessage(Object car, Object status) {
    return 'Auftrag \"$car\" ist jetzt $status';
  }

  @override
  String get newChemicalTitle => 'Neues Mittel';

  @override
  String get nameLabel => 'Name *';

  @override
  String get brandLabel => 'Marke';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get volumeLabel => 'Volumen (ml)';

  @override
  String get deleteItemTitle => 'Löschen?';

  @override
  String deleteItemMessage(Object item) {
    return '\"$item\" aus dem Lager löschen?';
  }

  @override
  String get unnamedItem => 'Unbenannt';

  @override
  String get replenish => 'Auffüllen';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get goodMorning => 'Guten Morgen!';

  @override
  String get goodAfternoon => 'Guten Tag!';

  @override
  String get goodEvening => 'Guten Abend!';

  @override
  String get statsTodayOrders => 'Heutige Termine';

  @override
  String get statsInWork => 'In Arbeit';

  @override
  String get statsTodayRevenue => 'Heutiger Umsatz';

  @override
  String get statsTotalClients => 'Kunden';

  @override
  String get noCars => 'Keine Autos';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get newOrder => 'Neuer Termin';

  @override
  String get newClient => 'Neuer Kunde';

  @override
  String get todayOrdersTitle => 'Termine heute';

  @override
  String get calendarTitle => 'Kalender';

  @override
  String get monthJanuary => 'Januar';

  @override
  String get monthFebruary => 'Februar';

  @override
  String get monthMarch => 'März';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJune => 'Juni';

  @override
  String get monthJuly => 'Juli';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'Oktober';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'Dezember';

  @override
  String get statsTitle => 'Statistiken';

  @override
  String get statsRevenue => 'Umsatz';

  @override
  String get statsOrders => 'Aufträge';

  @override
  String get statsPeriodWeek => 'Woche';

  @override
  String get statsPeriodMonth => 'Monat';

  @override
  String get statsPeriodYear => 'Jahr';

  @override
  String get photosTitle => 'Fotos';

  @override
  String get orderBeforePhotosTitle => 'Vorher';

  @override
  String get orderAfterPhotosTitle => 'Nachher';

  @override
  String get photosAdd => 'Foto hinzufügen';

  @override
  String get photosEmpty => 'Keine Fotos vorhanden';

  @override
  String get photosSelectCar => 'Auto wählen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get visits => 'Besuche';

  @override
  String get totalSpent => 'Gesamtumsatz';

  @override
  String get orderHistoryTitle => 'Auftragshistorie';

  @override
  String get orderHistoryEmpty => 'Historie ist leer';

  @override
  String get call => 'Anrufen';

  @override
  String get message => 'Nachricht';

  @override
  String get photoReport => 'Fotubericht';

  @override
  String get photosNotAdded => 'Keine Fotos hinzugefügt';

  @override
  String get editOrderTitle => 'Auftrag bearbeiten';

  @override
  String get newOrderTitle => 'Neuer Auftrag';

  @override
  String get clientFieldLabel => 'Kunde *';

  @override
  String get selectClient => 'Kunde wählen';

  @override
  String get carHint => 'Modell und Kennzeichen';

  @override
  String get enterCar => 'Auto angeben';

  @override
  String get serviceFieldLabel => 'Leistung *';

  @override
  String get selectService => 'Leistung wählen';

  @override
  String get orderMaterialCostLabel => 'Materialkosten';

  @override
  String get orderLaborCostLabel => 'Arbeitskosten';

  @override
  String get orderTotalCostLabel => 'Gesamtkosten';

  @override
  String get orderProfitLabel => 'Gewinn';

  @override
  String get statsProfit => 'Gewinn';

  @override
  String get orderNotesLabel => 'Anmerkungen';

  @override
  String get createOrderButton => 'Auftrag erstellen';

  @override
  String get orderUpdated => 'Auftrag aktualisiert';

  @override
  String get orderCreated => 'Auftrag erstellt';

  @override
  String errorMessage(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get editClient => 'Kunde bearbeiten';

  @override
  String get clientNameLabel => 'Kundenname *';

  @override
  String get enterName => 'Name eingeben';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get phoneHint => '+49 (___) _______';

  @override
  String get enterValidPhone => 'Gültige Nummer eingeben';

  @override
  String get carsLabel => 'Fahrzeuge *';

  @override
  String get addCar => 'Hinzufügen';

  @override
  String get addAtLeastOneCar => 'Mindestens ein Auto hinzufügen';

  @override
  String get addCarDialogTitle => 'Auto hinzufügen';

  @override
  String get carExample => 'Z.B.: BMW X5 B-MW 777';

  @override
  String get carAlreadyAdded => 'Bereits hinzugefügt';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get saveClient => 'Kunde speichern';

  @override
  String get clientUpdated => 'Kunde aktualisiert';

  @override
  String get clientAdded => 'Kunde hinzugefügt';

  @override
  String get otherCategory => 'Sonstiges';

  @override
  String replenishItemTitle(Object item) {
    return '\"$item\" auffüllen';
  }

  @override
  String get howManyToAdd => 'Wie viel hinzufügen?';

  @override
  String get ml => 'ml';

  @override
  String currentStockTitle(Object item) {
    return 'Bestand: \"$item\"';
  }

  @override
  String get currentStockLabel => 'Aktuelle Menge im Regal';

  @override
  String get inactiveClients => 'Inaktive Kunden';

  @override
  String get promotions => 'Aktionen & Rabatte';

  @override
  String get promotionsDescription => 'Aktionen zur Kundengewinnung';

  @override
  String get loyaltyProgram => 'Treueprogramm';

  @override
  String get loyaltyDescription => 'Stammkunden mit Boni belohnen';

  @override
  String get smsBroadcast => 'SMS-Versand';

  @override
  String get smsDescription => 'Erinnerungen und News senden';

  @override
  String get reviews => 'Bewertungen';

  @override
  String get reviewsDescription => 'Bewertungen sammeln';

  @override
  String get comingSoon => 'In Entwicklung';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get ordersChannelName => 'Aufträge';

  @override
  String get ordersChannelDescription => 'Auftragsbenachrichtigungen';

  @override
  String get currencyLabel => 'Währung';

  @override
  String get searchClientsHint => 'Suche nach Namen oder Auto...';

  @override
  String get crmFilterAll => 'Alle';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => 'Gefährdet';

  @override
  String get crmFilterInactive => 'Inaktiv';

  @override
  String get crmTagsLabel => 'Tags';

  @override
  String get crmTagsHint => 'VIP, Flotte, Empfehlung';

  @override
  String get crmSegmentLabel => 'Segment';

  @override
  String get crmLastVisitLabel => 'Letzter Besuch';

  @override
  String get crmAtRiskLabel => 'Kontakt erforderlich';

  @override
  String get crmReminderButton => 'Erinnerung senden';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return 'Hallo, $client! Eine freundliche Erinnerung vom Detailing-Studio. Wir können Sie für $service zu einem passenden Zeitpunkt einplanen.';
  }

  @override
  String get crmBulkReminderButton => 'CRM-Kampagne';

  @override
  String get crmBulkReminderTitle => 'Empfänger auswählen';

  @override
  String get crmBulkReminderToggleAll => 'Alle';

  @override
  String get crmBulkReminderSendSelected => 'An Ausgewählte senden';

  @override
  String get crmBulkReminderEmpty =>
      'In dieser Liste gibt es keine Kunden mit Telefonnummer.';

  @override
  String get crmBulkReminderTemplate =>
      'Hallo! Eine Erinnerung vom Detailing-Studio. Sie können einen passenden Termin für Ihren nächsten Service buchen.';

  @override
  String get crmSegmentNew => 'Neu';

  @override
  String get crmSegmentReturning => 'Wiederkehrend';

  @override
  String get crmSegmentLoyal => 'Treu';

  @override
  String get clientsNotFound => 'Keine Kunden gefunden';

  @override
  String get openCallFailed => 'Anruf konnte nicht geöffnet werden.';

  @override
  String get openWhatsAppFailed => 'SMS-App konnte nicht geöffnet werden.';

  @override
  String get sortTooltip => 'Sortieren';

  @override
  String get sortByNameAsc => 'Name: A-Z';

  @override
  String get sortByNameDesc => 'Name: Z-A';

  @override
  String get sortByNewest => 'Neueste zuerst';

  @override
  String get permissionDeniedTitle => 'Zugriff verweigert';

  @override
  String get permissionCreateOrderDenied =>
      'Keine Berechtigung, einen Auftrag zu erstellen.';

  @override
  String get permissionDeleteOrderDenied =>
      'Löschen von Aufträgen nur für Direktor oder Besitzer.';

  @override
  String get permissionEditOrderDenied =>
      'Keine Berechtigung, einen Auftrag zu bearbeiten.';

  @override
  String get permissionSaveOrderDenied =>
      'Keine Berechtigung, einen Auftrag zu speichern.';

  @override
  String get permissionCreateClientDenied =>
      'Keine Berechtigung, einen Kunden zu erstellen.';

  @override
  String get permissionDeleteClientDenied =>
      'Keine Berechtigung, einen Kunden zu löschen.';

  @override
  String get permissionEditClientDenied =>
      'Keine Berechtigung, einen Kunden zu bearbeiten.';

  @override
  String get permissionSaveClientDenied =>
      'Keine Berechtigung, einen Kunden zu speichern.';

  @override
  String get permissionModifyInventoryDenied =>
      'Keine Berechtigung, das Lager zu ändern.';

  @override
  String get permissionEditInventoryStockDenied =>
      'Keine Berechtigung, Bestände zu ändern.';

  @override
  String get permissionEditInventoryDenied =>
      'Keine Berechtigung, das Lager zu bearbeiten.';

  @override
  String get clientDeleted => 'Kunde wurde gelöscht';

  @override
  String get clientGarageTitle => 'Fahrzeuge des Kunden';

  @override
  String get navTeamChats => 'Team-Chats';

  @override
  String get navCommunityChat => 'Community-Chat';

  @override
  String get orderDefaultTitle => 'Auftrag';

  @override
  String get completeOrderAndConsumePrompt =>
      'Auftrag abschließen und Chemie vom Lager abbuchen?';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: Abgeschlossen';
  }

  @override
  String get appointmentReminderTitle => 'Termin steht bevor';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car um $time';
  }

  @override
  String get inventoryFirstItemHint =>
      'Fügen Sie den ersten Lagerartikel hinzu: Chemie, Verbrauchsmaterial, Zubehör oder Geräte.';

  @override
  String get inventoryFilteredEmpty =>
      'Für die gewählten Filter wurden keine Positionen gefunden.';

  @override
  String get inventoryItemLabel => 'POSITION';

  @override
  String inventoryLowStockMore(Object count) {
    return ' und $count weitere';
  }

  @override
  String get inventoryLowStockTitle => 'Niedriger Lagerbestand';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items benötigen Aufmerksamkeit.';
  }

  @override
  String get inventoryNotificationsChannelName => 'Lagerbenachrichtigungen';

  @override
  String get inventoryNotificationsChannelDescription =>
      'Benachrichtigungen bei niedrigem Lagerbestand';

  @override
  String get inventoryEditItemTitle => 'Position bearbeiten';

  @override
  String get inventoryNewItemTitle => 'Neue Lagerposition';

  @override
  String get inventoryItemTypeLabel => 'Positionstyp';

  @override
  String get inventoryUnitLabel => 'Einheit';

  @override
  String get inventoryCurrentStockLabel => 'Aktueller Bestand';

  @override
  String get inventoryMinStockLabel => 'Mindestbestand';

  @override
  String get inventoryLocationLabel => 'Lagerort';

  @override
  String get inventoryUsageLabel => 'Verwendung';

  @override
  String inventoryLowStockCount(Object count) {
    return 'Niedriger Bestand: $count';
  }

  @override
  String inventoryLowStockItemLine(
    Object amount,
    Object item,
    Object minStock,
    Object unit,
  ) {
    return '$item: $amount $unit, Minimum $minStock $unit';
  }

  @override
  String get inventoryAllTypes => 'Alle Typen';

  @override
  String get inventoryBelowMin => 'Unter Minimum';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return 'Min: $minStock $unit';
  }

  @override
  String get chatProfileSaved => 'Chat-Profil gespeichert';

  @override
  String get chatUnavailableShort =>
      'Firebase ist nicht konfiguriert. Chat ist vorübergehend nicht verfügbar.';

  @override
  String get chatCreateDialogTitle => 'Neuer Dialog';

  @override
  String get chatCreateExternalTitle => 'Neuer externer Chat';

  @override
  String get chatPeerIdLabelTeam => 'Mitarbeiter-ID';

  @override
  String get chatPeerIdLabelExternal => 'Studio/Mitarbeiter-ID';

  @override
  String get chatPeerNameLabelTeam => 'Mitarbeitername';

  @override
  String get chatPeerNameLabelExternal => 'Studio- oder Mitarbeitername';

  @override
  String get chatCreateAction => 'Erstellen';

  @override
  String get chatDialogTitle => 'Dialog';

  @override
  String get chatScreenTitleTeam => 'Internes Team-Chat';

  @override
  String get chatScreenTitleExternal => 'Externes Community-Chat';

  @override
  String get chatNewChatButton => 'Neuer Chat';

  @override
  String get chatMyIdLabel => 'Ihre ID';

  @override
  String get chatMyIdHint => 'Zum Beispiel: master_001';

  @override
  String get chatMyNameLabel => 'Ihr Name';

  @override
  String get chatMyNameHint => 'Zum Beispiel: Alex';

  @override
  String get chatUnavailableTitle => 'Chat vorübergehend nicht verfügbar';

  @override
  String get chatUnavailableSubtitle =>
      'Firebase ist für diesen Build nicht konfiguriert. Fügen Sie Firebase-Konfigurationen hinzu.';

  @override
  String get chatProfileFillTitleTeam => 'Chat-Profil ausfüllen';

  @override
  String get chatProfileFillTitleExternal => 'Community-Profil ausfüllen';

  @override
  String get chatProfileFillSubtitleTeam =>
      'Geben Sie Ihre ID und Ihren Namen ein und drücken Sie Speichern.';

  @override
  String get chatProfileFillSubtitleExternal =>
      'Geben Sie Ihre ID und Ihren Namen ein, um mit anderen Studios und Mitarbeitern zu chatten.';

  @override
  String get chatErrorTitle => 'Chat nicht verfügbar';

  @override
  String get chatErrorSubtitle =>
      'Firebase-Einrichtung prüfen (google-services und Firebase.initializeApp).';

  @override
  String get chatEmptyTitle => 'Noch keine Dialoge';

  @override
  String get chatEmptySubtitle =>
      'Erstellen Sie den ersten Chat über die Schaltfläche Neuer Chat.';

  @override
  String get chatNoMessages => 'Noch keine Nachrichten';

  @override
  String get chatOpenAfterFirebase =>
      'Firebase ist nicht konfiguriert. Öffnen Sie den Chat nach der Firebase-Einrichtung.';

  @override
  String get chatConnectionError => 'Chat-Verbindungsfehler';

  @override
  String get chatMessageHint => 'Nachricht eingeben';

  @override
  String get chatAttachPhoto => 'Foto anhängen';

  @override
  String get chatAttachFile => 'Datei anhängen';

  @override
  String get chatAttachmentFile => 'Datei';

  @override
  String get chatFileOpenFailed => 'Datei konnte nicht geöffnet werden.';

  @override
  String chatUploadFailed(Object error) {
    return 'Upload fehlgeschlagen: $error';
  }

  @override
  String get durationMinutesShort => 'Min';

  @override
  String get inventoryTypeChemistry => 'Chemie';

  @override
  String get inventoryTypeConsumable => 'Verbrauchsmaterial';

  @override
  String get inventoryTypeAccessory => 'Zubehör';

  @override
  String get inventoryTypeEquipment => 'Ausrüstung';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get authEnterEmail => 'E-Mail eingeben';

  @override
  String get authInvalidEmail => 'Ungültige E-Mail';

  @override
  String get authEnterPassword => 'Passwort eingeben';

  @override
  String get authPasswordMin => 'Mindestens 8 Zeichen';

  @override
  String get authFirebaseGuestOnly =>
      'Firebase ist nicht konfiguriert. Gastmodus ist verfügbar.';

  @override
  String get authSignInFailed =>
      'Anmeldung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get authPasswordsMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get authJoinSuccess => 'Sie sind dem Team erfolgreich beigetreten!';

  @override
  String authInviteRejected(Object error) {
    return 'Registrierung abgeschlossen, aber Einladungscode wurde abgelehnt: $error';
  }

  @override
  String get authRegisterFailed =>
      'Registrierung konnte nicht abgeschlossen werden. Bitte erneut versuchen.';

  @override
  String get authGuestName => 'Gast';

  @override
  String get authGoogleSoon => 'Google-Anmeldung wird später hinzugefügt';

  @override
  String get authInvalidEmailFormat => 'Ungültiges E-Mail-Format';

  @override
  String get authWrongCredentials => 'Falsche E-Mail oder falsches Passwort';

  @override
  String get authEmailInUse => 'Diese E-Mail wird bereits verwendet';

  @override
  String get authWeakPassword => 'Passwort ist zu schwach';

  @override
  String get authTooManyRequests =>
      'Zu viele Versuche. Bitte später erneut versuchen';

  @override
  String get authAuthorizationError => 'Autorisierungsfehler';

  @override
  String get authWelcome => 'Willkommen';

  @override
  String get authSubtitle => 'Melden Sie sich an oder registrieren Sie sich';

  @override
  String get authTabSignIn => 'Anmelden';

  @override
  String get authTabRegister => 'Registrieren';

  @override
  String get authContinueWithGoogle => 'Mit Google fortfahren';

  @override
  String get authContinueAsGuest => 'Als Gast fortfahren';

  @override
  String get authPasswordLabel => 'Passwort';

  @override
  String get authConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get authInviteCodeOptional => 'Einladungscode (optional)';

  @override
  String get authInviteHint => 'Wenn Sie vom Leiter eingeladen wurden';

  @override
  String get authRegisterButton => 'Registrieren';

  @override
  String get businessModeQuestion => 'Wie arbeiten Sie?';

  @override
  String get businessModeSubtitle =>
      'Wählen Sie einen Modus, damit die App nur die benötigten Module zeigt.';

  @override
  String get businessModeSoloTitle => 'Ich arbeite allein';

  @override
  String get businessModeSoloSubtitle =>
      'Für Einzel-Spezialisten: Aufträge, Kunden, Lager, Finanzen und externer Chat.';

  @override
  String get businessModeTeamTitle => 'Wir haben ein Team';

  @override
  String get businessModeTeamSubtitle =>
      'Für Studios: Rollen, interner Chat, Aufgaben nach Mitarbeitern und Leitungskontrolle.';

  @override
  String get photosGallerySaveFailed =>
      'Foto wurde zur App hinzugefügt, konnte aber nicht in der Galerie gespeichert werden.';

  @override
  String get photosCameraUnsupported =>
      'Die Kamera ist nur auf Android/iOS oder in der Webversion verfügbar.';

  @override
  String get photosAddedAndSaved =>
      'Foto hinzugefügt und in der Galerie gespeichert.';

  @override
  String get photosAddedFromGallery => 'Foto aus der Galerie hinzugefügt.';

  @override
  String get photosAddFromGallery => 'Aus Galerie hinzufügen';

  @override
  String get photosTakePhoto => 'Foto aufnehmen';

  @override
  String get photosDeleteDenied =>
      'Nicht genügend Berechtigungen zum Löschen des Fotos.';

  @override
  String get settingsProfileAndOrgTitle => 'Profil und Organisation';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => 'Gast';

  @override
  String get settingsBusinessModeTitle => 'Arbeitsmodus';

  @override
  String get settingsUserRoleTitle => 'Benutzerrolle';

  @override
  String get settingsInviteMasterTitle => 'Mitarbeiter einladen';

  @override
  String get settingsInviteMasterSubtitle =>
      'Einmaligen Einladungscode erzeugen';

  @override
  String get settingsServicesSection => 'Dienste';

  @override
  String get settingsLogoutButton => 'Abmelden';

  @override
  String get settingsBusinessModeTeam => 'Team (Studio)';

  @override
  String get settingsBusinessModeSolo => 'Solo (ein Mitarbeiter)';

  @override
  String get settingsRoleDirector => 'Direktor';

  @override
  String get settingsRoleMaster => 'Mitarbeiter';

  @override
  String get settingsRoleMasterOwner => 'Inhaber-Mitarbeiter';

  @override
  String get settingsSelectModeTitle => 'Modus wählen';

  @override
  String get settingsModeSoloTitle => 'Solo';

  @override
  String get settingsModeSoloSubtitle => 'Ein Mitarbeiter';

  @override
  String get settingsModeTeamTitle => 'Team';

  @override
  String get settingsModeTeamSubtitle => 'Studio mit Mitarbeitern';

  @override
  String get settingsModeUpdated => 'Modus aktualisiert.';

  @override
  String get settingsOrgNotFound =>
      'Organisation nicht gefunden. Einstellungen zuerst speichern.';

  @override
  String settingsInviteGenerateError(Object error) {
    return 'Fehler beim Generieren des Codes: $error';
  }

  @override
  String get settingsInviteDialogTitle => 'Einladungscode für Mitarbeiter';

  @override
  String get settingsInviteDialogDescription =>
      'Senden Sie diesen Code an den Mitarbeiter. Der Code ist einmalig und verfällt nach der Nutzung.';

  @override
  String get settingsCopy => 'Kopieren';

  @override
  String get settingsCodeCopied => 'Code in die Zwischenablage kopiert';

  @override
  String get settingsInviteRegistrationHint =>
      'Der Mitarbeiter gibt den Code im Feld Einladungscode bei der Registrierung ein.';

  @override
  String get settingsClose => 'Schließen';

  @override
  String get settingsSelectRoleTitle => 'Rolle wählen';

  @override
  String get settingsRoleUpdated => 'Rolle aktualisiert.';

  @override
  String get settingsLogoutTitle => 'Abmelden';

  @override
  String get settingsLogoutMessage => 'Vom aktuellen Konto abmelden?';

  @override
  String get settingsLogoutConfirm => 'Abmelden';

  @override
  String get settingsLoggedOut => 'Sie wurden abgemeldet.';

  @override
  String get settingsAccessDenied =>
      'Nicht genügend Berechtigungen für diese Aktion.';

  @override
  String get settingsResetWarning =>
      'WARNUNG: Alle Aufträge, Kunden und Lagerbestände werden gelöscht!';

  @override
  String get settingsServiceDeleteDenied =>
      'Nicht genügend Berechtigungen zum Löschen des Dienstes.';

  @override
  String get settingsServiceEditDenied =>
      'Nicht genügend Berechtigungen zum Bearbeiten des Dienstes.';

  @override
  String get legalTitle => 'Rechtliches';

  @override
  String get legalPrivacyTab => 'Datenschutzerklärung';

  @override
  String get legalTermsTab => 'Nutzungsbedingungen';

  @override
  String get legalPrivacySummaryTitle =>
      'Zusammenfassung der Datenschutzerklärung';

  @override
  String get legalTermsSummaryTitle =>
      'Zusammenfassung der Nutzungsbedingungen';

  @override
  String get legalSummarySubtitle =>
      'Kurze Zusammenfassung in der App. Die vollständige rechtliche Version finden Sie auf der veröffentlichten Seite.';

  @override
  String get legalOpenFullPrivacy => 'Vollständige Datenschutzerklärung öffnen';

  @override
  String get legalOpenFullTerms => 'Vollständige Bedingungen öffnen';

  @override
  String get legalOpenLinkError =>
      'Dokumentenlink konnte nicht geöffnet werden.';

  @override
  String get legalPrivacySection1Title => '1. Was die App macht';

  @override
  String get legalPrivacySection1Body =>
      'DetailingPro Business hilft Detailing-Teams bei der Verwaltung von Kunden, Aufträgen, Zeitplänen, Lagerbestand, Team-Chat und angehängten Medien.';

  @override
  String get legalPrivacySection2Title => '2. Welche Daten wir verarbeiten';

  @override
  String get legalPrivacySection2Body =>
      'Die App kann Kontodaten, Kunden- und Auftragsdaten, Leistungsdaten, Lagerdaten, Teamnachrichten, Anhänge und technische Kennungen wie Benachrichtigungstoken verarbeiten.';

  @override
  String get legalPrivacySection3Title =>
      '3. Warum diese Daten verwendet werden';

  @override
  String get legalPrivacySection3Body =>
      'Die Daten werden genutzt, um Kernfunktionen bereitzustellen, zwischen Geräten zu synchronisieren, Erinnerungen zu senden, Zusammenarbeit zu ermöglichen sowie Zuverlässigkeit und Sicherheit des Dienstes zu gewährleisten.';

  @override
  String get legalPrivacySection4Title => '4. Berechtigungen und Zugriff';

  @override
  String get legalPrivacySection4Body =>
      'Kamera- und Medienberechtigungen werden nur für Funktionen wie Foto- und Dateianhänge angefordert. Benachrichtigungsberechtigungen werden für Erinnerungen und Push-Benachrichtigungen verwendet.';

  @override
  String get legalPrivacySection5Title => '5. Infrastruktur und Anbieter';

  @override
  String get legalPrivacySection5Body =>
      'Die App nutzt Firebase-Dienste (Authentication, Firestore, Storage, Messaging). Daten werden auf der Infrastruktur dieser Anbieter verarbeitet.';

  @override
  String get legalPrivacySection6Title => '6. Speicherung, Löschung und Rechte';

  @override
  String get legalPrivacySection6Body =>
      'Daten werden so lange gespeichert, wie es für die Bereitstellung des Dienstes erforderlich ist. Nutzer können entsprechend geltendem Recht Zugriff, Berichtigung oder Löschung beantragen.';

  @override
  String get legalPrivacySection7Title => '7. Kontakt';

  @override
  String get legalPrivacySection7Body =>
      'Fragen zum Datenschutz: support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. Leistungsumfang';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro ist eine Business-Produktivitäts-App zur Verwaltung von Terminen, Kunden, Medien, internem Chat und Betriebsdaten.';

  @override
  String get legalTermsSection2Title => '2. Konten und Zugriff';

  @override
  String get legalTermsSection2Body =>
      'Nutzer sind dafür verantwortlich, ihre Zugangsdaten zu schützen und die App nur im Rahmen der für ihre Rolle vergebenen Rechte zu nutzen.';

  @override
  String get legalTermsSection3Title => '3. Zulässige Nutzung';

  @override
  String get legalTermsSection3Body =>
      'Der Dienst darf nicht für unrechtmäßige Datenverarbeitung, missbräuchliche Nachrichten, unbefugte Zugriffsversuche oder sonstige rechtswidrige Aktivitäten verwendet werden.';

  @override
  String get legalTermsSection4Title => '4. Verfügbarkeit';

  @override
  String get legalTermsSection4Body =>
      'Der Dienst kann sich im Laufe der Zeit ändern. Funktionen können hinzugefügt, angepasst oder entfernt werden, wenn sich das Produkt weiterentwickelt.';

  @override
  String get legalTermsSection5Title => '5. Kostenpflichtige Pläne';

  @override
  String get legalTermsSection5Body =>
      'Vor dem Launch sollte dieser Abschnitt mit finalen Abrechnungsbedingungen, Verlängerungsregeln, Testphasen, Kündigungsbedingungen und Erstattungen für Google Play-Abonnements aktualisiert werden.';

  @override
  String get legalTermsSection6Title => '6. Haftungsbeschränkung';

  @override
  String get legalTermsSection6Body =>
      'Vor der öffentlichen Veröffentlichung ersetzen Sie diesen Entwurf durch eine endgültige rechtliche Version für Ihre Rechtsordnung und Unternehmensstruktur.';

  @override
  String get legalTermsSection7Title => '7. Rechtliche Angaben';

  @override
  String get legalTermsSection7Body =>
      'Ersetzen Sie diesen Abschnitt vor der Veröffentlichung durch Ihre registrierten Unternehmensdaten und Informationen zum anwendbaren Recht.';

  @override
  String get invoiceCompanyDataTitle => 'Firmendaten';

  @override
  String get invoiceCompanyDataSubtitle => 'Für Rechnungen';

  @override
  String get invoiceCompanyName => 'Firmenname';

  @override
  String get invoiceCompanyAddress => 'Adresse';

  @override
  String get invoiceCompanyPostalCode => 'Postleitzahl';

  @override
  String get invoiceCompanyCity => 'Stadt';

  @override
  String get invoiceGenerateButton => 'Rechnung erstellen';

  @override
  String get invoiceVatRate => 'MwSt.-Satz';

  @override
  String get settingsBookingLinkTitle => 'Online-Buchungslink';

  @override
  String get settingsBookingRequestsTitle => 'Online-Buchungen';

  @override
  String get settingsBookingLinkDialogTitle => 'Ihr Buchungslink';

  @override
  String get settingsBookingLinkCopied => 'Link kopiert';

  @override
  String get settingsBookingLinkAuthRequired =>
      'Melden Sie sich an, um einen Buchungslink zu erstellen.';

  @override
  String get settingsBookingLinkOpen => 'Öffnen';

  @override
  String get settingsWorkingHoursTitle => 'Arbeitszeiten';

  @override
  String get settingsWorkingHoursSlotLabel => 'Slot';

  @override
  String get settingsWorkingHoursMinNoticeLabel => 'Min. Vorlauf';

  @override
  String get settingsWorkingHoursBreakLabel => 'Pause';

  @override
  String get settingsWorkingHoursNotice1Hour => '1 Stunde';

  @override
  String get settingsWorkingHoursNotice2Hours => '2 Stunden';

  @override
  String get settingsWorkingHoursNotice24Hours => '24 Stunden';

  @override
  String get bookingRequestsTitle => 'Online-Buchungen';

  @override
  String get bookingRequestsFirebaseUnavailable =>
      'Firebase ist für Online-Buchungen nicht konfiguriert.';

  @override
  String get bookingRequestsSignInRequired =>
      'Melden Sie sich an, um Buchungen zu sehen.';

  @override
  String bookingRequestsError(Object error) {
    return 'Fehler beim Laden der Buchungen: $error';
  }

  @override
  String get bookingRequestsEmpty => 'Noch keine Online-Buchungen.';

  @override
  String get bookingRequestServiceLabel => 'Leistung';

  @override
  String get bookingRequestScheduleLabel => 'Wunschtermin';

  @override
  String get bookingRequestPhoneLabel => 'Telefon';

  @override
  String get bookingRequestCarLabel => 'Auto';

  @override
  String get bookingRequestNoteLabel => 'Notiz';

  @override
  String get bookingRequestAccept => 'Annehmen';

  @override
  String get bookingRequestDecline => 'Ablehnen';

  @override
  String get bookingRequestCall => 'Anrufen';

  @override
  String get bookingRequestStatusPending => 'Offen';

  @override
  String get bookingRequestStatusAccepted => 'Angenommen';

  @override
  String get bookingRequestStatusDeclined => 'Abgelehnt';

  @override
  String get bookingRequestsFilterAll => 'Alle';

  @override
  String get bookingRequestsEmptyNew => 'Keine neuen Anfragen';

  @override
  String get bookingRequestsAcceptedFeedback =>
      'Anfrage angenommen — Auftrag wird automatisch erstellt';

  @override
  String get bookingRequestsDeclinedFeedback => 'Anfrage abgelehnt';

  @override
  String get bookingRequestsDeclineConfirmContent =>
      'Diese Buchungsanfrage ablehnen?';

  @override
  String get enterServiceName => 'Servicename ist erforderlich';

  @override
  String get invalidPrice => 'Gültigen Preis eingeben (0 oder mehr)';

  @override
  String get invoiceTitle => 'RECHNUNG';

  @override
  String get invoiceNumberPrefix => 'RE';

  @override
  String get invoiceSeller => 'VERKÄUFER';

  @override
  String get invoiceBuyer => 'KÄUFER';

  @override
  String get invoiceIssueDateLabel => 'Ausstellungsdatum';

  @override
  String get invoiceServiceDateLabel => 'Leistungsdatum';

  @override
  String get invoiceDescriptionLabel => 'Beschreibung';

  @override
  String get invoiceQtyLabel => 'Menge';

  @override
  String get invoiceNetPriceLabel => 'Nettopreis';

  @override
  String get invoiceVatPctLabel => 'MwSt. %';

  @override
  String get invoiceVatAmountLabel => 'MwSt. Betrag';

  @override
  String get invoiceGrossPriceLabel => 'Bruttopreis';

  @override
  String get invoiceNetTotalLabel => 'Netto gesamt:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return 'MwSt. $rate:';
  }

  @override
  String get invoiceTotalDueLabel => 'GESAMT:';

  @override
  String get invoiceFillCompanyLabel => 'Firmendaten ausfüllen';

  @override
  String get invoiceIssuedByLabel => 'Rechnung ausgestellt von';

  @override
  String get invoicePrimaryIdLabel => 'USt-IdNr.';

  @override
  String get invoiceSecondaryIdLabel => 'Handelsregisternr.';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total Plätze';
  }

  @override
  String get syncOfflineWarning =>
      'Keine Internetverbindung. Daten sind möglicherweise veraltet.';

  @override
  String get forceUpdateTitle => 'Update erforderlich';

  @override
  String get forceUpdateMessage =>
      'Eine neue Version der App ist verfügbar. Bitte aktualisieren Sie Detailing Pro, um fortzufahren.';

  @override
  String get forceUpdateButton => 'Aktualisieren';

  @override
  String get storageStartupTitle => 'Lokaler Speicher nicht verfügbar';

  @override
  String get storageStartupBody =>
      'Detailing Pro konnte die verschlüsselte Datenbank nicht öffnen. Die Daten auf diesem Gerät sind möglicherweise geschützt oder beschädigt.';

  @override
  String get storageStartupHint =>
      'Schließen Sie die App vollständig und öffnen Sie sie erneut. Wenn das Problem bleibt, installieren Sie die App neu (Cloud-Daten bleiben bei gleichem Konto erhalten).';

  @override
  String get storageStartupCloseApp => 'App schließen';

  @override
  String get settingsSyncStatusTitle => 'Cloud-Sync';

  @override
  String settingsSyncPendingMessage(int count) {
    return '$count Änderungen warten auf Sync';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return '$count Änderungen konnten nicht synchronisiert werden';
  }

  @override
  String get settingsSyncRetryButton => 'Sync wiederholen';

  @override
  String get settingsSyncDiscardButton =>
      'Fehlgeschlagene Änderungen verwerfen';
}
