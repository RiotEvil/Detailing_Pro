# Detailing Pro — Глубокий аудит кодовой базы
**Дата:** 2026-05-25  
**Версия:** 7.1.5 (build 23)  
**Crashlytics:** 237 крашей за 7 дней, 75% crash-free users, 63% crash-free sessions  

---

## TL;DR — Самые важные баги

| # | Файл | Баг | Приоритет | Статус |
|---|------|-----|-----------|--------|
| 1 | `functions/index.js:832` | `canUpdateOrgPlan` не объявлен → ReferenceError → `syncPlanStatus` крашится 100% | **P0** | ✅ FIXED |
| 2 | `functions/index.js:1549` | `db` не объявлен в `getBookingAvailability` → ReferenceError → 500 | **P0** | ✅ FIXED |
| 3 | `order_details_screen.dart:477` | `Image.file()` без `errorBuilder` → краш при невалидном пути к фото | **P0** | ✅ FIXED |
| 4 | `dashboard_screen.dart:58` | `service['chemistry'] as List` — unsafe cast → TypeError | **P0** | ✅ FIXED |
| 5 | `hive_setup.dart:81` | `catch(_)` при открытии бокса удаляет данные при любой I/O ошибке | **P0** | ✅ FIXED |
| 6 | `functions/index.js:832` | Org plan НИКОГДА не обновляется при покупке (следствие бага #1) | **P1** | ✅ FIXED (via #1) |
| 7 | `add_job_screen.dart:215` | `initialValue` Dropdown может не совпадать с items → assertion error | **P1** | ✅ FIXED |
| 8 | `settings_screen.dart:208` | `onChanged: (v) => settingsBox.put('locale', v)` — v может быть null | **P1** | ✅ FIXED |
| 9 | `dashboard_screen.dart:164` | `syncForOrders` вызывается `unawaited` на каждый rebuild | **P2** | ✅ FIXED |
| 10 | `invoice_service.dart:70` | `PdfGoogleFonts.notoSansRegular()` без try-catch → краш при нет сети | **P2** | ✅ FIXED |

---

## P0 — КРИТИЧЕСКИЕ (причины крашей в Crashlytics)

---

### BUG-01: `canUpdateOrgPlan` не определён в `syncPlanStatus`
**Файл:** `functions/index.js`, строка ~832  
**Серьёзность:** КРИТИЧЕСКАЯ — функция падает с 500 на каждый вызов

```javascript
// ПРОБЛЕМА: canUpdateOrgPlan нигде не объявлен!
if (canUpdateOrgPlan) {
    batch.set(firestore.collection("organizations").doc(orgId), ...);
}
```

**Последствия:**
- Каждый вызов `syncPlanStatus` завершается `ReferenceError: canUpdateOrgPlan is not defined`
- Batch.commit() никогда не выполняется → план пользователя в Firestore не обновляется
- Пользователи, купившие подписку, могут не получить доступ к платным функциям
- Каждый запуск приложения (где вызывается `RevenueCatService._syncPlanWithBackend`) получает 500

**Фикс:**
```javascript
// Добавить перед `const batch = firestore.batch();` (~строка 819):
const canUpdateOrgPlan = typeof orgId === "string" && orgId.trim().length > 0;
```

---

### BUG-02: `db` не объявлен в `getBookingAvailability`
**Файл:** `functions/index.js`, строка ~1549  
**Серьёзность:** КРИТИЧЕСКАЯ — функция всегда падает

```javascript
// В начале хэндлера нет: const db = admin.firestore();
// ...
const masterAccess = await loadOrgAccessForUid(db, masterUid); // ReferenceError: db is not defined
```

`loadOrgAccessForUid` принимает `db` как параметр, но в `getBookingAvailability` переменная не объявлена — все остальные вызовы используют `admin.firestore()` напрямую.

**Последствие:** Страница онлайн-бронирования не показывает доступное время. Все пользователи Pro/Business плана не могут принимать онлайн-заявки.

**Фикс:**
```javascript
exports.getBookingAvailability = onRequest({...}, async (req, res) => {
    if (withCors(req, res)) return;
    // ... остальные проверки ...
    
    const db = admin.firestore(); // ← ДОБАВИТЬ ЭТО
    
    try {
        const users = db.collection("users"); // также исправить: admin.firestore() → db
        // ...
        const masterAccess = await loadOrgAccessForUid(db, masterUid); // теперь работает
```

---

### BUG-03: `Image.file()` без `errorBuilder` → краш при невалидном пути фото
**Файл:** `lib/screens/order_details_screen.dart`, строки 477, 554  
**Серьёзность:** КРИТИЧЕСКАЯ — вероятно #1 источник крашей в Crashlytics

```dart
// ПРОБЛЕМА: если файл не существует — unhandled exception
Image.file(File(path), fit: BoxFit.cover)
Image.file(File(photoPath), fit: BoxFit.contain)
```

**Почему пути становятся невалидными:**
- Переустановка приложения — пути `/data/user/0/.../cache/...` меняются
- Очистка данных/кэша приложения
- Миграция устройства
- Файл удалён пользователем через файловый менеджер

**Фикс:**
```dart
Image.file(
  File(path),
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) => Container(
    width: 160,
    color: Colors.grey.shade800,
    child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
  ),
)
```

**Также проверить:** `client_details_screen.dart`, `photos_screen.dart` — там тоже могут быть `Image.file` без errorBuilder.

---

### BUG-04: `service['chemistry'] as List` — unsafe cast в `_completeOrder`
**Файл:** `lib/screens/dashboard_screen.dart`, строка ~58  
**Серьёзность:** КРИТИЧЕСКАЯ — TypeError при завершении заказа

```dart
// ПРОБЛЕМА: если 'chemistry' это null или не List → краш
final selectedChems = List.from(service['chemistry'] as List);

// ТАКЖЕ проблема:
inventoryBox.get(k)['name'] // если get(k) вернёт null → NullPointerException
```

**Фикс:**
```dart
final chemistry = service['chemistry'];
if (chemistry is! List) continue; // или безопасный cast
final selectedChems = List<dynamic>.from(chemistry);

// Для inventory lookup:
final invKey = inventoryBox.keys.firstWhere(
  (k) {
    final item = inventoryBox.get(k);
    return item is Map && item['name'] == chemName;
  },
  orElse: () => null,
);
```

---

### BUG-05: `_openBoxEncrypted` удаляет данные при ЛЮБОЙ ошибке
**Файл:** `lib/core/hive_setup.dart`, строки 79-96  
**Серьёзность:** КРИТИЧЕСКАЯ — потеря данных пользователя

```dart
try {
  return await Hive.openBox<T>(name, encryptionCipher: cipher);
} catch (_) {  // ← ЛОВИТ ВСЁ: I/O ошибки, disk full, corrupted storage
  // Предполагается что бокс незашифрован — но это может быть любая ошибка!
  final plain = await Hive.openBox<T>(name); // тоже может упасть
  // ...
  await Hive.deleteBoxFromDisk(name); // УДАЛЯЕМ ВСЕ ДАННЫЕ
```

Если телефон имеет мало места на диске, I/O ошибка при первом `openBox` будет интерпретирована как "бокс незашифрован" → бокс удаляется → все данные потеряны.

**Фикс:**
```dart
} on HiveError catch (hiveError) {
  // HiveError при открытии зашифрованного бокса = скорее всего незашифрованный legacy
  debugPrint('[Hive] Possible unencrypted box "$name": $hiveError');
  // ... миграция ...
} catch (e) {
  // Неизвестная ошибка — НЕ удаляем данные, пробрасываем
  rethrow;
}
```

---

## P1 — ВЫСОКИЕ (функциональные баги)

---

### BUG-06: Org plan никогда не обновляется через `syncPlanStatus`
**Файл:** `functions/index.js`, строка ~832 (следствие BUG-01)

Из-за `ReferenceError` в `syncPlanStatus` весь batch.commit() не выполняется:
- `users/{uid}.plan` — не обновляется
- `organizations/{orgId}.plan` — не обновляется
- Billing audit — не записывается

Пользователи должны ждать RevenueCat Webhook для обновления статуса подписки.

---

### BUG-07: `DropdownButtonFormField` с `initialValue` вне списка items
**Файл:** `lib/screens/add_job_screen.dart`, строки ~215, ~262, ~314  
**Серьёзность:** Assertion error в debug, undefined behavior в release

```dart
DropdownButtonFormField<String>(
  initialValue: _selectedClient, // может быть не в списке clients!
  items: clients.map(...).toList(),
  ...
)
```

В `_syncClientAndServiceDefaults`:
```dart
if (_selectedClient != null && !clients.contains(_selectedClient)) {
  _selectedClient = null; // обнуляем, но setState не вызывается здесь!
}
```

Это вызывается внутри `builder` без `setState`, а `initialValue` читается из поля — race condition.

**Фикс:** Убедиться, что `initialValue` всегда null или содержится в items. Использовать проверку:
```dart
final safeInitialClient = clients.contains(_selectedClient) ? _selectedClient : null;
```

---

### BUG-08: Language Dropdown `onChanged` без null check
**Файл:** `lib/screens/settings_screen.dart`, строка ~208

```dart
onChanged: (v) => settingsBox.put('locale', v), // v может быть null!
```

Если DropdownButton получает null selection → `settingsBox.put('locale', null)` → при следующем `box.get('locale', defaultValue: 'en')` возвращается null, а не 'en'.

**Фикс:**
```dart
onChanged: (v) { if (v != null) settingsBox.put('locale', v); },
```

То же самое для currency dropdown:
```dart
onChanged: (v) => settingsBox.put('currency', v), // строка ~151
```

---

### BUG-09: `_handleAuthenticated` может вызвать `configureAndLogin(null)`
**Файл:** `lib/main.dart`, строки 491-493

```dart
await RevenueCatService.configureAndLogin(
  FirebaseAuth.instance.currentUser?.uid, // может быть null в race condition
);
```

Если `currentUser` был null после только что выполненной аутентификации (редкий timing issue), передаётся null. RevenueCat service обрабатывает это gracefully, но `Purchases.logIn(null)` может дать неожиданное поведение.

---

### BUG-10: `_authSubscription` listener — нет `mounted` guard
**Файл:** `lib/main.dart`, строки 354-362

```dart
_accessProfileSubscription = CloudProfileSync.watchAccessProfile().listen(
  (profile) async {
    if (profile.isEmpty) return;
    await _applyAccessProfile(profile); // не проверяет mounted!
  },
);
```

`_applyAccessProfile` в конце вызывает `_startCloudSyncIfReady` — обращается к `_settingsBox`. Если виджет был disposed к этому моменту, будет exception.

---

### BUG-11: Invoice PDF без обработки ошибок
**Файл:** `lib/core/invoice_service.dart`, строка ~70

```dart
final fontRegular = await PdfGoogleFonts.notoSansRegular(); // HTTP запрос!
final fontBold = await PdfGoogleFonts.notoSansBold();       // HTTP запрос!
```

Если нет интернет-соединения → `SocketException` → unhandled crash.

**Фикс:**
```dart
try {
  final fontRegular = await PdfGoogleFonts.notoSansRegular();
  // ...
} catch (e) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Cannot generate invoice: no internet connection')),
  );
  return;
}
```

---

### BUG-12: `_filter` состояние в `add_job_screen.dart` — services filter сбрасывает выбранные
**Файл:** `lib/screens/add_job_screen.dart`, строки 639-656

```dart
void _syncClientAndServiceDefaults(List<String> clients, List<Map> services) {
  // ...
  _selectedServices = _selectedServices
      .where((name) => knownServiceNames.contains(name))
      .toList();
```

Это вызывается на каждый rebuild в `ValueListenableBuilder`. Если Firestore sync удаляет и пересоздаёт сервис (другое имя), выбранные услуги сбрасываются без предупреждения пользователя. При переходе в `EditOrder` прайс обнуляется.

---

## P2 — СРЕДНИЕ (UX/логические проблемы)

---

### BUG-13: `OrderReminderService.syncForOrders` в каждом rebuild
**Файлы:** `dashboard_screen.dart:164`, `jobs_screen.dart:95`

```dart
unawaited(
  OrderReminderService.syncForOrders(orders: ..., l10n: l10n),
);
```

Вызывается на каждый rebuild `ValueListenableBuilder`. При активных пользователях с 20-50 заказами — многократные вызовы `appNotifications.zonedSchedule()` в секунду. Хэш-guard помогает, но сама функция `syncForOrders` итерирует все заказы на каждый чек.

**Фикс:** Вынести в `initState` или `addPostFrameCallback`, кэшировать по orderEntries.hashCode.

---

### BUG-14: `settings_screen.dart` seat limit — хардкод вместо данных Firestore
**Файл:** `lib/screens/settings_screen.dart`, строка ~240

```dart
l10n.settingsSeatUsage(
  _activeMemberCount!,
  appPlan == AppPlan.business ? 5 : 1, // хардкод! реальный seatLimit из Firestore не читается
),
```

Если администратор вручную увеличил `seatLimit` в Firestore, UI всё равно показывает 5 или 1.

---

### BUG-15: `watchAccessProfile` — двойной Firestore listener
**Файл:** `lib/core/cloud_profile_sync.dart`, строки 232-264

```dart
return FirebaseFirestore.instance
  .collection('users').doc(user.uid).snapshots()
  .asyncExpand((userSnap) {
    // ...
    return FirebaseFirestore.instance
      .collection('organizations').doc(orgId).snapshots() // ← новая подписка на каждое обновление users!
      .map(...);
  });
```

При каждом изменении `users/{uid}` создаётся новая Firestore подписка на `organizations/{orgId}`. Старая подписка не отменяется — утечка подписок. При частых обновлениях профиля (login, token refresh) может накапливаться много подписок.

**Фикс:** Использовать `switchMap` логику с явной отменой предыдущей подписки, или использовать Firestore `zipWith`/комбинированный stream.

---

### BUG-16: `DashboardScreen.unawaited(AppDataService.syncInventoryItemToCloud(...))` без await
**Файл:** `lib/screens/dashboard_screen.dart`, строки 75-79

В `_completeOrder` после обновления инвентаря:
```dart
unawaited(AppDataService.syncInventoryItemToCloud(Map<String, dynamic>.from(item)));
```

Если `syncInventoryItemToCloud` завершится ошибкой (нет сети), WriteQueue должен это поймать, но поскольку `unawaited`, ошибка может быть потеряна. Уже обрабатывается через `WriteQueue.enqueueSet` внутри service, но стоит проверить.

---

### BUG-17: Отсутствие cleanup фото при удалении заказа
**Файл:** `lib/screens/jobs_screen.dart` (функция удаления заказа)

При удалении заказа локальные файлы фотографий (`beforePhotos`, `afterPhotos`) не удаляются с диска. Со временем накапливается мусор. После 100+ заказов с фото устройство может закончить место.

---

### BUG-18: Pagination gap в `_mirrorToHive`
**Файл:** `lib/core/app_data_service.dart`, строки 424-430

```dart
for (final entry in idToKey.entries) {
  if (!cloudIds.contains(entry.key)) {
    box.delete(entry.value); // удаляем локальные записи которых нет в cloud snapshot
  }
}
```

Если в Firestore есть > 1000 документов (лимит одного snapshot), часть документов не войдёт в `snap.docs`. Эти документы будут удалены из Hive, хотя они существуют в облаке. Для детейлинг-студий с большой историей (300+ заказов в год) это проблема.

**Рекомендация:** Добавить пагинацию или использовать `startAfter` для больших коллекций.

---

### BUG-19: `revenueCatWebhook` — мертвый код с redundant null check
**Файл:** `functions/index.js`, строки ~3074

```javascript
if (!rcApiKey) {
  // ...
  res.status(503).json(...);
  return; // ← уже вернулись если нет ключа
}
let resolved = {plan: "free", ...};

if (rcApiKey) { // ← ВСЕГДА true (мы уже вернулись если false)
  const rcResponse = await fetch(...);
  // ...
}
// resolved остаётся дефолтным если rcApiKey falsy — но мы уже вернулись
```

Не краш, но запутывает логику. Убрать лишний `if (rcApiKey)`.

---

### BUG-20: SMS body hardcoded in English
**Файл:** `functions/index.js`, строки ~2638-2641

```javascript
const smsBody = serviceName
  ? `Hi ${clientName}! Reminder: your ${serviceName} appointment is ${leadLabel}...`
  : `Hi ${clientName}! Reminder: your detailing appointment is ${leadLabel}...`;
```

SMS-напоминания всегда на английском, даже если пользователь выбрал польский/немецкий/etc. Для польского рынка — критично. Нужна интернационализация или хотя бы определение языка по `order.locale` из booking request.

---

### BUG-21: Email reminder HTML — XSS via unsanitized user data
**Файл:** `functions/index.js`, строки ~2882-2900

```javascript
const html = `
<h2>Hi ${clientName}! 👋</h2>
<p>...your <strong>${serviceName || "detailing"}</strong>...`
```

`clientName` и `serviceName` вставляются в HTML без экранирования. Если злоумышленник создаст клиента с именем `<script>alert(1)</script>`, это попадёт в письмо. Для self-XSS риск минимален, но нарушает GDPR data integrity guidelines.

**Фикс:**
```javascript
function escapeHtml(str) {
  return String(str || "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}
```

---

### BUG-22: `force_update_service.dart` — нет кэша проверки
**Файл:** `lib/core/force_update_service.dart`

Каждый `AppLifecycleState.resumed` вызывает `_checkForUpdate()` (через `initState`). При частом сворачивании/разворачивании приложения — многократные Firestore запросы к `app_config/versions`.

**Фикс:** Добавить TTL кэш (например, 24 часа):
```dart
static DateTime? _lastCheck;
static const _cacheDuration = Duration(hours: 24);

static Future<ForceUpdateResult> check() async {
  if (_lastCheck != null && DateTime.now().difference(_lastCheck!) < _cacheDuration) {
    return const ForceUpdateResult(required: false);
  }
  _lastCheck = DateTime.now();
  // ... остальная логика
}
```

---

## P3 — НИЗКИЕ (улучшения качества)

---

### BUG-23: Double negation в `settings_screen.dart`
**Файл:** `lib/screens/settings_screen.dart`, строка 43

```dart
if (!Firebase.apps.isNotEmpty) return; // логически верно, но запутывает
```

Должно быть:
```dart
if (Firebase.apps.isEmpty) return;
```

---

### BUG-24: `cloud_profile_sync.dart` — отступ
**Файл:** `lib/core/cloud_profile_sync.dart`, строка 274

```dart
  final plan = orgData?['plan']?.toString() ?? userData['plan']?.toString();
```

4 пробела вместо 2 — нарушение стиля Dart. Не баг, но стоит исправить.

---

### BUG-25: `_pendingRequestIds` в BookingRequestsScreen не очищается
**Файл:** `lib/screens/booking_requests_screen.dart`

`_pendingRequestIds` — Set<String> накапливается за время жизни экрана. При долгой сессии может содержать сотни ID принятых/отклонённых заказов.

---

### BUG-26: `OrderStatus.fromName` маскирует неизвестные статусы
**Файл:** `lib/core/constants.dart`, строка ~57

```dart
static OrderStatus fromName(String? name) {
  return OrderStatus.values.firstWhere(
    (e) => e.name == name,
    orElse: () => OrderStatus.scheduled, // неизвестный статус → scheduled
  );
}
```

Если в Firestore приходит новый статус (например, `cancelled` от будущей версии), он молча становится `scheduled`. Лучше логировать:

```dart
orElse: () {
  if (name != null && name.isNotEmpty) {
    debugPrint('[OrderStatus] Unknown status: "$name", defaulting to scheduled');
  }
  return OrderStatus.scheduled;
},
```

---

### BUG-27: `recoverStuckBookingImports` использует `updatedAt` но обновляет его на `null`
**Файл:** `functions/index.js`, строки ~2411-2413

```javascript
await doc.ref.update({
  importState: null,
  updatedAt: admin.firestore.FieldValue.serverTimestamp(), // обновляет updatedAt
});
```

Запрос использует `where("updatedAt", "<=", stuckTs)` для поиска застрявших. После reset `updatedAt` обновляется на now → следующий run не найдёт этот документ даже если `importBookingRequest` снова зависнет. Нужно использовать отдельное поле `importProcessingStartedAt`.

---

## Несостыковки и архитектурные замечания

### ARCH-01: Двойная синхронизация плана
Система имеет 3 пути обновления плана:
1. `RevenueCatService._syncPlanWithBackend()` → `syncPlanStatus` Cloud Function (сломана — BUG-01)
2. `RevenueCatService._applyCustomerInfo()` → прямая запись в Hive (работает)
3. `revenueCatWebhook` → обновление Firestore + `CloudProfileSync.watchAccessProfile` → Hive (работает)

Из-за BUG-01 путь #1 всегда падает. Firestore план обновляется только через webhook (#3). Это означает задержку от нескольких секунд до нескольких минут после покупки.

### ARCH-02: Photo storage strategy — local paths
Текущая архитектура хранит фото как локальные пути (`/data/user/0/.../...`). Это фундаментальная проблема:
- Нет резервной копии фотографий
- Пути недействительны после переустановки
- Синхронизация между устройствами невозможна

**Рекомендация:** Мигрировать на Firebase Storage. Загружать фото в `gs://project-id.appspot.com/orgs/{orgId}/orders/{orderId}/photos/` и хранить URL вместо путей.

### ARCH-03: Hive как единственная offline база
WriteQueue реализован через Hive, но при повреждении `pendingWritesBox` все незагруженные изменения теряются. Нет механизма восстановления кроме retry из Hive.

### ARCH-04: `_ensureOrgQuotasOnServer` на каждый startCloudSync
**Файл:** `lib/core/app_data_service.dart`, строки 52-53

```dart
await WriteQueue.flush();
await _ensureOrgQuotasOnServer(); // HTTP запрос при каждом старте sync!
```

`_ensureOrgQuotasOnServer` делает полный recount клиентов и заказов на сервере при каждом запуске синхронизации. На больших орг (100+ клиентов) это может быть дорого и медленно.

---

## Статус исправлений (2026-05-25)

### ✅ Закрыто (все P0 + P1 + большинство P2/P3)
| Баг | Файл | Статус |
|-----|------|--------|
| BUG-01 | functions/index.js | ✅ `canUpdateOrgPlan` объявлен |
| BUG-02 | functions/index.js | ✅ `const db = admin.firestore()` добавлен |
| BUG-03 | order_details_screen.dart + 3 других | ✅ `errorBuilder` добавлен везде |
| BUG-04 | dashboard_screen.dart | ✅ безопасный cast + null guard |
| BUG-05 | hive_setup.dart | ✅ catch сужен до `HiveError` |
| BUG-07 | add_job_screen.dart | ✅ `initialValue` защищён |
| BUG-08 | settings_screen.dart | ✅ null check в onChanged |
| BUG-09 | main.dart | ✅ null guard на uid |
| BUG-10 | main.dart | ✅ `mounted` guard в listener |
| BUG-11 | invoice_service.dart | ✅ try/catch + Helvetica fallback |
| BUG-12 | add_job_screen.dart | ✅ не сбрасывать services в edit mode |
| BUG-13 | dashboard_screen.dart, jobs_screen.dart | ✅ перенесено в postFrameCallback |
| BUG-14 | settings_screen.dart | ✅ читает `seatLimit` из Firestore |
| BUG-15 | cloud_profile_sync.dart | ✅ switchMap, нет утечки подписок |
| BUG-17 | jobs_screen.dart | ✅ фото удаляются с диска при удалении заказа |
| BUG-19 | functions/index.js | ✅ мёртвый if(rcApiKey) убран |
| BUG-21 | functions/index.js | ✅ escapeHtml() добавлен |
| BUG-22 | force_update_service.dart | ✅ TTL кэш 4 часа |
| BUG-23 | settings_screen.dart | ✅ двойное отрицание убрано |
| BUG-24 | cloud_profile_sync.dart | ✅ отступ исправлен |
| BUG-25 | booking_requests_screen.dart | ✅ remove() вне mounted-guard |
| BUG-26 | constants.dart | ✅ assert + null guard |
| BUG-27 | functions/index.js | ✅ `importProcessingStartedAt` вместо `updatedAt` |

### ⏳ Открыто (архитектурные / требуют отдельного релиза)
| Баг | Описание |
|-----|---------|
| BUG-16 | `syncInventoryItemToCloud` unawaited — уже handled WriteQueue, низкий риск |
| BUG-18 | Pagination gap в `_mirrorToHive` (>1000 docs) — требует pagination |
| BUG-20 | SMS-напоминания hardcoded English — нужна i18n |
| ARCH-01 | Двойная синхронизация плана — BUG-01 исправлен, webhook путь работает |
| ARCH-02 | Фото как локальные пути — нужна миграция на Firebase Storage |
| ARCH-03 | Hive как единственная offline база |
| ARCH-04 | `_ensureOrgQuotasOnServer` на каждый startCloudSync |

---

## Статистика аудита

| Приоритет | Количество |
|-----------|-----------|
| P0 — Критические (крашат приложение) | 5 |
| P1 — Высокие (функциональные баги) | 6 |
| P2 — Средние (UX/логика) | 10 |
| P3 — Низкие (качество кода) | 6 |
| Архитектурные | 4 |
| **ИТОГО** | **31** |

---

*Аудит проведён: 2026-05-25*  
*Версия приложения: 7.1.5 (build 23)*  
*Предыдущий аудит: 2026-05-15 (все проблемы закрыты)*
