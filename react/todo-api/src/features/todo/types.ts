export type TodoStatus = 'done' | 'pending';
export type TodoFilter = 'all' | TodoStatus;

export interface TodoItem {
  id: number;
  title: string;
  description: string;
  status: TodoStatus;
  createdDate: string;
}

export interface TodoFormValues {
  title: string;
  description: string;
  status: TodoStatus;
}

export interface TodosResponse {
  todos: Array<{
    id: number;
    todo: string;
    completed: boolean;
    userId: number;
  }>;
  total: number;
  skip: number;
  limit: number;
}
