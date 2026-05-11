import type { TodoItem } from '../types';

interface TodoTableProps {
  items: TodoItem[];
  onEdit: (todo: TodoItem) => void;
  onDelete: (id: number) => Promise<void>;
}

export function TodoTable({ items, onEdit, onDelete }: TodoTableProps) {
  if (items.length === 0) return <p className="empty">Data tidak ditemukan.</p>;

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
                <span className={todo.status === 'done' ? 'tag done' : 'tag pending'}>
                  {todo.status}
                </span>
              </td>
              <td>{new Date(todo.createdDate).toLocaleString('id-ID')}</td>
              <td className="actions-cell">
                <button type="button" className="ghost" onClick={() => onEdit(todo)}>
                  Edit
                </button>
                <button
                  type="button"
                  className="danger"
                  onClick={() => void onDelete(todo.id)}
                >
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
