# Todo Local (React + TypeScript)

Aplikasi Todo List berbasis local state dan `localStorage`.

## Fitur

- Create, Read, Update, Delete
- Search berdasarkan `title`
- Filter status: `all`, `done`, `pending`
- Persist data via `localStorage` (data tetap ada setelah refresh)
- Validasi form (`title` dan `description` wajib diisi)

## Demo Flow yang Bisa Diuji

1. Tambah todo baru
2. Edit title/description/status todo
3. Klik toggle status pada row tabel
4. Hapus todo
5. Cari todo lewat search input
6. Ubah filter status
7. Refresh browser, data tetap tersimpan

## Menjalankan Project

```bash
npm install
npm run dev
```

## Scripts

```bash
npm run dev    # run development server
npm run lint   # lint code
npm run build  # type-check + production build
```

## Build Production

```bash
npm run build
```

## Struktur Folder

```text
src/
  features/todo/
    components/
      TodoForm.tsx
      TodoToolbar.tsx
      TodoTable.tsx
    hooks/
      useLocalTodos.ts
    types.ts
  App.tsx
  index.css
```

## Penjelasan Arsitektur Singkat

- `useLocalTodos` menangani state utama todo + sinkronisasi `localStorage`
- Komponen dipisah agar reusable dan mudah dites:
  - `TodoForm` untuk create/edit
  - `TodoToolbar` untuk search/filter
  - `TodoTable` untuk list + aksi row
- `App.tsx` berfungsi sebagai composition/container

## Data Model

Setiap todo memiliki:
- `id`
- `title`
- `description`
- `status` (`done` / `pending`)
- `createdDate`

## Catatan

- Project ini tidak memerlukan backend/API eksternal.
