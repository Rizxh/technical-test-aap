# Todo API (Flutter)

Aplikasi Todo List terhubung ke **DummyJSON** (`https://dummyjson.com`).

## Fitur

- Fetch list (`GET /todos` atau `GET /todos/search`)
- Create (`POST /todos/add`)
- Update (`PUT /todos/:id`)
- Delete (`DELETE /todos/:id`)
- Debounce search (~450 ms)
- Filter status di UI (All / Done / Pending)
- Infinite scroll (muat halaman berikutnya otomatis saat mendekati bawah list)
- Loading & error state + pull-to-refresh

## Menjalankan

```bash
flutter pub get
flutter run
```

Perlu koneksi internet. Android sudah memakai permission `INTERNET` di `AndroidManifest.xml`.

## Dependencies utama

- `provider` — state management
- `http` — HTTP client modular
- `intl` — format tanggal

## Struktur

```text
lib/
  core/
    constants/api_constants.dart
    theme/app_theme.dart
  features/todo/
    domain/
    data/              # TodoRemoteApi, DTO, TodoRemoteRepository
    presentation/    # TodoApiNotifier, pages, widgets
  main.dart
```

## Catatan DummyJSON

API ini bersifat dummy: respons `POST` / `PUT` / `DELETE` sukses, tetapi data tidak selalu persisten seperti database production.

## Uji manual

1. Buka app — daftar todo termuat
2. Scroll ke bawah — halaman berikutnya termuat
3. Ketik di search — debounce lalu hasil dari endpoint search
4. Filter status pada item yang sudah dimuat
5. Tambah / edit / hapus — lihat pesan error jika jaringan gagal
