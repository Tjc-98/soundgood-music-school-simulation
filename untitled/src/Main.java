import java.util.Random;

public class Main {
    public static void main(String[] args) {
        //(instrument_id, amount, instrument_rental_fee)
        int count = 10;
        Random rand = new Random();
        int[] prices = new int[] {218,  202,  201, 418,  425,  306,  300,  110,  240,  292};
        for (int i = 0; i< count; i++) {
            int amount = rand.nextInt(90)+10;
            int temp = i+1;
            int rentedInstruments = rand.nextInt(amount+1);
            System.out.println("(" + temp + ", " + amount + ", " + prices[i] + ", " + rentedInstruments + "),");
        }
    }
}
