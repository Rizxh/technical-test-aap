# React Technical Test

Repository ini berisi 2 project React terpisah:

- `todo-local`: Todo CRUD berbasis local state + localStorage
- `todo-api`: Todo CRUD berbasis REST API DummyJSON

## Cara Menjalankan

### `todo-local`

```bash
cd react/todo-local
npm install
npm run dev
```

### `todo-api`

```bash
cd react/todo-api
npm install
npm run dev
```

## Teknologi

- React + TypeScript
- Vite
- Fetch API
- LocalStorage

## Struktur Folder Utama

- `src/features/todo/components`: reusable komponen UI Todo
- `src/features/todo/hooks`: custom hooks untuk logic state/data
- `src/features/todo/services`: abstraction API/service
- `src/components`, `src/hooks`, `src/services`, `src/types`, `src/pages`: struktur umum untuk skalabilitas
