import type { TodoFilter } from '../types';

interface TodoToolbarProps {
  query: string;
  filter: TodoFilter;
  onQueryChange: (value: string) => void;
  onFilterChange: (value: TodoFilter) => void;
}

export function TodoToolbar({
  query,
  filter,
  onQueryChange,
  onFilterChange,
}: TodoToolbarProps) {
  return (
    <section className="toolbar">
      <label>
        Search (DummyJSON)
        <input
          value={query}
          onChange={(event) => onQueryChange(event.target.value)}
          placeholder="Cari todo..."
        />
      </label>
      <label>
        Filter
        <select
          value={filter}
          onChange={(event) => onFilterChange(event.target.value as TodoFilter)}
        >
          <option value="all">All</option>
          <option value="done">Done</option>
          <option value="pending">Pending</option>
        </select>
      </label>
    </section>
  );
}
