import java.util.ArrayList;

class Library implements LibraryOperations {
    private ArrayList<Book> books = new ArrayList<>();

    @Override
    public void addBook(Book book) {
        books.add(book);
        System.out.println("Book added: " + book);
    }

    @Override
    public void removeBook(int id) {
        books.removeIf(b -> b.getId() == id);
        System.out.println("Book with ID " + id + " removed.");
    }

    @Override
    public Book searchBook(int id) {
        for(Book b : books) {
            if(b.getId() == id) return b;
        }
        return null;
    }

    public ArrayList<Book> getAllBooks() {
        return books;
    }
}
