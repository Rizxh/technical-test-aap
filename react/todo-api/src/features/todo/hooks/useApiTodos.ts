import { useCallback, useEffect, useMemo, useState } from 'react';
import type { TodoFilter, TodoFormValues, TodoItem } from '../types';
import {
  createTodo,
  deleteTodo,
  fetchTodos,
  updateTodo,
} from '../services/todoService';

export function useApiTodos(query: string, page: number, pageSize: number) {
  const [items, setItems] = useState<TodoItem[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [total, setTotal] = useState(0);

  const loadTodos = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const response = await fetchTodos({
        query,
        limit: pageSize,
        skip: (page - 1) * pageSize,
      });
      setItems(response.items);
      setTotal(response.total);
    } catch {
      setError('Gagal memuat data dari DummyJSON.');
    } finally {
      setIsLoading(false);
    }
  }, [page, pageSize, query]);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    void loadTodos();
  }, [loadTodos]);

  const addTodo = useCallback(
    async (values: TodoFormValues) => {
      const created = await createTodo(values);
      setItems((prev) => [created, ...prev].slice(0, pageSize));
      setTotal((prev) => prev + 1);
    },
    [pageSize],
  );

  const editTodo = useCallback(async (id: number, values: TodoFormValues) => {
    const updated = await updateTodo(id, values);
    setItems((prev) =>
      prev.map((todo) =>
        todo.id === id ? { ...todo, ...updated, description: values.description } : todo,
      ),
    );
  }, []);

  const removeTodo = useCallback(async (id: number) => {
    await deleteTodo(id);
    setItems((prev) => prev.filter((todo) => todo.id !== id));
    setTotal((prev) => Math.max(0, prev - 1));
  }, []);

  const byFilter = useCallback(
    (filter: TodoFilter) =>
      filter === 'all' ? items : items.filter((item) => item.status === filter),
    [items],
  );

  const maxPage = useMemo(() => Math.max(1, Math.ceil(total / pageSize)), [total, pageSize]);

  return {
    items,
    isLoading,
    error,
    total,
    maxPage,
    loadTodos,
    addTodo,
    editTodo,
    removeTodo,
    byFilter,
  };
}
