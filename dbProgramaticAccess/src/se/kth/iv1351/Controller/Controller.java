package se.kth.project.Controller;

import se.kth.project.Model.DatabaseException;
import se.kth.project.Model.Stock;
import se.kth.project.Model.StudentRental;

import java.sql.Connection;
import java.sql.SQLException;


/**
 * The controller for all the operation of the rental, termination and show current rentals
 */
public class Controller {
    Stock stock;
    StudentRental studentRental;
    Connection connection;

    /**
     * @param connection pass the connection from the main to the Stock and StudentRental
     */
    public Controller(Connection connection) {
        this.connection = connection;
        stock = new Stock(connection);
        studentRental = new StudentRental(connection);
    }

    /**
     * @throws SQLException in unexpected cases while running the SQL queries.
     */
    public void showAvailableInstrumentsInStock() throws SQLException, DatabaseException {
        StringBuilder availableInstrumentInStock = new StringBuilder();
        stock.getAvailableInstruments(availableInstrumentInStock);
        System.out.println(availableInstrumentInStock.toString());
    }

    /**
     * @param studentId to show students rentals
     * @throws SQLException in unexpected cases while running the SQL queries.
     * @throws DatabaseException which unexpected cases and to not disturb the user.
     */
    public void insertRentalInContr(int studentId) throws SQLException, DatabaseException {
        try {
            studentRental.ShowInsertedStudentRentals(stock, studentId);
        }catch (DatabaseException e) {
            throw new DatabaseException("Something went wrong, " + e.getMessage());
        }
    }

    /**
     * @param rentalStudentId to add a new rentals
     * @param rentalInstrumentId to rent the instrument which has this id
     * @param rentalPeriod to choose the rentalPeriod in months number
     * @param indexOfDeliveryMethod to choose the method of the delivery
     * @throws SQLException in unexpected cases while running the SQL queries.
     * @throws DatabaseException which unexpected cases and to not disturb the user.
     */
    public void addRentalInContr(int rentalStudentId, int rentalInstrumentId, int rentalPeriod, int indexOfDeliveryMethod) throws SQLException, DatabaseException {
        try {
            if (rentalPeriod <= 12) {
                studentRental.addRental(stock, rentalStudentId, rentalInstrumentId, rentalPeriod, indexOfDeliveryMethod);
            }
            else {
                System.out.println("The rental period cannot be more than 12 months");
            }
        }catch (DatabaseException e) {
            throw new DatabaseException("Something went wrong, " + e.getMessage());
        }
    }

    /**
     * @param terminationStudentId the id of the student who wants to terminate an existing rental
     * @param terminationRentalId enter the id of the rental to make it easier to terminate retnal
     * @throws SQLException in unexpected cases while running the SQL queries.
     * @throws DatabaseException which unexpected cases and to not disturb the user.
     */
    public void terminateRentalInContr(int terminationStudentId, int terminationRentalId) throws SQLException, DatabaseException {
        try {
            studentRental.terminateRental(terminationStudentId, terminationRentalId);
        }catch (DatabaseException e) {
            throw new DatabaseException("Something went wrong, " + e.getMessage());
        }
    }

    /**
     * close the connection after quiting the program
     */
    public void closeConnection() {
        try {
            connection.close();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
    public void rollbackForView() throws SQLException {
        connection.rollback();
    }
}
