package Config;

import java.sql.Connection;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class ContextoDB implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        Connection con = conexion.getConnection();
        if (con != null) {
            sce.getServletContext().setAttribute("conexion", con);
            System.out.println("Conexión guardada en el contexto");
        } else {
            System.out.println("No se pudo establecer la conexión");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        Connection con = (Connection) sce.getServletContext().getAttribute("conexion");
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                System.out.println("Conexión cerrada correctamente");
            }
        } catch (Exception e) {
            System.out.println("Error al cerrar la conexión");
            e.printStackTrace();
        }
    }
}
