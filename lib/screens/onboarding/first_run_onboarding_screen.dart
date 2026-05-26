import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants.dart';

class FirstRunOnboardingScreen extends StatefulWidget {
  final Future<void> Function(bool skipped) onFinish;

  const FirstRunOnboardingScreen({super.key, required this.onFinish});

  @override
  State<FirstRunOnboardingScreen> createState() =>
      _FirstRunOnboardingScreenState();
}

class _FirstRunOnboardingScreenState extends State<FirstRunOnboardingScreen> {
  late final PageController _pageController;
  int _index = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish({required bool skipped}) async {
    if (_saving) return;

    setState(() => _saving = true);
    try {
      await widget.onFinish(skipped);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _next() async {
    final copy = _OnboardingCopy.of(context);
    if (_index == copy.slides.length - 1) {
      await _finish(skipped: false);
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCompact = size.height < 740;
    final copy = _OnboardingCopy.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _AtmosphereBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                isCompact ? 8 : 16,
                16,
                isCompact ? 12 : 20,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _saving ? null : () => _finish(skipped: true),
                      child: Text(copy.skip),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: copy.slides.length,
                      onPageChanged: (value) => setState(() => _index = value),
                      itemBuilder: (context, index) {
                        final slide = copy.slides[index];
                        return _SlideCard(
                          key: ValueKey('${slide.title}_$index'),
                          slide: slide,
                          isCompact: isCompact,
                          noteText: copy.note,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DotIndicator(
                    currentIndex: _index,
                    total: copy.slides.length,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _next,
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _index == copy.slides.length - 1
                                  ? Icons.rocket_launch
                                  : Icons.arrow_forward,
                            ),
                      label: Text(
                        _index == copy.slides.length - 1
                            ? copy.startWorking
                            : copy.continueLabel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideCard extends StatelessWidget {
  final _SlideModel slide;
  final bool isCompact;
  final String noteText;

  const _SlideCard({
    super.key,
    required this.slide,
    required this.isCompact,
    required this.noteText,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Opacity(
          opacity: scale.clamp(0.0, 1.0),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.14),
                  Colors.white.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
              boxShadow: [
                BoxShadow(
                  color: slide.accent.withValues(alpha: 0.22),
                  blurRadius: 40,
                  spreadRadius: 2,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Padding(
                  padding: EdgeInsets.all(isCompact ? 22 : 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              slide.accent,
                              slide.accent.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(slide.icon, size: 36, color: Colors.black),
                      ),
                      SizedBox(height: isCompact ? 18 : 28),
                      Text(
                        slide.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isCompact ? 26 : 30,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        slide.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: isCompact ? 15 : 17,
                          height: 1.45,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Text(
                          noteText,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const _DotIndicator({required this.currentIndex, required this.total});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(total, (i) {
        final active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: active ? 26 : 9,
          height: 9,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.white24,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _AtmosphereBackground extends StatelessWidget {
  const _AtmosphereBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F141B), Color(0xFF1B1D2C), Color(0xFF0B1016)],
            ),
          ),
        ),
        Positioned(
          top: -120,
          left: -80,
          child: _GlowBlob(
            size: 260,
            color: const Color(0xFFFFA726).withValues(alpha: 0.24),
          ),
        ),
        Positioned(
          top: 140,
          right: -100,
          child: _GlowBlob(
            size: 300,
            color: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
          ),
        ),
        Positioned(
          bottom: -120,
          left: 40,
          child: _GlowBlob(
            size: 280,
            color: const Color(0xFF81C784).withValues(alpha: 0.18),
          ),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0.0)],
          ),
        ),
      ),
    );
  }
}

class _SlideModel {
  final IconData icon;
  final String title;
  final String description;
  final Color accent;

  const _SlideModel({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
  });
}

class _OnboardingCopy {
  final List<_SlideModel> slides;
  final String skip;
  final String continueLabel;
  final String startWorking;
  final String note;

  const _OnboardingCopy({
    required this.slides,
    required this.skip,
    required this.continueLabel,
    required this.startWorking,
    required this.note,
  });

  static _OnboardingCopy of(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();

    if (lang == 'uk') {
      return const _OnboardingCopy(
        slides: [
          _SlideModel(
            icon: Icons.auto_awesome,
            title: 'Ласкаво просимо до Detailing Pro',
            description:
                'Замовлення, клієнти та склад в одному зручному робочому просторі для дітейлінг-команд.',
            accent: Color(0xFFFFB74D),
          ),
          _SlideModel(
            icon: Icons.timeline,
            title: 'Контроль щодня',
            description:
                'Одразу видно, що заплановано, що в роботі та що готово сьогодні без зайвих переходів.',
            accent: Color(0xFF4FC3F7),
          ),
          _SlideModel(
            icon: Icons.flag,
            title: 'Старт за хвилину',
            description:
                'Оберіть режим, додайте першого клієнта та створіть перше замовлення, щоб увімкнути повний сценарій.',
            accent: Color(0xFF81C784),
          ),
        ],
        skip: 'Пропустити',
        continueLabel: 'Далі',
        startWorking: 'Почати роботу',
        note:
            'Коротке навчання. Підказки можна знову відкрити в налаштуваннях.',
      );
    }

    if (lang == 'pl') {
      return const _OnboardingCopy(
        slides: [
          _SlideModel(
            icon: Icons.auto_awesome,
            title: 'Witamy w Detailing Pro',
            description:
                'Zamowienia, klienci i magazyn w jednym przejrzystym miejscu dla zespolow detailingowych.',
            accent: Color(0xFFFFB74D),
          ),
          _SlideModel(
            icon: Icons.timeline,
            title: 'Pelna kontrola kazdego dnia',
            description:
                'Od razu widzisz co jest zaplanowane, co w trakcie i co gotowe dzisiaj.',
            accent: Color(0xFF4FC3F7),
          ),
          _SlideModel(
            icon: Icons.flag,
            title: 'Start w mniej niz minute',
            description:
                'Wybierz tryb, dodaj pierwszego klienta i utworz pierwsze zlecenie, aby odblokowac pelny workflow.',
            accent: Color(0xFF81C784),
          ),
        ],
        skip: 'Pomin',
        continueLabel: 'Dalej',
        startWorking: 'Zacznij prace',
        note:
            'Szybki onboarding. Wskazowki mozna ponownie uruchomic w Ustawieniach.',
      );
    }

    if (lang == 'de') {
      return const _OnboardingCopy(
        slides: [
          _SlideModel(
            icon: Icons.auto_awesome,
            title: 'Willkommen bei Detailing Pro',
            description:
                'Auftrage, Kunden und Lager in einem klaren Arbeitsbereich fur Detailing-Teams.',
            accent: Color(0xFFFFB74D),
          ),
          _SlideModel(
            icon: Icons.timeline,
            title: 'Tagliche Kontrolle behalten',
            description:
                'Sieh sofort, was geplant ist, was lauft und was heute fertig ist.',
            accent: Color(0xFF4FC3F7),
          ),
          _SlideModel(
            icon: Icons.flag,
            title: 'In unter einer Minute starten',
            description:
                'Wahle den Modus, lege den ersten Kunden an und erstelle den ersten Auftrag.',
            accent: Color(0xFF81C784),
          ),
        ],
        skip: 'Uberspringen',
        continueLabel: 'Weiter',
        startWorking: 'Jetzt starten',
        note:
            'Kurzes Onboarding. Tipps kannst du spater in den Einstellungen erneut starten.',
      );
    }

    if (lang == 'es') {
      return const _OnboardingCopy(
        slides: [
          _SlideModel(
            icon: Icons.auto_awesome,
            title: 'Bienvenido a Detailing Pro',
            description:
                'Pedidos, clientes e inventario en un espacio claro para equipos de detailing.',
            accent: Color(0xFFFFB74D),
          ),
          _SlideModel(
            icon: Icons.timeline,
            title: 'Control diario total',
            description:
                'Ve al instante que esta reservado, que esta en proceso y que esta listo hoy.',
            accent: Color(0xFF4FC3F7),
          ),
          _SlideModel(
            icon: Icons.flag,
            title: 'Empieza en menos de un minuto',
            description:
                'Elige tu modo, agrega tu primer cliente y crea el primer pedido para activar el flujo completo.',
            accent: Color(0xFF81C784),
          ),
        ],
        skip: 'Omitir',
        continueLabel: 'Continuar',
        startWorking: 'Comenzar',
        note: 'Onboarding rapido. Puedes reabrir las sugerencias en Ajustes.',
      );
    }

    if (lang == 'it') {
      return const _OnboardingCopy(
        slides: [
          _SlideModel(
            icon: Icons.auto_awesome,
            title: 'Benvenuto in Detailing Pro',
            description:
                'Ordini, clienti e magazzino in un unico spazio pulito per team di detailing.',
            accent: Color(0xFFFFB74D),
          ),
          _SlideModel(
            icon: Icons.timeline,
            title: 'Controllo ogni giorno',
            description:
                'Vedi subito cosa e prenotato, cosa e in corso e cosa e pronto oggi.',
            accent: Color(0xFF4FC3F7),
          ),
          _SlideModel(
            icon: Icons.flag,
            title: 'Parti in meno di un minuto',
            description:
                'Scegli la modalita, aggiungi il primo cliente e crea il primo ordine.',
            accent: Color(0xFF81C784),
          ),
        ],
        skip: 'Salta',
        continueLabel: 'Avanti',
        startWorking: 'Inizia',
        note:
            'Onboarding rapido. Puoi riaprire i suggerimenti nelle Impostazioni.',
      );
    }

    if (lang == 'pt') {
      return const _OnboardingCopy(
        slides: [
          _SlideModel(
            icon: Icons.auto_awesome,
            title: 'Bem-vindo ao Detailing Pro',
            description:
                'Pedidos, clientes e estoque em um espaco organizado para equipes de detailing.',
            accent: Color(0xFFFFB74D),
          ),
          _SlideModel(
            icon: Icons.timeline,
            title: 'Controle diario completo',
            description:
                'Veja rapidamente o que esta agendado, em andamento e pronto hoje.',
            accent: Color(0xFF4FC3F7),
          ),
          _SlideModel(
            icon: Icons.flag,
            title: 'Comece em menos de um minuto',
            description:
                'Escolha o modo, adicione o primeiro cliente e crie o primeiro pedido.',
            accent: Color(0xFF81C784),
          ),
        ],
        skip: 'Pular',
        continueLabel: 'Continuar',
        startWorking: 'Comecar',
        note: 'Onboarding rapido. Voce pode reabrir as dicas em Configuracoes.',
      );
    }

    if (lang == 'tr') {
      return const _OnboardingCopy(
        slides: [
          _SlideModel(
            icon: Icons.auto_awesome,
            title: 'Detailing Pro ya hos geldiniz',
            description:
                'Siparisler, musteriler ve stok tek bir sade calisma alaninda.',
            accent: Color(0xFFFFB74D),
          ),
          _SlideModel(
            icon: Icons.timeline,
            title: 'Gunluk kontrol sizde',
            description:
                'Neyin planli, neyinin devam ettigi ve neyin hazir oldugu hemen gorulur.',
            accent: Color(0xFF4FC3F7),
          ),
          _SlideModel(
            icon: Icons.flag,
            title: 'Bir dakikadan kisa surede baslayin',
            description:
                'Modu secin, ilk musteriyi ekleyin ve ilk siparisi olusturun.',
            accent: Color(0xFF81C784),
          ),
        ],
        skip: 'Gec',
        continueLabel: 'Devam',
        startWorking: 'Basla',
        note:
            'Hizli onboarding. Ipuclarini Ayarlar ekranindan yeniden acabilirsiniz.',
      );
    }

    if (lang == 'zh') {
      return const _OnboardingCopy(
        slides: [
          _SlideModel(
            icon: Icons.auto_awesome,
            title: '欢迎使用 Detailing Pro',
            description: '订单、客户和库存集中在一个清晰的工作空间中。',
            accent: Color(0xFFFFB74D),
          ),
          _SlideModel(
            icon: Icons.timeline,
            title: '每天都在掌控中',
            description: '快速查看今日已预约、进行中和已完成的工作。',
            accent: Color(0xFF4FC3F7),
          ),
          _SlideModel(
            icon: Icons.flag,
            title: '一分钟内开始使用',
            description: '选择模式、添加首位客户并创建首个订单，即可开启完整流程。',
            accent: Color(0xFF81C784),
          ),
        ],
        skip: '跳过',
        continueLabel: '继续',
        startWorking: '开始使用',
        note: '快速引导。你可以在设置中重新打开提示。',
      );
    }

    if (lang == 'ru') {
      return const _OnboardingCopy(
        slides: [
          _SlideModel(
            icon: Icons.auto_awesome,
            title: 'Добро пожаловать в Detailing Pro',
            description:
                'Заказы, клиенты и склад в одном чистом рабочем пространстве для детейлинг-команд.',
            accent: Color(0xFFFFB74D),
          ),
          _SlideModel(
            icon: Icons.timeline,
            title: 'Контроль каждого дня',
            description:
                'Сразу видно, что запланировано, что в работе и что готово сегодня, без переключений между экранами.',
            accent: Color(0xFF4FC3F7),
          ),
          _SlideModel(
            icon: Icons.flag,
            title: 'Старт меньше чем за минуту',
            description:
                'Выберите режим, добавьте первого клиента и создайте первый заказ, чтобы открыть полный рабочий сценарий.',
            accent: Color(0xFF81C784),
          ),
        ],
        skip: 'Пропустить',
        continueLabel: 'Далее',
        startWorking: 'Начать работу',
        note: 'Короткое обучение. Подсказки можно снова открыть в настройках.',
      );
    }

    return const _OnboardingCopy(
      slides: [
        _SlideModel(
          icon: Icons.auto_awesome,
          title: 'Welcome to Detailing Pro',
          description:
              'Track orders, clients, and inventory in one clean workspace made for auto detailing teams.',
          accent: Color(0xFFFFB74D),
        ),
        _SlideModel(
          icon: Icons.timeline,
          title: 'Stay In Control Daily',
          description:
              'See what is booked, what is in progress, and what is ready today without jumping across screens.',
          accent: Color(0xFF4FC3F7),
        ),
        _SlideModel(
          icon: Icons.flag,
          title: 'Start In Less Than A Minute',
          description:
              'Pick your mode, add your first client, and create the first job to unlock full workflow guidance.',
          accent: Color(0xFF81C784),
        ),
      ],
      skip: 'Skip',
      continueLabel: 'Continue',
      startWorking: 'Start Working',
      note: 'Quick onboarding. You can reopen tips later in Settings.',
    );
  }
}
