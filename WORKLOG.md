# WORKLOG

Этот файл ведется как единый журнал прогресса по проекту.
После каждого изменения кода, правки контента или деплоя сюда добавляется новая запись.

## Как вести

- Фиксировать: что изменено, где изменено, результат проверки.
- Отдельно отмечать: что сделано, что в работе, что дальше.
- При вопросе "на чем мы остановились" сначала смотреть этот файл.

## Текущее состояние

Обновлено: 2026-05-22

### Сделано

- ✅ Подготовлена релизная версия `7.1.4+22`
- ✅ Подготовлен пакет выкладки v22: обновлен `PLAYMARKET_CHECKLIST.md` и добавлен `RELEASE_NOTES_V22.md`
- ✅ Закрыты P0-фиксы: rules isolation, invites backend flow, setBusinessMode hardening, force-update deadlock fix, sync client counter conflict fix, public_users privacy tightening, key.properties placeholders
- ✅ Проверка `get_errors`: без ошибок
- ✅ В `Settings` добавлена кнопка повторного запуска обучения (с подтверждением и сбросом прогресса)
- ✅ Onboarding расширен на все основные локали приложения (`ru/en/uk/pl/de/es/it/pt/tr/zh`)
- ✅ Добавлена локализация onboarding экрана (RU/EN) + улучшены микро-анимации появления карточек
- ✅ Добавлены одноразовые контекстные post-login подсказки по вкладкам в `MainNavigationScreen` (с флагами в Hive)
- ✅ Добавлен визуальный first-run onboarding (градиентный экран, стеклянные карточки, индикатор шагов, CTA)
- ✅ Онбординг подключен в стартовую развилку AuthGate с флагами в Hive и версионированием
- ✅ Добавлена миграция default-ключей onboarding в setup Hive
- ✅ `functions/index.js`: `TWILIO_FROM_NUMBER` переведён с `defineSecret` на `process.env` → деплой без ошибки
- ✅ Cloud Functions задеплоены: `sendAppointmentSmsReminders` и `resetMonthlySmsCounters` — CREATED
- ✅ `pubspec.yaml` обновлён до `7.1.1+18` (синхронизировано с build number)
- ✅ AAB пересобран с версией `7.1.1+18` (54.4MB)
- ✅ Тесты `access_guard_test.dart` 31/31 зелёные (лимит Free = 20)
- ✅ Настроены Firebase secrets: `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`
- ✅ Исправлена ошибка в `lib/core/invite_service.dart` (tx.get → .get())
- ✅ Firestore/Storage rules задеплоены
- ✅ Firestore indexes задеплоены
- ✅ Firestore документ `app_config/versions` создан для Force Update (min build: 18)
- ✅ **SECURITY AUDIT P0**: Firestore rules — ограничен global read `public_users` (get vs list), закрыт cross-org invite escalation (usedBy == currentUid + list только для adminRights)
- ✅ **SECURITY AUDIT P0**: RevenueCat webhook — fail-closed: обязателен REVENUECAT_WEBHOOK_SECRET (503 при отсутствии), обязателен REVENUECAT_SECRET_KEY (503 при отсутствии), добавлен в secrets webhook-функции
- ✅ **RELIABILITY AUDIT P0**: SMS/Email reminders — не помечать окно обработанным при failed; retry до 3 раз с retryCount, закрытие окна только после 3 неудач
- ✅ **RELIABILITY AUDIT P0**: Booking import recovery — логика импорта вынесена в `importBookingRequest()`, добавлен scheduler `recoverStuckBookingImports` (каждые 10 мин, восстанавливает заявки в processing > 5 мин)
- ✅ **RELIABILITY AUDIT P0**: Auth/roles bootstrap — `syncBusinessMode` переведён на Cloud Function `setBusinessMode` (Admin SDK); прямые записи `orgId/role` в `users` с клиента убраны
- ✅ **PERFORMANCE AUDIT P1**: N+1 в SMS/Email schedulers — добавлен per-window кэш org и client (Map), inline-проверка квоты без повторных чтений Firestore
- ✅ **SECURITY AUDIT P1**: `getBookingAvailability` — убрана утечка `String(error)` в ответ клиенту; добавлен флаг `indexFallbackUsed` и warning-лог при fallback scan
- ✅ **PERFORMANCE AUDIT P2**: `SettingsScreen` — `listenable()` заменён на `listenable(keys: [...])` только с нужными ключами (9 ключей), снижены лишние rebuilds
- ✅ RevenueCat purchase setup tightened for local VS Code runs: invalid keys no longer count as enabled, pricing screen now shows an unavailable banner and snackbar fallback, and VS Code launch uses `build_config.env`

### В работе

- ⏳ Финальная ручная проверка на физическом Android-устройстве (Google Sign-In, Firebase, RevenueCat)
- ⏳ Загрузка AAB 7.1.4+22 в Play Console
- ⏳ Вставка release notes для 10 локалей из RELEASE_NOTES_V22.md
- ⏳ Запуск staged rollout (5% → 25% → 100%)

### Дальше

- 📋 После ручной проверки подтвердить чеклист релиза и зафиксировать результат в WORKLOG
- 📋 Опубликовать v22 через staged rollout и мониторить crash-free/users feedback первые 24 часа
- 📋 Вернуться к пост-релизным задачам (Twilio номер и возврат defineSecret для TWILIO_FROM_NUMBER)

## Лента изменений

### 2026-05-20

- Релизная подготовка: версия `pubspec.yaml` обновлена до `7.1.4+22`.
- Успешная сборка финального AAB `7.1.4+22`.
- Подготовлены release notes для 10 локалей (файл `RELEASE_NOTES_V22.md`).
- Smoke `createBookingRequest`: штатные JSON-вызовы возвращают `400 invalid-payload`; inline `curl` может давать `500` как артефакт парсинга.
- Закрыты P0-фиксы: rules isolation, invites backend flow, setBusinessMode hardening, force-update deadlock fix, sync client counter conflict fix, public_users privacy tightening, key.properties placeholders.
- Проверка `get_errors`: без ошибок.
- Следующий шаг: финальная ручная проверка на устройстве, загрузка AAB 7.1.4+22 в Play Console и запуск staged rollout.

### 2026-05-22

- RevenueCat enabled-state now requires a non-empty public SDK key starting with `appl_` on Android/iOS; web remains disabled.
- `PricingScreen` now shows a visible unavailable card when RevenueCat is not configured and shows a snackbar on buy/restore taps in that state.
- Added `.vscode/launch.json` so VS Code debug runs launch `lib/main.dart` with `--dart-define-from-file=build_config.env`.
- Verification: `get_errors` for `lib/core/revenuecat_config.dart` and `lib/screens/pricing_screen.dart` returned no errors.

### 2026-05-05

- Полный аудит безопасности и надёжности (App Council: Reliability Skeptic, Security Guardian, UX Critic, Performance Optimizer, Release Arbiter).
- Закрыты все 4 P0 блокера релиза: auth/roles, payments webhook, reminders retry, booking import recovery.
- Исправлены Firestore rules: public_users listing, invite cross-org escalation.
- RevenueCat webhook: fail-closed при отсутствии секретов.
- SMS/Email schedulers: retry-логика (не теряем напоминания при transient failure).
- Booking import: вынесен в отдельную функцию + scheduler автовосстановления для застрявших заявок.
- Auth/roles: `CloudProfileSync.syncBusinessMode` переведён на Cloud Function `setBusinessMode` (обход блокировки rules на запись `orgId/role` с клиента).
- Performance: кэши в schedulers, убран error leak из публичных endpoints, settings listenable scope.
- Следующий шаг: задеплоить обновлённые Functions + rules + провести end-to-end smoke test.

### 2026-05-04

- Добавлен управляемый перезапуск обучения из экрана настроек.
- Добавлена поддержка мультиязычного onboarding для всех текущих языков интерфейса.
- Добавлен второй этап обучения: контекстные подсказки после входа в основные разделы (один раз на раздел).
- Добавлена локализация текста onboarding без подключения новых зависимостей.
- Реализован первый этап красивого онбординга для новых пользователей:
  - новый экран onboarding с PageView и кастомным атмосферным фоном;
  - сохранение состояния/версии онбординга в settings Hive;
  - подключение показа до auth flow в AuthGate.
- В Firebase Firestore создан документ `app_config/versions` для Force Update.
- Поля билдов сохранены типом `int64`: `minAndroidBuild=18`, `minIosBuild=18`.
- Финальный AAB `build/app/outputs/bundle/release/app-release.aab` загружен в Play Console.
- Следующий шаг: проверить настройки релиза и отправить на review/publish.

### 2026-05-03

- Инициализирован `WORKLOG.md` как единая точка учета прогресса и следующего шага.
- Сборка `flutter build appbundle --release --build-number=18` сначала упала из-за ошибки типов в `lib/core/invite_service.dart`.
- Ошибка исправлена: получение пользователей по `orgId` переведено на обычный запрос Firestore `.get()`.
- Повторная сборка успешна: `build/app/outputs/bundle/release/app-release.aab` (54.4MB).
- Выполнена проверка перед загрузкой: файл `build/app/outputs/bundle/release/app-release.aab` присутствует, ошибок анализа в проекте не найдено.
- Pre-release аудит перед публикацией (GO/NO-GO):
  - Unit-тесты упали: `test/access_guard_test.dart` ожидает старый лимит Free=100, тогда как в коде установлен 20.
  - Проверка secrets: `TWILIO_ACCOUNT_SID` и `TWILIO_AUTH_TOKEN` есть, `TWILIO_FROM_NUMBER` отсутствует (404).
  - Проверка прод-функций: в Firebase есть `onBookingRequestAccepted`, `revenueCatWebhook` и др., но нет scheduler-функций SMS (`sendAppointmentSmsReminders`, `resetMonthlySmsCounters`).
  - Версия в `pubspec.yaml`: `7.1.1+17`; текущий AAB собран вручную с `--build-number=18`.
