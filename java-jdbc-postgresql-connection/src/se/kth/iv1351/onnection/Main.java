package se.kth.project.onnection;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;

public class Main {

    private static String listingAvailableInstruments(Connection connection) throws SQLException {
        String queryInstrument = "SELECT public.instrument.id, public.instrument.kind, public.instrument.brand  FROM public.instrument";
        String queryStock = "SELECT * FROM public.stock";
        String returnedList = "";
        if( connection != null)
        {
            Statement statement = connection.createStatement();
            ResultSet resultQueryInstrument = statement.executeQuery(queryInstrument);
            ResultSet resultQueryStock = statement.executeQuery(queryStock);

            returnedList += String.format("%-20s%-20s%-20s%-20s\n","ID","Kind","Brand","Rental Price");
            while (resultQueryInstrument.next())
            {
                if(resultQueryStock.next())
                {
                    int remainingInstruments = Integer.parseInt(resultQueryStock.getString(2)) - Integer.parseInt(resultQueryStock.getString(4));
                    if(remainingInstruments != 0)
                    {
                        for (int i = 1; i < 4; i++)
                        {
                            returnedList +=  String.format("%-19s ", resultQueryInstrument.getString(i));
                        }
                        for (int j = 1; j < 5; j++)
                        {
                            if(j ==3 )
                            {
                                returnedList +=  String.format("%-19s ",resultQueryStock.getString(j));
                            }
                        }
                        returnedList += "\n";
                    }
                }
            }
        }
        return returnedList;
    }

    public static int executeRentalQuery(String rentInstrumentQuery, Statement statement) {
        try{
            ResultSet resultSet = statement.executeQuery(rentInstrumentQuery);
            return 0;
        } catch (Exception e) {
            return -1;
        }
    }


    public static void main(String[] args) throws SQLException {
        Connection connection = null;

        connection = ConnectionConfiguration.getConnection();
        try {
          String availableList =  listingAvailableInstruments(connection); // this function will be used for both the first and the second bullets in task4. The second bullet to let the
                                                    // user know every instrument's id.

            System.out.println(availableList);
            if( connection != null)
            {
                String queryInstrument = "SELECT public.instrument.id, " +
                        "public.instrument.kind, " +
                        "public.instrument.brand " +
                        "FROM " +
                        "public.instrument";
                String queryStock = "SELECT * " +
                        "FROM public.stock";
                String instrumentRental = "SELECT * " +
                        "FROM " +
                        "public.instrument_rental";
                Statement statement = connection.createStatement();

                ResultSet resultQueryInstrument = statement.executeQuery(queryInstrument);
                ResultSet resultQueryStock = statement.executeQuery(queryStock);
                ResultSet resultQueryInstrumentRentals = statement.executeQuery(instrumentRental);

                int studentID = 23;
                StringBuilder str = new StringBuilder();
                LocalDate dateOfRenting = LocalDate.now();
                int studentsCurrentRentals = 0;
                while (resultQueryInstrumentRentals.next())
                {
                    if(Integer.parseInt(resultQueryInstrumentRentals.getString(3)) == studentID)
                    {
                        String rentalMonthsString = resultQueryInstrumentRentals.getString(6);
                        int rentalMonths = Integer.parseInt(rentalMonthsString);
                        String rentalDateAsString = resultQueryInstrumentRentals.getString(4);
                        LocalDate rentalDate = LocalDate.parse(rentalDateAsString);
                        String returnDateAsString = resultQueryInstrumentRentals.getString(4);
                        LocalDate returnDate = LocalDate.parse(returnDateAsString).plusMonths(rentalMonths);
                        if(returnDate.compareTo(LocalDate.now()) >=0) // if returnDate after the date today.
                        {
                            studentsCurrentRentals++;
                            for (int i = 1; i < 10; i++)
                            {// get instrument_rentals

                                //LocalDate.parse(resultQueryInstrumentRentals.getString(5));
                                str.append(resultQueryInstrumentRentals.getString(i));
                                if(i == 9) {
                                    str.append("");
                                }
                                else {
                                    str.append(", ");
                                }

                            }
                            str.append("\n");
                        }
                    }
                }

                System.out.println("Student ID: " + studentID);
                System.out.println("Number of current Rentals: " + studentsCurrentRentals);
                System.out.println(str.toString());
                if(studentsCurrentRentals < 2) {
                    System.out.println("Enter the ID of the instrument you want to rent: ");
                    int instrumentId = 5;
                    while (resultQueryStock.next()) {
                        if (instrumentId == Integer.parseInt(resultQueryStock.getString(1))) {
                            if (Integer.parseInt(resultQueryStock.getString(4)) < Integer.parseInt(resultQueryStock.getString(2))) {
                                LocalDate rentalDate = LocalDate.now();
                                System.out.println("Enter the period of the rental (max 1 year = 12 months)");
                                int rentalPeriod = 7;
                                LocalDate returnDate = rentalDate.plusMonths(rentalPeriod);
                                System.out.println("Choose the delivery method: Enter 1 for (Deliver to house), enter 2 for (Pick up)");
                                String deliveryMethod = "Deliver to house"; // user will choose.

                                String rentInstrumentQuery =  String.format("INSERT INTO public.instrument_rental(\n" +
                                                "\tinstrument_id, student_id, rental_date, return_date, rental_period, delivery_method, terminated, date_of_termination)\n" +
                                                "\tVALUES (%d, %d, '%s', '%s', %d, '%s', false, null);"
                                        , instrumentId, studentID, rentalDate, returnDate, rentalPeriod, deliveryMethod).toString();

                              int returnedExecutionStatus = executeRentalQuery(rentInstrumentQuery, statement);
                              if(returnedExecutionStatus == -1) { // it is illegal to use this method in MVC, I should rethrow another exception in try and catch. And choose the
                                  System.out.println("The rental succeeded"); // check the exception. expected to run the try not the catch.
                              }
                              else {
                                  System.out.println("Something went wrong, try again!"); //
                              }
                             String updateStock = String.format("UPDATE public.stock\n" +
                                      "\tSET rented_instruments=rented_instruments+1\n" +
                                      "\tWHERE instrument_id=%d;", instrumentId);
                              int returnedUpdateStock = executeRentalQuery(updateStock, statement);
                              if(returnedExecutionStatus == 0) { // it is illegal to use this method in MVC, I should rethrow another exception in try and catch. And choose the
                                  System.out.println("Something went wrong, try again!"); //
                              }
                            }
                        }
                    }
                }
                else {
                    System.out.println("The Student already has 2 current rentals. You are not allowed to rent more than 2 instruments at the same time.");
                }
            }

        } catch (Exception e)
        {
            e.printStackTrace();
        } finally
        {
            if(connection != null)
            {
                connection.close();
            }
        }
    }
}