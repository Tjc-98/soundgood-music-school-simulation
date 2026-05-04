package se.kth.project.startup;

import se.kth.project.Controller.Controller;
import se.kth.project.Model.DatabaseException;
import se.kth.project.View.View;
import se.kth.project.integration.ConnectionConfig;

import java.sql.Connection;
import java.sql.SQLException;

public class Main {

    /**
     * @throws SQLException in unexpected cases while running the SQL queries.
     * @throws DatabaseException which unexpected cases and to not disturb the user.
     */
    public static void main(String[] args) throws SQLException, DatabaseException {
        Connection connection = ConnectionConfig.getConnection();
        Controller controller = new Controller(connection);
        View view = new View(controller);
        view.startInterface();
    }
}
