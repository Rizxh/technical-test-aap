import { useState } from 'react';
import type { TodoFormValues, TodoItem } from '../types';

interface TodoFormProps {
  mode: 'create' | 'edit';
  initialValues: TodoFormValues;
  selectedTodo?: TodoItem | null;
  onSubmit: (values: TodoFormValues) => void;
  onCancelEdit?: () => void;
}

export function TodoForm({
  mode,
  initialValues,
  selectedTodo,
  onSubmit,
  onCancelEdit,
}: TodoFormProps) {
  const [form, setForm] = useState<TodoFormValues>(
    selectedTodo
      ? {
          title: selectedTodo.title,
          description: selectedTodo.description,
          status: selectedTodo.status,
        }
      : initialValues,
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

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!validate()) return;
    onSubmit(form);
    if (mode === 'create') {
      setForm(initialValues);
    }
  };

  return (
    <form className="todo-form" onSubmit={handleSubmit}>
      <h2>{mode === 'create' ? 'Tambah Todo' : 'Edit Todo'}</h2>
      <label>
        Title
        <input
          value={form.title}
          onChange={(event) =>
            setForm((prev) => ({ ...prev, title: event.target.value }))
          }
          placeholder="Masukkan judul todo"
        />
        {errors.title && <small className="field-error">{errors.title}</small>}
      </label>
      <label>
        Description
        <textarea
          value={form.description}
          onChange={(event) =>
            setForm((prev) => ({ ...prev, description: event.target.value }))
          }
          rows={3}
          placeholder="Masukkan deskripsi todo"
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
        <button type="submit">{mode === 'create' ? 'Tambah' : 'Simpan'}</button>
        {mode === 'edit' && onCancelEdit && (
          <button type="button" className="ghost" onClick={onCancelEdit}>
            Batal
          </button>
        )}
      </div>
    </form>
  );
}
