# Todo Local (Flutter)

Aplikasi Todo List dengan **local state** dan persist **`SharedPreferences`**.

## Fitur

- CRUD todo (id, title, description, status, createdDate)
- Search berdasarkan title
- Filter status: All / Done / Pending
- Validasi form (title & description wajib)
- Pull-to-refresh memuat ulang dari storage

## Menjalankan

```bash
flutter pub get
flutter run
```

## Dependencies utama

- `provider` — state management
- `shared_preferences` — persist JSON todo
- `intl` — format tanggal

## Struktur

```text
lib/
  core/
    constants/app_storage.dart
    theme/app_theme.dart
  features/todo/
    domain/          # Todo, TodoStatus, TodoFilter
    data/            # TodoLocalRepository
    presentation/    # TodoLocalNotifier, pages, widgets
  main.dart
```

## Uji manual

1. Tambah todo lewat FAB
2. Edit / hapus dari kartu list
3. Toggle status lewat ikon checklist
4. Cari dan filter
5. Tutup app lalu buka lagi — data tetap ada
