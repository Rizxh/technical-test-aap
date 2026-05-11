interface PaginationProps {
  page: number;
  maxPage: number;
  onPageChange: (nextPage: number) => void;
}

export function Pagination({ page, maxPage, onPageChange }: PaginationProps) {
  return (
    <nav className="pagination">
      <button
        type="button"
        className="ghost"
        onClick={() => onPageChange(page - 1)}
        disabled={page <= 1}
      >
        Prev
      </button>
      <span>
        Page {page} / {maxPage}
      </span>
      <button
        type="button"
        className="ghost"
        onClick={() => onPageChange(page + 1)}
        disabled={page >= maxPage}
      >
        Next
      </button>
    </nav>
  );
}
