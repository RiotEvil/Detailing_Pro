// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Detailing Pro';

  @override
  String versionLabel(Object version) {
    return 'Versão $version';
  }

  @override
  String get navDashboard => 'Painel';

  @override
  String get navOrders => 'Pedidos';

  @override
  String get navClients => 'Clientes';

  @override
  String get navCalendar => 'Calendário';

  @override
  String get navInventory => 'Estoque';

  @override
  String get navStats => 'Estatísticas';

  @override
  String get navPhotos => 'Fotos';

  @override
  String get navMarketing => 'Marketing';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get inventoryEmptyTitle => 'Estoque vazio';

  @override
  String get inventoryEmptySubtitle => 'Adicione produtos no botão abaixo';

  @override
  String get showAllCategories => 'Mostrar categorias';

  @override
  String get chemicalsButton => 'QUÍMICA';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Adicionar';

  @override
  String get save => 'Salvar';

  @override
  String get noOrdersTitle => 'Sem pedidos';

  @override
  String get noOrdersSubtitle => 'Adicione o primeiro pedido para começar';

  @override
  String get addOrder => 'Adicionar serviço';

  @override
  String get orderButton => 'PEDIDO';

  @override
  String get deleteOrderTitle => 'Excluir pedido?';

  @override
  String deleteOrderMessage(Object car) {
    return 'O pedido \"$car\" será excluído permanentemente.';
  }

  @override
  String deletedOrderSnack(Object car) {
    return 'Pedido \"$car\" excluído';
  }

  @override
  String get undo => 'Desfazer';

  @override
  String get delete => 'Excluir';

  @override
  String get carLabel => 'Carro';

  @override
  String clientLabel(Object client) {
    return 'Cliente: $client';
  }

  @override
  String serviceLabel(Object duration, Object service) {
    return 'Serviço: $service ($duration min)';
  }

  @override
  String get statusScheduled => 'Agendado';

  @override
  String get statusInProgress => 'Em andamento';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusPaid => 'Pago';

  @override
  String get statusCompleted => 'Concluído';

  @override
  String get edit => 'Editar';

  @override
  String get start => 'Iniciar';

  @override
  String get markDone => 'Pronto';

  @override
  String get markPaid => 'Pago';

  @override
  String get statusChangedTitle => 'Status do pedido atualizado';

  @override
  String statusChangedMessage(Object car, Object status) {
    return 'O pedido \"$car\" agora está $status';
  }

  @override
  String get newChemicalTitle => 'Novo produto';

  @override
  String get nameLabel => 'Nome *';

  @override
  String get brandLabel => 'Marca';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get volumeLabel => 'Volume (ml)';

  @override
  String get deleteItemTitle => 'Excluir?';

  @override
  String deleteItemMessage(Object item) {
    return 'Excluir \"$item\" do estoque?';
  }

  @override
  String get unnamedItem => 'Sem nome';

  @override
  String get replenish => 'Repor';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get goodMorning => 'Bom dia!';

  @override
  String get goodAfternoon => 'Boa tarde!';

  @override
  String get goodEvening => 'Boa noite!';

  @override
  String get statsTodayOrders => 'Agendados hoje';

  @override
  String get statsInWork => 'Em trabalho';

  @override
  String get statsTodayRevenue => 'Faturamento hoje';

  @override
  String get statsTotalClients => 'Clientes';

  @override
  String get noCars => 'Sem carros';

  @override
  String get quickActions => 'Ações rápidas';

  @override
  String get newOrder => 'Novo agendamento';

  @override
  String get newClient => 'Novo cliente';

  @override
  String get todayOrdersTitle => 'Pedidos de hoje';

  @override
  String get calendarTitle => 'Calendário';

  @override
  String get monthJanuary => 'Janeiro';

  @override
  String get monthFebruary => 'Fevereiro';

  @override
  String get monthMarch => 'Março';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Maio';

  @override
  String get monthJune => 'Junho';

  @override
  String get monthJuly => 'Julho';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Setembro';

  @override
  String get monthOctober => 'Outubro';

  @override
  String get monthNovember => 'Novembro';

  @override
  String get monthDecember => 'Dezembro';

  @override
  String get statsTitle => 'Estatísticas';

  @override
  String get statsRevenue => 'Faturamento';

  @override
  String get statsOrders => 'Pedidos';

  @override
  String get statsPeriodWeek => 'Semana';

  @override
  String get statsPeriodMonth => 'Mês';

  @override
  String get statsPeriodYear => 'Ano';

  @override
  String get photosTitle => 'Fotos';

  @override
  String get orderBeforePhotosTitle => 'Antes';

  @override
  String get orderAfterPhotosTitle => 'Depois';

  @override
  String get photosAdd => 'Adicionar foto';

  @override
  String get photosEmpty => 'Sem fotos ainda';

  @override
  String get photosSelectCar => 'Selecione o carro';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get visits => 'Visitas';

  @override
  String get totalSpent => 'Gasto total';

  @override
  String get orderHistoryTitle => 'Histórico de pedidos';

  @override
  String get orderHistoryEmpty => 'Histórico vazio';

  @override
  String get call => 'Ligar';

  @override
  String get message => 'Mensagem';

  @override
  String get photoReport => 'Relatório de fotos';

  @override
  String get photosNotAdded => 'Sem fotos adicionadas';

  @override
  String get editOrderTitle => 'Editar pedido';

  @override
  String get newOrderTitle => 'Novo pedido';

  @override
  String get clientFieldLabel => 'Cliente *';

  @override
  String get selectClient => 'Escolha o cliente';

  @override
  String get carHint => 'Modelo e placa';

  @override
  String get enterCar => 'Indique o carro';

  @override
  String get serviceFieldLabel => 'Serviço *';

  @override
  String get selectService => 'Escolha o serviço';

  @override
  String get orderMaterialCostLabel => 'Custo de materiais';

  @override
  String get orderLaborCostLabel => 'Custo de mão de obra';

  @override
  String get orderTotalCostLabel => 'Custo total';

  @override
  String get orderProfitLabel => 'Lucro';

  @override
  String get statsProfit => 'Lucro';

  @override
  String get orderNotesLabel => 'Notas do pedido';

  @override
  String get createOrderButton => 'Criar pedido';

  @override
  String get orderUpdated => 'Pedido atualizado';

  @override
  String get orderCreated => 'Pedido criado com sucesso';

  @override
  String errorMessage(Object error) {
    return 'Erro: $error';
  }

  @override
  String get editClient => 'Editar cliente';

  @override
  String get clientNameLabel => 'Nome do cliente *';

  @override
  String get enterName => 'Digite o nome';

  @override
  String get phoneLabel => 'Telefone';

  @override
  String get phoneHint => '+55 (__) _____-____';

  @override
  String get enterValidPhone => 'Número inválido';

  @override
  String get carsLabel => 'Automóveis *';

  @override
  String get addCar => 'Adicionar';

  @override
  String get addAtLeastOneCar => 'Adicione pelo menos um carro';

  @override
  String get addCarDialogTitle => 'Adicionar carro';

  @override
  String get carExample => 'Ex: BMW X5 ABC-1234';

  @override
  String get carAlreadyAdded => 'Já adicionado';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get saveClient => 'Salvar cliente';

  @override
  String get clientUpdated => 'Cliente atualizado';

  @override
  String get clientAdded => 'Cliente adicionado';

  @override
  String get otherCategory => 'Outro';

  @override
  String replenishItemTitle(Object item) {
    return 'Repor \"$item\"';
  }

  @override
  String get howManyToAdd => 'Quanto adicionar?';

  @override
  String get ml => 'ml';

  @override
  String currentStockTitle(Object item) {
    return 'Saldo: \"$item\"';
  }

  @override
  String get currentStockLabel => 'Volume atual';

  @override
  String get inactiveClients => 'Clientes inativos';

  @override
  String get promotions => 'Promoções e descontos';

  @override
  String get promotionsDescription => 'Crie promoções para atrair clientes';

  @override
  String get loyaltyProgram => 'Programa de fidelidade';

  @override
  String get loyaltyDescription => 'Recompense clientes fixos';

  @override
  String get smsBroadcast => 'Envio de SMS';

  @override
  String get smsDescription => 'Envie lembretes e notícias';

  @override
  String get reviews => 'Avaliações';

  @override
  String get reviewsDescription => 'Colete avaliações';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get gotIt => 'Entendido';

  @override
  String get ordersChannelName => 'Pedidos';

  @override
  String get ordersChannelDescription => 'Notificações de pedidos';

  @override
  String get currencyLabel => 'Moeda';

  @override
  String get searchClientsHint => 'Pesquisar cliente ou carro...';

  @override
  String get crmFilterAll => 'Todos';

  @override
  String get crmFilterVip => 'VIP';

  @override
  String get crmFilterAtRisk => 'Em risco';

  @override
  String get crmFilterInactive => 'Inativos';

  @override
  String get crmTagsLabel => 'Tags';

  @override
  String get crmTagsHint => 'VIP, frota, indicação';

  @override
  String get crmSegmentLabel => 'Segmento';

  @override
  String get crmLastVisitLabel => 'Última visita';

  @override
  String get crmAtRiskLabel => 'Precisa de contato';

  @override
  String get crmReminderButton => 'Enviar lembrete';

  @override
  String crmReminderTemplate(Object client, Object service) {
    return 'Olá, $client! Este é um lembrete amigável da estética automotiva. Podemos agendar você para $service no melhor horário.';
  }

  @override
  String get crmBulkReminderButton => 'Campanha CRM';

  @override
  String get crmBulkReminderTitle => 'Selecionar destinatários';

  @override
  String get crmBulkReminderToggleAll => 'Todos';

  @override
  String get crmBulkReminderSendSelected => 'Enviar para selecionados';

  @override
  String get crmBulkReminderEmpty =>
      'Não há clientes com telefone nesta lista.';

  @override
  String get crmBulkReminderTemplate =>
      'Olá! Lembrete da estética automotiva. Você pode agendar um horário conveniente para o próximo serviço.';

  @override
  String get crmSegmentNew => 'Novo';

  @override
  String get crmSegmentReturning => 'Recorrente';

  @override
  String get crmSegmentLoyal => 'Fiel';

  @override
  String get clientsNotFound => 'Não foram encontrados clientes';

  @override
  String get openCallFailed => 'Não foi possível abrir a chamada.';

  @override
  String get openWhatsAppFailed => 'Não foi possível abrir o app de SMS.';

  @override
  String get sortTooltip => 'Ordenar';

  @override
  String get sortByNameAsc => 'Nome: A-Z';

  @override
  String get sortByNameDesc => 'Nome: Z-A';

  @override
  String get sortByNewest => 'Mais recentes primeiro';

  @override
  String get permissionDeniedTitle => 'Acesso negado';

  @override
  String get permissionCreateOrderDenied => 'Sem permissão para criar pedido.';

  @override
  String get permissionDeleteOrderDenied =>
      'Excluir pedidos é permitido apenas ao diretor ou proprietário.';

  @override
  String get permissionEditOrderDenied => 'Sem permissão para editar pedido.';

  @override
  String get permissionSaveOrderDenied => 'Sem permissão para salvar pedido.';

  @override
  String get permissionCreateClientDenied =>
      'Sem permissão para criar cliente.';

  @override
  String get permissionDeleteClientDenied =>
      'Sem permissão para excluir cliente.';

  @override
  String get permissionEditClientDenied => 'Sem permissão para editar cliente.';

  @override
  String get permissionSaveClientDenied => 'Sem permissão para salvar cliente.';

  @override
  String get permissionModifyInventoryDenied =>
      'Sem permissão para alterar o estoque.';

  @override
  String get permissionEditInventoryStockDenied =>
      'Sem permissão para alterar níveis de estoque.';

  @override
  String get permissionEditInventoryDenied =>
      'Sem permissão para editar o estoque.';

  @override
  String get clientDeleted => 'Cliente foi removido';

  @override
  String get clientGarageTitle => 'Garagem do cliente';

  @override
  String get navTeamChats => 'Chats da equipe';

  @override
  String get navCommunityChat => 'Chat da comunidade';

  @override
  String get orderDefaultTitle => 'Pedido';

  @override
  String get completeOrderAndConsumePrompt =>
      'Finalizar serviço e descontar químicos do estoque?';

  @override
  String orderCompletedSnack(Object car) {
    return '$car: Concluído';
  }

  @override
  String get appointmentReminderTitle => 'Agendamento próximo';

  @override
  String appointmentReminderBody(Object car, Object time) {
    return '$car às $time';
  }

  @override
  String get inventoryFirstItemHint =>
      'Adicione o primeiro item do estoque: químicos, consumíveis, acessórios ou equipamento.';

  @override
  String get inventoryFilteredEmpty =>
      'Nenhum item encontrado para os filtros selecionados.';

  @override
  String get inventoryItemLabel => 'ITEM';

  @override
  String inventoryLowStockMore(Object count) {
    return ' e mais $count';
  }

  @override
  String get inventoryLowStockTitle => 'Estoque baixo';

  @override
  String inventoryLowStockBody(Object items) {
    return '$items precisam de atenção.';
  }

  @override
  String get inventoryNotificationsChannelName => 'Alertas de estoque';

  @override
  String get inventoryNotificationsChannelDescription =>
      'Alertas sobre estoque baixo';

  @override
  String get inventoryEditItemTitle => 'Editar item';

  @override
  String get inventoryNewItemTitle => 'Novo item de estoque';

  @override
  String get inventoryItemTypeLabel => 'Tipo de item';

  @override
  String get inventoryUnitLabel => 'Unidade';

  @override
  String get inventoryCurrentStockLabel => 'Estoque atual';

  @override
  String get inventoryMinStockLabel => 'Estoque mínimo';

  @override
  String get inventoryLocationLabel => 'Local de armazenamento';

  @override
  String get inventoryUsageLabel => 'Uso';

  @override
  String inventoryLowStockCount(Object count) {
    return 'Estoque baixo: $count';
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
  String get inventoryAllTypes => 'Todos os tipos';

  @override
  String get inventoryBelowMin => 'Abaixo do mínimo';

  @override
  String inventoryMinChip(Object minStock, Object unit) {
    return 'Mín: $minStock $unit';
  }

  @override
  String get chatProfileSaved => 'Perfil do chat salvo';

  @override
  String get chatUnavailableShort =>
      'Firebase não está configurado. O chat está temporariamente indisponível.';

  @override
  String get chatCreateDialogTitle => 'Novo diálogo';

  @override
  String get chatCreateExternalTitle => 'Novo chat externo';

  @override
  String get chatPeerIdLabelTeam => 'ID do profissional';

  @override
  String get chatPeerIdLabelExternal => 'ID do estúdio/profissional';

  @override
  String get chatPeerNameLabelTeam => 'Nome do profissional';

  @override
  String get chatPeerNameLabelExternal => 'Nome do estúdio ou profissional';

  @override
  String get chatCreateAction => 'Criar';

  @override
  String get chatDialogTitle => 'Diálogo';

  @override
  String get chatScreenTitleTeam => 'Chat interno da equipe';

  @override
  String get chatScreenTitleExternal => 'Chat externo da comunidade';

  @override
  String get chatNewChatButton => 'Novo chat';

  @override
  String get chatMyIdLabel => 'Seu ID';

  @override
  String get chatMyIdHint => 'Exemplo: master_001';

  @override
  String get chatMyNameLabel => 'Seu nome';

  @override
  String get chatMyNameHint => 'Exemplo: Alex';

  @override
  String get chatUnavailableTitle => 'Chat temporariamente indisponível';

  @override
  String get chatUnavailableSubtitle =>
      'Firebase não está configurado para esta build. Adicione as configurações do Firebase.';

  @override
  String get chatProfileFillTitleTeam => 'Preencha seu perfil de chat';

  @override
  String get chatProfileFillTitleExternal =>
      'Preencha seu perfil da comunidade';

  @override
  String get chatProfileFillSubtitleTeam =>
      'Informe seu ID e nome, depois toque em Salvar.';

  @override
  String get chatProfileFillSubtitleExternal =>
      'Informe seu ID e nome para conversar com outros estúdios e profissionais.';

  @override
  String get chatErrorTitle => 'Chat indisponível';

  @override
  String get chatErrorSubtitle =>
      'Verifique a configuração do Firebase (google-services e Firebase.initializeApp).';

  @override
  String get chatEmptyTitle => 'Ainda não há diálogos';

  @override
  String get chatEmptySubtitle => 'Crie o primeiro chat com o botão Novo chat.';

  @override
  String get chatNoMessages => 'Ainda não há mensagens';

  @override
  String get chatOpenAfterFirebase =>
      'Firebase não está configurado. Abra o chat após configurar o Firebase.';

  @override
  String get chatConnectionError => 'Erro de conexão do chat';

  @override
  String get chatMessageHint => 'Digite uma mensagem';

  @override
  String get chatAttachPhoto => 'Anexar foto';

  @override
  String get chatAttachFile => 'Anexar arquivo';

  @override
  String get chatAttachmentFile => 'Arquivo';

  @override
  String get chatFileOpenFailed => 'Não foi possível abrir o arquivo.';

  @override
  String chatUploadFailed(Object error) {
    return 'Falha no envio: $error';
  }

  @override
  String get durationMinutesShort => 'min';

  @override
  String get inventoryTypeChemistry => 'Química';

  @override
  String get inventoryTypeConsumable => 'Consumível';

  @override
  String get inventoryTypeAccessory => 'Acessório';

  @override
  String get inventoryTypeEquipment => 'Equipamento';

  @override
  String get emailLabel => 'Email';

  @override
  String get authEnterEmail => 'Digite o email';

  @override
  String get authInvalidEmail => 'Email inválido';

  @override
  String get authEnterPassword => 'Digite a senha';

  @override
  String get authPasswordMin => 'Mínimo de 8 caracteres';

  @override
  String get authFirebaseGuestOnly =>
      'Firebase não está configurado. O modo convidado está disponível.';

  @override
  String get authSignInFailed => 'Não foi possível entrar. Tente novamente.';

  @override
  String get authPasswordsMismatch => 'As senhas não coincidem';

  @override
  String get authJoinSuccess => 'Você entrou na equipe com sucesso!';

  @override
  String authInviteRejected(Object error) {
    return 'Registro concluído, mas o código de convite foi recusado: $error';
  }

  @override
  String get authRegisterFailed =>
      'Não foi possível concluir o registro. Tente novamente.';

  @override
  String get authGuestName => 'Convidado';

  @override
  String get authGoogleSoon => 'Login com Google será adicionado depois';

  @override
  String get authInvalidEmailFormat => 'Formato de email inválido';

  @override
  String get authWrongCredentials => 'Email ou senha incorretos';

  @override
  String get authEmailInUse => 'Este email já está em uso';

  @override
  String get authWeakPassword => 'Senha muito fraca';

  @override
  String get authTooManyRequests =>
      'Muitas tentativas. Tente novamente mais tarde';

  @override
  String get authAuthorizationError => 'Erro de autorização';

  @override
  String get authWelcome => 'Bem-vindo';

  @override
  String get authSubtitle => 'Entre na sua conta ou registre-se';

  @override
  String get authTabSignIn => 'Entrar';

  @override
  String get authTabRegister => 'Registro';

  @override
  String get authContinueWithGoogle => 'Continuar com Google';

  @override
  String get authContinueAsGuest => 'Continuar como convidado';

  @override
  String get authPasswordLabel => 'Senha';

  @override
  String get authConfirmPasswordLabel => 'Confirmar senha';

  @override
  String get authInviteCodeOptional => 'Código de convite (opcional)';

  @override
  String get authInviteHint => 'Se você foi convidado pelo diretor';

  @override
  String get authRegisterButton => 'Registrar';

  @override
  String get businessModeQuestion => 'Como você trabalha?';

  @override
  String get businessModeSubtitle =>
      'Escolha um modo para o app mostrar apenas os módulos necessários.';

  @override
  String get businessModeSoloTitle => 'Eu trabalho sozinho';

  @override
  String get businessModeSoloSubtitle =>
      'Para profissional solo: pedidos, clientes, estoque, finanças e chat externo.';

  @override
  String get businessModeTeamTitle => 'Temos uma equipe';

  @override
  String get businessModeTeamSubtitle =>
      'Para estúdio: funções da equipe, chat interno, tarefas por técnico e controle do diretor.';

  @override
  String get photosGallerySaveFailed =>
      'A foto foi adicionada ao app, mas não foi possível salvar na galeria.';

  @override
  String get photosCameraUnsupported =>
      'A câmera está disponível apenas no Android/iOS ou na versão web.';

  @override
  String get photosAddedAndSaved => 'Foto adicionada e salva na galeria.';

  @override
  String get photosAddedFromGallery => 'Foto adicionada da galeria.';

  @override
  String get photosAddFromGallery => 'Adicionar da galeria';

  @override
  String get photosTakePhoto => 'Tirar foto';

  @override
  String get photosDeleteDenied =>
      'Permissões insuficientes para excluir a foto.';

  @override
  String get settingsProfileAndOrgTitle => 'Perfil e organização';

  @override
  String settingsProfileAndOrgSubtitle(Object mode, Object user) {
    return '$mode | $user';
  }

  @override
  String get settingsAuthModeFirebase => 'Firebase';

  @override
  String get settingsAuthModeGuest => 'Convidado';

  @override
  String get settingsBusinessModeTitle => 'Modo de trabalho';

  @override
  String get settingsUserRoleTitle => 'Função do usuário';

  @override
  String get settingsInviteMasterTitle => 'Convidar profissional';

  @override
  String get settingsInviteMasterSubtitle =>
      'Gerar código de convite de uso único';

  @override
  String get settingsServicesSection => 'Serviços';

  @override
  String get settingsLogoutButton => 'Sair da conta';

  @override
  String get settingsBusinessModeTeam => 'Equipe (estúdio)';

  @override
  String get settingsBusinessModeSolo => 'Solo (um profissional)';

  @override
  String get settingsRoleDirector => 'Diretor';

  @override
  String get settingsRoleMaster => 'Profissional';

  @override
  String get settingsRoleMasterOwner => 'Profissional proprietário';

  @override
  String get settingsSelectModeTitle => 'Selecionar modo';

  @override
  String get settingsModeSoloTitle => 'Solo';

  @override
  String get settingsModeSoloSubtitle => 'Um profissional';

  @override
  String get settingsModeTeamTitle => 'Equipe';

  @override
  String get settingsModeTeamSubtitle => 'Estúdio com funcionários';

  @override
  String get settingsModeUpdated => 'Modo atualizado.';

  @override
  String get settingsOrgNotFound =>
      'Organização não encontrada. Salve as configurações primeiro.';

  @override
  String settingsInviteGenerateError(Object error) {
    return 'Erro ao gerar código: $error';
  }

  @override
  String get settingsInviteDialogTitle => 'Código de convite para profissional';

  @override
  String get settingsInviteDialogDescription =>
      'Envie este código ao profissional. É de uso único e expira após ser utilizado.';

  @override
  String get settingsCopy => 'Copiar';

  @override
  String get settingsCodeCopied =>
      'Código copiado para a área de transferência';

  @override
  String get settingsInviteRegistrationHint =>
      'O profissional insere o código no campo Código de convite durante o cadastro.';

  @override
  String get settingsClose => 'Fechar';

  @override
  String get settingsSelectRoleTitle => 'Selecionar função';

  @override
  String get settingsRoleUpdated => 'Função atualizada.';

  @override
  String get settingsLogoutTitle => 'Sair';

  @override
  String get settingsLogoutMessage => 'Sair da conta atual?';

  @override
  String get settingsLogoutConfirm => 'Sair';

  @override
  String get settingsLoggedOut => 'Você saiu da conta.';

  @override
  String get settingsAccessDenied => 'Permissões insuficientes para esta ação.';

  @override
  String get settingsResetWarning =>
      'ATENÇÃO: Todos os pedidos, clientes e estoque serão excluídos!';

  @override
  String get settingsServiceDeleteDenied =>
      'Permissões insuficientes para excluir o serviço.';

  @override
  String get settingsServiceEditDenied =>
      'Permissões insuficientes para editar o serviço.';

  @override
  String get legalTitle => 'Informações legais';

  @override
  String get legalPrivacyTab => 'Política de privacidade';

  @override
  String get legalTermsTab => 'Termos';

  @override
  String get legalPrivacySummaryTitle => 'Resumo da política de privacidade';

  @override
  String get legalTermsSummaryTitle => 'Resumo dos termos de serviço';

  @override
  String get legalSummarySubtitle =>
      'Resumo rápido no app. A versão legal completa está disponível na página publicada.';

  @override
  String get legalOpenFullPrivacy => 'Abrir política completa';

  @override
  String get legalOpenFullTerms => 'Abrir termos completos';

  @override
  String get legalOpenLinkError =>
      'Não foi possível abrir o link do documento.';

  @override
  String get legalPrivacySection1Title => '1. O que o app faz';

  @override
  String get legalPrivacySection1Body =>
      'O DetailingPro Business ajuda equipes de detailing a gerenciar clientes, pedidos, agenda, estoque, chat da equipe e mídias anexadas.';

  @override
  String get legalPrivacySection2Title => '2. Dados que processamos';

  @override
  String get legalPrivacySection2Body =>
      'O app pode processar dados de conta, dados de clientes e pedidos, registros de serviços, estoque, mensagens da equipe, anexos e identificadores técnicos como tokens de notificação.';

  @override
  String get legalPrivacySection3Title => '3. Por que esses dados são usados';

  @override
  String get legalPrivacySection3Body =>
      'Os dados são usados para executar recursos principais, sincronizar entre dispositivos, enviar lembretes, apoiar colaboração e manter confiabilidade e segurança do serviço.';

  @override
  String get legalPrivacySection4Title => '4. Permissões e acesso';

  @override
  String get legalPrivacySection4Body =>
      'Permissões de câmera e mídia são solicitadas apenas para recursos como fotos e anexos. A permissão de notificações é usada para lembretes e alertas push.';

  @override
  String get legalPrivacySection5Title => '5. Infraestrutura e provedores';

  @override
  String get legalPrivacySection5Body =>
      'O app usa serviços Firebase (Authentication, Firestore, Storage, Messaging). Os dados são processados na infraestrutura desses provedores.';

  @override
  String get legalPrivacySection6Title => '6. Retenção, exclusão e direitos';

  @override
  String get legalPrivacySection6Body =>
      'Os dados são mantidos pelo tempo necessário para fornecer o serviço. Os usuários podem solicitar acesso, correção ou exclusão conforme a legislação aplicável.';

  @override
  String get legalPrivacySection7Title => '7. Contato';

  @override
  String get legalPrivacySection7Body =>
      'Dúvidas sobre privacidade: support@detailingpro-business.com';

  @override
  String get legalTermsSection1Title => '1. Escopo do serviço';

  @override
  String get legalTermsSection1Body =>
      'Detailing Pro é um aplicativo de produtividade empresarial para gerenciar agendamentos, clientes, mídia, chat interno e dados operacionais.';

  @override
  String get legalTermsSection2Title => '2. Contas e acesso';

  @override
  String get legalTermsSection2Body =>
      'Os usuários são responsáveis por manter as credenciais seguras e usar o app apenas dentro das permissões concedidas ao seu papel.';

  @override
  String get legalTermsSection3Title => '3. Uso aceitável';

  @override
  String get legalTermsSection3Body =>
      'O serviço não deve ser usado para processamento ilegal de dados, mensagens abusivas, tentativas de acesso não autorizado ou qualquer atividade que viole a lei.';

  @override
  String get legalTermsSection4Title => '4. Disponibilidade';

  @override
  String get legalTermsSection4Body =>
      'O serviço pode mudar com o tempo. Recursos podem ser adicionados, modificados ou removidos conforme o produto evolui.';

  @override
  String get legalTermsSection5Title => '5. Planos pagos';

  @override
  String get legalTermsSection5Body =>
      'Antes do lançamento, esta seção deve ser atualizada com regras finais de cobrança, renovação, período de teste, cancelamento e reembolsos para assinaturas do Google Play.';

  @override
  String get legalTermsSection6Title => '6. Limitação de responsabilidade';

  @override
  String get legalTermsSection6Body =>
      'Antes da publicação pública, substitua este rascunho por uma versão legal final revisada para sua jurisdição e estrutura empresarial.';

  @override
  String get legalTermsSection7Title => '7. Informações legais';

  @override
  String get legalTermsSection7Body =>
      'Substitua esta seção pelos dados registrados da sua empresa e informações de legislação aplicável antes de publicar na loja.';

  @override
  String get invoiceCompanyDataTitle => 'Dados da empresa';

  @override
  String get invoiceCompanyDataSubtitle => 'Para faturas';

  @override
  String get invoiceCompanyName => 'Nome da empresa';

  @override
  String get invoiceCompanyAddress => 'Endereço';

  @override
  String get invoiceCompanyPostalCode => 'Código postal';

  @override
  String get invoiceCompanyCity => 'Cidade';

  @override
  String get invoiceGenerateButton => 'Gerar fatura';

  @override
  String get invoiceVatRate => 'Taxa de IVA';

  @override
  String get settingsBookingLinkTitle => 'Link de reserva online';

  @override
  String get settingsBookingRequestsTitle => 'Pedidos online';

  @override
  String get settingsBookingLinkDialogTitle => 'Seu link de reserva';

  @override
  String get settingsBookingLinkCopied => 'Link copiado';

  @override
  String get settingsBookingLinkAuthRequired =>
      'Inicie sessão para gerar um link de reserva.';

  @override
  String get settingsBookingLinkOpen => 'Abrir';

  @override
  String get settingsWorkingHoursTitle => 'Horario de trabalho';

  @override
  String get settingsWorkingHoursSlotLabel => 'Intervalo';

  @override
  String get settingsWorkingHoursMinNoticeLabel => 'Aviso min.';

  @override
  String get settingsWorkingHoursBreakLabel => 'Pausa';

  @override
  String get settingsWorkingHoursNotice1Hour => '1 hora';

  @override
  String get settingsWorkingHoursNotice2Hours => '2 horas';

  @override
  String get settingsWorkingHoursNotice24Hours => '24 horas';

  @override
  String get bookingRequestsTitle => 'Pedidos online';

  @override
  String get bookingRequestsFirebaseUnavailable =>
      'Firebase não está configurado para reservas online.';

  @override
  String get bookingRequestsSignInRequired =>
      'Inicie sessão para ver os pedidos.';

  @override
  String bookingRequestsError(Object error) {
    return 'Erro ao carregar pedidos: $error';
  }

  @override
  String get bookingRequestsEmpty => 'Ainda não existem pedidos online.';

  @override
  String get bookingRequestServiceLabel => 'Serviço';

  @override
  String get bookingRequestScheduleLabel => 'Data/hora preferida';

  @override
  String get bookingRequestPhoneLabel => 'Telefone';

  @override
  String get bookingRequestCarLabel => 'Carro';

  @override
  String get bookingRequestNoteLabel => 'Nota';

  @override
  String get bookingRequestAccept => 'Aceitar';

  @override
  String get bookingRequestDecline => 'Recusar';

  @override
  String get bookingRequestCall => 'Ligar';

  @override
  String get bookingRequestStatusPending => 'Pendente';

  @override
  String get bookingRequestStatusAccepted => 'Aceite';

  @override
  String get bookingRequestStatusDeclined => 'Recusado';

  @override
  String get bookingRequestsFilterAll => 'Todos';

  @override
  String get bookingRequestsEmptyNew => 'Sem novas solicitações';

  @override
  String get bookingRequestsAcceptedFeedback =>
      'Solicitação aceita — o pedido será criado automaticamente';

  @override
  String get bookingRequestsDeclinedFeedback => 'Solicitação recusada';

  @override
  String get bookingRequestsDeclineConfirmContent =>
      'Recusar esta solicitação de reserva?';

  @override
  String get enterServiceName => 'O nome do serviço é obrigatório';

  @override
  String get invalidPrice => 'Insira um preço válido (0 ou mais)';

  @override
  String get invoiceTitle => 'FATURA';

  @override
  String get invoiceNumberPrefix => 'FT';

  @override
  String get invoiceSeller => 'VENDEDOR';

  @override
  String get invoiceBuyer => 'COMPRADOR';

  @override
  String get invoiceIssueDateLabel => 'Data de emissão';

  @override
  String get invoiceServiceDateLabel => 'Data do serviço';

  @override
  String get invoiceDescriptionLabel => 'Descrição';

  @override
  String get invoiceQtyLabel => 'Qtd.';

  @override
  String get invoiceNetPriceLabel => 'Preço líquido';

  @override
  String get invoiceVatPctLabel => 'IVA %';

  @override
  String get invoiceVatAmountLabel => 'Valor IVA';

  @override
  String get invoiceGrossPriceLabel => 'Preço bruto';

  @override
  String get invoiceNetTotalLabel => 'Total líquido:';

  @override
  String invoiceVatLineLabel(Object rate) {
    return 'IVA $rate:';
  }

  @override
  String get invoiceTotalDueLabel => 'A PAGAR:';

  @override
  String get invoiceFillCompanyLabel => 'Preencher dados da empresa';

  @override
  String get invoiceIssuedByLabel => 'Fatura emitida por';

  @override
  String get invoicePrimaryIdLabel => 'NIF';

  @override
  String get invoiceSecondaryIdLabel => 'Registo comercial';

  @override
  String settingsSeatUsage(Object total, Object used) {
    return '$used / $total lugares';
  }

  @override
  String get syncOfflineWarning =>
      'Sem ligação à Internet. Os dados podem estar desatualizados.';

  @override
  String get forceUpdateTitle => 'Atualização necessária';

  @override
  String get forceUpdateMessage =>
      'Está disponível uma nova versão da app. Atualize o Detailing Pro para continuar.';

  @override
  String get forceUpdateButton => 'Atualizar';

  @override
  String get storageStartupTitle => 'Armazenamento local indisponível';

  @override
  String get storageStartupBody =>
      'O Detailing Pro não conseguiu abrir a base de dados encriptada. Os dados neste dispositivo podem estar protegidos ou corrompidos.';

  @override
  String get storageStartupHint =>
      'Feche a app completamente e abra novamente. Se o problema continuar, reinstale a app (os dados na nuvem mantêm-se se iniciar sessão com a mesma conta).';

  @override
  String get storageStartupCloseApp => 'Fechar app';

  @override
  String get settingsSyncStatusTitle => 'Sincronização na nuvem';

  @override
  String settingsSyncPendingMessage(int count) {
    return '$count alterações aguardando sincronização';
  }

  @override
  String settingsSyncFailedMessage(int count) {
    return '$count alterações não sincronizadas';
  }

  @override
  String get settingsSyncRetryButton => 'Tentar sincronizar novamente';

  @override
  String get settingsSyncDiscardButton => 'Descartar alterações com falha';
}
