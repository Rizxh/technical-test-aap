import { useMemo, useState } from 'react';
import { TodoForm } from './features/todo/components/TodoForm';
import { TodoTable } from './features/todo/components/TodoTable';
import { TodoToolbar } from './features/todo/components/TodoToolbar';
import { useLocalTodos } from './features/todo/hooks/useLocalTodos';
import type { TodoFilter, TodoItem } from './features/todo/types';

function App() {
  const {
    defaultValues,
    isLoading,
    error,
    addTodo,
    updateTodo,
    removeTodo,
    toggleStatus,
    filterTodos,
    stats,
  } = useLocalTodos();

  const [query, setQuery] = useState('');
  const [filter, setFilter] = useState<TodoFilter>('all');
  const [selectedTodo, setSelectedTodo] = useState<TodoItem | null>(null);

  const visibleTodos = useMemo(() => filterTodos(query, filter), [filterTodos, query, filter]);

  return (
    <main className="page">
      <header>
        <h1>Todo Local</h1>
        <p>CRUD todo dengan local state dan localStorage persistence.</p>
        <div className="stats">
          <span>All: {stats.all}</span>
          <span>Done: {stats.done}</span>
          <span>Pending: {stats.pending}</span>
        </div>
      </header>

      <TodoForm
        key={selectedTodo ? selectedTodo.id : 'create'}
        mode={selectedTodo ? 'edit' : 'create'}
        initialValues={defaultValues}
        selectedTodo={selectedTodo}
        onSubmit={(values) => {
          if (selectedTodo) {
            updateTodo(selectedTodo.id, values);
            setSelectedTodo(null);
            return;
          }
          addTodo(values);
        }}
        onCancelEdit={() => setSelectedTodo(null)}
      />

      <TodoToolbar
        query={query}
        filter={filter}
        onQueryChange={setQuery}
        onFilterChange={setFilter}
      />

      {isLoading && <p className="status">Memuat data local...</p>}
      {error && <p className="status error">{error}</p>}
      {!isLoading && !error && (
        <TodoTable
          items={visibleTodos}
          onEdit={setSelectedTodo}
          onDelete={removeTodo}
          onToggle={toggleStatus}
        />
      )}
    </main>
  );
}

export default App;
