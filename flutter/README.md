# Flutter Technical Test

Dua aplikasi Flutter terpisah untuk technical test:

| Folder | Deskripsi |
|--------|-----------|
| [todo-local](todo-local) | CRUD Todo + search + filter + persist `SharedPreferences` |
| [todo-api](todo-api) | CRUD Todo via **DummyJSON** + loading/error + search + filter + infinite scroll |

## Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable)
- Jalankan `flutter doctor` sampai environment siap untuk target platform kamu (Android / iOS / Windows / web).

## Menjalankan

### Todo Local

```bash
cd flutter/todo-local
flutter pub get
flutter run
```

### Todo API

```bash
cd flutter/todo-api
flutter pub get
flutter run
```

Pastikan perangkat/emulator punya akses internet untuk project API.

## Kualitas

```bash
cd flutter/todo-local   # atau todo-api
flutter analyze
flutter test
```

Catatan: di beberapa lingkungan Windows, `flutter test` bisa diblokir oleh Application Control policy. Jika terjadi, jalankan test dari mesin lokal atau IDE.

## Arsitektur (ringkas)

Keduanya memakai **Provider (`ChangeNotifier`)** dan struktur modular:

- `lib/core` — theme, constants
- `lib/features/todo/domain` — model domain
- `lib/features/todo/data` — repository / API / persistence
- `lib/features/todo/presentation` — notifier + halaman + widget reusable

## State management

- `todo-local`: `TodoLocalNotifier` + `TodoLocalRepository` (`SharedPreferences`)
- `todo-api`: `TodoApiNotifier` + `TodoRemoteRepository` + `TodoRemoteApi` (`package:http`)
