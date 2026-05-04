package se.kth.project.DTO;

import java.time.LocalDate;

/**
 * StudentRentalsInfo where the rentals info can be stored for later usage
 */
public class StudentRentalsInfo {
    private int rentalId;
    private int instrumentId;
    private int studentId;
    private LocalDate rentalDate;
    private LocalDate returnDate;
    private int rentalPeriod;
    private String deliveryMethod;
    private boolean terminated;
    private LocalDate dateOfTermination;

    /**
     * @param rentalId the id of the rental.
     * @param instrumentId the instrument id the student want to rent.
     * @param studentId the id of the student want to complete the rental.
     * @param rentalDate the date when the rental is completed
     * @param returnDate the expected date of returning the instrument
     * @param rentalPeriod the length of period of renting the instrument.
     * @param deliveryMethod the method of delivery
     */
    public StudentRentalsInfo(int rentalId, int instrumentId, int studentId, LocalDate rentalDate, LocalDate returnDate, int rentalPeriod, String deliveryMethod) {
        this.rentalId = rentalId;
        this.instrumentId = instrumentId;
        this.studentId = studentId;
        this.rentalDate = rentalDate;
        this.returnDate = returnDate;
        this.rentalPeriod = rentalPeriod;
        this.deliveryMethod = deliveryMethod;
        this.terminated = false;
        this.dateOfTermination = null;
    }

    /**
     * @return the rentalId as int
     */
    public int getRentalId() {
        return rentalId;
    }

    /**
     * @return the instrumentId as int
     */
    public int getInstrumentId() {
        return instrumentId;
    }

    /**
     * @return the studentId as int
     */
    public int getStudentId() {
        return studentId;
    }

    /**
     * @return the rentalDate as LocalDate
     */
    public LocalDate getRentalDate() {
        return rentalDate;
    }

    /**
     * @return the returnDate as LocalDate
     */
    public LocalDate getReturnDate() {
        return returnDate;
    }

    /**
     * @return the rentalPeriod as int
     */
    public int getRentalPeriod() {
        return rentalPeriod;
    }

    /**
     * @return the deliveryMethod as String
     */
    public String getDeliveryMethod() {
        return deliveryMethod;
    }

    /**
     * @return if the instrument is terminated or not as boolean
     */
    public boolean isTerminated() {
        return terminated;
    }

}
