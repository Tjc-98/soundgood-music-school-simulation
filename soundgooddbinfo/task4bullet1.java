package se.kth.project.onnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Main {

    public static void main(String[] args) throws SQLException {
        Connection connection = null;
        String queryInstrument = "SELECT public.instrument.id, public.instrument.kind, public.instrument.brand  FROM public.instrument";
        String queryStock = "SELECT * FROM public.stock";
        try {
            connection = ConnectionConfiguration.getConnection();

            if( connection != null) {
                Statement statement = connection.createStatement();
                ResultSet resultQueryInstrument = statement.executeQuery(queryInstrument);
                ResultSet resultQueryStock = statement.executeQuery(queryStock);

                System.out.printf("%-20s%-20s%-20s%-20s\n","ID","Kind","Brand","Rental Price");
                while (resultQueryInstrument.next()) {
                    if(resultQueryStock.next()) {
                        int remainingInstruments = Integer.parseInt(resultQueryStock.getString(2)) - Integer.parseInt(resultQueryStock.getString(4));
                        if(remainingInstruments != 0) {
                            StringBuilder str = new StringBuilder();
                            for (int i = 1; i < 4; i++) {
                                System.out.printf("%-19s ", resultQueryInstrument.getString(i));
                            }
                            for (int j = 1; j < 5; j++) {
                                if(j ==3 ) {
                                    System.out.printf("%-19s ",resultQueryStock.getString(j));
                                }
                            }
                            System.out.println("");
                        }
                    }
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(connection != null) {
                connection.close();
            }
        }
    }
}


package se.kth.project.onnection;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;

public class ConnectionConfiguration {

    public static Connection getConnection() {
        Connection connection = null;

        try {
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/soundgoodschool2db", "postgres", "Berj123");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return connection;
    }
}
