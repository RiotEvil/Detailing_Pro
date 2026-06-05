import 'package:flutter/material.dart';

import 'constants.dart';

class SubscriptionTexts {
  SubscriptionTexts._();

  static String _lang(BuildContext context) {
    return Localizations.localeOf(context).languageCode.toLowerCase();
  }

  static String _pick(BuildContext context, Map<String, String> values) {
    final code = _lang(context);
    return values[code] ?? values['en']!;
  }

  static String planName(BuildContext context, AppPlan plan) {
    switch (plan) {
      case AppPlan.free:
        return _pick(context, {
          'en': 'Free',
          'ru': 'Бесплатный',
          'uk': 'Безкоштовний',
          'pl': 'Bezpłatny',
          'pt': 'Gratuito',
          'tr': 'Ucretsiz',
          'zh': '免费',
          'es': 'Gratis',
          'it': 'Gratis',
          'de': 'Kostenlos',
        });
      case AppPlan.pro:
        return 'Pro';
      case AppPlan.business:
        return _pick(context, {
          'en': 'Business',
          'ru': 'Бизнес',
          'uk': 'Бізнес',
          'pl': 'Business',
          'pt': 'Business',
          'tr': 'Business',
          'zh': '商业版',
          'es': 'Business',
          'it': 'Business',
          'de': 'Business',
        });
    }
  }

  static String planStatus(BuildContext context, PlanStatus status) {
    switch (status) {
      case PlanStatus.inactive:
        return _pick(context, {
          'en': 'Inactive',
          'ru': 'Неактивен',
          'pl': 'Nieaktywny',
          'pt': 'Inativo',
          'tr': 'Pasif',
          'zh': '未激活',
          'es': 'Inactivo',
          'it': 'Inattivo',
          'de': 'Inaktiv',
        });
      case PlanStatus.active:
        return _pick(context, {
          'en': 'Active',
          'ru': 'Активен',
          'pl': 'Aktywny',
          'pt': 'Ativo',
          'tr': 'Aktif',
          'zh': '已激活',
          'es': 'Activo',
          'it': 'Attivo',
          'de': 'Aktiv',
        });
      case PlanStatus.trial:
        return _pick(context, {
          'en': 'Trial',
          'ru': 'Пробный',
          'pl': 'Okres probny',
          'pt': 'Teste',
          'tr': 'Deneme',
          'zh': '试用',
          'es': 'Prueba',
          'it': 'Prova',
          'de': 'Testphase',
        });
      case PlanStatus.grace:
        return _pick(context, {
          'en': 'Grace period',
          'ru': 'Льготный период',
          'pl': 'Okres karencji',
          'pt': 'Periodo de graca',
          'tr': 'Ek sure',
          'zh': '宽限期',
          'es': 'Periodo de gracia',
          'it': 'Periodo di tolleranza',
          'de': 'Kulanzzeit',
        });
    }
  }

  static String plansAndPricing(BuildContext context) {
    return _pick(context, {
      'en': 'Plans and pricing',
      'ru': 'Тарифы и цены',
      'pl': 'Plany i ceny',
      'pt': 'Planos e precos',
      'tr': 'Planlar ve fiyatlar',
      'zh': '套餐与价格',
      'es': 'Planes y precios',
      'it': 'Piani e prezzi',
      'de': 'Tarife und Preise',
    });
  }

  static String releaseSectionTitle(BuildContext context) {
    return _pick(context, {
      'en': 'RELEASE',
      'ru': 'РЕЛИЗ',
      'pl': 'WYDANIE',
      'pt': 'LANCAMENTO',
      'tr': 'SURUM',
      'zh': '发布',
      'es': 'LANZAMIENTO',
      'it': 'RILASCIO',
      'de': 'RELEASE',
    });
  }

  static String legalDocumentsTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Legal documents',
      'ru': 'Юридические документы',
      'pl': 'Dokumenty prawne',
      'pt': 'Documentos legais',
      'tr': 'Yasal belgeler',
      'zh': '法律文件',
      'es': 'Documentos legales',
      'it': 'Documenti legali',
      'de': 'Rechtliche Dokumente',
    });
  }

  static String legalDocumentsSubtitle(BuildContext context) {
    return _pick(context, {
      'en': 'Privacy policy and terms of service.',
      'ru': 'Политика конфиденциальности и условия использования.',
      'pl': 'Polityka prywatności i warunki korzystania z usługi.',
      'pt': 'Política de privacidade e termos de serviço.',
      'tr': 'Gizlilik politikası ve kullanım koşulları.',
      'zh': '隐私政策与服务条款。',
      'es': 'Política de privacidad y condiciones de uso.',
      'it': 'Informativa sulla privacy e termini di servizio.',
      'de': 'Datenschutzrichtlinie und Nutzungsbedingungen.',
    });
  }

  static String currentPlanLine(
    BuildContext context,
    AppPlan plan,
    PlanStatus status,
  ) {
    final prefix = _pick(context, {
      'en': 'Current',
      'ru': 'Текущий',
      'pl': 'Aktualny',
      'pt': 'Atual',
      'tr': 'Mevcut',
      'zh': '当前',
      'es': 'Actual',
      'it': 'Corrente',
      'de': 'Aktuell',
    });
    return '$prefix: ${planName(context, plan)} · ${planStatus(context, status)}';
  }

  static String requiredPlan(BuildContext context, AppPlan plan) {
    final prefix = _pick(context, {
      'en': 'Required plan',
      'ru': 'Нужен тариф',
      'pl': 'Wymagany plan',
      'pt': 'Plano necessario',
      'tr': 'Gerekli plan',
      'zh': '所需套餐',
      'es': 'Plan requerido',
      'it': 'Piano richiesto',
      'de': 'Erforderlicher Tarif',
    });
    return '$prefix: ${planName(context, plan)}';
  }

  static String choosePlan(BuildContext context, String planName) {
    return _pick(context, {
      'en': 'Choose $planName',
      'ru': 'Выбрать $planName',
      'pl': 'Wybierz $planName',
      'uk': 'Обрати $planName',
      'pt': 'Escolher $planName',
      'tr': '$planName Seç',
      'zh': '选择 $planName',
      'es': 'Elegir $planName',
      'it': 'Scegli $planName',
      'de': '$planName wählen',
    });
  }

  static String viewPlans(BuildContext context) {
    return _pick(context, {
      'en': 'View plans',
      'ru': 'Смотреть тарифы',
      'pl': 'Zobacz plany',
      'pt': 'Ver planos',
      'tr': 'Planlari gor',
      'zh': '查看套餐',
      'es': 'Ver planes',
      'it': 'Vedi piani',
      'de': 'Tarife ansehen',
    });
  }

  static String businessPlanRequiredTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Business plan required',
      'ru': 'Требуется тариф Бизнес',
      'pl': 'Wymagany plan Business',
      'pt': 'Plano Business necessario',
      'tr': 'Business plani gerekli',
      'zh': '需要商业版套餐',
      'es': 'Se requiere plan Business',
      'it': 'Piano Business richiesto',
      'de': 'Business-Tarif erforderlich',
    });
  }

  static String teamWorkspaceBusinessMessage(BuildContext context) {
    return _pick(context, {
      'en':
          'See who\'s working, what\'s assigned and where the money is — without spreadsheets, group chats or guesswork.',
      'ru':
          'Смотрите кто работает, что назначено и где деньги — без таблиц, чатов и догадок.',
      'pl':
          'Widzisz kto pracuje, co jest przypisane i gdzie sa pieniadze — bez tabel, chatow i domyslow.',
      'pt':
          'Veja quem esta trabalhando, o que foi atribuido e onde esta o dinheiro — sem planilhas, chats ou suposicoes.',
      'tr':
          'Kim calisiyor, ne atanmis ve para nerede — tablo, grup sohbeti veya tahmin olmadan goruntuleyin.',
      'zh': '看清谁在工作、任务如何分配、钱在哪里——无需表格、群聊或猜测。',
      'es':
          'Ve quien trabaja, que esta asignado y donde esta el dinero — sin hojas de calculo, chats ni suposiciones.',
      'it':
          'Vedi chi lavora, cosa e assegnato e dove sono i soldi — senza fogli, chat di gruppo o supposizioni.',
      'de':
          'Sieh, wer arbeitet, was zugewiesen ist und wo das Geld ist — ohne Tabellen, Gruppenchats oder Raterei.',
    });
  }

  static String crmProTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Win back clients who\'ve gone quiet',
      'ru': 'Верните клиентов, которые пропали',
      'pl': 'Odzysk klientow, ktorzy zamilkli',
      'pt': 'Recupere clientes que sumiram',
      'tr': 'Sessizlesen musterilerinizi geri kazanin',
      'zh': '唤回沉默的客户',
      'es': 'Recupera clientes que han desaparecido',
      'it': 'Recupera i clienti che si sono persi',
      'de': 'Abgewanderte Kunden zuruckgewinnen',
    });
  }

  static String crmProMessage(BuildContext context) {
    return _pick(context, {
      'en':
          'Clients with no visit in 45+ days are potential lost revenue. Pro lets you reach them in one tap.',
      'ru':
          'Клиенты без визита 45+ дней — это потерянные деньги. Pro позволяет напомнить о себе в один клик.',
      'pl':
          'Klienci bez wizyty przez 45+ dni to utracony dochod. Pro pozwala przypomniec im o sobie jednym dotknieciem.',
      'pt':
          'Clientes sem visita ha 45+ dias sao receita perdida. O Pro permite alcanca-los com um toque.',
      'tr':
          '45+ gun ziyaret etmeyen musteriler potansiyel kaybedilen gelirdir. Pro, tek dokunusla onlara ulasmanizi saglar.',
      'zh': '45天以上未到访的客户就是潜在的流失收入。Pro 让你一键触达他们。',
      'es':
          'Los clientes sin visita en 45+ dias son ingresos perdidos. Pro te permite contactarlos con un toque.',
      'it':
          'I clienti senza visita da 45+ giorni sono ricavi persi. Pro ti permette di raggiungerli con un tap.',
      'de':
          'Kunden ohne Besuch seit 45+ Tagen sind potenziell verlorener Umsatz. Pro lasst dich sie mit einem Tipp erreichen.',
    });
  }

  static String marketingProTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Grow without buying new traffic',
      'ru': 'Рост без покупки нового трафика',
      'pl': 'Rozwijaj sie bez kupowania nowego ruchu',
      'pt': 'Cresca sem comprar novos clientes',
      'tr': 'Yeni trafik satin almadan buyuyin',
      'zh': '无需购买新流量也能增长',
      'es': 'Crece sin comprar nuevo trafico',
      'it': 'Cresci senza comprare nuovo traffico',
      'de': 'Wachse ohne neuen Traffic zu kaufen',
    });
  }

  static String marketingProMessage(BuildContext context) {
    return _pick(context, {
      'en':
          'Your existing clients are your cheapest source of new revenue. Pro gives you the tools to reach them at the right moment.',
      'ru':
          'Существующие клиенты — самый дешёвый источник новых заказов. Pro даёт инструменты, чтобы обращаться к ним в нужный момент.',
      'pl':
          'Twoi obecni klienci sa najtanszym zrodlem nowych przychodow. Pro daje narzedzia, by dotrzec do nich we wlasciwym momencie.',
      'pt':
          'Seus clientes existentes sao a fonte mais barata de nova receita. O Pro da ferramentas para alcanca-los no momento certo.',
      'tr':
          'Mevcut musterileriniz en ucuz yeni gelir kaynaginizdir. Pro, dogru anda onlara ulasmak icin araclari saglar.',
      'zh': '现有客户是你最便宜的新收入来源。Pro 提供工具，让你在合适的时机触达他们。',
      'es':
          'Tus clientes actuales son tu fuente mas barata de nuevos ingresos. Pro te da las herramientas para contactarlos en el momento justo.',
      'it':
          'I tuoi clienti esistenti sono la fonte piu economica di nuovi ricavi. Pro ti da gli strumenti per raggiungerli al momento giusto.',
      'de':
          'Deine bestehenden Kunden sind deine gunstigste Quelle fur neue Einnahmen. Pro gibt dir die Werkzeuge, sie im richtigen Moment anzusprechen.',
    });
  }

  static String bookingProTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Get clients while you work',
      'ru': 'Клиенты записываются сами, пока вы работаете',
      'pl': 'Zdobywaj klientow podczas pracy',
      'pt': 'Receba clientes enquanto trabalha',
      'tr': 'Calisirken musteri kazanin',
      'zh': '工作时也能收到客户预约',
      'es': 'Consigue clientes mientras trabajas',
      'it': 'Ricevi clienti mentre lavori',
      'de': 'Kunden gewinnen wahrend du arbeitest',
    });
  }

  static String bookingProMessage(BuildContext context) {
    return _pick(context, {
      'en':
          'Share your booking link — clients pick a time, you get the order. No calls, no back-and-forth in chats.',
      'ru':
          'Поделитесь ссылкой — клиент выбирает время, заявка сразу попадает к вам. Без звонков и переписки.',
      'pl':
          'Udostepnij link — klient wybiera czas, zlecenie trafia do ciebie. Zero telefonow i pisania na czacie.',
      'pt':
          'Compartilhe o link — o cliente escolhe o horario, o pedido chega direto a voce. Sem ligacoes nem chats.',
      'tr':
          'Baglantinizi paylasin — musteri zaman secer, siparis size gelir. Telefon ve mesajlasma yok.',
      'zh': '分享预约链接——客户选好时间，订单直接到你手上。无需打电话，无需反复沟通。',
      'es':
          'Comparte el enlace — el cliente elige horario, el pedido llega a ti. Sin llamadas ni chats interminables.',
      'it':
          'Condividi il link — il cliente sceglie l\'orario, l\'ordine arriva a te. Niente telefonate ne messaggi.',
      'de':
          'Link teilen — Kunde wahlt die Zeit, Auftrag kommt zu dir. Keine Anrufe, kein Hin-und-Her im Chat.',
    });
  }

  static String remindersProTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Stop losing money to no-shows',
      'ru': 'Перестаньте терять деньги на пустых окнах',
      'pl': 'Przestan tracic pieniadze przez nieobecnych klientow',
      'pt': 'Pare de perder dinheiro com ausencias',
      'tr': 'Gelmeyen musterilere para kaybetmeyi birakin',
      'zh': '不再因爽约损失收入',
      'es': 'Deja de perder dinero por cancelaciones',
      'it': 'Smetti di perdere soldi per le assenze',
      'de': 'Hor auf, durch No-Shows Geld zu verlieren',
    });
  }

  static String remindersProMessage(BuildContext context) {
    return _pick(context, {
      'en':
          'One missed appointment costs more than a month of Pro. Automated reminders keep your calendar full.',
      'ru':
          'Одна отмена стоит дороже месяца Pro. Автоматические напоминания держат ваш календарь заполненным.',
      'pl':
          'Jedna nieobecnosc kosztuje wiecej niz miesiac Pro. Automatyczne przypomnienia zapelniaja twoj kalendarz.',
      'pt':
          'Uma ausencia custa mais que um mes de Pro. Lembretes automaticos mantem sua agenda sempre cheia.',
      'tr':
          'Tek bir randevu kaybi, Pro\'nun aylik ucretinden fazlasina mal olur. Otomatik hatirlaticilar takviminizi dolu tutar.',
      'zh': '一次爽约的损失超过一个月的 Pro 订阅费。自动提醒让你的日历始终满满当当。',
      'es':
          'Una cita perdida cuesta mas que un mes de Pro. Los recordatorios automaticos mantienen tu agenda llena.',
      'it':
          'Un appuntamento mancato costa piu di un mese di Pro. I promemoria automatici tengono pieno il tuo calendario.',
      'de':
          'Ein verpasster Termin kostet mehr als ein Monat Pro. Automatische Erinnerungen halten deinen Kalender voll.',
    });
  }

  static String freeClientLimitTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Free plan client limit reached',
      'ru': 'Достигнут лимит клиентов на Free',
      'pl': 'Osiagnieto limit klientow w planie Free',
      'pt': 'Limite de clientes do plano Free atingido',
      'tr': 'Free plani musteri limitine ulasildi',
      'zh': '已达到免费套餐客户上限',
      'es': 'Se alcanzo el limite de clientes del plan Free',
      'it': 'Raggiunto il limite clienti del piano Free',
      'de': 'Kundenlimit im Free-Tarif erreicht',
    });
  }

  static String freeClientLimitMessage(BuildContext context, int limit) {
    return _pick(context, {
      'en':
          'The Free plan supports up to $limit clients. Upgrade to Pro for unlimited client storage.',
      'ru':
          'Тариф Free поддерживает до $limit клиентов. Перейдите на Pro для неограниченной клиентской базы.',
      'pl':
          'Plan Free obsluguje do $limit klientow. Przejdz na Pro, aby miec nielimitowana baze klientow.',
      'pt':
          'O plano Free suporta ate $limit clientes. Atualize para Pro para clientes ilimitados.',
      'tr':
          'Free plan en fazla $limit musteri destekler. Sinirsiz musteri icin Pro\'ya gecin.',
      'zh': '免费套餐最多支持 $limit 位客户。升级到 Pro 可获得无限客户数。',
      'es':
          'El plan Free admite hasta $limit clientes. Actualiza a Pro para clientes ilimitados.',
      'it':
          'Il piano Free supporta fino a $limit clienti. Passa a Pro per clienti illimitati.',
      'de':
          'Der Free-Tarif unterstutzt bis zu $limit Kunden. Upgrade auf Pro fur unbegrenzte Kunden.',
    });
  }

  static String freeOrderLimitTitle(BuildContext context) {
    return _pick(context, {
      'en': 'You\'ve outgrown the Free plan',
      'ru': 'Вы выросли из бесплатного тарифа',
      'pl': 'Wyrosles z planu Free',
      'pt': 'Voce superou o plano Free',
      'tr': 'Free planinin otesine gectiniz',
      'zh': '你已超出免费套餐',
      'es': 'Has superado el plan Free',
      'it': 'Hai superato il piano Free',
      'de': 'Du bist uber den Free-Tarif hinausgewachsen',
    });
  }

  static String freeOrderLimitMessage(BuildContext context, int limit) {
    return _pick(context, {
      'en':
          '$limit orders per month is the Free limit — and you\'re already there. Upgrade to Pro and keep going without limits.',
      'ru':
          '$limit заказов в месяц — лимит Free, и вы уже у него. Перейдите на Pro и работайте без ограничений.',
      'pl':
          '$limit zlecen miesiecznie to limit Free — i juz go osiagasz. Przejdz na Pro i pracuj bez ograniczen.',
      'pt':
          '$limit pedidos por mes e o limite Free — e voce ja chegou la. Atualize para Pro e continue sem limites.',
      'tr':
          'Aylik $limit siparis Free limitidir — ve siz zaten oraya ulastiniz. Pro\'ya gecin ve sinirsiz calisin.',
      'zh': '每月 $limit 个订单是免费套餐上限——你已经到了。升级到 Pro，继续无限制工作。',
      'es':
          '$limit pedidos al mes es el limite Free — y ya lo alcanzaste. Actualiza a Pro y sigue sin limites.',
      'it':
          '$limit ordini al mese e il limite Free — e sei gia li. Passa a Pro e lavora senza limiti.',
      'de':
          '$limit Auftrage pro Monat ist das Free-Limit — und du bist schon dort. Upgrade auf Pro und arbeite ohne Grenzen.',
    });
  }

  static String chatAttachmentsProTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Chat attachments require Pro',
      'ru': 'Вложения в чате требуют Pro',
      'pl': 'Zalaczniki na czacie wymagaja Pro',
      'pt': 'Anexos no chat exigem Pro',
      'tr': 'Sohbet ekleri Pro gerektirir',
      'zh': '聊天附件需要 Pro',
      'es': 'Los adjuntos del chat requieren Pro',
      'it': 'Gli allegati in chat richiedono Pro',
      'de': 'Chat-Anhange erfordern Pro',
    });
  }

  static String chatAttachmentsProMessage(BuildContext context) {
    return _pick(context, {
      'en':
          'Upgrade to Pro to send photos and files inside chat across your organization.',
      'ru':
          'Перейдите на Pro, чтобы отправлять фото и файлы в чате внутри вашей организации.',
      'pl':
          'Przejdz na Pro, aby wysylac zdjecia i pliki na czacie w organizacji.',
      'pt':
          'Atualize para Pro para enviar fotos e arquivos no chat da sua organizacao.',
      'tr':
          'Kurulusunuz genelinde sohbette fotograf ve dosya gondermek icin Pro\'ya gecin.',
      'zh': '升级到 Pro 以在组织内聊天中发送照片和文件。',
      'es':
          'Actualiza a Pro para enviar fotos y archivos en el chat de tu organizacion.',
      'it':
          'Passa a Pro per inviare foto e file nella chat della tua organizzazione.',
      'de':
          'Upgrade auf Pro, um Fotos und Dateien im Chat in deiner Organisation zu senden.',
    });
  }

  static String fileSharingProTitle(BuildContext context) {
    return _pick(context, {
      'en': 'File sharing requires Pro',
      'ru': 'Обмен файлами требует Pro',
      'pl': 'Udostepnianie plikow wymaga Pro',
      'pt': 'Compartilhamento de arquivos exige Pro',
      'tr': 'Dosya paylasimi Pro gerektirir',
      'zh': '文件共享需要 Pro',
      'es': 'Compartir archivos requiere Pro',
      'it': 'La condivisione file richiede Pro',
      'de': 'Dateifreigabe erfordert Pro',
    });
  }

  static String fileSharingProMessage(BuildContext context) {
    return _pick(context, {
      'en':
          'Upgrade to Pro to share documents, checklists and media files in chat.',
      'ru':
          'Перейдите на Pro, чтобы делиться документами, чек-листами и медиафайлами в чате.',
      'pl':
          'Przejdz na Pro, aby udostepniac dokumenty, checklisty i pliki multimedialne na czacie.',
      'pt':
          'Atualize para Pro para compartilhar documentos, checklists e midia no chat.',
      'tr':
          'Sohbette belge, kontrol listesi ve medya dosyalari paylasmak icin Pro\'ya gecin.',
      'zh': '升级到 Pro 以在聊天中共享文档、清单和媒体文件。',
      'es':
          'Actualiza a Pro para compartir documentos, listas y archivos multimedia en el chat.',
      'it':
          'Passa a Pro per condividere documenti, checklist e file multimediali in chat.',
      'de':
          'Upgrade auf Pro, um Dokumente, Checklisten und Mediendateien im Chat zu teilen.',
    });
  }

  static String statsProTitle(BuildContext context) {
    return _pick(context, {
      'en': 'See who\'s bringing you money',
      'ru': 'Узнайте, кто приносит вам деньги',
      'pl': 'Zobacz kto przynosi ci pieniadze',
      'pt': 'Veja quem esta trazendo dinheiro para voce',
      'tr': 'Size para getireni gorün',
      'zh': '看清谁在为你带来收入',
      'es': 'Descubre quien te trae dinero',
      'it': 'Scopri chi ti porta soldi',
      'de': 'Sieh, wer dir Geld bringt',
    });
  }

  static String statsProSubtitle(BuildContext context) {
    return _pick(context, {
      'en':
          'Which clients come back, which services pay the most, where your revenue is growing — all in Pro and Business.',
      'ru':
          'Какие клиенты возвращаются, какие услуги приносят больше всего, где растёт выручка — всё в Pro и Бизнес.',
      'pl':
          'Ktorzy klienci wracaja, ktore uslugi najbardziej sie oplacaja, gdzie rosna przychody — w Pro i Business.',
      'pt':
          'Quais clientes voltam, quais servicos pagam mais, onde sua receita cresce — tudo no Pro e Business.',
      'tr':
          'Hangi musteriler geri donuyor, hangi hizmetler en fazla kazandiriyor, geliriniz nerede artiyor — Pro ve Business\'ta.',
      'zh': '哪些客户复访、哪些服务最赚钱、收入在哪里增长——Pro 和商业版中一目了然。',
      'es':
          'Que clientes vuelven, que servicios dejan mas, donde crece tu ingreso — todo en Pro y Business.',
      'it':
          'Quali clienti ritornano, quali servizi rendono di piu, dove cresce il tuo fatturato — in Pro e Business.',
      'de':
          'Welche Kunden kommen wieder, welche Leistungen bringen am meisten, wo wachst dein Umsatz — in Pro und Business.',
    });
  }

  static String statsUpgradeTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Know your numbers',
      'ru': 'Знайте свои цифры',
      'pl': 'Znaj swoje liczby',
      'pt': 'Conheca seus numeros',
      'tr': 'Rakamlarinizi bilin',
      'zh': '了解你的数字',
      'es': 'Conoce tus numeros',
      'it': 'Conosci i tuoi numeri',
      'de': 'Kenne deine Zahlen',
    });
  }

  static String statsUpgradeMessage(BuildContext context) {
    return _pick(context, {
      'en':
          'Revenue trends, top clients and performance by service — all in Pro and Business.',
      'ru':
          'Тренды выручки, топ-клиенты и эффективность по услугам — всё в Pro и Бизнес.',
      'pl':
          'Trendy przychodow, najlepsi klienci i wydajnosc uslug — wszystko w Pro i Business.',
      'pt':
          'Tendencias de receita, melhores clientes e desempenho por servico — tudo no Pro e Business.',
      'tr':
          'Gelir trendleri, en iyi musteriler ve hizmet performansi — Pro ve Business\'ta.',
      'zh': '收入趋势、顶级客户和按服务统计的业绩——全在 Pro 和商业版中。',
      'es':
          'Tendencias de ingresos, mejores clientes y rendimiento por servicio — todo en Pro y Business.',
      'it':
          'Trend ricavi, clienti top e performance per servizio — tutto in Pro e Business.',
      'de':
          'Umsatztrends, Top-Kunden und Service-Performance — alles in Pro und Business.',
    });
  }

  static String pricingTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Plans',
      'ru': 'Тарифы',
      'pl': 'Plany',
      'pt': 'Planos',
      'tr': 'Planlar',
      'zh': '套餐',
      'es': 'Planes',
      'it': 'Piani',
      'de': 'Tarife',
    });
  }

  static String pricingIntroTitle(BuildContext context) {
    return _pick(context, {
      'en': 'International pricing baseline',
      'ru': 'Базовая международная тарификация',
      'pl': 'Bazowe ceny miedzynarodowe',
      'pt': 'Base internacional de precos',
      'tr': 'Uluslararasi fiyatlandirma tabani',
      'zh': '国际定价基线',
      'es': 'Base internacional de precios',
      'it': 'Base prezzi internazionale',
      'de': 'Internationale Preisbasis',
    });
  }

  static String pricingIntroBody(BuildContext context) {
    return _pick(context, {
      'en':
          'These plans are prepared as a starting point for Europe-first launch. Store pricing can be localized later for Poland and other markets.',
      'ru':
          'Эти тарифы подготовлены как старт для запуска в Европе. Цены в сторах можно локализовать отдельно для Польши и других рынков.',
      'pl':
          'Te plany sa przygotowane jako punkt startowy dla wdrozenia w Europie. Ceny sklepowe mozna pozniej zlokalizowac dla Polski i innych rynkow.',
      'pt':
          'Esses planos sao um ponto de partida para lancamento na Europa. Os precos da loja podem ser localizados depois para a Polonia e outros mercados.',
      'tr':
          'Bu planlar Avrupa odakli lansman icin baslangic noktasi olarak hazirlandi. Magaza fiyatlari daha sonra Polonya ve diger pazarlar icin yerlestirilebilir.',
      'zh': '这些套餐作为欧洲优先发布的起点，后续可为波兰及其他市场本地化商店价格。',
      'es':
          'Estos planes se prepararon como base para un lanzamiento inicial en Europa. Los precios de tienda se pueden localizar despues para Polonia y otros mercados.',
      'it':
          'Questi piani sono una base per il lancio iniziale in Europa. I prezzi store potranno essere localizzati in seguito per Polonia e altri mercati.',
      'de':
          'Diese Tarife sind als Ausgangspunkt fur einen Europa-Start gedacht. Store-Preise konnen spater fur Polen und andere Markte lokalisiert werden.',
    });
  }

  static String currentBadge(BuildContext context) {
    return _pick(context, {
      'en': 'Current',
      'ru': 'Текущий',
      'pl': 'Aktualny',
      'pt': 'Atual',
      'tr': 'Mevcut',
      'zh': '当前',
      'es': 'Actual',
      'it': 'Corrente',
      'de': 'Aktuell',
    });
  }

  static String recommendedBadge(BuildContext context) {
    return _pick(context, {
      'en': 'Recommended',
      'ru': 'Рекомендуем',
      'pl': 'Polecany',
      'pt': 'Recomendado',
      'tr': 'Onerilen',
      'zh': '推荐',
      'es': 'Recomendado',
      'it': 'Consigliato',
      'de': 'Empfohlen',
    });
  }

  static String planDescription(BuildContext context, AppPlan plan) {
    switch (plan) {
      case AppPlan.free:
        return _pick(context, {
          'en':
              'For solo specialists who want to try the app and keep basic operations in one place.',
          'ru':
              'Для мастеров-одиночек, которые хотят попробовать приложение и вести базовые процессы в одном месте.',
          'uk':
              'Для майстрів-одинаків, які хочуть спробувати застосунок і вести базові процеси в одному місці.',
          'pl':
              'Dla samodzielnych specjalistow, ktorzy chca przetestowac aplikacje i prowadzic podstawowe procesy w jednym miejscu.',
          'pt':
              'Para profissionais solo que querem testar o app e manter operacoes basicas em um so lugar.',
          'tr':
              'Uygulamayi denemek ve temel islemleri tek yerde tutmak isteyen tek uzmanlar icin.',
          'zh': '适合想先试用应用、并在一个地方管理基础流程的个人技师。',
          'es':
              'Para especialistas independientes que quieren probar la app y mantener operaciones basicas en un solo lugar.',
          'it':
              'Per professionisti singoli che vogliono provare l\'app e gestire le operazioni base in un unico posto.',
          'de':
              'Fur Einzel-Spezialisten, die die App testen und grundlegende Ablaufe an einem Ort verwalten wollen.',
        });
      case AppPlan.pro:
        return _pick(context, {
          'en':
              'For professionals who want bookings without phone calls, zero missed appointments and clear revenue tracking.',
          'ru':
              'Для мастеров, которым нужны записи без звонков, ноль пропущенных визитов и понятная выручка.',
          'uk':
              'Для майстрів, яким потрібні записи без дзвінків, нуль пропущених візитів і зрозумілий дохід.',
          'pl':
              'Dla profesjonalistow, ktorzy chca rezerwacji bez telefonow, zera opuszczonych wizyt i przejrzystych przychodow.',
          'pt':
              'Para profissionais que querem agendamentos sem telefonemas, zero ausencias e controle claro de receita.',
          'tr':
              'Telefonsuz randevular, sifir kacirilan randevu ve net gelir takibi isteyen profesyoneller icin.',
          'zh': '适合想要无需打电话即可预约、零爽约和清晰收入追踪的专业人士。',
          'es':
              'Para profesionales que quieren reservas sin llamadas, cero citas perdidas y seguimiento claro de ingresos.',
          'it':
              'Per professionisti che vogliono prenotazioni senza telefonate, zero appuntamenti persi e ricavi chiari.',
          'de':
              'Fur Profis, die Buchungen ohne Anrufe, null verpasste Termine und klares Umsatz-Tracking wollen.',
        });
      case AppPlan.business:
        return _pick(context, {
          'en':
              'For studios where the owner needs to see everything: who\'s working, what\'s booked and where the money is.',
          'ru':
              'Для студий, где владелец должен видеть всё: кто работает, что забронировано и где деньги.',
          'uk':
              'Для студій, де власник має бачити все: хто працює, що заброньовано і де гроші.',
          'pl':
              'Dla studiow, w ktorych wlasciciel musi widziec wszystko: kto pracuje, co jest zarezerwowane i gdzie sa pieniadze.',
          'pt':
              'Para estudios onde o dono precisa ver tudo: quem esta trabalhando, o que foi agendado e onde esta o dinheiro.',
          'tr':
              'Sahibin her seyi gormesi gereken studyolar icin: kim calisiyor, ne rezerve edildi ve para nerede.',
          'zh': '适合老板需要看清一切的门店：谁在工作、预约了什么、钱在哪里。',
          'es':
              'Para estudios donde el dueno necesita verlo todo: quien trabaja, que esta reservado y donde esta el dinero.',
          'it':
              'Per studi dove il titolare deve vedere tutto: chi lavora, cosa e prenotato e dove sono i soldi.',
          'de':
              'Fur Studios, wo der Inhaber alles sehen muss: wer arbeitet, was gebucht ist und wo das Geld ist.',
        });
    }
  }

  static String planPrice(BuildContext context, AppPlan plan) {
    switch (plan) {
      case AppPlan.free:
        return _pick(context, {
          'en': '€0 / month',
          'ru': '€0 / мес',
          'uk': '€0 / міс',
          'pl': '€0 / mies.',
          'pt': '€0 / mes',
          'tr': '€0 / ay',
          'zh': '€0 / 月',
          'es': '€0 / mes',
          'it': '€0 / mese',
          'de': '€0 / Monat',
        });
      case AppPlan.pro:
        return _pick(context, {
          'en': '€10 / month',
          'ru': '€10 / мес',
          'uk': '€10 / міс',
          'pl': '€10 / mies.',
          'pt': '€10 / mes',
          'tr': '€10 / ay',
          'zh': '€10 / 月',
          'es': '€10 / mes',
          'it': '€10 / mese',
          'de': '€10 / Monat',
        });
      case AppPlan.business:
        return _pick(context, {
          'en': '€39 / month',
          'ru': '€39 / мес',
          'uk': '€39 / міс',
          'pl': '€39 / mies.',
          'pt': '€39 / mes',
          'tr': '€39 / ay',
          'zh': '€39 / 月',
          'es': '€39 / mes',
          'it': '€39 / mese',
          'de': '€39 / Monat',
        });
    }
  }

  static List<String> planFeatures(BuildContext context, AppPlan plan) {
    switch (plan) {
      case AppPlan.free:
        return [
          _pick(context, {
            'en': '1 user',
            'ru': '1 пользователь',
            'pl': '1 uzytkownik',
            'pt': '1 usuario',
            'tr': '1 kullanici',
            'zh': '1 位用户',
            'es': '1 usuario',
            'it': '1 utente',
            'de': '1 Benutzer',
          }),
          _pick(context, {
            'en': 'Up to 5 clients',
            'ru': 'До 5 клиентов',
            'pl': 'Do 5 klientow',
            'pt': 'Ate 5 clientes',
            'tr': '5 musteriye kadar',
            'zh': '最多 5 位客户',
            'es': 'Hasta 5 clientes',
            'it': 'Fino a 5 clienti',
            'de': 'Bis zu 5 Kunden',
          }),
          _pick(context, {
            'en': 'Up to 3 active orders per month',
            'ru': 'До 3 активных заказов в месяц',
            'pl': 'Do 3 aktywnych zlecen miesiecznie',
            'pt': 'Ate 3 pedidos ativos por mes',
            'tr': 'Aylik 3 aktif siparise kadar',
            'zh': '每月最多 3 个活跃订单',
            'es': 'Hasta 3 pedidos activos por mes',
            'it': 'Fino a 3 ordini attivi al mese',
            'de': 'Bis zu 3 aktive Auftrage pro Monat',
          }),
          _pick(context, {
            'en': 'Basic calendar and client cards',
            'ru': 'Базовый календарь и карточки клиентов',
            'pl': 'Podstawowy kalendarz i karty klientow',
            'pt': 'Calendario basico e fichas de clientes',
            'tr': 'Temel takvim ve musteri kartlari',
            'zh': '基础日历与客户卡片',
            'es': 'Calendario basico y fichas de clientes',
            'it': 'Calendario base e schede clienti',
            'de': 'Basis-Kalender und Kundenkarten',
          }),
          _pick(context, {
            'en': 'Manual reminders only',
            'ru': 'Только ручные напоминания',
            'pl': 'Tylko ręczne przypomnienia',
            'pt': 'Apenas lembretes manuais',
            'tr': 'Yalnızca manuel hatırlatıcılar',
            'zh': '仅支持手动提醒',
            'es': 'Solo recordatorios manuales',
            'it': 'Solo promemoria manuali',
            'de': 'Nur manuelle Erinnerungen',
          }),
          _pick(context, {
            'en': 'No chat attachments',
            'ru': 'Без вложений в чате',
            'pl': 'Brak załączników na czacie',
            'pt': 'Sem anexos no chat',
            'tr': 'Sohbette dosya eki yok',
            'zh': '聊天不支持附件',
            'es': 'Sin adjuntos en el chat',
            'it': 'Nessun allegato in chat',
            'de': 'Keine Chat-Anhänge',
          }),
        ];
      case AppPlan.pro:
        return [
          _pick(context, {
            'en': 'Online booking link for clients',
            'ru': 'Онлайн-ссылка для записи клиентов',
            'pl': 'Link do rezerwacji online dla klientow',
            'pt': 'Link de agendamento online para clientes',
            'tr': 'Musteriler icin cevrimici rezervasyon baglantisi',
            'zh': '客户在线预约链接',
            'es': 'Enlace de reserva online para clientes',
            'it': 'Link di prenotazione online per i clienti',
            'de': 'Online-Buchungslink fur Kunden',
          }),
          _pick(context, {
            'en': '1 user',
            'ru': '1 пользователь',
            'pl': '1 uzytkownik',
            'pt': '1 usuario',
            'tr': '1 kullanici',
            'zh': '1 位用户',
            'es': '1 usuario',
            'it': '1 utente',
            'de': '1 Benutzer',
          }),
          _pick(context, {
            'en': 'Unlimited clients and orders',
            'ru': 'Безлимит клиентов и заказов',
            'pl': 'Nielimitowana liczba klientow i zlecen',
            'pt': 'Clientes e pedidos ilimitados',
            'tr': 'Sinirsiz musteri ve siparis',
            'zh': '客户与订单无限制',
            'es': 'Clientes y pedidos ilimitados',
            'it': 'Clienti e ordini illimitati',
            'de': 'Unbegrenzte Kunden und Auftrage',
          }),
          _pick(context, {
            'en': 'Automated reminders (in-app, optional SMS)',
            'ru': 'Автоматические напоминания (в приложении, опционально SMS)',
            'pl': 'Automatyczne przypomnienia (w aplikacji, opcjonalnie SMS)',
            'pt': 'Lembretes automáticos (no app, SMS opcional)',
            'tr': 'Otomatik hatırlatıcılar (uygulama içi, isteğe bağlı SMS)',
            'zh': '自动提醒（应用内，支持可选短信）',
            'es': 'Recordatorios automáticos (en app, SMS opcional)',
            'it': 'Promemoria automatici (in-app, SMS opzionale)',
            'de': 'Automatische Erinnerungen (in der App, optional per SMS)',
          }),
          _pick(context, {
            'en': 'Unlimited chat attachments',
            'ru': 'Безлимит вложений в чате',
            'pl': 'Nielimitowane zalaczniki czatu',
            'pt': 'Anexos de chat ilimitados',
            'tr': 'Sinirsiz sohbet ekleri',
            'zh': '聊天附件无限制',
            'es': 'Adjuntos de chat ilimitados',
            'it': 'Allegati chat illimitati',
            'de': 'Unbegrenzte Chat-Anhange',
          }),
          _pick(context, {
            'en': 'Cloud data sync across devices',
            'ru': 'Облачная синхронизация данных между устройствами',
            'pl': 'Synchronizacja danych w chmurze między urządzeniami',
            'pt': 'Sincronização de dados em nuvem entre dispositivos',
            'tr': 'Cihazlar arasında bulut veri senkronizasyonu',
            'zh': '跨设备云端数据同步',
            'es': 'Sincronización de datos en la nube entre dispositivos',
            'it': 'Sincronizzazione dati cloud tra dispositivi',
            'de': 'Cloud-Datensynchronisierung zwischen Geräten',
          }),
          _pick(context, {
            'en': 'Revenue and repeat-client analytics',
            'ru': 'Аналитика выручки и возвратных клиентов',
            'pl': 'Analityka przychodow i powracajacych klientow',
            'pt': 'Analise de receita e clientes recorrentes',
            'tr': 'Gelir ve tekrar gelen musteri analizi',
            'zh': '营收与复购客户分析',
            'es': 'Analitica de ingresos y clientes recurrentes',
            'it': 'Analisi ricavi e clienti ricorrenti',
            'de': 'Umsatz- und Stammkunden-Analysen',
          }),
          _pick(context, {
            'en': 'CRM campaigns',
            'ru': 'CRM-рассылки',
            'pl': 'Kampanie CRM',
            'pt': 'Campanhas de CRM',
            'tr': 'CRM kampanyaları',
            'zh': 'CRM 活动',
            'es': 'Campañas CRM',
            'it': 'Campagne CRM',
            'de': 'CRM-Kampagnen',
          }),
        ];
      case AppPlan.business:
        return [
          _pick(context, {
            'en': 'Up to 5 team members',
            'ru': 'До 5 сотрудников в команде',
            'pl': 'Do 5 czlonkow zespolu',
            'pt': 'Ate 5 membros da equipe',
            'tr': '5 ekip uyesine kadar',
            'zh': '最多 5 名团队成员',
            'es': 'Hasta 5 miembros del equipo',
            'it': 'Fino a 5 membri del team',
            'de': 'Bis zu 5 Teammitglieder',
          }),
          _pick(context, {
            'en': 'Roles and permissions',
            'ru': 'Роли и права доступа',
            'pl': 'Role i uprawnienia',
            'pt': 'Funcoes e permissoes',
            'tr': 'Roller ve izinler',
            'zh': '角色与权限',
            'es': 'Roles y permisos',
            'it': 'Ruoli e permessi',
            'de': 'Rollen und Berechtigungen',
          }),
          _pick(context, {
            'en': 'Shared team calendar',
            'ru': 'Общий календарь команды',
            'pl': 'Wspolny kalendarz zespolu',
            'pt': 'Calendario compartilhado da equipe',
            'tr': 'Paylasilan ekip takvimi',
            'zh': '团队共享日历',
            'es': 'Calendario compartido del equipo',
            'it': 'Calendario condiviso del team',
            'de': 'Gemeinsamer Team-Kalender',
          }),
          _pick(context, {
            'en': 'Organization-wide data sync',
            'ru': 'Синхронизация данных по всей организации',
            'pl': 'Synchronizacja danych w calej organizacji',
            'pt': 'Sincronizacao de dados em toda a organizacao',
            'tr': 'Kurulus genelinde veri esitleme',
            'zh': '全组织数据同步',
            'es': 'Sincronizacion de datos en toda la organizacion',
            'it': 'Sincronizzazione dati a livello organizzazione',
            'de': 'Daten-Synchronisierung in der gesamten Organisation',
          }),
          _pick(context, {
            'en': 'Work assignment by staff member',
            'ru': 'Распределение задач по сотрудникам',
            'pl': 'Przydział zadań według pracownika',
            'pt': 'Distribuição de tarefas por membro da equipe',
            'tr': 'Personele göre iş atama',
            'zh': '按员工分配任务',
            'es': 'Asignación de tareas por empleado',
            'it': 'Assegnazione attività per membro del team',
            'de': 'Aufgabenverteilung pro Mitarbeiter',
          }),
          _pick(context, {
            'en': 'Team chat and invite flow',
            'ru': 'Командный чат и система приглашений',
            'pl': 'Czat zespolowy i system zaproszen',
            'pt': 'Chat da equipe e fluxo de convites',
            'tr': 'Ekip sohbeti ve davet akisi',
            'zh': '团队聊天与邀请流程',
            'es': 'Chat de equipo y flujo de invitaciones',
            'it': 'Chat team e flusso inviti',
            'de': 'Team-Chat und Einladungsablauf',
          }),
        ];
    }
  }

  static String nextStepTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Next implementation step',
      'ru': 'Следующий шаг внедрения',
      'pl': 'Nastepny krok wdrozenia',
      'pt': 'Proximo passo de implementacao',
      'tr': 'Sonraki uygulama adimi',
      'zh': '下一步实施',
      'es': 'Siguiente paso de implementacion',
      'it': 'Prossimo passo di implementazione',
      'de': 'Nachster Implementierungsschritt',
    });
  }

  static String nextStepBody(BuildContext context) {
    return _pick(context, {
      'en':
          'Connect Google Play Billing or RevenueCat and map app access to three plan states: free, pro and business.',
      'ru':
          'Подключите Google Play Billing или RevenueCat и свяжите доступ в приложении с тремя состояниями тарифа: free, pro и business.',
      'pl':
          'Podlacz Google Play Billing lub RevenueCat i powiaz dostep aplikacji z trzema stanami planu: free, pro i business.',
      'pt':
          'Conecte Google Play Billing ou RevenueCat e vincule o acesso do app aos tres estados do plano: free, pro e business.',
      'tr':
          'Google Play Billing veya RevenueCat baglayin ve uygulama erisimini uc plan durumuna esleyin: free, pro ve business.',
      'zh':
          '接入 Google Play Billing 或 RevenueCat，并将应用权限映射到 free、pro、business 三种套餐状态。',
      'es':
          'Conecta Google Play Billing o RevenueCat y vincula el acceso de la app a tres estados de plan: free, pro y business.',
      'it':
          'Collega Google Play Billing o RevenueCat e mappa gli accessi app sui tre stati piano: free, pro e business.',
      'de':
          'Verbinde Google Play Billing oder RevenueCat und ordne App-Zugriffe den drei Tarifzustanden zu: free, pro und business.',
    });
  }

  static String debugTitle(BuildContext context) {
    return _pick(context, {
      'en': 'Debug billing scaffold',
      'ru': 'Отладочный блок биллинга',
      'pl': 'Debugowy blok billingowy',
      'pt': 'Bloco de debug de billing',
      'tr': 'Hata ayiklama faturalama blogu',
      'zh': '计费调试模块',
      'es': 'Bloque de depuracion de facturacion',
      'it': 'Blocco debug billing',
      'de': 'Debug-Billing-Block',
    });
  }

  static String debugBody(BuildContext context) {
    return _pick(context, {
      'en':
          'Visible only in debug builds. Useful before RevenueCat or Google Play Billing is connected.',
      'ru':
          'Виден только в debug-сборках. Полезен до подключения RevenueCat или Google Play Billing.',
      'pl':
          'Widoczne tylko w buildach debug. Przydatne przed podlaczeniem RevenueCat lub Google Play Billing.',
      'pt':
          'Visivel apenas em builds de debug. Util antes de conectar RevenueCat ou Google Play Billing.',
      'tr':
          'Yalnizca debug derlemelerde gorunur. RevenueCat veya Google Play Billing baglanmadan once kullanislidir.',
      'zh': '仅在调试构建中可见。在接入 RevenueCat 或 Google Play Billing 前很有用。',
      'es':
          'Visible solo en builds de depuracion. Util antes de conectar RevenueCat o Google Play Billing.',
      'it':
          'Visibile solo nelle build debug. Utile prima di collegare RevenueCat o Google Play Billing.',
      'de':
          'Nur in Debug-Builds sichtbar. Nützlich vor der Anbindung von RevenueCat oder Google Play Billing.',
    });
  }

  static String debugPlanSwitched(BuildContext context, AppPlan plan) {
    final prefix = _pick(context, {
      'en': 'Debug plan switched to',
      'ru': 'Debug-тариф переключен на',
      'pl': 'Plan debug przelaczono na',
      'pt': 'Plano de debug alterado para',
      'tr': 'Hata ayiklama plani su sekilde degistirildi',
      'zh': '调试套餐已切换为',
      'es': 'Plan de depuracion cambiado a',
      'it': 'Piano debug cambiato in',
      'de': 'Debug-Tarif umgestellt auf',
    });
    return '$prefix ${planName(context, plan)}';
  }

  static String debugSetPlan(BuildContext context, AppPlan plan) {
    final prefix = _pick(context, {
      'en': 'Set',
      'ru': 'Установить',
      'pl': 'Ustaw',
      'pt': 'Definir',
      'tr': 'Ayarla',
      'zh': '设为',
      'es': 'Establecer',
      'it': 'Imposta',
      'de': 'Setze',
    });
    return '$prefix ${planName(context, plan)}';
  }

  static String planActivated(BuildContext context, String planTitle) {
    final prefix = _pick(context, {
      'en': 'Plan',
      'ru': 'Тариф',
      'uk': 'Тариф',
      'pl': 'Plan',
      'pt': 'Plano',
      'tr': 'Plan',
      'zh': '套餐',
      'es': 'Plan',
      'it': 'Piano',
      'de': 'Tarif',
    });
    final suffix = _pick(context, {
      'en': 'activated',
      'ru': 'активирован',
      'uk': 'активовано',
      'pl': 'aktywowany',
      'pt': 'ativado',
      'tr': 'aktif edildi',
      'zh': '已激活',
      'es': 'activado',
      'it': 'attivato',
      'de': 'aktiviert',
    });
    return '$prefix $planTitle $suffix.';
  }

  static String purchaseFailed(BuildContext context, String detail) {
    final prefix = _pick(context, {
      'en': 'Purchase failed',
      'ru': 'Ошибка покупки',
      'uk': 'Помилка покупки',
      'pl': 'Blad zakupu',
      'pt': 'Falha na compra',
      'tr': 'Satin alma hatasi',
      'zh': '购买失败',
      'es': 'Error en la compra',
      'it': 'Acquisto fallito',
      'de': 'Kauf fehlgeschlagen',
    });
    return '$prefix: $detail';
  }

  static String restorePurchasesLabel(BuildContext context) {
    return _pick(context, {
      'en': 'Restore purchases',
      'ru': 'Восстановить покупки',
      'uk': 'Відновити покупки',
      'pl': 'Przywroc zakupy',
      'pt': 'Restaurar compras',
      'tr': 'Satin alimlari geri yukle',
      'zh': '恢复购买',
      'es': 'Restaurar compras',
      'it': 'Ripristina acquisti',
      'de': 'Kaeufe wiederherstellen',
    });
  }

  static String purchasesRestored(BuildContext context) {
    return _pick(context, {
      'en': 'Purchases restored.',
      'ru': 'Покупки восстановлены.',
      'uk': 'Покупки відновлено.',
      'pl': 'Zakupy przywrocono.',
      'pt': 'Compras restauradas.',
      'tr': 'Satin alimlar geri yuklendi.',
      'zh': '购买已恢复。',
      'es': 'Compras restauradas.',
      'it': 'Acquisti ripristinati.',
      'de': 'Kaeufe wiederhergestellt.',
    });
  }

  static String restoreFailed(BuildContext context, String detail) {
    final prefix = _pick(context, {
      'en': 'Restore failed',
      'ru': 'Ошибка восстановления',
      'uk': 'Помилка відновлення',
      'pl': 'Blad przywracania',
      'pt': 'Falha na restauracao',
      'tr': 'Geri yukleme hatasi',
      'zh': '恢复失败',
      'es': 'Error al restaurar',
      'it': 'Ripristino fallito',
      'de': 'Wiederherstellung fehlgeschlagen',
    });
    return '$prefix: $detail';
  }

  // --- Paywall hero screen ---

  static String paywallHeadline(BuildContext context) {
    return _pick(context, {
      'en': 'Still tracking jobs in WhatsApp?',
      'ru': 'Ведёшь учёт в WhatsApp?',
      'uk': 'Ведеш облік у WhatsApp?',
      'pl': 'Prowadzisz ewidencje na WhatsApp?',
      'pt': 'Ainda anotando tudo no WhatsApp?',
      'tr': 'Isi hala WhatsApp\'tan mi takip ediyorsunuz?',
      'zh': '还在用 WhatsApp 记账？',
      'es': '¿Todavia llevas las cuentas en WhatsApp?',
      'it': 'Gestisci ancora tutto su WhatsApp?',
      'de': 'Verwaltest du noch alles uber WhatsApp?',
    });
  }

  static String paywallSubtitle(BuildContext context) {
    return _pick(context, {
      'en':
          'Detailing Pro keeps your clients, history, photos, and calculates income — automatically.',
      'ru':
          'Detailing Pro хранит клиентов, историю, фото и считает доход — автоматически.',
      'uk':
          'Detailing Pro зберігає клієнтів, історію, фото і рахує дохід — автоматично.',
      'pl':
          'Detailing Pro przechowuje klientow, historie, zdjecia i liczy dochod — automatycznie.',
      'pt':
          'Detailing Pro guarda clientes, historico, fotos e calcula a renda — automaticamente.',
      'tr':
          'Detailing Pro musterileri, gecmisi, fotograflari saklar ve geliri hesaplar — otomatik olarak.',
      'zh': 'Detailing Pro 自动存储客户、历史记录、照片并计算收入。',
      'es':
          'Detailing Pro guarda clientes, historial, fotos y calcula ingresos — automaticamente.',
      'it':
          'Detailing Pro memorizza clienti, storico, foto e calcola i guadagni — automaticamente.',
      'de':
          'Detailing Pro speichert Kunden, Verlauf, Fotos und berechnet Einnahmen — automatisch.',
    });
  }

  static String paywallBenefit1(BuildContext context) {
    return _pick(context, {
      'en': 'All clients in one place',
      'ru': 'Все клиенты в одном месте',
      'uk': 'Всі клієнти в одному місці',
      'pl': 'Wszyscy klienci w jednym miejscu',
      'pt': 'Todos os clientes em um lugar',
      'tr': 'Tum musteriler tek bir yerde',
      'zh': '所有客户一目了然',
      'es': 'Todos los clientes en un solo lugar',
      'it': 'Tutti i clienti in un unico posto',
      'de': 'Alle Kunden an einem Ort',
    });
  }

  static String paywallBenefit2(BuildContext context) {
    return _pick(context, {
      'en': 'Revenue stats for any period',
      'ru': 'Статистика дохода за любой период',
      'uk': 'Статистика доходу за будь-який період',
      'pl': 'Statystyki przychodu za dowolny okres',
      'pt': 'Estatisticas de receita para qualquer periodo',
      'tr': 'Herhangi bir donem icin gelir istatistikleri',
      'zh': '任意时期的收入统计',
      'es': 'Estadisticas de ingresos para cualquier periodo',
      'it': 'Statistiche entrate per qualsiasi periodo',
      'de': 'Einnahmenstatistik fur beliebige Zeitraume',
    });
  }

  static String paywallBenefit3(BuildContext context) {
    return _pick(context, {
      'en': 'Reminders — clients come back on their own',
      'ru': 'Напоминания — клиенты возвращаются сами',
      'uk': 'Нагадування — клієнти повертаються самі',
      'pl': 'Przypomnienia — klienci wracaja sami',
      'pt': 'Lembretes — os clientes voltam por conta propria',
      'tr': 'Hatirlatmalar — musteriler kendileri geri donuyor',
      'zh': '自动提醒——客户自己回来',
      'es': 'Recordatorios — los clientes vuelven solos',
      'it': 'Promemoria — i clienti tornano da soli',
      'de': 'Erinnerungen — Kunden kommen von selbst zuruck',
    });
  }

  static String paywallTagline(BuildContext context) {
    return _pick(context, {
      'en': 'Less than one car wash a month',
      'ru': 'Меньше одной мойки в месяц',
      'uk': 'Менше однієї мийки на місяць',
      'pl': 'Mniej niz jedna myjnia miesiecznie',
      'pt': 'Menos do que uma lavagem por mes',
      'tr': 'Ayda bir aracin yikama ucretinden az',
      'zh': '每月不到洗一辆车的钱',
      'es': 'Menos que un lavado de auto al mes',
      'it': 'Meno di un lavaggio al mese',
      'de': 'Weniger als eine Autowaesche im Monat',
    });
  }

  static String paywallActiveBadge(BuildContext context) {
    return _pick(context, {
      'en': '✓ Your current plan',
      'ru': '✓ Ваш текущий план',
      'uk': '✓ Ваш поточний план',
      'pl': '✓ Twoj aktualny plan',
      'pt': '✓ Seu plano atual',
      'tr': '✓ Mevcut planınız',
      'zh': '✓ 当前套餐',
      'es': '✓ Tu plan actual',
      'it': '✓ Il tuo piano attuale',
      'de': '✓ Ihr aktueller Tarif',
    });
  }

  static String paywallBusinessLabel(BuildContext context, String price) {
    return _pick(context, {
      'en': 'For teams: Business — $price / month',
      'ru': 'Для команд: Business — $price / мес',
      'uk': 'Для команд: Business — $price / міс',
      'pl': 'Dla zespolow: Business — $price / mies',
      'pt': 'Para equipes: Business — $price / mes',
      'tr': 'Ekipler icin: Business — $price / ay',
      'zh': '团队版：Business — $price / 月',
      'es': 'Para equipos: Business — $price / mes',
      'it': 'Per i team: Business — $price / mese',
      'de': 'Fur Teams: Business — $price / Monat',
    });
  }

  // --- Trial CTA ---

  static String trialCta(BuildContext context) {
    return _pick(context, {
      'en': 'Try free for 7 days',
      'ru': 'Попробовать бесплатно 7 дней',
      'uk': 'Спробувати безкоштовно 7 днів',
      'pl': 'Wyprobuj za darmo przez 7 dni',
      'pt': 'Experimentar gratis por 7 dias',
      'tr': '7 gun ucretsiz dene',
      'zh': '免费试用 7 天',
      'es': 'Probar gratis 7 dias',
      'it': 'Prova gratis 7 giorni',
      'de': '7 Tage kostenlos testen',
    });
  }

  static String afterTrialNote(BuildContext context, String price) {
    return _pick(context, {
      'en': 'Then $price/mo. Cancel anytime.',
      'ru': 'Затем $price/мес. Отмена в любой момент.',
      'uk': 'Потім $price/міс. Скасування будь-коли.',
      'pl': 'Potem $price/mies. Anuluj kiedy chcesz.',
      'pt': 'Depois $price/mes. Cancele quando quiser.',
      'tr': 'Sonra $price/ay. Istediginizde iptal edin.',
      'zh': '之后 $price/月，随时取消。',
      'es': 'Luego $price/mes. Cancela cuando quieras.',
      'it': 'Poi $price/mese. Disdici in qualsiasi momento.',
      'de': 'Dann $price/Monat. Jederzeit kundbar.',
    });
  }

  // --- Soft paywall ---

  static String softPaywallTitle(BuildContext context) {
    return _pick(context, {
      'en': 'You\'ve reached the Free limit',
      'ru': 'Вы достигли лимита Free',
      'uk': 'Ви досягли ліміту Free',
      'pl': 'Osiagnales limit planu Free',
      'pt': 'Voce atingiu o limite Free',
      'tr': 'Free limitine ulastiniz',
      'zh': '您已达到免费套餐上限',
      'es': 'Has alcanzado el limite Free',
      'it': 'Hai raggiunto il limite Free',
      'de': 'Du hast das Free-Limit erreicht',
    });
  }

  static String softPaywallSubtitle(BuildContext context) {
    return _pick(context, {
      'en': 'Upgrade to Pro to keep going',
      'ru': 'Перейдите на Pro чтобы продолжить работу',
      'uk': 'Перейдіть на Pro щоб продовжити роботу',
      'pl': 'Przejdz na Pro, aby kontynuowac prace',
      'pt': 'Atualize para Pro para continuar trabalhando',
      'tr': 'Calismaya devam etmek icin Pro\'ya gecin',
      'zh': '升级到 Pro 以继续工作',
      'es': 'Actualiza a Pro para seguir trabajando',
      'it': 'Passa a Pro per continuare a lavorare',
      'de': 'Upgrade auf Pro, um weiterzumachen',
    });
  }

  static String softPaywallPrice(BuildContext context) {
    return _pick(context, {
      'en': '€10 / month',
      'ru': '€10 / месяц',
      'uk': '€10 / місяць',
      'pl': '€10 / miesiac',
      'pt': '€10 / mes',
      'tr': '€10 / ay',
      'zh': '€10 / 月',
      'es': '€10 / mes',
      'it': '€10 / mese',
      'de': '€10 / Monat',
    });
  }

  static String softPaywallCta(BuildContext context) {
    return _pick(context, {
      'en': 'Start 7-day free trial',
      'ru': 'Начать 7 дней бесплатно',
      'uk': 'Почати 7 днів безкоштовно',
      'pl': 'Rozpocznij 7-dniowy okres probny',
      'pt': 'Iniciar 7 dias gratis',
      'tr': '7 gunluk ucretsiz deneme baslat',
      'zh': '开始 7 天免费试用',
      'es': 'Iniciar prueba gratuita de 7 dias',
      'it': 'Inizia 7 giorni gratis',
      'de': '7-tagige Testversion starten',
    });
  }

  static String softPaywallDismiss(BuildContext context) {
    return _pick(context, {
      'en': 'Not now',
      'ru': 'Не сейчас',
      'uk': 'Не зараз',
      'pl': 'Nie teraz',
      'pt': 'Agora nao',
      'tr': 'Simdi degil',
      'zh': '暂时不用',
      'es': 'Ahora no',
      'it': 'Non ora',
      'de': 'Nicht jetzt',
    });
  }

  static String clientSlotWarning(BuildContext context, int remaining) {
    return _pick(context, {
      'en': '$remaining slot left. Pro — unlimited for €10/mo',
      'ru': 'Остался $remaining слот. Pro — безлимит за €10/мес',
      'uk': 'Залишився $remaining слот. Pro — безліміт за €10/міс',
      'pl': 'Zostal $remaining slot. Pro — bez limitu za €10/mies',
      'pt': '$remaining slot restante. Pro — ilimitado por €10/mes',
      'tr': '$remaining slot kaldi. Pro — €10/ay sinirsiz',
      'zh': '剩 $remaining 个名额。Pro — €10/月无限',
      'es': 'Queda $remaining espacio. Pro — ilimitado por €10/mes',
      'it': '$remaining slot rimasto. Pro — illimitato a €10/mese',
      'de': '$remaining Slot ubrig. Pro — unbegrenzt fur €10/Mon',
    });
  }

  static String orderSlotWarning(BuildContext context, int remaining) {
    return _pick(context, {
      'en': '$remaining order left this month',
      'ru': 'Остался $remaining заказ в этом месяце',
      'uk': 'Залишився $remaining замовлення цього місяця',
      'pl': 'Zostalo $remaining zlecenie w tym miesiacu',
      'pt': '$remaining pedido restante este mes',
      'tr': 'Bu ay $remaining siparis kaldi',
      'zh': '本月还剩 $remaining 个订单',
      'es': 'Queda $remaining pedido este mes',
      'it': '$remaining ordine rimasto questo mese',
      'de': '$remaining Auftrag verbleibend diesen Monat',
    });
  }

  static String upgradeLabel(BuildContext context) {
    return _pick(context, {
      'en': 'Upgrade',
      'ru': 'Апгрейд',
      'uk': 'Апгрейд',
      'pl': 'Ulepszenie',
      'pt': 'Upgrade',
      'tr': 'Yukselt',
      'zh': '升级',
      'es': 'Mejorar',
      'it': 'Aggiorna',
      'de': 'Upgrade',
    });
  }
}
