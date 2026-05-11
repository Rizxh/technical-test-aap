import { useState } from 'react';
import type { TodoFormValues, TodoItem } from '../types';

interface TodoFormProps {
  selectedTodo: TodoItem | null;
  onSubmit: (values: TodoFormValues) => Promise<void>;
  onCancelEdit: () => void;
}

const defaultValues: TodoFormValues = {
  title: '',
  description: '',
  status: 'pending',
};

export function TodoForm({ selectedTodo, onSubmit, onCancelEdit }: TodoFormProps) {
  const [form, setForm] = useState<TodoFormValues>(
    selectedTodo
      ? {
          title: selectedTodo.title,
          description: selectedTodo.description,
          status: selectedTodo.status,
        }
      : defaultValues,
  );
  const [errors, setErrors] = useState<{ title?: string; description?: string }>(
    {},
  );

  const validate = () => {
    const nextErrors: { title?: string; description?: string } = {};
    if (!form.title.trim()) nextErrors.title = 'Title wajib diisi.';
    if (!form.description.trim()) nextErrors.description = 'Description wajib diisi.';
    setErrors(nextErrors);
    return Object.keys(nextErrors).length === 0;
  };

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!validate()) return;
    await onSubmit(form);
    if (!selectedTodo) setForm(defaultValues);
  };

  return (
    <form className="todo-form" onSubmit={handleSubmit}>
      <h2>{selectedTodo ? 'Edit Todo' : 'Tambah Todo API'}</h2>
      <label>
        Title
        <input
          value={form.title}
          onChange={(event) =>
            setForm((prev) => ({ ...prev, title: event.target.value }))
          }
        />
        {errors.title && <small className="field-error">{errors.title}</small>}
      </label>
      <label>
        Description
        <textarea
          rows={3}
          value={form.description}
          onChange={(event) =>
            setForm((prev) => ({ ...prev, description: event.target.value }))
          }
        />
        {errors.description && (
          <small className="field-error">{errors.description}</small>
        )}
      </label>
      <label>
        Status
        <select
          value={form.status}
          onChange={(event) =>
            setForm((prev) => ({
              ...prev,
              status: event.target.value as TodoFormValues['status'],
            }))
          }
        >
          <option value="pending">Pending</option>
          <option value="done">Done</option>
        </select>
      </label>
      <div className="action-row">
        <button type="submit">{selectedTodo ? 'Simpan' : 'Tambah'}</button>
        {selectedTodo && (
          <button type="button" className="ghost" onClick={onCancelEdit}>
            Batal
          </button>
        )}
      </div>
    </form>
  );
}
