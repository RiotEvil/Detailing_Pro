// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return 'Versión $version';
  }

  @override
  String get navDashboard => 'Panel';

  @override
  String get navOrders => 'Pedidos';

  @override
  String get navClients => 'Clientes';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navInventory => 'Inventario';

  @override
  String get navStats => 'Estadísticas';

  @override
  String get navPhotos => 'Fotos';

  @override
  String get navMarketing => 'Marketing';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get inventoryEmptyTitle => 'Inventario vacío';

  @override
  String get inventoryEmptySubtitle => 'Añade productos con el botón de abajo';

  @override
  String get showAllCategories => 'Ver categorías';

  @override
  String get chemicalsButton => 'QUÍMICA';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Añadir';

  @override
  String get save => 'Guardar';

  @override
  String get noOrdersTitle => 'Sin pedidos';

  @override
  String get noOrdersSubtitle => 'Añade el primer pedido para empezar';

  @override
  String get addOrder => 'Añadir servicio';

  @override
  String get orderButton => 'PEDIDO';

  @override
  String get deleteOrderTitle => '¿Eliminar pedido?';

  @override
  String deleteOrderMessage(Object car) {
    return 'El pedido \"$car\" se eliminará permanentemente.';
  }

  @override
  String deletedOrderSnack(Object car) {
    return 'Pedido \"$car\" eliminado';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get delete => 'Eliminar';

  @override
  String get carLabel => 'Coche';

  @override
  String clientLabel(Object client) {
    return 'Cliente: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return 'Servicio: $service ($duration min)';
  }

  @override
  String get statusScheduled => 'Agendado';

  @override
  String get statusInProgress => 'En curso';

  @override
  String get statusReady => 'Listo';

  @override
  String get statusPaid => 'Pagado';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get edit => 'Editar';

  @override
  String get start => 'Iniciar';

  @override
  String get markDone => 'Listo';

  @override
  String get markPaid => 'Pagado';

  @override
  String get statusChangedTitle => 'Estado del pedido actualizado';

  @override
  String statusChangedMessage(Object car, Object status) {
    return 'El pedido \"$car\" ahora está $status';
  }

  @override
  String get newChemicalTitle => 'Nuevo producto';

  @override
  String get nameLabel => 'Nombre *';

  @override
  String get brandLabel => 'Marca';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get volumeLabel => 'Volumen (ml)';

  @override
  String get deleteItemTitle => '¿Eliminar?';

  @override
  String deleteItemMessage(Object item) {
    return '¿Eliminar \"$item\" del inventario?';
  }

  @override
  String get unnamedItem => 'Sin nombre';

  @override
  String get replenish => 'Reponer';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get goodMorning => '¡Buenos días!';

  @override
  String get goodAfternoon => '¡Buenas tardes!';

  @override
  String get goodEvening => '¡Buenas noches!';

  @override
  String get statsTodayOrders => 'Citas de hoy';

  @override
  String get statsInWork => 'En trabajo';

  @override
  String get statsTodayRevenue => 'Ingresos hoy';

  @override
  String get statsTotalClients => 'Clientes';

  @override
  String get noCars => 'Sin coches';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get newOrder => 'Nueva cita';

  @override
  String get newClient => 'Nuevo cliente';

  @override
  String get todayOrdersTitle => 'Pedidos de hoy';

  @override
  String get calendarTitle => 'Calendario';

  @override
  String get monthJanuary => 'Enero';

  @override
  String get monthFebruary => 'Febrero';

  @override
  String get monthMarch => 'Marzo';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Mayo';

  @override
  String get monthJune => 'Junio';

  @override
  String get monthJuly => 'Julio';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Septiembre';

  @override
  String get monthOctober => 'Octubre';

  @override
  String get monthNovember => 'Noviembre';

  @override
  String get monthDecember => 'Diciembre';

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String get statsRevenue => 'Ingresos';

  @override
  String get statsOrders => 'Pedidos';

  @override
  String get statsPeriodWeek => 'Semana';

  @override
  String get statsPeriodMonth => 'Mes';

  @override
  String get statsPeriodYear => 'Año';

  @override
  String get photosTitle => 'Fotos';

  @override
  String get orderBeforePhotosTitle => 'Antes';

  @override
  String get orderAfterPhotosTitle => 'Después';

  @override
  String get photosAdd => 'Añadir foto';

  @override
  String get photosEmpty => 'Sin fotos aún';

  @override
  String get photosSelectCar => 'Selecciona el coche';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get visits => 'Visitas';

  @override
  String get totalSpent => 'Gasto total';

  @override
  String get orderHistoryTitle => 'Historial de pedidos';

  @override
  String get orderHistoryEmpty => 'Historial vacío';

  @override
  String get call => 'Llamar';

  @override
  String get message => 'Escribir';

  @override
  String get photoReport => 'Informe de fotos';

  @override
  String get photosNotAdded => 'Sin fotos añadidas';

  @override
  String get editOrderTitle => 'Editar pedido';

  @override
  String get newOrderTitle => 'Nuevo pedido';

  @override
  String get clientFieldLabel => 'Cliente *';

  @override
  String get selectClient => 'Elige cliente';

  @override
  String get carHint => 'Modelo y matrícula';

  @override
  String get enterCar => 'Indica coche';

  @override
  String get serviceFieldLabel => 'Servicio *';

  @override
  String get selectService => 'Elige servicio';

  @override
  String get orderMaterialCostLabel => 'Coste de materiales';

  @override
  String get orderLaborCostLabel => 'Coste de mano de obra';

  @override
  String get orderTotalCostLabel => 'Coste total';

  @override
  String get orderProfitLabel => 'Beneficio';

  @override
  String get statsProfit => 'Beneficio';

  @override
  String get orderNotesLabel => 'Notas';

  @override
  String get createOrderButton => 'Crear pedido';

  @override
  String get orderUpdated => 'Pedido actualizado';

  @override
  String get orderCreated => 'Pedido creado con éxito';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get editClient => 'Editar cliente';

  @override
  String get clientNameLabel => 'Nombre del cliente *';

  @override
  String get enterName => 'Introduce nombre';

  @override
  String get phoneLabel => 'Teléfono';

  @override
  String get phoneHint => '+34 ___ ___ ___';

  @override
  String get enterValidPhone => 'Número inválido';

  @override
  String get carsLabel => 'Automóviles *';

  @override
  String get addCar => 'Añadir';

  @override
  String get addAtLeastOneCar => 'Añade al menos un coche';

  @override
  String get addCarDialogTitle => 'Añadir coche';

  @override
  String get carExample => 'Ej: BMW X5 1234ABC';

  @override
  String get carAlreadyAdded => 'Ya añadido';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get saveClient => 'Guardar cliente';

  @override
  String get clientUpdated => 'Cliente actualizado';

  @override
  String get clientAdded => 'Cliente añadido';

  @override
  String get otherCategory => 'Otro';

  @override
  String replenishItemTitle(Object item) {
    return 'Reponer \"$item\"';
  }

  @override
  String get howManyToAdd => '¿Cuánto añadir?';

  @override
  String get ml => 'ml';

  @override
  String currentStockTitle(Object item) {
    return 'Saldo: \"$item\"';
  }

  @override
  String get currentStockLabel => 'Volumen actual';

  @override
  String get inactiveClients => 'Clientes inactivos';

  @override
  String get promotions => 'Promociones';

  @override
  String get promotionsDescription => 'Crea promociones para atraer clientes';

  @override
  String get loyaltyProgram => 'Fidelización';

  @override
  String get loyaltyDescription => 'Recompensa a clientes fijos';

  @override
  String get smsBroadcast => 'Envío SMS';

  @override
  String get smsDescription => 'Envía recordatorios y noticias';

  @override
  String get reviews => 'Reseñas';

  @override
  String get reviewsDescription => 'Recopila reseñas';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get gotIt => 'Entendido';

  @override
  String get ordersChannelName => 'Pedidos';

  @override
  String get ordersChannelDescription => 'Notificaciones de pedidos';

  @override
  String get currencyLabel => 'Moneda';

  @override
  String get searchClientsHint => 'Buscar por cliente o auto...';

  @override
  String get crmFilterAll => 'Todos';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => 'En riesgo';

  @override
  String get crmFilterInactive => 'Inactivos';

  @override
  String get crmTagsLabel => 'Etiquetas';

  @override
  String get crmTagsHint => 'VIP, flota, recomendación';

  @override
  String get crmSegmentLabel => 'Segmento';

  @override
  String get crmLastVisitLabel => 'Última visita';

  @override
  String get crmAtRiskLabel => 'Requiere seguimiento';

  @override
  String get crmReminderButton => 'Enviar recordatorio';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return 'Hola, $client. Te enviamos un recordatorio del estudio de detailing. Podemos agendarte para $service en el horario que te convenga.';
  }

  @override
  String get crmBulkReminderButton => 'Campaña CRM';

  @override
  String get crmBulkReminderTitle => 'Seleccionar destinatarios';

  @override
  String get crmBulkReminderToggleAll => 'Todos';

  @override
  String get crmBulkReminderSendSelected => 'Enviar a seleccionados';

  @override
  String get crmBulkReminderEmpty =>
      'No hay clientes con teléfono en esta lista.';

  @override
  String get crmBulkReminderTemplate =>
      '¡Hola! Te recordamos desde el estudio de detailing. Puedes reservar un horario conveniente para tu próximo servicio.';

  @override
  String get crmSegmentNew => 'Nuevo';

  @override
  String get crmSegmentReturning => 'Recurrente';

  @override
  String get crmSegmentLoyal => 'Leal';

  @override
  String get clientsNotFound => 'No se encontraron clientes';

  @override
  String get openCallFailed => 'No se pudo abrir la llamada.';

  @override
  String get openWhatsAppFailed => 'No se pudo abrir la app de SMS.';

  @override
  String get sortTooltip => 'Ordenar';

  @override
  String get sortByNameAsc => 'Nombre: A-Z';

  @override
  String get sortByNameDesc => 'Nombre: Z-A';

  @override
  String get sortByNewest => 'Más recientes primero';

  @override
  String get permissionDeniedTitle => 'Acceso denegado';

  @override
  String get permissionCreateOrderDenied =>
      'No tienes permisos para crear un pedido.';

  @override
  String get permissionDeleteOrderDenied =>
      'Solo el director o propietario puede eliminar pedidos.';

  @override
  String get permissionEditOrderDenied =>
      'No tienes permisos para editar un pedido.';

  @override
  String get permissionSaveOrderDenied =>
      'No tienes permisos para guardar un pedido.';

  @override
  String get permissionCreateClientDenied =>
      'No tienes permisos para crear un cliente.';

  @override
  String get permissionDeleteClientDenied =>
      'No tienes permisos para eliminar un cliente.';

  @override
  String get permissionEditClientDenied =>
      'No tienes permisos para editar un cliente.';

  @override
  String get permissionSaveClientDenied =>
      'No tienes permisos para guardar un cliente.';

  @override
  String get permissionModifyInventoryDenied =>
      'No tienes permisos para modificar el inventario.';

  @override
  String get permissionEditInventoryStockDenied =>
      'No tienes permisos para cambiar existencias.';

  @override
  String get permissionEditInventoryDenied =>
      'No tienes permisos para editar el inventario.';

  @override
  String get clientDeleted => 'El cliente fue eliminado';

  @override
  String get clientGarageTitle => 'Garaje del cliente';

  @override
  String get navTeamChats => 'Chats del equipo';

  @override
  String get navCommunityChat => 'Chat de la comunidad';

  @override
  String get orderDefaultTitle => 'Pedido';

  @override
  String get completeOrderAndConsumePrompt =>
      '¿Completar el trabajo y descontar químicos del inventario?';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: Completado';
  }

  @override
  String get appointmentReminderTitle => 'Cita próxima';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car a las $time';
  }

  @override
  String get inventoryFirstItemHint =>
      'Añade el primer artículo del inventario: químicos, consumibles, accesorios o equipo.';

  @override
  String get inventoryFilteredEmpty =>
      'No se encontraron artículos para los filtros seleccionados.';

  @override
  String get inventoryItemLabel => 'ARTÍCULO';

  @override
  String inventoryLowStockMore(Object count) {
    return ' y $count más';
  }

  @override
  String get inventoryLowStockTitle => 'Stock bajo en inventario';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items requieren atención.';
  }

  @override
  String get inventoryNotificationsChannelName => 'Alertas de inventario';

  @override
  String get inventoryNotificationsChannelDescription =>
      'Alertas de stock bajo en inventario';

  @override
  String get inventoryEditItemTitle => 'Editar artículo';

  @override
  String get inventoryNewItemTitle => 'Nuevo artículo de inventario';

  @override
  String get inventoryItemTypeLabel => 'Tipo de artículo';

  @override
  String get inventoryUnitLabel => 'Unidad';

  @override
  String get inventoryCurrentStockLabel => 'Stock actual';

  @override
  String get inventoryMinStockLabel => 'Stock mínimo';

  @override
  String get inventoryLocationLabel => 'Ubicación de almacenamiento';

  @override
  String get inventoryUsageLabel => 'Uso';

  @override
  String inventoryLowStockCount(Object count) {
    return 'Stock bajo: $count';
  }

  @override
  String inventoryLowStockItemLine(
    Object amount,
    Object item,
    Object minStock,
    Object unit,
  ) {
    return '$item: $amount $unit, mínimo $minStock $unit';
  }

  @override
  String get inventoryAllTypes => 'Todos los tipos';

  @override
  String get inventoryBelowMin => 'Por debajo del mínimo';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return 'Mín: $minStock $unit';
  }

  @override
  String get chatProfileSaved => 'Perfil del chat guardado';

  @override
  String get chatUnavailableShort =>
      'Firebase no está configurado. El chat no está disponible temporalmente.';

  @override
  String get chatCreateDialogTitle => 'Nuevo diálogo';

  @override
  String get chatCreateExternalTitle => 'Nuevo chat externo';

  @override
  String get chatPeerIdLabelTeam => 'ID del técnico';

  @override
  String get chatPeerIdLabelExternal => 'ID del estudio/técnico';

  @override
  String get chatPeerNameLabelTeam => 'Nombre del técnico';

  @override
  String get chatPeerNameLabelExternal => 'Nombre del estudio o técnico';

  @override
  String get chatCreateAction => 'Crear';

  @override
  String get chatDialogTitle => 'Diálogo';

  @override
  String get chatScreenTitleTeam => 'Chat interno del equipo';

  @override
  String get chatScreenTitleExternal => 'Chat externo de la comunidad';

  @override
  String get chatNewChatButton => 'Nuevo chat';

  @override
  String get chatMyIdLabel => 'Tu ID';

  @override
  String get chatMyIdHint => 'Por ejemplo: master_001';

  @override
  String get chatMyNameLabel => 'Tu nombre';

  @override
  String get chatMyNameHint => 'Por ejemplo: Alex';

  @override
  String get chatUnavailableTitle => 'Chat temporalmente no disponible';

  @override
  String get chatUnavailableSubtitle =>
      'Firebase no está configurado para esta compilación. Añade la configuración de Firebase.';

  @override
  String get chatProfileFillTitleTeam => 'Completa tu perfil de chat';

  @override
  String get chatProfileFillTitleExternal => 'Completa tu perfil de comunidad';

  @override
  String get chatProfileFillSubtitleTeam =>
      'Introduce tu ID y nombre, luego pulsa Guardar.';

  @override
  String get chatProfileFillSubtitleExternal =>
      'Introduce tu ID y nombre para chatear con otros estudios y técnicos.';

  @override
  String get chatErrorTitle => 'Chat no disponible';

  @override
  String get chatErrorSubtitle =>
      'Revisa la configuración de Firebase (google-services y Firebase.initializeApp).';

  @override
  String get chatEmptyTitle => 'Aún no hay diálogos';

  @override
  String get chatEmptySubtitle =>
      'Crea el primer chat con el botón Nuevo chat.';

  @override
  String get chatNoMessages => 'Aún no hay mensajes';

  @override
  String get chatOpenAfterFirebase =>
      'Firebase no está configurado. Abre el chat después de configurar Firebase.';

  @override
  String get chatConnectionError => 'Error de conexión al chat';

  @override
  String get chatMessageHint => 'Escribe un mensaje';

  @override
  String get chatAttachPhoto => 'Adjuntar foto';

  @override
  String get chatAttachFile => 'Adjuntar archivo';

  @override
  String get chatAttachmentFile => 'Archivo';

  @override
  String get chatFileOpenFailed => 'No se pudo abrir el archivo.';

  @override
  String chatUploadFailed(Object error) {
    return 'Error al subir: $error';
  }

  @override
  String get durationMinutesShort => 'min';

  @override
  String get inventoryTypeChemistry => 'Química';

  @override
  String get inventoryTypeConsumable => 'Consumible';

  @override
  String get inventoryTypeAccessory => 'Accesorio';

  @override
  String get inventoryTypeEquipment => 'Equipo';

  @override
  String get emailLabel => 'Correo';

  @override
  String get authEnterEmail => 'Introduce el correo';

  @override
  String get authInvalidEmail => 'Correo no válido';

  @override
  String get authEnterPassword => 'Introduce la contraseña';

  @override
  String get authPasswordMin => 'Mínimo 8 caracteres';

  @override
  String get authFirebaseGuestOnly =>
      'Firebase no está configurado. El modo invitado está disponible.';

  @override
  String get authSignInFailed =>
      'No se pudo iniciar sesión. Inténtalo de nuevo.';

  @override
  String get authPasswordsMismatch => 'Las contraseñas no coinciden';

  @override
  String get authJoinSuccess => '¡Te uniste al equipo correctamente!';

  @override
  String authInviteRejected(Object error) {
    return 'Registro completado, pero el código de invitación fue rechazado: $error';
  }

  @override
  String get authRegisterFailed =>
      'No se pudo completar el registro. Inténtalo de nuevo.';

  @override
  String get authGuestName => 'Invitado';

  @override
  String get authGoogleSoon => 'El inicio con Google se añadirá más tarde';

  @override
  String get authInvalidEmailFormat => 'Formato de correo no válido';

  @override
  String get authWrongCredentials => 'Correo o contraseña incorrectos';

  @override
  String get authEmailInUse => 'Este correo ya está en uso';

  @override
  String get authWeakPassword => 'La contraseña es demasiado débil';

  @override
  String get authTooManyRequests => 'Demasiados intentos. Inténtalo más tarde';

  @override
  String get authAuthorizationError => 'Error de autorización';

  @override
  String get authWelcome => 'Bienvenido';

  @override
  String get authSubtitle => 'Inicia sesión o regístrate';

  @override
  String get authTabSignIn => 'Entrar';

  @override
  String get authTabRegister => 'Registro';

  @override
  String get authContinueWithGoogle => 'Continuar con Google';

  @override
  String get authContinueAsGuest => 'Continuar como invitado';

  @override
  String get authPasswordLabel => 'Contraseña';

  @override
  String get authConfirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get authInviteCodeOptional => 'Código de invitación (opcional)';

  @override
  String get authInviteHint => 'Si te invitó el director';

  @override
  String get authRegisterButton => 'Registrarse';

  @override
  String get businessModeQuestion => '¿Cómo trabajas?';

  @override
  String get businessModeSubtitle =>
      'Elige un modo para ver solo los módulos necesarios.';

  @override
  String get businessModeSoloTitle => 'Trabajo solo';

  @override
  String get businessModeSoloSubtitle =>
      'Para especialista individual: pedidos, clientes, inventario, finanzas y chat externo.';

  @override
  String get businessModeTeamTitle => 'Tenemos equipo';

  @override
  String get businessModeTeamSubtitle =>
      'Para estudio: roles del personal, chat interno, tareas por técnico y control del director.';

  @override
  String get photosGallerySaveFailed =>
      'La foto se añadió a la app, pero no se pudo guardar en la galería.';

  @override
  String get photosCameraUnsupported =>
      'La cámara solo está disponible en Android/iOS o en la versión web.';

  @override
  String get photosAddedAndSaved => 'Foto añadida y guardada en la galería.';

  @override
  String get photosAddedFromGallery => 'Foto añadida desde la galería.';

  @override
  String get photosAddFromGallery => 'Añadir desde galería';

  @override
  String get photosTakePhoto => 'Tomar foto';

  @override
  String get photosDeleteDenied => 'No tienes permisos para eliminar la foto.';

  @override
  String get settingsProfileAndOrgTitle => 'Perfil y organización';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => 'Invitado';

  @override
  String get settingsBusinessModeTitle => 'Modo de trabajo';

  @override
  String get settingsUserRoleTitle => 'Rol de usuario';

  @override
  String get settingsInviteMasterTitle => 'Invitar técnico';

  @override
  String get settingsInviteMasterSubtitle =>
      'Generar código de invitación de un solo uso';

  @override
  String get settingsServicesSection => 'Servicios';

  @override
  String get settingsLogoutButton => 'Cerrar sesión';

  @override
  String get settingsBusinessModeTeam => 'Equipo (estudio)';

  @override
  String get settingsBusinessModeSolo => 'Solo (un técnico)';

  @override
  String get settingsRoleDirector => 'Director';

  @override
  String get settingsRoleMaster => 'Técnico';

  @override
  String get settingsRoleMasterOwner => 'Técnico propietario';

  @override
  String get settingsSelectModeTitle => 'Seleccionar modo';

  @override
  String get settingsModeSoloTitle => 'Solo';

  @override
  String get settingsModeSoloSubtitle => 'Un técnico';

  @override
  String get settingsModeTeamTitle => 'Equipo';

  @override
  String get settingsModeTeamSubtitle => 'Estudio con empleados';

  @override
  String get settingsModeUpdated => 'Modo actualizado.';

  @override
  String get settingsOrgNotFound =>
      'Organización no encontrada. Guarda primero la configuración.';

  @override
  String settingsInviteGenerateError(Object error) {
    return 'Error al generar el código: $error';
  }

  @override
  String get settingsInviteDialogTitle => 'Código de invitación para técnico';

  @override
  String get settingsInviteDialogDescription =>
      'Envía este código al técnico. Es de un solo uso y caduca después de utilizarse.';

  @override
  String get settingsCopy => 'Copiar';

  @override
  String get settingsCodeCopied => 'Código copiado al portapapeles';

  @override
  String get settingsInviteRegistrationHint =>
      'El técnico introduce el código en el campo Código de invitación durante el registro.';

  @override
  String get settingsClose => 'Cerrar';

  @override
  String get settingsSelectRoleTitle => 'Seleccionar rol';

  @override
  String get settingsRoleUpdated => 'Rol actualizado.';

  @override
  String get settingsLogoutTitle => 'Cerrar sesión';

  @override
  String get settingsLogoutMessage => '¿Cerrar sesión de la cuenta actual?';

  @override
  String get settingsLogoutConfirm => 'Cerrar sesión';

  @override
  String get settingsLoggedOut => 'Has cerrado sesión.';

  @override
  String get settingsAccessDenied => 'No tienes permisos para esta acción.';

  @override
  String get settingsResetWarning =>
      'ADVERTENCIA: ¡Se eliminarán todos los pedidos, clientes e inventario!';

  @override
  String get settingsServiceDeleteDenied =>
      'No tienes permisos para eliminar el servicio.';

  @override
  String get settingsServiceEditDenied =>
      'No tienes permisos para editar el servicio.';

  @override
  String get legalTitle => 'Legal';

  @override
  String get legalPrivacyTab => 'Política de privacidad';

  @override
  String get legalTermsTab => 'Términos';

  @override
  String get legalPrivacySummaryTitle => 'Resumen de la política de privacidad';

  @override
  String get legalTermsSummaryTitle => 'Resumen de los términos del servicio';

  @override
  String get legalSummarySubtitle =>
      'Resumen rápido en la app. La versión legal completa está disponible en la página publicada.';

  @override
  String get legalOpenFullPrivacy => 'Abrir política de privacidad completa';

  @override
  String get legalOpenFullTerms => 'Abrir términos completos';

  @override
  String get legalOpenLinkError => 'No se pudo abrir el enlace del documento.';

  @override
  String get legalPrivacySection1Title => '1. Qué hace la app';

  @override
  String get legalPrivacySection1Body =>
      'DetailingPro Business ayuda a los equipos de detailing a gestionar clientes, pedidos, horarios, inventario, chat del equipo y archivos multimedia adjuntos.';

  @override
  String get legalPrivacySection2Title => '2. Datos que procesamos';

  @override
  String get legalPrivacySection2Body =>
      'La app puede procesar datos de cuenta, datos de clientes y pedidos, registros de servicios, inventario, mensajes de equipo, archivos adjuntos e identificadores técnicos como tokens de notificaciones.';

  @override
  String get legalPrivacySection3Title => '3. Para qué se usan estos datos';

  @override
  String get legalPrivacySection3Body =>
      'Los datos se usan para ejecutar funciones principales, sincronizar entre dispositivos, enviar recordatorios, facilitar la colaboración y mantener la fiabilidad y seguridad del servicio.';

  @override
  String get legalPrivacySection4Title => '4. Permisos y acceso';

  @override
  String get legalPrivacySection4Body =>
      'Los permisos de cámara y archivos multimedia se solicitan solo para funciones como fotos y adjuntos. El permiso de notificaciones se utiliza para recordatorios y alertas push.';

  @override
  String get legalPrivacySection5Title => '5. Infraestructura y proveedores';

  @override
  String get legalPrivacySection5Body =>
      'La app utiliza servicios de Firebase (Authentication, Firestore, Storage, Messaging). Los datos se procesan en la infraestructura de estos proveedores.';

  @override
  String get legalPrivacySection6Title =>
      '6. Retención, eliminación y derechos';

  @override
  String get legalPrivacySection6Body =>
      'Los datos se conservan mientras sean necesarios para prestar el servicio. Los usuarios pueden solicitar acceso, corrección o eliminación según la ley aplicable.';

  @override
  String get legalPrivacySection7Title => '7. Contacto';

  @override
  String get legalPrivacySection7Body =>
      'Consultas de privacidad: support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. Alcance del servicio';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro es una aplicación de productividad empresarial para gestionar citas, clientes, contenido multimedia, chat interno y datos operativos.';

  @override
  String get legalTermsSection2Title => '2. Cuentas y acceso';

  @override
  String get legalTermsSection2Body =>
      'Los usuarios son responsables de proteger sus credenciales y de usar la app solo dentro de los permisos asignados a su rol.';

  @override
  String get legalTermsSection3Title => '3. Uso permitido';

  @override
  String get legalTermsSection3Body =>
      'El servicio no debe usarse para procesamiento ilícito de datos, mensajes abusivos, intentos de acceso no autorizado ni actividades que infrinjan la ley.';

  @override
  String get legalTermsSection4Title => '4. Disponibilidad';

  @override
  String get legalTermsSection4Body =>
      'El servicio puede cambiar con el tiempo. Las funciones pueden añadirse, modificarse o eliminarse conforme evoluciona el producto.';

  @override
  String get legalTermsSection5Title => '5. Planes de pago';

  @override
  String get legalTermsSection5Body =>
      'Antes del lanzamiento, esta sección debe actualizarse con las condiciones finales de facturación, renovaciones, pruebas, cancelaciones y reembolsos de suscripciones de Google Play.';

  @override
  String get legalTermsSection6Title => '6. Limitación de responsabilidad';

  @override
  String get legalTermsSection6Body =>
      'Antes del lanzamiento público, sustituye este borrador por una versión legal final revisada para tu jurisdicción y estructura empresarial.';

  @override
  String get legalTermsSection7Title => '7. Información legal';

  @override
  String get legalTermsSection7Body =>
      'Sustituye esta sección por los datos registrados de tu empresa y la información sobre la ley aplicable antes de publicar en la tienda.';

  @override
  String get invoiceCompanyDataTitle => 'Datos de empresa';

  @override
  String get invoiceCompanyDataSubtitle => 'Para facturas';

  @override
  String get invoiceCompanyName => 'Nombre de empresa';

  @override
  String get invoiceCompanyAddress => 'Dirección';

  @override
  String get invoiceCompanyPostalCode => 'Código postal';

  @override
  String get invoiceCompanyCity => 'Ciudad';

  @override
  String get invoiceGenerateButton => 'Crear factura';

  @override
  String get invoiceVatRate => 'Tipo de IVA';

  @override
  String get settingsBookingLinkTitle => 'Enlace de reserva online';

  @override
  String get settingsBookingRequestsTitle => 'Solicitudes online';

  @override
  String get settingsBookingLinkDialogTitle => 'Tu enlace de reserva';

  @override
  String get settingsBookingLinkCopied => 'Enlace copiado';

  @override
  String get settingsBookingLinkAuthRequired =>
      'Inicia sesión para generar un enlace de reserva.';

  @override
  String get settingsBookingLinkOpen => 'Abrir';

  @override
  String get settingsWorkingHoursTitle => 'Horario de trabajo';

  @override
  String get settingsWorkingHoursSlotLabel => 'Intervalo';

  @override
  String get settingsWorkingHoursMinNoticeLabel => 'Aviso min.';

  @override
  String get settingsWorkingHoursBreakLabel => 'Descanso';

  @override
  String get settingsWorkingHoursNotice1Hour => '1 hora';

  @override
  String get settingsWorkingHoursNotice2Hours => '2 horas';

  @override
  String get settingsWorkingHoursNotice24Hours => '24 horas';

  @override
  String get bookingRequestsTitle => 'Solicitudes online';

  @override
  String get bookingRequestsFirebaseUnavailable =>
      'Firebase no está configurado para reservas online.';

  @override
  String get bookingRequestsSignInRequired =>
      'Inicia sesión para ver las solicitudes.';

  @override
  String bookingRequestsError(Object error) {
    return 'Error al cargar las solicitudes: $error';
  }

  @override
  String get bookingRequestsEmpty => 'Aún no hay solicitudes online.';

  @override
  String get bookingRequestServiceLabel => 'Servicio';

  @override
  String get bookingRequestScheduleLabel => 'Fecha/hora preferida';

  @override
  String get bookingRequestPhoneLabel => 'Teléfono';

  @override
  String get bookingRequestCarLabel => 'Coche';

  @override
  String get bookingRequestNoteLabel => 'Nota';

  @override
  String get bookingRequestAccept => 'Aceptar';

  @override
  String get bookingRequestDecline => 'Rechazar';

  @override
  String get bookingRequestCall => 'Llamar';

  @override
  String get bookingRequestStatusPending => 'Pendiente';

  @override
  String get bookingRequestStatusAccepted => 'Aceptada';

  @override
  String get bookingRequestStatusDeclined => 'Rechazado';

  @override
  String get bookingRequestsFilterAll => 'Todos';

  @override
  String get bookingRequestsEmptyNew => 'Sin nuevas solicitudes';

  @override
  String get bookingRequestsAcceptedFeedback =>
      'Solicitud aceptada — el pedido se creará automáticamente';

  @override
  String get bookingRequestsDeclinedFeedback => 'Solicitud rechazada';

  @override
  String get bookingRequestsDeclineConfirmContent =>
      '¿Rechazar esta solicitud de reserva?';

  @override
  String get enterServiceName => 'El nombre del servicio es obligatorio';

  @override
  String get invalidPrice => 'Introduce un precio válido (0 o más)';

  @override
  String get invoiceTitle => 'FACTURA';

  @override
  String get invoiceNumberPrefix => 'FC';

  @override
  String get invoiceSeller => 'VENDEDOR';

  @override
  String get invoiceBuyer => 'COMPRADOR';

  @override
  String get invoiceIssueDateLabel => 'Fecha de emisión';

  @override
  String get invoiceServiceDateLabel => 'Fecha del servicio';

  @override
  String get invoiceDescriptionLabel => 'Descripción';

  @override
  String get invoiceQtyLabel => 'Cant.';

  @override
  String get invoiceNetPriceLabel => 'Precio neto';

  @override
  String get invoiceVatPctLabel => 'IVA %';

  @override
  String get invoiceVatAmountLabel => 'Importe IVA';

  @override
  String get invoiceGrossPriceLabel => 'Precio bruto';

  @override
  String get invoiceNetTotalLabel => 'Total neto:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return 'IVA $rate:';
  }

  @override
  String get invoiceTotalDueLabel => 'TOTAL A PAGAR:';

  @override
  String get invoiceFillCompanyLabel => 'Completar datos de empresa';

  @override
  String get invoiceIssuedByLabel => 'Factura emitida por';

  @override
  String get invoicePrimaryIdLabel => 'NIF/CIF';

  @override
  String get invoiceSecondaryIdLabel => 'Registro mercantil';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total plazas';
  }

  @override
  String get syncOfflineWarning =>
      'Sin conexión a Internet. Los datos pueden estar desactualizados.';

  @override
  String get forceUpdateTitle => 'Actualización requerida';

  @override
  String get forceUpdateMessage =>
      'Hay una nueva versión de la app. Actualiza Detailing Pro para continuar.';

  @override
  String get forceUpdateButton => 'Actualizar';

  @override
  String get storageStartupTitle => 'Almacenamiento local no disponible';

  @override
  String get storageStartupBody =>
      'Detailing Pro no pudo abrir su base de datos cifrada. Los datos en este dispositivo pueden estar protegidos o dañados.';

  @override
  String get storageStartupHint =>
      'Cierra la app por completo y ábrela de nuevo. Si el problema continúa, reinstala la app (los datos en la nube se conservan si inicias sesión con la misma cuenta).';

  @override
  String get storageStartupCloseApp => 'Cerrar app';

  @override
  String get settingsSyncStatusTitle => 'Sincronización en la nube';

  @override
  String settingsSyncPendingMessage(int count) {
    return '$count cambios pendientes de sincronizar';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return '$count cambios no se pudieron sincronizar';
  }

  @override
  String get settingsSyncRetryButton => 'Reintentar sincronización';

  @override
  String get settingsSyncDiscardButton => 'Descartar cambios fallidos';
}
