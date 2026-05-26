// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return 'Versione $version';
  }

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navOrders => 'Ordini';

  @override
  String get navClients => 'Clienti';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navInventory => 'Magazzino';

  @override
  String get navStats => 'Statistiche';

  @override
  String get navPhotos => 'Foto';

  @override
  String get navMarketing => 'Marketing';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get inventoryEmptyTitle => 'Magazzino vuoto';

  @override
  String get inventoryEmptySubtitle =>
      'Aggiungi prodotti con il pulsante sotto';

  @override
  String get showAllCategories => 'Mostra tutte le categorie';

  @override
  String get chemicalsButton => 'CHIMICA';

  @override
  String get cancel => 'Anulla';

  @override
  String get add => 'Aggiungi';

  @override
  String get save => 'Salva';

  @override
  String get noOrdersTitle => 'Nessun ordine';

  @override
  String get noOrdersSubtitle => 'Aggiungi il primo ordine per iniziare';

  @override
  String get addOrder => 'Aggiungi servizio';

  @override
  String get orderButton => 'ORDINE';

  @override
  String get deleteOrderTitle => 'Eliminare l\'ordine?';

  @override
  String deleteOrderMessage(Object car) {
    return 'L\'ordine \"$car\" verrà eliminato definitivamente.';
  }

  @override
  String deletedOrderSnack(Object car) {
    return 'Ordine \"$car\" eliminato';
  }

  @override
  String get undo => 'Anulla';

  @override
  String get delete => 'Elimina';

  @override
  String get carLabel => 'Auto';

  @override
  String clientLabel(Object client) {
    return 'Cliente: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return 'Servizio: $service ($duration min)';
  }

  @override
  String get statusScheduled => 'Prenotato';

  @override
  String get statusInProgress => 'In corso';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusPaid => 'Pagato';

  @override
  String get statusCompleted => 'Completato';

  @override
  String get edit => 'Modifica';

  @override
  String get start => 'Inizia';

  @override
  String get markDone => 'Fatto';

  @override
  String get markPaid => 'Pagato';

  @override
  String get statusChangedTitle => 'Stato modificato';

  @override
  String statusChangedMessage(Object car, Object status) {
    return 'L\'ordine \"$car\" è ora $status';
  }

  @override
  String get newChemicalTitle => 'Nuovo prodotto';

  @override
  String get nameLabel => 'Nome *';

  @override
  String get brandLabel => 'Marca';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get volumeLabel => 'Volume (ml)';

  @override
  String get deleteItemTitle => 'Elimina?';

  @override
  String deleteItemMessage(Object item) {
    return 'Eliminare \"$item\" dal magazzino?';
  }

  @override
  String get unnamedItem => 'Senza nome';

  @override
  String get replenish => 'Rifornisci';

  @override
  String get languageLabel => 'Lingua';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get goodMorning => 'Buongiorno!';

  @override
  String get goodAfternoon => 'Buon pomeriggio!';

  @override
  String get goodEvening => 'Buonasera!';

  @override
  String get statsTodayOrders => 'Appuntamenti oggi';

  @override
  String get statsInWork => 'In corso';

  @override
  String get statsTodayRevenue => 'Incasso oggi';

  @override
  String get statsTotalClients => 'Clienti';

  @override
  String get noCars => 'Nessuna auto';

  @override
  String get quickActions => 'Azioni rapide';

  @override
  String get newOrder => 'Nuovo ordine';

  @override
  String get newClient => 'Nuovo cliente';

  @override
  String get todayOrdersTitle => 'Ordini di oggi';

  @override
  String get calendarTitle => 'Calendario';

  @override
  String get monthJanuary => 'Gennaio';

  @override
  String get monthFebruary => 'Febbraio';

  @override
  String get monthMarch => 'Marzo';

  @override
  String get monthApril => 'Aprile';

  @override
  String get monthMay => 'Maggio';

  @override
  String get monthJune => 'Giugno';

  @override
  String get monthJuly => 'Luglio';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Settembre';

  @override
  String get monthOctober => 'Ottobre';

  @override
  String get monthNovember => 'Novembre';

  @override
  String get monthDecember => 'Dicembre';

  @override
  String get statsTitle => 'Statistiche';

  @override
  String get statsRevenue => 'Fatturato';

  @override
  String get statsOrders => 'Ordini';

  @override
  String get statsPeriodWeek => 'Settimana';

  @override
  String get statsPeriodMonth => 'Mese';

  @override
  String get statsPeriodYear => 'Anno';

  @override
  String get photosTitle => 'Fotografie';

  @override
  String get orderBeforePhotosTitle => 'Prima';

  @override
  String get orderAfterPhotosTitle => 'Dopo';

  @override
  String get photosAdd => 'Aggiungi foto';

  @override
  String get photosEmpty => 'Nessuna foto presente';

  @override
  String get photosSelectCar => 'Seleziona auto';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get visits => 'Visite';

  @override
  String get totalSpent => 'Spesa totale';

  @override
  String get orderHistoryTitle => 'Cronologia ordini';

  @override
  String get orderHistoryEmpty => 'Cronologia vuota';

  @override
  String get call => 'Chiama';

  @override
  String get message => 'Scrivi';

  @override
  String get photoReport => 'Report foto';

  @override
  String get photosNotAdded => 'Nessuna foto aggiunta';

  @override
  String get editOrderTitle => 'Modifica ordine';

  @override
  String get newOrderTitle => 'Nuovo ordine';

  @override
  String get clientFieldLabel => 'Cliente *';

  @override
  String get selectClient => 'Scegli cliente';

  @override
  String get carHint => 'Modello e targa';

  @override
  String get enterCar => 'Indica auto';

  @override
  String get serviceFieldLabel => 'Servizio *';

  @override
  String get selectService => 'Scegli servizio';

  @override
  String get orderMaterialCostLabel => 'Costo materiali';

  @override
  String get orderLaborCostLabel => 'Costo lavoro';

  @override
  String get orderTotalCostLabel => 'Costo totale';

  @override
  String get orderProfitLabel => 'Profitto';

  @override
  String get statsProfit => 'Profitto';

  @override
  String get orderNotesLabel => 'Note ordine';

  @override
  String get createOrderButton => 'Crea ordine';

  @override
  String get orderUpdated => 'Ordine aggiornato';

  @override
  String get orderCreated => 'Ordine creato con successo';

  @override
  String errorMessage(Object error) {
    return 'Errore: $error';
  }

  @override
  String get editClient => 'Modifica cliente';

  @override
  String get clientNameLabel => 'Nome cliente *';

  @override
  String get enterName => 'Inserisci nome';

  @override
  String get phoneLabel => 'Telefono';

  @override
  String get phoneHint => '+39 ___ _______';

  @override
  String get enterValidPhone => 'Inserisci numero valido';

  @override
  String get carsLabel => 'Automobili *';

  @override
  String get addCar => 'Aggiungi';

  @override
  String get addAtLeastOneCar => 'Aggiungi almeno un\'auto';

  @override
  String get addCarDialogTitle => 'Aggiungi auto';

  @override
  String get carExample => 'Es: BMW X5 AB123CD';

  @override
  String get carAlreadyAdded => 'Auto già aggiunta';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get saveClient => 'Salva cliente';

  @override
  String get clientUpdated => 'Cliente aggiornato';

  @override
  String get clientAdded => 'Cliente aggiunto';

  @override
  String get otherCategory => 'Altro';

  @override
  String replenishItemTitle(Object item) {
    return 'Rifornisci \"$item\"';
  }

  @override
  String get howManyToAdd => 'Quanto aggiungere?';

  @override
  String get ml => 'ml';

  @override
  String currentStockTitle(Object item) {
    return 'Rimanenza: \"$item\"';
  }

  @override
  String get currentStockLabel => 'Volume attuale';

  @override
  String get inactiveClients => 'Clienti inattivi';

  @override
  String get promotions => 'Offerte e sconti';

  @override
  String get promotionsDescription => 'Crea offerte per attirare clienti';

  @override
  String get loyaltyProgram => 'Programma fedeltà';

  @override
  String get loyaltyDescription => 'Premia i clienti fissi con bonus';

  @override
  String get smsBroadcast => 'Invio SMS';

  @override
  String get smsDescription => 'Invia promemoria e novità';

  @override
  String get reviews => 'Recensioni';

  @override
  String get reviewsDescription => 'Raccogli recensioni';

  @override
  String get comingSoon => 'In arrivo';

  @override
  String get gotIt => 'Ho capito';

  @override
  String get ordersChannelName => 'Ordini';

  @override
  String get ordersChannelDescription => 'Notifiche ordini';

  @override
  String get currencyLabel => 'Valuta';

  @override
  String get searchClientsHint => 'Cerca per cliente o auto...';

  @override
  String get crmFilterAll => 'Tutti';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => 'A rischio';

  @override
  String get crmFilterInactive => 'Inattivi';

  @override
  String get crmTagsLabel => 'Tag';

  @override
  String get crmTagsHint => 'VIP, flotta, referral';

  @override
  String get crmSegmentLabel => 'Segmento';

  @override
  String get crmLastVisitLabel => 'Ultima visita';

  @override
  String get crmAtRiskLabel => 'Richiede contatto';

  @override
  String get crmReminderButton => 'Invia promemoria';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return 'Ciao, $client! Un promemoria dal centro detailing. Possiamo prenotarti per $service in un orario comodo.';
  }

  @override
  String get crmBulkReminderButton => 'Campagna CRM';

  @override
  String get crmBulkReminderTitle => 'Seleziona destinatari';

  @override
  String get crmBulkReminderToggleAll => 'Tutti';

  @override
  String get crmBulkReminderSendSelected => 'Invia ai selezionati';

  @override
  String get crmBulkReminderEmpty =>
      'In questo elenco non ci sono clienti con telefono.';

  @override
  String get crmBulkReminderTemplate =>
      'Ciao! Ti ricordiamo dal centro detailing. Puoi prenotare un orario comodo per il tuo prossimo servizio.';

  @override
  String get crmSegmentNew => 'Nuovo';

  @override
  String get crmSegmentReturning => 'Di ritorno';

  @override
  String get crmSegmentLoyal => 'Fidelizzato';

  @override
  String get clientsNotFound => 'Nessun cliente trovato';

  @override
  String get openCallFailed => 'Impossibile aprire la chiamata.';

  @override
  String get openWhatsAppFailed => 'Impossibile aprire l\'app SMS.';

  @override
  String get sortTooltip => 'Ordina';

  @override
  String get sortByNameAsc => 'Nome: A-Z';

  @override
  String get sortByNameDesc => 'Nome: Z-A';

  @override
  String get sortByNewest => 'Più recenti prima';

  @override
  String get permissionDeniedTitle => 'Accesso negato';

  @override
  String get permissionCreateOrderDenied =>
      'Permessi insufficienti per creare un ordine.';

  @override
  String get permissionDeleteOrderDenied =>
      'Solo direttore o proprietario possono eliminare ordini.';

  @override
  String get permissionEditOrderDenied =>
      'Permessi insufficienti per modificare un ordine.';

  @override
  String get permissionSaveOrderDenied =>
      'Permessi insufficienti per salvare un ordine.';

  @override
  String get permissionCreateClientDenied =>
      'Permessi insufficienti per creare un cliente.';

  @override
  String get permissionDeleteClientDenied =>
      'Permessi insufficienti per eliminare un cliente.';

  @override
  String get permissionEditClientDenied =>
      'Permessi insufficienti per modificare un cliente.';

  @override
  String get permissionSaveClientDenied =>
      'Permessi insufficienti per salvare un cliente.';

  @override
  String get permissionModifyInventoryDenied =>
      'Permessi insufficienti per modificare il magazzino.';

  @override
  String get permissionEditInventoryStockDenied =>
      'Permessi insufficienti per cambiare le giacenze.';

  @override
  String get permissionEditInventoryDenied =>
      'Permessi insufficienti per modificare il magazzino.';

  @override
  String get clientDeleted => 'Cliente eliminato';

  @override
  String get clientGarageTitle => 'Garage del cliente';

  @override
  String get navTeamChats => 'Chat del team';

  @override
  String get navCommunityChat => 'Chat community';

  @override
  String get orderDefaultTitle => 'Ordine';

  @override
  String get completeOrderAndConsumePrompt =>
      'Completare il lavoro e scalare la chimica dal magazzino?';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: Completato';
  }

  @override
  String get appointmentReminderTitle => 'Appuntamento imminente';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car alle $time';
  }

  @override
  String get inventoryFirstItemHint =>
      'Aggiungi il primo articolo di magazzino: chimica, consumabili, accessori o attrezzatura.';

  @override
  String get inventoryFilteredEmpty =>
      'Nessun articolo trovato per i filtri selezionati.';

  @override
  String get inventoryItemLabel => 'ARTICOLO';

  @override
  String inventoryLowStockMore(Object count) {
    return ' e altri $count';
  }

  @override
  String get inventoryLowStockTitle => 'Scorte basse in magazzino';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items richiedono attenzione.';
  }

  @override
  String get inventoryNotificationsChannelName => 'Notifiche magazzino';

  @override
  String get inventoryNotificationsChannelDescription =>
      'Avvisi su scorte basse in magazzino';

  @override
  String get inventoryEditItemTitle => 'Modifica articolo';

  @override
  String get inventoryNewItemTitle => 'Nuovo articolo di magazzino';

  @override
  String get inventoryItemTypeLabel => 'Tipo articolo';

  @override
  String get inventoryUnitLabel => 'Unità';

  @override
  String get inventoryCurrentStockLabel => 'Scorta attuale';

  @override
  String get inventoryMinStockLabel => 'Scorta minima';

  @override
  String get inventoryLocationLabel => 'Posizione';

  @override
  String get inventoryUsageLabel => 'Uso';

  @override
  String inventoryLowStockCount(Object count) {
    return 'Scorte basse: $count';
  }

  @override
  String inventoryLowStockItemLine(
    Object amount,
    Object item,
    Object minStock,
    Object unit,
  ) {
    return '$item: $amount $unit, minimo $minStock $unit';
  }

  @override
  String get inventoryAllTypes => 'Tutti i tipi';

  @override
  String get inventoryBelowMin => 'Sotto il minimo';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return 'Min: $minStock $unit';
  }

  @override
  String get chatProfileSaved => 'Profilo chat salvato';

  @override
  String get chatUnavailableShort =>
      'Firebase non è configurato. Chat temporaneamente non disponibile.';

  @override
  String get chatCreateDialogTitle => 'Nuovo dialogo';

  @override
  String get chatCreateExternalTitle => 'Nuova chat esterna';

  @override
  String get chatPeerIdLabelTeam => 'ID operatore';

  @override
  String get chatPeerIdLabelExternal => 'ID studio/operatore';

  @override
  String get chatPeerNameLabelTeam => 'Nome operatore';

  @override
  String get chatPeerNameLabelExternal => 'Nome studio o operatore';

  @override
  String get chatCreateAction => 'Crea';

  @override
  String get chatDialogTitle => 'Dialogo';

  @override
  String get chatScreenTitleTeam => 'Chat interna team';

  @override
  String get chatScreenTitleExternal => 'Chat esterna community';

  @override
  String get chatNewChatButton => 'Nuova chat';

  @override
  String get chatMyIdLabel => 'Il tuo ID';

  @override
  String get chatMyIdHint => 'Ad esempio: master_001';

  @override
  String get chatMyNameLabel => 'Il tuo nome';

  @override
  String get chatMyNameHint => 'Ad esempio: Alex';

  @override
  String get chatUnavailableTitle => 'Chat temporaneamente non disponibile';

  @override
  String get chatUnavailableSubtitle =>
      'Firebase non è configurato per questa build. Aggiungi la configurazione Firebase.';

  @override
  String get chatProfileFillTitleTeam => 'Compila il profilo chat';

  @override
  String get chatProfileFillTitleExternal => 'Compila il profilo community';

  @override
  String get chatProfileFillSubtitleTeam =>
      'Inserisci ID e nome, poi premi Salva.';

  @override
  String get chatProfileFillSubtitleExternal =>
      'Inserisci ID e nome per chattare con altri studi e operatori.';

  @override
  String get chatErrorTitle => 'Chat non disponibile';

  @override
  String get chatErrorSubtitle =>
      'Controlla la configurazione Firebase (google-services e Firebase.initializeApp).';

  @override
  String get chatEmptyTitle => 'Nessun dialogo';

  @override
  String get chatEmptySubtitle =>
      'Crea la prima chat con il pulsante Nuova chat.';

  @override
  String get chatNoMessages => 'Nessun messaggio';

  @override
  String get chatOpenAfterFirebase =>
      'Firebase non è configurato. Apri la chat dopo aver configurato Firebase.';

  @override
  String get chatConnectionError => 'Errore di connessione chat';

  @override
  String get chatMessageHint => 'Scrivi un messaggio';

  @override
  String get chatAttachPhoto => 'Allega foto';

  @override
  String get chatAttachFile => 'Allega file';

  @override
  String get chatAttachmentFile => 'File';

  @override
  String get chatFileOpenFailed => 'Impossibile aprire il file.';

  @override
  String chatUploadFailed(Object error) {
    return 'Caricamento fallito: $error';
  }

  @override
  String get durationMinutesShort => 'min';

  @override
  String get inventoryTypeChemistry => 'Chimica';

  @override
  String get inventoryTypeConsumable => 'Consumabile';

  @override
  String get inventoryTypeAccessory => 'Accessorio';

  @override
  String get inventoryTypeEquipment => 'Attrezzatura';

  @override
  String get emailLabel => 'Email';

  @override
  String get authEnterEmail => 'Inserisci email';

  @override
  String get authInvalidEmail => 'Email non valida';

  @override
  String get authEnterPassword => 'Inserisci password';

  @override
  String get authPasswordMin => 'Minimo 8 caratteri';

  @override
  String get authFirebaseGuestOnly =>
      'Firebase non è configurato. Modalità ospite disponibile.';

  @override
  String get authSignInFailed => 'Accesso non riuscito. Riprova.';

  @override
  String get authPasswordsMismatch => 'Le password non corrispondono';

  @override
  String get authJoinSuccess => 'Ti sei unito al team con successo!';

  @override
  String authInviteRejected(Object error) {
    return 'Registrazione completata, ma il codice invito è stato rifiutato: $error';
  }

  @override
  String get authRegisterFailed =>
      'Impossibile completare la registrazione. Riprova.';

  @override
  String get authGuestName => 'Ospite';

  @override
  String get authGoogleSoon => 'L\'accesso con Google sarà aggiunto più tardi';

  @override
  String get authInvalidEmailFormat => 'Formato email non valido';

  @override
  String get authWrongCredentials => 'Email o password non corretti';

  @override
  String get authEmailInUse => 'Questa email è già in uso';

  @override
  String get authWeakPassword => 'Password troppo debole';

  @override
  String get authTooManyRequests => 'Troppi tentativi. Riprova più tardi';

  @override
  String get authAuthorizationError => 'Errore di autorizzazione';

  @override
  String get authWelcome => 'Benvenuto';

  @override
  String get authSubtitle => 'Accedi o registrati';

  @override
  String get authTabSignIn => 'Accedi';

  @override
  String get authTabRegister => 'Registrazione';

  @override
  String get authContinueWithGoogle => 'Continua con Google';

  @override
  String get authContinueAsGuest => 'Continua come ospite';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Conferma password';

  @override
  String get authInviteCodeOptional => 'Codice invito (opzionale)';

  @override
  String get authInviteHint => 'Se sei stato invitato dal direttore';

  @override
  String get authRegisterButton => 'Registrati';

  @override
  String get businessModeQuestion => 'Come lavori?';

  @override
  String get businessModeSubtitle =>
      'Scegli una modalità per mostrare solo i moduli necessari.';

  @override
  String get businessModeSoloTitle => 'Lavoro da solo';

  @override
  String get businessModeSoloSubtitle =>
      'Per professionista singolo: ordini, clienti, magazzino, finanze e chat esterna.';

  @override
  String get businessModeTeamTitle => 'Abbiamo un team';

  @override
  String get businessModeTeamSubtitle =>
      'Per studio: ruoli del personale, chat interna, attività per tecnico e controllo del direttore.';

  @override
  String get photosGallerySaveFailed =>
      'Foto aggiunta all\'app, ma impossibile salvarla nella galleria.';

  @override
  String get photosCameraUnsupported =>
      'La fotocamera è disponibile solo su Android/iOS o nella versione web.';

  @override
  String get photosAddedAndSaved => 'Foto aggiunta e salvata in galleria.';

  @override
  String get photosAddedFromGallery => 'Foto aggiunta dalla galleria.';

  @override
  String get photosAddFromGallery => 'Aggiungi dalla galleria';

  @override
  String get photosTakePhoto => 'Scatta foto';

  @override
  String get photosDeleteDenied =>
      'Permessi insufficienti per eliminare la foto.';

  @override
  String get settingsProfileAndOrgTitle => 'Profilo e organizzazione';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => 'Ospite';

  @override
  String get settingsBusinessModeTitle => 'Modalità di lavoro';

  @override
  String get settingsUserRoleTitle => 'Ruolo utente';

  @override
  String get settingsInviteMasterTitle => 'Invita tecnico';

  @override
  String get settingsInviteMasterSubtitle => 'Genera codice invito monouso';

  @override
  String get settingsServicesSection => 'Servizi';

  @override
  String get settingsLogoutButton => 'Esci dall\'account';

  @override
  String get settingsBusinessModeTeam => 'Team (studio)';

  @override
  String get settingsBusinessModeSolo => 'Solo (un tecnico)';

  @override
  String get settingsRoleDirector => 'Direttore';

  @override
  String get settingsRoleMaster => 'Tecnico';

  @override
  String get settingsRoleMasterOwner => 'Tecnico proprietario';

  @override
  String get settingsSelectModeTitle => 'Scegli modalità';

  @override
  String get settingsModeSoloTitle => 'Solo';

  @override
  String get settingsModeSoloSubtitle => 'Un tecnico';

  @override
  String get settingsModeTeamTitle => 'Team';

  @override
  String get settingsModeTeamSubtitle => 'Studio con dipendenti';

  @override
  String get settingsModeUpdated => 'Modalità aggiornata.';

  @override
  String get settingsOrgNotFound =>
      'Organizzazione non trovata. Salva prima le impostazioni.';

  @override
  String settingsInviteGenerateError(Object error) {
    return 'Errore durante la generazione del codice: $error';
  }

  @override
  String get settingsInviteDialogTitle => 'Codice invito per tecnico';

  @override
  String get settingsInviteDialogDescription =>
      'Invia questo codice al tecnico. È monouso e scade dopo l\'utilizzo.';

  @override
  String get settingsCopy => 'Copia';

  @override
  String get settingsCodeCopied => 'Codice copiato negli appunti';

  @override
  String get settingsInviteRegistrationHint =>
      'Il tecnico inserisce il codice nel campo Codice invito durante la registrazione.';

  @override
  String get settingsClose => 'Chiudi';

  @override
  String get settingsSelectRoleTitle => 'Scegli ruolo';

  @override
  String get settingsRoleUpdated => 'Ruolo aggiornato.';

  @override
  String get settingsLogoutTitle => 'Uscita';

  @override
  String get settingsLogoutMessage => 'Uscire dall\'account corrente?';

  @override
  String get settingsLogoutConfirm => 'Esci';

  @override
  String get settingsLoggedOut => 'Sei uscito dall\'account.';

  @override
  String get settingsAccessDenied =>
      'Permessi insufficienti per questa azione.';

  @override
  String get settingsResetWarning =>
      'ATTENZIONE: Tutti ordini, clienti e magazzino verranno eliminati!';

  @override
  String get settingsServiceDeleteDenied =>
      'Permessi insufficienti per eliminare il servizio.';

  @override
  String get settingsServiceEditDenied =>
      'Permessi insufficienti per modificare il servizio.';

  @override
  String get legalTitle => 'Note legali';

  @override
  String get legalPrivacyTab => 'Informativa sulla privacy';

  @override
  String get legalTermsTab => 'Termini';

  @override
  String get legalPrivacySummaryTitle =>
      'Sintesi dell\'informativa sulla privacy';

  @override
  String get legalTermsSummaryTitle => 'Sintesi dei termini di servizio';

  @override
  String get legalSummarySubtitle =>
      'Breve riepilogo nell\'app. La versione legale completa è disponibile nella pagina pubblicata.';

  @override
  String get legalOpenFullPrivacy => 'Apri informativa completa';

  @override
  String get legalOpenFullTerms => 'Apri termini completi';

  @override
  String get legalOpenLinkError => 'Impossibile aprire il link del documento.';

  @override
  String get legalPrivacySection1Title => '1. Cosa fa l\'app';

  @override
  String get legalPrivacySection1Body =>
      'DetailingPro Business aiuta i team di detailing a gestire clienti, ordini, pianificazioni, inventario, chat del team e media allegati.';

  @override
  String get legalPrivacySection2Title => '2. Dati che trattiamo';

  @override
  String get legalPrivacySection2Body =>
      'L\'app può trattare dati dell\'account, dati di clienti e ordini, registri dei servizi, inventario, messaggi del team, allegati e identificatori tecnici come i token di notifica.';

  @override
  String get legalPrivacySection3Title => '3. Perché usiamo questi dati';

  @override
  String get legalPrivacySection3Body =>
      'I dati vengono usati per fornire le funzionalità principali, sincronizzare tra dispositivi, inviare promemoria, supportare la collaborazione e mantenere affidabilità e sicurezza del servizio.';

  @override
  String get legalPrivacySection4Title => '4. Permessi e accesso';

  @override
  String get legalPrivacySection4Body =>
      'I permessi per fotocamera e media sono richiesti solo per funzioni come foto e allegati. Il permesso notifiche è usato per promemoria e avvisi push.';

  @override
  String get legalPrivacySection5Title => '5. Infrastruttura e fornitori';

  @override
  String get legalPrivacySection5Body =>
      'L\'app usa i servizi Firebase (Authentication, Firestore, Storage, Messaging). I dati sono trattati sull\'infrastruttura di questi fornitori.';

  @override
  String get legalPrivacySection6Title =>
      '6. Conservazione, eliminazione e diritti';

  @override
  String get legalPrivacySection6Body =>
      'I dati sono conservati per il tempo necessario all\'erogazione del servizio. Gli utenti possono richiedere accesso, rettifica o cancellazione secondo la legge applicabile.';

  @override
  String get legalPrivacySection7Title => '7. Contatti';

  @override
  String get legalPrivacySection7Body =>
      'Domande sulla privacy: support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. Ambito del servizio';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro è un\'app di produttività aziendale per la gestione di appuntamenti, clienti, media, chat interna e dati operativi.';

  @override
  String get legalTermsSection2Title => '2. Account e accesso';

  @override
  String get legalTermsSection2Body =>
      'Gli utenti sono responsabili della protezione delle credenziali e dell\'uso dell\'app solo entro i permessi assegnati al proprio ruolo.';

  @override
  String get legalTermsSection3Title => '3. Uso consentito';

  @override
  String get legalTermsSection3Body =>
      'Il servizio non deve essere utilizzato per trattamento illecito dei dati, messaggi abusivi, tentativi di accesso non autorizzati o attività che violano la legge.';

  @override
  String get legalTermsSection4Title => '4. Disponibilità';

  @override
  String get legalTermsSection4Body =>
      'Il servizio può cambiare nel tempo. Le funzioni possono essere aggiunte, modificate o rimosse con l\'evoluzione del prodotto.';

  @override
  String get legalTermsSection5Title => '5. Piani a pagamento';

  @override
  String get legalTermsSection5Body =>
      'Prima del lancio, questa sezione dovrebbe essere aggiornata con condizioni finali di fatturazione, rinnovi, periodo di prova, cancellazione e rimborsi per gli abbonamenti Google Play.';

  @override
  String get legalTermsSection6Title => '6. Limitazione di responsabilità';

  @override
  String get legalTermsSection6Body =>
      'Prima del rilascio pubblico, sostituisci questa bozza con una versione legale finale adatta alla tua giurisdizione e struttura aziendale.';

  @override
  String get legalTermsSection7Title => '7. Informazioni legali';

  @override
  String get legalTermsSection7Body =>
      'Prima della pubblicazione nello store, sostituisci questa sezione con i dati registrati della tua azienda e le informazioni sulla legge applicabile.';

  @override
  String get invoiceCompanyDataTitle => 'Dati aziendali';

  @override
  String get invoiceCompanyDataSubtitle => 'Per le fatture';

  @override
  String get invoiceCompanyName => 'Nome azienda';

  @override
  String get invoiceCompanyAddress => 'Indirizzo';

  @override
  String get invoiceCompanyPostalCode => 'CAP';

  @override
  String get invoiceCompanyCity => 'Città';

  @override
  String get invoiceGenerateButton => 'Crea fattura';

  @override
  String get invoiceVatRate => 'Aliquota IVA';

  @override
  String get settingsBookingLinkTitle => 'Link prenotazione online';

  @override
  String get settingsBookingRequestsTitle => 'Richieste online';

  @override
  String get settingsBookingLinkDialogTitle => 'Il tuo link di prenotazione';

  @override
  String get settingsBookingLinkCopied => 'Link copiato';

  @override
  String get settingsBookingLinkAuthRequired =>
      'Accedi per generare un link di prenotazione.';

  @override
  String get settingsBookingLinkOpen => 'Apri';

  @override
  String get settingsWorkingHoursTitle => 'Orari di lavoro';

  @override
  String get settingsWorkingHoursSlotLabel => 'Slot';

  @override
  String get settingsWorkingHoursMinNoticeLabel => 'Preavviso min.';

  @override
  String get settingsWorkingHoursBreakLabel => 'Pausa';

  @override
  String get settingsWorkingHoursNotice1Hour => '1 ora';

  @override
  String get settingsWorkingHoursNotice2Hours => '2 ore';

  @override
  String get settingsWorkingHoursNotice24Hours => '24 ore';

  @override
  String get bookingRequestsTitle => 'Richieste online';

  @override
  String get bookingRequestsFirebaseUnavailable =>
      'Firebase non è configurato per le prenotazioni online.';

  @override
  String get bookingRequestsSignInRequired => 'Accedi per vedere le richieste.';

  @override
  String bookingRequestsError(Object error) {
    return 'Errore durante il caricamento delle richieste: $error';
  }

  @override
  String get bookingRequestsEmpty => 'Nessuna richiesta online.';

  @override
  String get bookingRequestServiceLabel => 'Servizio';

  @override
  String get bookingRequestScheduleLabel => 'Data/ora preferita';

  @override
  String get bookingRequestPhoneLabel => 'Telefono';

  @override
  String get bookingRequestCarLabel => 'Auto';

  @override
  String get bookingRequestNoteLabel => 'Nota';

  @override
  String get bookingRequestAccept => 'Accetta';

  @override
  String get bookingRequestDecline => 'Rifiuta';

  @override
  String get bookingRequestCall => 'Chiama';

  @override
  String get bookingRequestStatusPending => 'In attesa';

  @override
  String get bookingRequestStatusAccepted => 'Accettata';

  @override
  String get bookingRequestStatusDeclined => 'Rifiutato';

  @override
  String get bookingRequestsFilterAll => 'Tutti';

  @override
  String get bookingRequestsEmptyNew => 'Nessuna nuova richiesta';

  @override
  String get bookingRequestsAcceptedFeedback =>
      'Richiesta accettata — l\'ordine verrà creato automaticamente';

  @override
  String get bookingRequestsDeclinedFeedback => 'Richiesta rifiutata';

  @override
  String get bookingRequestsDeclineConfirmContent =>
      'Rifiutare questa richiesta di prenotazione?';

  @override
  String get enterServiceName => 'Il nome del servizio è obbligatorio';

  @override
  String get invalidPrice => 'Inserisci un prezzo valido (0 o più)';

  @override
  String get invoiceTitle => 'FATTURA';

  @override
  String get invoiceNumberPrefix => 'FT';

  @override
  String get invoiceSeller => 'VENDITORE';

  @override
  String get invoiceBuyer => 'ACQUIRENTE';

  @override
  String get invoiceIssueDateLabel => 'Data di emissione';

  @override
  String get invoiceServiceDateLabel => 'Data del servizio';

  @override
  String get invoiceDescriptionLabel => 'Descrizione';

  @override
  String get invoiceQtyLabel => 'Qtà';

  @override
  String get invoiceNetPriceLabel => 'Prezzo netto';

  @override
  String get invoiceVatPctLabel => 'IVA %';

  @override
  String get invoiceVatAmountLabel => 'Importo IVA';

  @override
  String get invoiceGrossPriceLabel => 'Prezzo lordo';

  @override
  String get invoiceNetTotalLabel => 'Totale netto:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return 'IVA $rate:';
  }

  @override
  String get invoiceTotalDueLabel => 'DA PAGARE:';

  @override
  String get invoiceFillCompanyLabel => 'Compilare i dati aziendali';

  @override
  String get invoiceIssuedByLabel => 'Fattura emessa da';

  @override
  String get invoicePrimaryIdLabel => 'Partita IVA';

  @override
  String get invoiceSecondaryIdLabel => 'Codice fiscale';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total posti';
  }

  @override
  String get syncOfflineWarning =>
      'Nessuna connessione Internet. I dati potrebbero non essere aggiornati.';

  @override
  String get forceUpdateTitle => 'Aggiornamento richiesto';

  @override
  String get forceUpdateMessage =>
      'È disponibile una nuova versione dell\'app. Aggiorna Detailing Pro per continuare.';

  @override
  String get forceUpdateButton => 'Aggiorna';

  @override
  String get storageStartupTitle => 'Archiviazione locale non disponibile';

  @override
  String get storageStartupBody =>
      'Detailing Pro non ha potuto aprire il database crittografato. I dati su questo dispositivo potrebbero essere protetti o danneggiati.';

  @override
  String get storageStartupHint =>
      'Chiudi completamente l\'app e riaprila. Se il problema persiste, reinstalla l\'app (i dati cloud restano se accedi con lo stesso account).';

  @override
  String get storageStartupCloseApp => 'Chiudi app';

  @override
  String get settingsSyncStatusTitle => 'Sincronizzazione cloud';

  @override
  String settingsSyncPendingMessage(int count) {
    return '$count modifiche in attesa di sync';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return '$count modifiche non sincronizzate';
  }

  @override
  String get settingsSyncRetryButton => 'Riprova sync';

  @override
  String get settingsSyncDiscardButton => 'Elimina modifiche fallite';
}
