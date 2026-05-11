import { useMemo, useState } from 'react';
import { Pagination } from './features/todo/components/Pagination';
import { TodoForm } from './features/todo/components/TodoForm';
import { TodoTable } from './features/todo/components/TodoTable';
import { TodoToolbar } from './features/todo/components/TodoToolbar';
import { useApiTodos } from './features/todo/hooks/useApiTodos';
import { useDebounce } from './features/todo/hooks/useDebounce';
import type { TodoFilter, TodoFormValues, TodoItem } from './features/todo/types';

const PAGE_SIZE = 10;

function App() {
  const [query, setQuery] = useState('');
  const [filter, setFilter] = useState<TodoFilter>('all');
  const [page, setPage] = useState(1);
  const [selectedTodo, setSelectedTodo] = useState<TodoItem | null>(null);
  const [submitError, setSubmitError] = useState<string | null>(null);

  const debouncedQuery = useDebounce(query, 500);
  const { isLoading, error, total, maxPage, addTodo, editTodo, removeTodo, byFilter } =
    useApiTodos(debouncedQuery, page, PAGE_SIZE);

  const visibleItems = useMemo(() => byFilter(filter), [byFilter, filter]);

  const handleSubmit = async (values: TodoFormValues) => {
    setSubmitError(null);
    try {
      if (selectedTodo) {
        await editTodo(selectedTodo.id, values);
        setSelectedTodo(null);
        return;
      }
      await addTodo(values);
    } catch {
      setSubmitError('Gagal menyimpan perubahan ke API.');
    }
  };

  return (
    <main className="page">
      <header>
        <h1>Todo API (DummyJSON)</h1>
        <p>Integrasi CRUD dengan loading state, error handling, search, filter, dan pagination.</p>
        <div className="stats">
          <span>Total API: {total}</span>
          <span>Visible: {visibleItems.length}</span>
          <span>Page Size: {PAGE_SIZE}</span>
        </div>
      </header>

      <TodoForm
        key={selectedTodo ? selectedTodo.id : 'create'}
        selectedTodo={selectedTodo}
        onSubmit={handleSubmit}
        onCancelEdit={() => setSelectedTodo(null)}
      />
      {submitError && <p className="status error">{submitError}</p>}

      <TodoToolbar
        query={query}
        filter={filter}
        onQueryChange={(value) => {
          setQuery(value);
          setPage(1);
        }}
        onFilterChange={setFilter}
      />

      {isLoading && <p className="status">Memuat data dari DummyJSON...</p>}
      {error && <p className="status error">{error}</p>}
      {!isLoading && !error && (
        <>
          <TodoTable
            items={visibleItems}
            onEdit={setSelectedTodo}
            onDelete={removeTodo}
          />
          <Pagination page={page} maxPage={maxPage} onPageChange={setPage} />
        </>
      )}
    </main>
  );
}

export default App;
