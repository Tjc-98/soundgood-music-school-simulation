package se.kth.project.DTO;


public class StockInstruments {
    private int instrumentId;
    private int amount;
    private int rentalFee;
    private int amountRentedInstruments;

    public StockInstruments() {

    }

    public int getInstrumentId() {

        return instrumentId;
    }

    public void setInstrumentId(int instrumentId) {
        this.instrumentId = instrumentId;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }


    public void setRentalFee(int rentalFee) {

        this.rentalFee = rentalFee;
    }

    public void setAmountRentedInstruments(int amountRentedInstruments) {
        this.amountRentedInstruments = amountRentedInstruments;
    }
}
