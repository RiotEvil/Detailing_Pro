// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return 'Versiyon $version';
  }

  @override
  String get navDashboard => 'Panel';

  @override
  String get navOrders => 'Siparişler';

  @override
  String get navClients => 'Müşteriler';

  @override
  String get navCalendar => 'Takvim';

  @override
  String get navInventory => 'Stok';

  @override
  String get navStats => 'İstatistikler';

  @override
  String get navPhotos => 'Fotoğraflar';

  @override
  String get navMarketing => 'Pazarlama';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get inventoryEmptyTitle => 'Stok boş';

  @override
  String get inventoryEmptySubtitle => 'Aşağıdaki butondan ürün ekleyin';

  @override
  String get showAllCategories => 'Kategorileri göster';

  @override
  String get chemicalsButton => 'KİMYASAL';

  @override
  String get cancel => 'İptal';

  @override
  String get add => 'Ekle';

  @override
  String get save => 'Kaydet';

  @override
  String get noOrdersTitle => 'Sipariş yok';

  @override
  String get noOrdersSubtitle => 'Başlamak için ilk siparişi ekleyin';

  @override
  String get addOrder => 'Hizmet ekle';

  @override
  String get orderButton => 'SİPARİŞ';

  @override
  String get deleteOrderTitle => 'Siparişi sil?';

  @override
  String deleteOrderMessage(Object car) {
    return '\"$car\" siparişi kalıcı olarak silinecektir.';
  }

  @override
  String deletedOrderSnack(Object car) {
    return '\"$car\" siparişi silindi';
  }

  @override
  String get undo => 'Geri al';

  @override
  String get delete => 'Sil';

  @override
  String get carLabel => 'Araç';

  @override
  String clientLabel(Object client) {
    return 'Müşteri: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return 'Hizmet: $service ($duration dk)';
  }

  @override
  String get statusScheduled => 'Randevulu';

  @override
  String get statusInProgress => 'İşlemde';

  @override
  String get statusReady => 'Hazır';

  @override
  String get statusPaid => 'Ödendi';

  @override
  String get statusCompleted => 'Tamamlandı';

  @override
  String get edit => 'Düzenle';

  @override
  String get start => 'Başlat';

  @override
  String get markDone => 'Hazır';

  @override
  String get markPaid => 'Ödendi';

  @override
  String get statusChangedTitle => 'Sipariş durumu güncellendi';

  @override
  String statusChangedMessage(Object car, Object status) {
    return '\"$car\" siparişi artık $status';
  }

  @override
  String get newChemicalTitle => 'Yeni ürün';

  @override
  String get nameLabel => 'İsim *';

  @override
  String get brandLabel => 'Marka';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get volumeLabel => 'Hacim (ml)';

  @override
  String get deleteItemTitle => 'Sil?';

  @override
  String deleteItemMessage(Object item) {
    return '\"$item\" stoktan silinsin mi?';
  }

  @override
  String get unnamedItem => 'Adsız';

  @override
  String get replenish => 'İkmal et';

  @override
  String get languageLabel => 'Dil';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get goodMorning => 'Günaydın!';

  @override
  String get goodAfternoon => 'Tünaydın!';

  @override
  String get goodEvening => 'İyi akşamlar!';

  @override
  String get statsTodayOrders => 'Bugünkü randevular';

  @override
  String get statsInWork => 'İşlemde';

  @override
  String get statsTodayRevenue => 'Bugünkü gelir';

  @override
  String get statsTotalClients => 'Müşteriler';

  @override
  String get noCars => 'Araç yok';

  @override
  String get quickActions => 'Hızlı işlemler';

  @override
  String get newOrder => 'Yeni randevu';

  @override
  String get newClient => 'Yeni müşteri';

  @override
  String get todayOrdersTitle => 'Bugünkü siparişler';

  @override
  String get calendarTitle => 'Takvim';

  @override
  String get monthJanuary => 'Ocak';

  @override
  String get monthFebruary => 'Şubat';

  @override
  String get monthMarch => 'Mart';

  @override
  String get monthApril => 'Nisan';

  @override
  String get monthMay => 'Mayıs';

  @override
  String get monthJune => 'Haziran';

  @override
  String get monthJuly => 'Temmuz';

  @override
  String get monthAugust => 'Ağustos';

  @override
  String get monthSeptember => 'Eylül';

  @override
  String get monthOctober => 'Ekim';

  @override
  String get monthNovember => 'Kasım';

  @override
  String get monthDecember => 'Aralık';

  @override
  String get statsTitle => 'İstatistikler';

  @override
  String get statsRevenue => 'Gelir';

  @override
  String get statsOrders => 'Siparişler';

  @override
  String get statsPeriodWeek => 'Hafta';

  @override
  String get statsPeriodMonth => 'Ay';

  @override
  String get statsPeriodYear => 'Yıl';

  @override
  String get photosTitle => 'Fotoğraflar';

  @override
  String get orderBeforePhotosTitle => 'Önce';

  @override
  String get orderAfterPhotosTitle => 'Sonra';

  @override
  String get photosAdd => 'Fotoğraf ekle';

  @override
  String get photosEmpty => 'Henüz fotoğraf yok';

  @override
  String get photosSelectCar => 'Araç seçin';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get visits => 'Ziyaretler';

  @override
  String get totalSpent => 'Toplam harcama';

  @override
  String get orderHistoryTitle => 'Sipariş geçmişi';

  @override
  String get orderHistoryEmpty => 'Geçmiş boş';

  @override
  String get call => 'Ara';

  @override
  String get message => 'Mesaj yaz';

  @override
  String get photoReport => 'Foto rapor';

  @override
  String get photosNotAdded => 'Fotoğraf eklenmedi';

  @override
  String get editOrderTitle => 'Siparişi düzenle';

  @override
  String get newOrderTitle => 'Yeni sipariş';

  @override
  String get clientFieldLabel => 'Müşteri *';

  @override
  String get selectClient => 'Müşteri seçin';

  @override
  String get carHint => 'Model ve plaka';

  @override
  String get enterCar => 'Araç belirtin';

  @override
  String get serviceFieldLabel => 'Hizmet *';

  @override
  String get selectService => 'Hizmet seçin';

  @override
  String get orderMaterialCostLabel => 'Malzeme maliyeti';

  @override
  String get orderLaborCostLabel => 'İşçilik maliyeti';

  @override
  String get orderTotalCostLabel => 'Toplam maliyet';

  @override
  String get orderProfitLabel => 'Kar';

  @override
  String get statsProfit => 'Kar';

  @override
  String get orderNotesLabel => 'Sipariş notları';

  @override
  String get createOrderButton => 'Sipariş oluştur';

  @override
  String get orderUpdated => 'Sipariş güncellendi';

  @override
  String get orderCreated => 'Sipariş başarıyla oluşturuldu';

  @override
  String errorMessage(Object error) {
    return 'Hata: $error';
  }

  @override
  String get editClient => 'Müşteriyi düzenle';

  @override
  String get clientNameLabel => 'Müşteri adı *';

  @override
  String get enterName => 'İsim girin';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get phoneHint => '+90 (___) ___ __ __';

  @override
  String get enterValidPhone => 'Geçerli numara girin';

  @override
  String get carsLabel => 'Araçlar *';

  @override
  String get addCar => 'Ekle';

  @override
  String get addAtLeastOneCar => 'En az bir araç ekleyin';

  @override
  String get addCarDialogTitle => 'Araç ekle';

  @override
  String get carExample => 'Örn: BMW X5 34 ABC 123';

  @override
  String get carAlreadyAdded => 'Zaten eklendi';

  @override
  String get saveChanges => 'Değişiklikleri kaydet';

  @override
  String get saveClient => 'Müşteriyi kaydet';

  @override
  String get clientUpdated => 'Müşteri güncellendi';

  @override
  String get clientAdded => 'Müşteri eklendi';

  @override
  String get otherCategory => 'Diğer';

  @override
  String replenishItemTitle(Object item) {
    return '\"$item\" ikmali yap';
  }

  @override
  String get howManyToAdd => 'Ne kadar eklenecek?';

  @override
  String get ml => 'ml';

  @override
  String currentStockTitle(Object item) {
    return 'Stok: \"$item\"';
  }

  @override
  String get currentStockLabel => 'Mevcut miktar';

  @override
  String get inactiveClients => 'Aktif olmayan müşteriler';

  @override
  String get promotions => 'Promosyonlar';

  @override
  String get promotionsDescription => 'Müşteri çekmek için kampanya oluşturun';

  @override
  String get loyaltyProgram => 'Sadakat programı';

  @override
  String get loyaltyDescription => 'Düzenli müşterileri ödüllendirin';

  @override
  String get smsBroadcast => 'SMS gönderimi';

  @override
  String get smsDescription => 'Hatırlatıcı ve haber gönderin';

  @override
  String get reviews => 'Değerlendirmeler';

  @override
  String get reviewsDescription => 'Geri bildirim toplayın';

  @override
  String get comingSoon => 'Yakında';

  @override
  String get gotIt => 'Anladım';

  @override
  String get ordersChannelName => 'Siparişler';

  @override
  String get ordersChannelDescription => 'Sipariş bildirimleri';

  @override
  String get currencyLabel => 'Para Birimi';

  @override
  String get searchClientsHint => 'Müşteri veya araç ara...';

  @override
  String get crmFilterAll => 'Tümü';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => 'Risk altında';

  @override
  String get crmFilterInactive => 'Pasif';

  @override
  String get crmTagsLabel => 'Etiketler';

  @override
  String get crmTagsHint => 'VIP, filo, referans';

  @override
  String get crmSegmentLabel => 'Segment';

  @override
  String get crmLastVisitLabel => 'Son ziyaret';

  @override
  String get crmAtRiskLabel => 'Takip gerekli';

  @override
  String get crmReminderButton => 'Hatırlatma gönder';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return 'Merhaba, $client! Detailing stüdyosundan dostça bir hatırlatma. Sizi $service için uygun bir zamana randevu edebiliriz.';
  }

  @override
  String get crmBulkReminderButton => 'CRM kampanyası';

  @override
  String get crmBulkReminderTitle => 'Alıcıları seçin';

  @override
  String get crmBulkReminderToggleAll => 'Tümü';

  @override
  String get crmBulkReminderSendSelected => 'Seçilenlere gönder';

  @override
  String get crmBulkReminderEmpty => 'Bu listede telefonu olan müşteri yok.';

  @override
  String get crmBulkReminderTemplate =>
      'Merhaba! Detailing stüdyosundan bir hatırlatma. Bir sonraki hizmetiniz için uygun bir zamana randevu alabilirsiniz.';

  @override
  String get crmSegmentNew => 'Yeni';

  @override
  String get crmSegmentReturning => 'Geri gelen';

  @override
  String get crmSegmentLoyal => 'Sadık';

  @override
  String get clientsNotFound => 'Müşteri bulunamadı';

  @override
  String get openCallFailed => 'Arama açılamadı.';

  @override
  String get openWhatsAppFailed => 'SMS uygulaması açılamadı.';

  @override
  String get sortTooltip => 'Sırala';

  @override
  String get sortByNameAsc => 'Ad: A-Z';

  @override
  String get sortByNameDesc => 'Ad: Z-A';

  @override
  String get sortByNewest => 'Önce yeniler';

  @override
  String get permissionDeniedTitle => 'Erişim reddedildi';

  @override
  String get permissionCreateOrderDenied => 'Sipariş oluşturma yetkiniz yok.';

  @override
  String get permissionDeleteOrderDenied =>
      'Sipariş silme yalnızca yönetici/sahip için geçerlidir.';

  @override
  String get permissionEditOrderDenied => 'Sipariş düzenleme yetkiniz yok.';

  @override
  String get permissionSaveOrderDenied => 'Siparişi kaydetme yetkiniz yok.';

  @override
  String get permissionCreateClientDenied => 'Müşteri oluşturma yetkiniz yok.';

  @override
  String get permissionDeleteClientDenied => 'Müşteri silme yetkiniz yok.';

  @override
  String get permissionEditClientDenied => 'Müşteri düzenleme yetkiniz yok.';

  @override
  String get permissionSaveClientDenied => 'Müşteriyi kaydetme yetkiniz yok.';

  @override
  String get permissionModifyInventoryDenied =>
      'Stok değişikliği için yetkiniz yok.';

  @override
  String get permissionEditInventoryStockDenied =>
      'Stok miktarını değiştirme yetkiniz yok.';

  @override
  String get permissionEditInventoryDenied => 'Stok düzenleme yetkiniz yok.';

  @override
  String get clientDeleted => 'Müşteri silindi';

  @override
  String get clientGarageTitle => 'Müşteri garajı';

  @override
  String get navTeamChats => 'Ekip sohbetleri';

  @override
  String get navCommunityChat => 'Topluluk sohbeti';

  @override
  String get orderDefaultTitle => 'Sipariş';

  @override
  String get completeOrderAndConsumePrompt =>
      'İşi tamamlayıp kimyasalları stoktan düşmek istiyor musunuz?';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: Tamamlandı';
  }

  @override
  String get appointmentReminderTitle => 'Yaklaşan randevu';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car saat $time';
  }

  @override
  String get inventoryFirstItemHint =>
      'İlk stok kalemini ekleyin: kimyasal, sarf malzemesi, aksesuar veya ekipman.';

  @override
  String get inventoryFilteredEmpty => 'Seçili filtreler için ürün bulunamadı.';

  @override
  String get inventoryItemLabel => 'ÜRÜN';

  @override
  String inventoryLowStockMore(Object count) {
    return ' ve $count tane daha';
  }

  @override
  String get inventoryLowStockTitle => 'Düşük stok';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items dikkat gerektiriyor.';
  }

  @override
  String get inventoryNotificationsChannelName => 'Stok uyarıları';

  @override
  String get inventoryNotificationsChannelDescription =>
      'Düşük stok bildirimleri';

  @override
  String get inventoryEditItemTitle => 'Ürünü düzenle';

  @override
  String get inventoryNewItemTitle => 'Yeni stok ürünü';

  @override
  String get inventoryItemTypeLabel => 'Ürün tipi';

  @override
  String get inventoryUnitLabel => 'Birim';

  @override
  String get inventoryCurrentStockLabel => 'Mevcut stok';

  @override
  String get inventoryMinStockLabel => 'Minimum stok';

  @override
  String get inventoryLocationLabel => 'Depolama yeri';

  @override
  String get inventoryUsageLabel => 'Kullanım';

  @override
  String inventoryLowStockCount(Object count) {
    return 'Düşük stok: $count';
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
  String get inventoryAllTypes => 'Tüm tipler';

  @override
  String get inventoryBelowMin => 'Minimumun altında';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return 'Min: $minStock $unit';
  }

  @override
  String get chatProfileSaved => 'Sohbet profili kaydedildi';

  @override
  String get chatUnavailableShort =>
      'Firebase yapılandırılmamış. Sohbet geçici olarak kullanılamıyor.';

  @override
  String get chatCreateDialogTitle => 'Yeni diyalog';

  @override
  String get chatCreateExternalTitle => 'Yeni dış sohbet';

  @override
  String get chatPeerIdLabelTeam => 'Usta ID';

  @override
  String get chatPeerIdLabelExternal => 'Stüdyo/Usta ID';

  @override
  String get chatPeerNameLabelTeam => 'Usta adı';

  @override
  String get chatPeerNameLabelExternal => 'Stüdyo veya usta adı';

  @override
  String get chatCreateAction => 'Oluştur';

  @override
  String get chatDialogTitle => 'Diyalog';

  @override
  String get chatScreenTitleTeam => 'Dahili ekip sohbeti';

  @override
  String get chatScreenTitleExternal => 'Harici topluluk sohbeti';

  @override
  String get chatNewChatButton => 'Yeni sohbet';

  @override
  String get chatMyIdLabel => 'ID\'niz';

  @override
  String get chatMyIdHint => 'Örneğin: master_001';

  @override
  String get chatMyNameLabel => 'Adınız';

  @override
  String get chatMyNameHint => 'Örneğin: Alex';

  @override
  String get chatUnavailableTitle => 'Sohbet geçici olarak kullanılamıyor';

  @override
  String get chatUnavailableSubtitle =>
      'Bu derleme için Firebase yapılandırılmamış. Firebase ayarlarını ekleyin.';

  @override
  String get chatProfileFillTitleTeam => 'Sohbet profilinizi doldurun';

  @override
  String get chatProfileFillTitleExternal => 'Topluluk profilinizi doldurun';

  @override
  String get chatProfileFillSubtitleTeam =>
      'ID ve adınızı girin, ardından Kaydet\'e basın.';

  @override
  String get chatProfileFillSubtitleExternal =>
      'Diğer stüdyolar ve ustalarla sohbet etmek için ID ve adınızı girin.';

  @override
  String get chatErrorTitle => 'Sohbet kullanılamıyor';

  @override
  String get chatErrorSubtitle =>
      'Firebase kurulumunu kontrol edin (google-services ve Firebase.initializeApp).';

  @override
  String get chatEmptyTitle => 'Henüz diyalog yok';

  @override
  String get chatEmptySubtitle =>
      'Yeni sohbet düğmesiyle ilk sohbeti oluşturun.';

  @override
  String get chatNoMessages => 'Henüz mesaj yok';

  @override
  String get chatOpenAfterFirebase =>
      'Firebase yapılandırılmamış. Firebase kurulumundan sonra sohbeti açın.';

  @override
  String get chatConnectionError => 'Sohbet bağlantı hatası';

  @override
  String get chatMessageHint => 'Mesaj yazın';

  @override
  String get chatAttachPhoto => 'Fotoğraf ekle';

  @override
  String get chatAttachFile => 'Dosya ekle';

  @override
  String get chatAttachmentFile => 'Dosya';

  @override
  String get chatFileOpenFailed => 'Dosya açılamadı.';

  @override
  String chatUploadFailed(Object error) {
    return 'Yükleme hatası: $error';
  }

  @override
  String get durationMinutesShort => 'dk';

  @override
  String get inventoryTypeChemistry => 'Kimyasal';

  @override
  String get inventoryTypeConsumable => 'Sarf malzemesi';

  @override
  String get inventoryTypeAccessory => 'Aksesuar';

  @override
  String get inventoryTypeEquipment => 'Ekipman';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get authEnterEmail => 'E-posta girin';

  @override
  String get authInvalidEmail => 'Geçersiz e-posta';

  @override
  String get authEnterPassword => 'Şifre girin';

  @override
  String get authPasswordMin => 'En az 8 karakter';

  @override
  String get authFirebaseGuestOnly =>
      'Firebase yapılandırılmadı. Misafir modu kullanılabilir.';

  @override
  String get authSignInFailed => 'Giriş yapılamadı. Lütfen tekrar deneyin.';

  @override
  String get authPasswordsMismatch => 'Şifreler eşleşmiyor';

  @override
  String get authJoinSuccess => 'Takıma başarıyla katıldınız!';

  @override
  String authInviteRejected(Object error) {
    return 'Kayıt tamamlandı, ancak davet kodu reddedildi: $error';
  }

  @override
  String get authRegisterFailed =>
      'Kayıt tamamlanamadı. Lütfen tekrar deneyin.';

  @override
  String get authGuestName => 'Misafir';

  @override
  String get authGoogleSoon => 'Google ile giriş daha sonra eklenecek';

  @override
  String get authInvalidEmailFormat => 'Geçersiz e-posta formatı';

  @override
  String get authWrongCredentials => 'E-posta veya şifre hatalı';

  @override
  String get authEmailInUse => 'Bu e-posta zaten kullanılıyor';

  @override
  String get authWeakPassword => 'Şifre çok zayıf';

  @override
  String get authTooManyRequests =>
      'Çok fazla deneme. Daha sonra tekrar deneyin';

  @override
  String get authAuthorizationError => 'Yetkilendirme hatası';

  @override
  String get authWelcome => 'Hoş geldiniz';

  @override
  String get authSubtitle => 'Hesabınıza giriş yapın veya kayıt olun';

  @override
  String get authTabSignIn => 'Giriş';

  @override
  String get authTabRegister => 'Kayıt';

  @override
  String get authContinueWithGoogle => 'Google ile devam et';

  @override
  String get authContinueAsGuest => 'Misafir olarak devam et';

  @override
  String get authPasswordLabel => 'Şifre';

  @override
  String get authConfirmPasswordLabel => 'Şifreyi doğrula';

  @override
  String get authInviteCodeOptional => 'Davet kodu (isteğe bağlı)';

  @override
  String get authInviteHint => 'Eğer yönetici sizi davet ettiyse';

  @override
  String get authRegisterButton => 'Kayıt ol';

  @override
  String get businessModeQuestion => 'Nasıl çalışıyorsunuz?';

  @override
  String get businessModeSubtitle =>
      'Uygulamanın yalnızca gerekli modülleri göstermesi için bir mod seçin.';

  @override
  String get businessModeSoloTitle => 'Tek başıma çalışıyorum';

  @override
  String get businessModeSoloSubtitle =>
      'Bireysel uzman için: siparişler, müşteriler, stok, finans ve dış sohbet.';

  @override
  String get businessModeTeamTitle => 'Bir ekibimiz var';

  @override
  String get businessModeTeamSubtitle =>
      'Stüdyo için: personel rolleri, iç sohbet, uzman bazlı görevler ve yönetici kontrolü.';

  @override
  String get photosGallerySaveFailed =>
      'Fotoğraf uygulamaya eklendi, ancak galeriye kaydedilemedi.';

  @override
  String get photosCameraUnsupported =>
      'Kamera yalnızca Android/iOS veya web sürümünde kullanılabilir.';

  @override
  String get photosAddedAndSaved => 'Fotoğraf eklendi ve galeriye kaydedildi.';

  @override
  String get photosAddedFromGallery => 'Fotoğraf galeriden eklendi.';

  @override
  String get photosAddFromGallery => 'Galeriden ekle';

  @override
  String get photosTakePhoto => 'Fotoğraf çek';

  @override
  String get photosDeleteDenied => 'Fotoğrafı silmek için yeterli yetki yok.';

  @override
  String get settingsProfileAndOrgTitle => 'Profil ve kuruluş';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => 'Misafir';

  @override
  String get settingsBusinessModeTitle => 'Çalışma modu';

  @override
  String get settingsUserRoleTitle => 'Kullanıcı rolü';

  @override
  String get settingsInviteMasterTitle => 'Usta davet et';

  @override
  String get settingsInviteMasterSubtitle =>
      'Tek kullanımlık davet kodu oluştur';

  @override
  String get settingsServicesSection => 'Hizmetler';

  @override
  String get settingsLogoutButton => 'Oturumu kapat';

  @override
  String get settingsBusinessModeTeam => 'Ekip (stüdyo)';

  @override
  String get settingsBusinessModeSolo => 'Solo (tek usta)';

  @override
  String get settingsRoleDirector => 'Yönetici';

  @override
  String get settingsRoleMaster => 'Usta';

  @override
  String get settingsRoleMasterOwner => 'Sahip usta';

  @override
  String get settingsSelectModeTitle => 'Mod seçin';

  @override
  String get settingsModeSoloTitle => 'Solo';

  @override
  String get settingsModeSoloSubtitle => 'Tek usta';

  @override
  String get settingsModeTeamTitle => 'Ekip';

  @override
  String get settingsModeTeamSubtitle => 'Çalışanlı stüdyo';

  @override
  String get settingsModeUpdated => 'Mod güncellendi.';

  @override
  String get settingsOrgNotFound =>
      'Kuruluş bulunamadı. Önce ayarları kaydedin.';

  @override
  String settingsInviteGenerateError(Object error) {
    return 'Kod oluşturma hatası: $error';
  }

  @override
  String get settingsInviteDialogTitle => 'Usta için davet kodu';

  @override
  String get settingsInviteDialogDescription =>
      'Bu kodu ustaya gönderin. Kod tek kullanımlıktır ve kullanıldıktan sonra geçersiz olur.';

  @override
  String get settingsCopy => 'Kopyala';

  @override
  String get settingsCodeCopied => 'Kod panoya kopyalandı';

  @override
  String get settingsInviteRegistrationHint =>
      'Usta, kayıt sırasında Davet kodu alanına bu kodu girer.';

  @override
  String get settingsClose => 'Kapat';

  @override
  String get settingsSelectRoleTitle => 'Rol seçin';

  @override
  String get settingsRoleUpdated => 'Rol güncellendi.';

  @override
  String get settingsLogoutTitle => 'Çıkış';

  @override
  String get settingsLogoutMessage => 'Mevcut hesaptan çıkılsın mı?';

  @override
  String get settingsLogoutConfirm => 'Çıkış';

  @override
  String get settingsLoggedOut => 'Hesaptan çıkış yapıldı.';

  @override
  String get settingsAccessDenied => 'Bu işlem için yeterli yetki yok.';

  @override
  String get settingsResetWarning =>
      'UYARI: Tüm siparişler, müşteriler ve stok silinecek!';

  @override
  String get settingsServiceDeleteDenied =>
      'Hizmeti silmek için yeterli yetki yok.';

  @override
  String get settingsServiceEditDenied =>
      'Hizmeti düzenlemek için yeterli yetki yok.';

  @override
  String get legalTitle => 'Yasal Bilgiler';

  @override
  String get legalPrivacyTab => 'Gizlilik Politikası';

  @override
  String get legalTermsTab => 'Kullanım Şartları';

  @override
  String get legalPrivacySummaryTitle => 'Gizlilik Politikası Özeti';

  @override
  String get legalTermsSummaryTitle => 'Hizmet Şartları Özeti';

  @override
  String get legalSummarySubtitle =>
      'Uygulama içi kısa özet. Tam yasal metin yayımlanan sayfada mevcuttur.';

  @override
  String get legalOpenFullPrivacy => 'Tam gizlilik politikasını aç';

  @override
  String get legalOpenFullTerms => 'Tam şartları aç';

  @override
  String get legalOpenLinkError => 'Belge bağlantısı açılamadı.';

  @override
  String get legalPrivacySection1Title => '1. Uygulama ne yapar';

  @override
  String get legalPrivacySection1Body =>
      'DetailingPro Business, detailing ekiplerinin müşterileri, siparişleri, programları, stokları, ekip sohbetini ve ekli medyayı yönetmesine yardımcı olur.';

  @override
  String get legalPrivacySection2Title => '2. İşlediğimiz veriler';

  @override
  String get legalPrivacySection2Body =>
      'Uygulama hesap verilerini, müşteri ve sipariş verilerini, hizmet kayıtlarını, stok kayıtlarını, ekip mesajlarını, ekleri ve bildirim belirteçleri gibi teknik tanımlayıcıları işleyebilir.';

  @override
  String get legalPrivacySection3Title => '3. Bu veriler neden kullanılır';

  @override
  String get legalPrivacySection3Body =>
      'Veriler temel özellikleri çalıştırmak, cihazlar arasında senkronizasyon sağlamak, hatırlatmalar göndermek, iş birliğini desteklemek ve hizmet güvenilirliği ile güvenliğini korumak için kullanılır.';

  @override
  String get legalPrivacySection4Title => '4. İzinler ve erişim';

  @override
  String get legalPrivacySection4Body =>
      'Kamera ve medya izinleri yalnızca fotoğraf ve dosya ekleri gibi özellikler için istenir. Bildirim izni hatırlatmalar ve anlık bildirimler için kullanılır.';

  @override
  String get legalPrivacySection5Title => '5. Altyapı ve sağlayıcılar';

  @override
  String get legalPrivacySection5Body =>
      'Uygulama Firebase servislerini kullanır (Authentication, Firestore, Storage, Messaging). Veriler bu sağlayıcıların altyapısında işlenir.';

  @override
  String get legalPrivacySection6Title => '6. Saklama, silme ve haklar';

  @override
  String get legalPrivacySection6Body =>
      'Veriler hizmeti sunmak için gerekli olduğu sürece saklanır. Kullanıcılar, yürürlükteki yasalara göre erişim, düzeltme veya silme talebinde bulunabilir.';

  @override
  String get legalPrivacySection7Title => '7. İletişim';

  @override
  String get legalPrivacySection7Body =>
      'Gizlilik soruları: support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. Hizmet kapsamı';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro, randevuları, müşterileri, medyayı, dahili sohbeti ve operasyonel verileri yönetmek için kullanılan bir iş üretkenliği uygulamasıdır.';

  @override
  String get legalTermsSection2Title => '2. Hesaplar ve erişim';

  @override
  String get legalTermsSection2Body =>
      'Kullanıcılar giriş bilgilerini güvenli tutmaktan ve uygulamayı yalnızca rollerine verilen izinler kapsamında kullanmaktan sorumludur.';

  @override
  String get legalTermsSection3Title => '3. Kabul edilebilir kullanım';

  @override
  String get legalTermsSection3Body =>
      'Hizmet; yasa dışı veri işleme, kötüye kullanım amaçlı mesajlaşma, yetkisiz erişim girişimleri veya yasaları ihlal eden faaliyetler için kullanılmamalıdır.';

  @override
  String get legalTermsSection4Title => '4. Erişilebilirlik';

  @override
  String get legalTermsSection4Body =>
      'Hizmet zaman içinde değişebilir. Ürün geliştikçe özellikler eklenebilir, değiştirilebilir veya kaldırılabilir.';

  @override
  String get legalTermsSection5Title => '5. Ücretli planlar';

  @override
  String get legalTermsSection5Body =>
      'Yayınlamadan önce bu bölüm; nihai ücretlendirme koşulları, yenileme kuralları, deneme ayrıntıları, iptal koşulları ve Google Play abonelikleri için iade süreçleriyle güncellenmelidir.';

  @override
  String get legalTermsSection6Title => '6. Sorumluluğun sınırlandırılması';

  @override
  String get legalTermsSection6Body =>
      'Genel yayından önce bu taslağı, yargı bölgenize ve işletme yapınıza uygun nihai bir hukuki metinle değiştirin.';

  @override
  String get legalTermsSection7Title => '7. Hukuki bilgiler';

  @override
  String get legalTermsSection7Body =>
      'Mağazada yayınlamadan önce bu bölümü işletmenizin kayıtlı bilgileri ve uygulanacak hukuk bilgileriyle değiştirin.';

  @override
  String get invoiceCompanyDataTitle => 'Şirket bilgileri';

  @override
  String get invoiceCompanyDataSubtitle => 'Faturalar için';

  @override
  String get invoiceCompanyName => 'Şirket adı';

  @override
  String get invoiceCompanyAddress => 'Adres';

  @override
  String get invoiceCompanyPostalCode => 'Posta kodu';

  @override
  String get invoiceCompanyCity => 'Şehir';

  @override
  String get invoiceGenerateButton => 'Fatura oluştur';

  @override
  String get invoiceVatRate => 'KDV oranı';

  @override
  String get settingsBookingLinkTitle => 'Online rezervasyon bağlantısı';

  @override
  String get settingsBookingRequestsTitle => 'Online rezervasyonlar';

  @override
  String get settingsBookingLinkDialogTitle => 'Rezervasyon bağlantınız';

  @override
  String get settingsBookingLinkCopied => 'Bağlantı kopyalandı';

  @override
  String get settingsBookingLinkAuthRequired =>
      'Rezervasyon bağlantısı oluşturmak için giriş yapın.';

  @override
  String get settingsBookingLinkOpen => 'Aç';

  @override
  String get settingsWorkingHoursTitle => 'Çalışma saatleri';

  @override
  String get settingsWorkingHoursSlotLabel => 'Aralık';

  @override
  String get settingsWorkingHoursMinNoticeLabel => 'Min. bildirim';

  @override
  String get settingsWorkingHoursBreakLabel => 'Mola';

  @override
  String get settingsWorkingHoursNotice1Hour => '1 saat';

  @override
  String get settingsWorkingHoursNotice2Hours => '2 saat';

  @override
  String get settingsWorkingHoursNotice24Hours => '24 saat';

  @override
  String get bookingRequestsTitle => 'Online rezervasyonlar';

  @override
  String get bookingRequestsFirebaseUnavailable =>
      'Firebase online rezervasyon için yapılandırılmamış.';

  @override
  String get bookingRequestsSignInRequired =>
      'Rezervasyonları görmek için giriş yapın.';

  @override
  String bookingRequestsError(Object error) {
    return 'Rezervasyonlar yüklenemedi: $error';
  }

  @override
  String get bookingRequestsEmpty => 'Henüz online rezervasyon yok.';

  @override
  String get bookingRequestServiceLabel => 'Hizmet';

  @override
  String get bookingRequestScheduleLabel => 'Tercih edilen tarih/saat';

  @override
  String get bookingRequestPhoneLabel => 'Telefon';

  @override
  String get bookingRequestCarLabel => 'Araç';

  @override
  String get bookingRequestNoteLabel => 'Not';

  @override
  String get bookingRequestAccept => 'Kabul et';

  @override
  String get bookingRequestDecline => 'Reddet';

  @override
  String get bookingRequestCall => 'Ara';

  @override
  String get bookingRequestStatusPending => 'Bekliyor';

  @override
  String get bookingRequestStatusAccepted => 'Kabul edildi';

  @override
  String get bookingRequestStatusDeclined => 'Reddedildi';

  @override
  String get bookingRequestsFilterAll => 'Tümü';

  @override
  String get bookingRequestsEmptyNew => 'Yeni talep yok';

  @override
  String get bookingRequestsAcceptedFeedback =>
      'Talep kabul edildi — sipariş otomatik olarak oluşturulacak';

  @override
  String get bookingRequestsDeclinedFeedback => 'Talep reddedildi';

  @override
  String get bookingRequestsDeclineConfirmContent =>
      'Bu rezervasyon talebini reddet?';

  @override
  String get enterServiceName => 'Hizmet adı gereklidir';

  @override
  String get invalidPrice => 'Geçerli fiyat girin (0 veya daha fazla)';

  @override
  String get invoiceTitle => 'FATURA';

  @override
  String get invoiceNumberPrefix => 'FT';

  @override
  String get invoiceSeller => 'SATICI';

  @override
  String get invoiceBuyer => 'ALICI';

  @override
  String get invoiceIssueDateLabel => 'Düzenleme tarihi';

  @override
  String get invoiceServiceDateLabel => 'Hizmet tarihi';

  @override
  String get invoiceDescriptionLabel => 'Açıklama';

  @override
  String get invoiceQtyLabel => 'Adet';

  @override
  String get invoiceNetPriceLabel => 'Net fiyat';

  @override
  String get invoiceVatPctLabel => 'KDV %';

  @override
  String get invoiceVatAmountLabel => 'KDV tutarı';

  @override
  String get invoiceGrossPriceLabel => 'Brüt fiyat';

  @override
  String get invoiceNetTotalLabel => 'Net toplam:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return 'KDV $rate:';
  }

  @override
  String get invoiceTotalDueLabel => 'ÖDENECEK:';

  @override
  String get invoiceFillCompanyLabel => 'Şirket bilgilerini doldurun';

  @override
  String get invoiceIssuedByLabel => 'Tarafından düzenlendi';

  @override
  String get invoicePrimaryIdLabel => 'Vergi No';

  @override
  String get invoiceSecondaryIdLabel => 'Şirket sicil no';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total kişi';
  }

  @override
  String get syncOfflineWarning =>
      'İnternet bağlantısı yok. Veriler güncel olmayabilir.';

  @override
  String get forceUpdateTitle => 'Güncelleme gerekli';

  @override
  String get forceUpdateMessage =>
      'Uygulamanın yeni bir sürümü var. Devam etmek için Detailing Pro\'yu güncelleyin.';

  @override
  String get forceUpdateButton => 'Güncelle';

  @override
  String get storageStartupTitle => 'Yerel depolama kullanılamıyor';

  @override
  String get storageStartupBody =>
      'Detailing Pro şifreli veritabanını açamadı. Bu cihazdaki veriler korunuyor veya bozulmuş olabilir.';

  @override
  String get storageStartupHint =>
      'Uygulamayı tamamen kapatıp yeniden açın. Sorun devam ederse uygulamayı yeniden yükleyin (aynı hesapla giriş yaparsanız bulut verileri kalır).';

  @override
  String get storageStartupCloseApp => 'Uygulamayı kapat';

  @override
  String get settingsSyncStatusTitle => 'Bulut senkronizasyonu';

  @override
  String settingsSyncPendingMessage(int count) {
    return 'Senkronize edilmeyi bekleyen $count değişiklik';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return '$count değişiklik buluta senkronize edilemedi';
  }

  @override
  String get settingsSyncRetryButton => 'Senkronizasyonu tekrar dene';

  @override
  String get settingsSyncDiscardButton => 'Başarısız değişiklikleri sil';
}
