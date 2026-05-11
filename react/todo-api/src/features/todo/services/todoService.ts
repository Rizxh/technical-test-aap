import type { TodoFormValues, TodoItem, TodosResponse } from '../types';
import { httpClient } from './httpClient';

function mapTodo(
  todo: { id: number; todo: string; completed: boolean },
  fallbackDate = new Date().toISOString(),
): TodoItem {
  return {
    id: todo.id,
    title: todo.todo,
    description: todo.todo,
    status: todo.completed ? 'done' : 'pending',
    createdDate: fallbackDate,
  };
}

export async function fetchTodos(params: {
  limit: number;
  skip: number;
  query: string;
}): Promise<{ items: TodoItem[]; total: number }> {
  const endpoint =
    params.query.trim().length > 0
      ? `/todos/search?q=${encodeURIComponent(params.query.trim())}&limit=${params.limit}&skip=${params.skip}`
      : `/todos?limit=${params.limit}&skip=${params.skip}`;

  const response = await httpClient<TodosResponse>(endpoint);
  return {
    items: response.todos.map((item) => mapTodo(item)),
    total: response.total,
  };
}

export async function createTodo(values: TodoFormValues): Promise<TodoItem> {
  const response = await httpClient<{
    id: number;
    todo: string;
    completed: boolean;
  }>('/todos/add', {
    method: 'POST',
    body: JSON.stringify({
      todo: values.title.trim(),
      completed: values.status === 'done',
      userId: 1,
    }),
  });

  return mapTodo(response);
}

export async function updateTodo(
  id: number,
  values: TodoFormValues,
): Promise<TodoItem> {
  const response = await httpClient<{
    id: number;
    todo: string;
    completed: boolean;
  }>(`/todos/${id}`, {
    method: 'PUT',
    body: JSON.stringify({
      todo: values.title.trim(),
      completed: values.status === 'done',
    }),
  });

  return mapTodo(response);
}

export async function deleteTodo(id: number): Promise<void> {
  await httpClient(`/todos/${id}`, { method: 'DELETE' });
}
