package Config;

import java.sql.Connection;
import java.sql.DriverManager;

public class conexion {
    public static final String username = "root";
    public static final String password = "1234";
    public static final String database = "ecommerce_urbano";
    public static final String url = "jdbc:mysql://localhost:3306/" + database;

    public static Connection getConnection() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection(url, username, password);
            System.out.println("Conexión establecida con la base de datos");
        } catch (Exception ex) {
            System.out.println("Error al conectar con la base de datos");
            ex.printStackTrace();
        }
        return cn;
    }
}
