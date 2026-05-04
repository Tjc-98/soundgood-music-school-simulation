package se.kth.project.Model;

import org.postgresql.util.PSQLException;
import se.kth.project.DTO.Instrument;
import se.kth.project.DTO.StockInstruments;
import se.kth.project.DTO.StudentRentalsInfo;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;

/**
 * StudentRental handles the operation of  renting instruments from the stock or terminating current rentals
 */
public class StudentRental {
    private static Connection connection;
    private Stock stock;


    /**
     * @param connection StudentRental constructor with by the connection from through the controller
     */
    public StudentRental(Connection connection) {
        StudentRental.connection = connection;
    }


    /**
     * @return list the current student rentals and save them as an array of StudentRentalsInfo.
     */
    public StudentRentalsInfo[] getStudentsRentals() throws DatabaseException, SQLException {
        Queue<StudentRentalsInfo> studentRentalsInfoQueue = new LinkedList<StudentRentalsInfo>();

        try {
            if(connection != null) {
                Statement statement = connection.createStatement();
                String queryInstrumentRental = "SELECT * FROM public.instrument_rental";
                ResultSet resultQueryInstrumentRentals = statement.executeQuery(queryInstrumentRental);
                connection.commit();
                while (resultQueryInstrumentRentals.next()) {
                    int tempRentalId = Integer.parseInt(resultQueryInstrumentRentals.getString(1));
                    int tempInstrumentId = Integer.parseInt(resultQueryInstrumentRentals.getString(2));
                    int tempStudentId = Integer.parseInt(resultQueryInstrumentRentals.getString(3));
                    LocalDate tempRentalDate = LocalDate.parse(resultQueryInstrumentRentals.getString(4));
                    LocalDate tempReturnDate = LocalDate.parse(resultQueryInstrumentRentals.getString(5));
                    int tempRentalPeriod = Integer.parseInt(resultQueryInstrumentRentals.getString(6));
                    String tempDeliveryMethod = resultQueryInstrumentRentals.getString(7);
                    String tempIsTerminated = resultQueryInstrumentRentals.getString(8);
                    if (tempIsTerminated.equals("f")) {
                        StudentRentalsInfo studentRentalsInfo = new StudentRentalsInfo(tempRentalId, tempInstrumentId, tempStudentId, tempRentalDate, tempReturnDate, tempRentalPeriod, tempDeliveryMethod);
                        studentRentalsInfoQueue.add(studentRentalsInfo);
                    }
                }
            }

            return studentRentalsInfoQueue.toArray(new StudentRentalsInfo[0]);

        }catch (Exception e ) {
            connection.rollback();
            throw new DatabaseException("Something went wrong, " + e.getMessage());
        }
    }


    /**
     * @param stock passed by the controller to use it in this function
     * @param studentId to show rentals
     * @return a list of StudentCurrentRetnals as StudentRentalsInfo object.
     */
    public StudentRentalsInfo[] showCurrentStudentRentals(Stock stock, int studentId) throws DatabaseException, SQLException {
        this.stock = stock;
        try {
            if(connection != null) {
                StringBuilder availableInstrumentInStock = new StringBuilder();
                stock.getAvailableInstruments(availableInstrumentInStock);
                Instrument[] instruments = stock.getInstrumentsDetails();
                StudentRentalsInfo[] studentsRentals = getStudentsRentals();
                List<StudentRentalsInfo> studentsCurrentRentalsList = new ArrayList<StudentRentalsInfo>();


                for (StudentRentalsInfo studentsRental : studentsRentals) {
                    if ((studentsRental.getStudentId() == studentId && !(studentsRental.isTerminated()) && studentsRental.getReturnDate().compareTo(LocalDate.now()) >=0)) {
                        studentsCurrentRentalsList.add(studentsRental);
                    }
                }
                return studentsCurrentRentalsList.toArray(new StudentRentalsInfo[0]);
            }
        }catch (Exception e ) {
            connection.rollback();
            throw new DatabaseException("Something went wrong, " + e.getMessage());
        }
        return null;
    }

    /**
     * @param stock passed by the controller to use it in this function
     * @param studentId to show rentals
     * @throws SQLException in unexpected cases while running the SQL queries.
     * @throws DatabaseException which unexpected cases and to not disturb the user
     */
    public void ShowInsertedStudentRentals(Stock stock, int studentId) throws DatabaseException, SQLException { // just to show if the user is eligible for rental or not.
        StudentRentalsInfo[] currentStudentRentalsPrevYear = showCurrentStudentRentals(stock, studentId);
        System.out.println(String.format("%-20s%-20s%-20s%-20s%-20s%-20s%-20s\n","Rental ID","Student ID","Instrument ID","Rental Date","Return Date","Rental Period","Delivery Method"));
        for (StudentRentalsInfo currentStudentRentalsInfo: currentStudentRentalsPrevYear) {
                System.out.println(String.format("%-20d%-20d%-20d%-20s%-20s%-20d%-20s\n",currentStudentRentalsInfo.getRentalId() ,currentStudentRentalsInfo.getStudentId(),
                        currentStudentRentalsInfo.getInstrumentId(),currentStudentRentalsInfo.getRentalDate(),currentStudentRentalsInfo.getReturnDate(),currentStudentRentalsInfo.getRentalPeriod()
                        ,currentStudentRentalsInfo.getDeliveryMethod()));
        }
    }

    /**
     * @param studentId to terminate rentals
     * @param rentalId to terminate a specific rental
     * @throws SQLException in unexpected cases while running the SQL queries.
     * @throws DatabaseException which unexpected cases and to not disturb the user
     */
    public void terminateRental(int studentId, int rentalId) throws SQLException, DatabaseException {
        Statement statement = connection.createStatement();
        StudentRentalsInfo[] currentStudentRentalsPrevYear = showCurrentStudentRentals(stock, studentId);
        int instrumentIdFromRentals = 0;

        for (StudentRentalsInfo studentRentalsInfo : currentStudentRentalsPrevYear) {
            if (studentRentalsInfo.getRentalId() == rentalId) {
                instrumentIdFromRentals = studentRentalsInfo.getInstrumentId();
            }
        }
        try {
            for (StudentRentalsInfo studentRentalsInfo : currentStudentRentalsPrevYear) {
                if (studentRentalsInfo.getRentalId() == rentalId) {
                    String terminateQuery = String.format("UPDATE public.instrument_rental\n" +
                            "\t SET terminated=true, date_of_termination=CURRENT_DATE\n" +
                            "\t WHERE id = %d;", rentalId);

                    String updateStock = String.format("UPDATE public.stock\n" +
                            "\tSET rented_instruments=rented_instruments-1\n" +
                            "\tWHERE instrument_id=%d;", instrumentIdFromRentals);
                    statement.executeUpdate(terminateQuery);
                    statement.executeUpdate(updateStock);
                    connection.commit();
                    System.out.println("Done");
                }
            }
        }catch (Exception e) {
            connection.rollback();
            throw new DatabaseException("Something went wrong, " + e.getMessage());
        }
    }

    /**
     * @param stock passed by the controller to use it in this function
     * @param studentId to add rentals
     * @param instrumentId to add a specific instrument to the rental
     * @param rentalPeriod the number of months the user want to rent the instrument
     * @param indexOfDeliveryMethod to let the use how he/she want to receive the rented instrument.
     * @throws SQLException in unexpected cases while running the SQL queries.
     * @throws DatabaseException which unexpected cases and to not disturb the user.
     */
    public void addRental(Stock stock, int studentId, int instrumentId, int rentalPeriod, int indexOfDeliveryMethod) throws SQLException, DatabaseException {
        Statement statement = connection.createStatement();
        StudentRentalsInfo[] currentStudentRentalsPrevYear = showCurrentStudentRentals(stock, studentId);
        StringBuilder availableInstrumentsInStock = new StringBuilder();
        StockInstruments[] availableInstruments = stock.getAvailableInstruments(availableInstrumentsInStock);
        int[] availableInstrumentsIds = new int[availableInstruments.length];
        for (int i = 0; i < availableInstruments.length; i++) {
            availableInstrumentsIds[i] = availableInstruments[i].getInstrumentId();
        }
        LocalDate rentalDate = LocalDate.now();
        LocalDate returnDate = LocalDate.now().plusMonths(rentalPeriod);
        String[] deliveryMethod = new String[]{"Deliver to house", "Pick up"};
        try {
            if (currentStudentRentalsPrevYear.length<2) {
                for (int id: availableInstrumentsIds) {
                    if(instrumentId == id) {
                        String rentInstrumentQuery = String.format("INSERT INTO public.instrument_rental(\n" +
                                        "\tinstrument_id, student_id, rental_date, return_date, rental_period, " +
                                        "delivery_method, terminated, date_of_termination)\n" +
                                        "\tVALUES (%d, %d, '%s', '%s', %d, '%s', false, null);"
                                , instrumentId, studentId, rentalDate, returnDate, rentalPeriod, deliveryMethod[indexOfDeliveryMethod]);

                        String updateStock = String.format("UPDATE public.stock\n" +
                                "\tSET rented_instruments=rented_instruments+1\n" +
                                "\tWHERE instrument_id=%d;", instrumentId);

                        statement.executeUpdate(rentInstrumentQuery);
                        statement.executeUpdate(updateStock);
                        connection.commit();
                        System.out.println("The Student with the id: " + studentId + " has added a new rental with the instrument id: " + instrumentId);
                    }
                }
            }
            else {
                System.out.println("The Student already has 2 current rentals. You are not allowed to rent more than 2 instruments at the same time.");
            }
        }catch (Exception e) {
            connection.rollback();
            throw new DatabaseException("Something went wrong, " + e.getMessage());
        }
    }
}
