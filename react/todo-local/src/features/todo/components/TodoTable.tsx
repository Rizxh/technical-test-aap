import type { TodoItem } from '../types';

interface TodoTableProps {
  items: TodoItem[];
  onEdit: (todo: TodoItem) => void;
  onDelete: (id: string) => void;
  onToggle: (id: string) => void;
}

export function TodoTable({ items, onEdit, onDelete, onToggle }: TodoTableProps) {
  if (items.length === 0) {
    return <p className="empty">Todo tidak ditemukan.</p>;
  }

  return (
    <div className="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Title</th>
            <th>Description</th>
            <th>Status</th>
            <th>Created Date</th>
            <th>Aksi</th>
          </tr>
        </thead>
        <tbody>
          {items.map((todo) => (
            <tr key={todo.id}>
              <td>{todo.title}</td>
              <td>{todo.description}</td>
              <td>
                <button
                  type="button"
                  className={todo.status === 'done' ? 'tag done' : 'tag pending'}
                  onClick={() => onToggle(todo.id)}
                >
                  {todo.status}
                </button>
              </td>
              <td>{new Date(todo.createdDate).toLocaleString('id-ID')}</td>
              <td className="actions-cell">
                <button type="button" className="ghost" onClick={() => onEdit(todo)}>
                  Edit
                </button>
                <button type="button" className="danger" onClick={() => onDelete(todo.id)}>
                  Delete
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
