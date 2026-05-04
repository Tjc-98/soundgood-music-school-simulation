package se.kth.project.View;

import se.kth.project.Controller.Controller;
import se.kth.project.Model.DatabaseException;

import java.sql.SQLException;
import java.util.Scanner;

public class View {

    Controller controller;

    public View(Controller controller) {
        this.controller = controller;
    }

    /**
     * @throws SQLException in unexpected cases while running the SQL queries.
     * @throws DatabaseException which unexpected cases and to not disturb the user.
     */
    public void startInterface() throws SQLException, DatabaseException {

        try {
            String chooseCategoryText = "Welcome to the SoundGood Music school:\n" +
                    "Enter the number of the category you want to enter: \n" +
                    "1: Show the available instruments in the stock.\n" +
                    "2: Show your current rentals.\n" +
                    "3: Add a new rental to your account.\n" +
                    "4: Terminate an ongoing rental.\n" +
                    "5: To exit.";
            System.out.println(chooseCategoryText);
            Scanner scan = new Scanner(System.in);

            boolean stillGoing = true;
            int counter = 0;
            while (stillGoing) {
                System.out.println("Enter the number of the category you want to enter: \n");
                switch(scan.nextInt()) {
                    case 1:
                        controller.showAvailableInstrumentsInStock();
                        break;
                    case 2:
                        System.out.println("Enter the Student id to show your current rentals");
                        int studentId = scan.nextInt();
                        controller.insertRentalInContr(studentId);
                        break;
                    case 3:
                        System.out.println("Enter the student id: ");
                        int rentalStudentId = scan.nextInt();
                        System.out.println("Enter the instrument id: ");
                        int rentalInstrumentId = scan.nextInt();
                        System.out.println("Enter the rental period: ");
                        int rentalPeriod = scan.nextInt();
                        System.out.println("Choose the delivery method: 1: for Delivery to house   2: for Pick up");
                        int indexOfDeliveryMethod = scan.nextInt();
                        if (indexOfDeliveryMethod != 2) {
                            indexOfDeliveryMethod = 1;
                        }
                        controller.addRentalInContr(rentalStudentId, rentalInstrumentId, rentalPeriod, indexOfDeliveryMethod-1);
                        break;
                    case 4:
                        System.out.println("Enter the student id:");
                        int terminationStudentId = scan.nextInt();
                        System.out.println("Enter The the Rental Id: (You can check it by choosing the 2 category to show your current rentals).");
                        int terminationRentalId = scan.nextInt();
                        controller.terminateRentalInContr(terminationStudentId, terminationRentalId);
                        System.out.println("Make sure to check your current rentals to confirm the termination");
                        break;
                    case 5:
                        stillGoing = false;
                        controller.closeConnection();
                        break;
                    default:
                        System.out.println("You have entered a wrong number");
                        break;
                }
                counter++;
                if(counter >= 4) {
                    controller.showAvailableInstrumentsInStock();
                    counter = 0;
                }
            }
        }catch (DatabaseException e) {
            controller.rollbackForView();
            throw new DatabaseException("Something went wrong," + e.getMessage());
        }
    }
}
