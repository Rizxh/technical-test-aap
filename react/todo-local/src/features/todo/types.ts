export type TodoStatus = 'done' | 'pending';
export type TodoFilter = 'all' | TodoStatus;

export interface TodoItem {
  id: string;
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
