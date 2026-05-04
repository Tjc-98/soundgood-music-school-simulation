import java.time.Month;
import java.util.Arrays;
import java.util.Random;

public class Main {

    public static void instrumentName() {
        //String[] instNames = new String[]{"Piano", "Guitar", "Violin", "Drums", "Saxophone", "Flute", "Cello", "Clarinet", "Trumpet", "Harp"};
        String[] instNames = new String[]{"string", "percussion", "brass", "woodwind"};
        Random rnd = null;
        int randomNumber = 0;
        for (int i=0; i<40; i++) {
            rnd = new Random();
            randomNumber = rnd.nextInt(instNames.length);
            System.out.println(instNames[randomNumber]);
        }
    }

    public static int[] randomRentYear() {
        Random rand = new Random();
        int[] rentYearArr = new int[120];

        for (int i=0; i<120; i++) {
            rentYearArr[i] = rand.nextInt(6) + 2015;
        }
        return rentYearArr;
    }

    public static int[] randomRentMonth() {
        Random rand = new Random();
        int[] rentMonthArr = new int[120];

        for (int i=0; i<120; i++) {
            rentMonthArr[i] = rand.nextInt(12) + 1;
        }
        return rentMonthArr;
    }

    public static int[] rentalPeriod() {
        Random rand = new Random();
        int[] rentalPeriodArr = new int[120];

        for (int i=0; i<120; i++) {
            rentalPeriodArr[i] = rand.nextInt(12)+1;
        }

        return rentalPeriodArr;
    }

    public static int[] generateRandomRentDay() {
        Random rand = new Random();
        int[] rentDayArr = new int[120];

        for (int i=0; i<120; i++) {
            rentDayArr[i] = rand.nextInt(30) + 1;
        }
        return rentDayArr;
    }

    public static void main(String[] args) {
      //  instrumentName();

//        for (int i=0; i<40; i++){
//            int renmondays[] = randomMonthAndDays();
//            int retmondays[] = randomMonthAndDays();
//            System.out.println(instrumentRentalPeriod(2019, renmondays[0], renmondays[1], 2019, retmondays[0], retmondays[1]));
//        }


        Random rand = new Random();
        int[] rentYear = randomRentYear();
        int[] rentMonth = randomRentMonth();
        int[] rentalPeriod = rentalPeriod();
        int[] rentDays = generateRandomRentDay();
        int[] retDays = new int[120];
        int[] returnYear = new int[120];
        int[] returnMonth = new int[120];
        int tempMonth, returnDay;
        for (int i=0; i<120; i++) {

            returnDay = rand.nextInt(30)+1;


            int period = returnDay - rentDays[i];
            if (period < 0) {
                retDays[i] = returnDay;
                returnMonth[i] += 1;
            }
            tempMonth=0;
            tempMonth = rentalPeriod[i] + rentMonth[i];
            if(tempMonth > 12) {
                tempMonth -= 12;
                returnMonth[i] = tempMonth;
                returnYear[i] = rentYear[i] + 1;
            }
            else {
                returnMonth[i] = tempMonth;
                returnYear[i] = rentYear[i];
            }



            System.out.println("'" + rentYear[i] + "-" + rentMonth[i] + "-" + rentDays[i] + "', '" + returnYear[i] + "-" +
                    returnMonth[i] + "-" + retDays[i] + "', " + rentalPeriod[i] + ", '" + (rentYear[i] + 1)+"-" + (rentMonth[i])+ "-" + rentDays[i] + "'");
        }


    }
}
