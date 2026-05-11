import { useCallback, useEffect, useMemo, useState } from 'react';
import type { TodoFilter, TodoFormValues, TodoItem } from '../types';

const STORAGE_KEY = 'todo-local-items-v1';

const defaultValues: TodoFormValues = {
  title: '',
  description: '',
  status: 'pending',
};

function loadInitialState(): { todos: TodoItem[]; error: string | null } {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return { todos: [], error: null };
    const parsed = JSON.parse(raw) as TodoItem[];
    return { todos: Array.isArray(parsed) ? parsed : [], error: null };
  } catch {
    return { todos: [], error: 'Gagal membaca data local storage.' };
  }
}

export function useLocalTodos() {
  const [error] = useState<string | null>(() => loadInitialState().error);
  const [todos, setTodos] = useState<TodoItem[]>(() => loadInitialState().todos);
  const [isLoading] = useState(false);

  useEffect(() => {
    if (isLoading) return;
    localStorage.setItem(STORAGE_KEY, JSON.stringify(todos));
  }, [isLoading, todos]);

  const addTodo = useCallback((values: TodoFormValues) => {
    const next: TodoItem = {
      id: crypto.randomUUID(),
      title: values.title.trim(),
      description: values.description.trim(),
      status: values.status,
      createdDate: new Date().toISOString(),
    };
    setTodos((prev) => [next, ...prev]);
  }, []);

  const updateTodo = useCallback((id: string, values: TodoFormValues) => {
    setTodos((prev) =>
      prev.map((todo) =>
        todo.id === id
          ? {
              ...todo,
              title: values.title.trim(),
              description: values.description.trim(),
              status: values.status,
            }
          : todo,
      ),
    );
  }, []);

  const removeTodo = useCallback((id: string) => {
    setTodos((prev) => prev.filter((todo) => todo.id !== id));
  }, []);

  const toggleStatus = useCallback((id: string) => {
    setTodos((prev) =>
      prev.map((todo) =>
        todo.id === id
          ? { ...todo, status: todo.status === 'done' ? 'pending' : 'done' }
          : todo,
      ),
    );
  }, []);

  const filterTodos = useCallback(
    (query: string, filter: TodoFilter) => {
      const normalizedQuery = query.trim().toLowerCase();
      return todos.filter((todo) => {
        const byFilter = filter === 'all' || todo.status === filter;
        const bySearch =
          normalizedQuery.length === 0 ||
          todo.title.toLowerCase().includes(normalizedQuery);
        return byFilter && bySearch;
      });
    },
    [todos],
  );

  const stats = useMemo(() => {
    const done = todos.filter((todo) => todo.status === 'done').length;
    return {
      all: todos.length,
      done,
      pending: todos.length - done,
    };
  }, [todos]);

  return {
    defaultValues,
    todos,
    isLoading,
    error,
    addTodo,
    updateTodo,
    removeTodo,
    toggleStatus,
    filterTodos,
    stats,
  };
}
