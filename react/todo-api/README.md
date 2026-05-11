# Todo API (React + TypeScript)

Aplikasi Todo List berbasis REST API menggunakan DummyJSON.

## Fitur

- Fetch data dari API (`GET /todos`)
- Create (`POST /todos/add`)
- Update (`PUT /todos/:id`)
- Delete (`DELETE /todos/:id`)
- Search API (`/todos/search`)
- Debounce search untuk mengurangi request beruntun
- Filter status (`all`, `done`, `pending`) di UI
- Pagination table
- Loading state dan error handling

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

## Endpoint API

- Base URL: `https://dummyjson.com`
- Endpoint yang digunakan:
  - `GET /todos`
  - `GET /todos/search?q=...`
  - `POST /todos/add`
  - `PUT /todos/:id`
  - `DELETE /todos/:id`

## Struktur Folder

```text
src/
  features/todo/
    components/
      TodoForm.tsx
      TodoToolbar.tsx
      TodoTable.tsx
      Pagination.tsx
    hooks/
      useApiTodos.ts
      useDebounce.ts
    services/
      httpClient.ts
      todoService.ts
    types.ts
  App.tsx
  index.css
```

## Penjelasan Arsitektur Singkat

- `httpClient.ts`: wrapper untuk fetch + standardisasi error HTTP
- `todoService.ts`: abstraction endpoint API supaya pemanggilan dari UI tetap bersih
- `useApiTodos.ts`: orchestrasi fetch list, mutation CRUD, pagination state
- `useDebounce.ts`: debounce query search sebelum request API
- `App.tsx`: composition layer antar komponen UI dan hook

## Demo Flow yang Bisa Diuji

1. Buka app dan tunggu data todo tampil
2. Cari todo lewat search input (dengan debounce)
3. Ubah filter status
4. Pindah halaman pagination
5. Tambah todo baru
6. Edit todo yang ada
7. Hapus todo

## Catatan Integrasi API

- DummyJSON adalah API dummy/simulasi.
- Operasi `POST/PUT/DELETE` berhasil merespon request, namun tidak menyimpan perubahan secara permanen di server.
