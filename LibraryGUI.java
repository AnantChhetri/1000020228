import javax.swing.*;
import java.awt.event.*;

class LibraryGUI {
    private Library library;
    private String bgImagePath = "C:\\Users\\Acer\\Desktop\\1693422613600.jpeg";

    public LibraryGUI(Library library) {
        this.library = library;
        createGUI();
    }

    public void createGUI() {
        JFrame frame = new JFrame("Library Management System");
        frame.setSize(500, 400);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Use BackgroundPanel instead of default JPanel
        BackgroundPanel bgPanel = new BackgroundPanel(bgImagePath);
        bgPanel.setLayout(null);

        // Labels and text fields
        JLabel label1 = new JLabel("Book ID:");
        label1.setBounds(20, 20, 80, 25);
        JTextField idField = new JTextField();
        idField.setBounds(100, 20, 150, 25);

        JLabel label2 = new JLabel("Title:");
        label2.setBounds(20, 60, 80, 25);
        JTextField titleField = new JTextField();
        titleField.setBounds(100, 60, 150, 25);

        JLabel label3 = new JLabel("Author:");
        label3.setBounds(20, 100, 80, 25);
        JTextField authorField = new JTextField();
        authorField.setBounds(100, 100, 150, 25);

        // Add button
        JButton addButton = new JButton("Add Book");
        addButton.setBounds(20, 140, 120, 30);
        addButton.addActionListener(e -> {
            int id = Integer.parseInt(idField.getText());
            String title = titleField.getText();
            String author = authorField.getText();
            library.addBook(new Book(id, title, author));
            JOptionPane.showMessageDialog(frame, "Book Added!");
        });

        // View button
        JButton viewButton = new JButton("View All Books");
        viewButton.setBounds(160, 140, 150, 30);
        viewButton.addActionListener(e -> {
            StringBuilder sb = new StringBuilder();
            for (Book b : library.getAllBooks()) {
                sb.append(b.toString()).append("\n");
            }
            JOptionPane.showMessageDialog(frame, sb.length() > 0 ? sb.toString() : "No books available.");
        });

        // Add components to background panel
        bgPanel.add(label1);
        bgPanel.add(idField);
        bgPanel.add(label2);
        bgPanel.add(titleField);
        bgPanel.add(label3);
        bgPanel.add(authorField);
        bgPanel.add(addButton);
        bgPanel.add(viewButton);

        // Set content pane
        frame.setContentPane(bgPanel);
        frame.setVisible(true);

        // Set custom app icon/logo
        ImageIcon logoIcon = new ImageIcon("C:\\Users\\Acer\\Desktop\\download.jpeg");
        frame.setIconImage(logoIcon.getImage());


    }
}
