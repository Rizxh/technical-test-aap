# React Technical Test

Monorepo React ini berisi 2 aplikasi yang meng-cover 2 kebutuhan test:

- `todo-local`: CRUD Todo dengan local state + localStorage
- `todo-api`: CRUD Todo dengan REST API DummyJSON

## Project List

### 1) `todo-local`
Fokus pada pengelolaan data lokal:
- CRUD todo (create, read, update, delete)
- Search todo berdasarkan title
- Filter status (`all`, `done`, `pending`)
- Persist data ke `localStorage`
- Validasi form required

### 2) `todo-api`
Fokus pada integrasi API:
- Fetch data dari DummyJSON
- Create, update, delete ke endpoint API
- Search (debounced)
- Filter status di sisi UI
- Pagination data table
- Loading state dan error handling

## Tech Stack

- React + TypeScript
- Vite
- Fetch API
- ESLint

## Cara Menjalankan

### Jalankan `todo-local`
```bash
cd react/todo-local
npm install
npm run dev
```

### Jalankan `todo-api`
```bash
cd react/todo-api
npm install
npm run dev
```

## Build & Lint

Contoh untuk masing-masing project:
```bash
npm run lint
npm run build
```

## Struktur Arsitektur (Per Project)

```text
src/
  features/
    todo/
      components/   -> reusable UI todo
      hooks/        -> business logic/state orchestration
      services/     -> API/service layer
      types.ts      -> model dan type todo
  components/       -> shared component (opsional)
  hooks/            -> shared hook (opsional)
  services/         -> shared service (opsional)
  types/            -> shared types (opsional)
  pages/            -> page container (opsional)
```

## Catatan Penilaian

Struktur dan implementasi disusun agar memenuhi poin assessment:
- clean code dan readability
- modular service/hook/component
- penanganan loading/error state
- dokumentasi setup dan arsitektur
