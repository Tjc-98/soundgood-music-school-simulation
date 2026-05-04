import java.time.LocalDate;
import java.util.Arrays;
import java.util.Random;
import java.util.GregorianCalendar;
import java.util.concurrent.ThreadLocalRandom;

public class Main {
    public static String generateInput(int count, int year) {
        StringBuilder data = new StringBuilder();
        Random rand = new Random();
        int[] rentMonths = generateMonth(count);
        int[] retYear = new int[count];
        int[] retDays = new int[count];
        int[] rentalMonths = new int[count];
        for (int i=0; i<count; i++) {
            retYear[i] = year;
            rentalMonths[i] = rand.nextInt(12)+1;
        }
        int[] studentId = new int[count];
        int[] retMonths = generateReturnMonth(count, rentMonths, retYear, rentalMonths);
        String[] hours = new String[] {"08", "09", "10", "11", "12", "13", "14", "15", "16", "17"};
        String[] minutes = new String[] {"00", "15", "30", "45"};

        String[] instrumentIdAndType = new String[] {"1, 'string',","2, 'string',","3, 'string',","4, 'percussion',","5, 'brass',",
                "6, 'woodwind',","7, 'string',","8, 'woodwind',","9, 'brass',","10, 'string',"};

        String[] shippingMethod = new String[] {"'Deliver to house'", "'Pick up'"};


        for (int i =0; i< count; i++) {
            if(rentMonths[i] == 2) {
                retDays[i] = rand.nextInt(27)+1;
                studentId[i] = rand.nextInt(30)+1;
            }
            else {
                    retDays[i] = rand.nextInt(30)+1;
                    studentId[i] = rand.nextInt(30)+1;
            }
        }

        for (int i =0; i< count; i++) {
            data.append("(");
            data.append(instrumentIdAndType[rand.nextInt(10)]);
            data.append(" ");
            data.append(studentId[i]);
            data.append(", ");
            data.append("'");
            data.append(year);
            data.append("-");
            data.append(rentMonths[i]);
            data.append("-");
            data.append(retDays[i]);
            data.append("', '");
            data.append(retYear[i]);
            data.append("-");
            data.append(retMonths[i]);
            data.append("-");
            data.append(retDays[i]);
            data.append("', ");
            data.append(rentalMonths[i]);
            data.append(", ");
            data.append("'");
            data.append(year+1);
            data.append("-");
            data.append(rentMonths[i]);
            data.append("-");
            data.append(retDays[i]);
            data.append("'),");
            data.append("\n");
        }

        return data.toString();
    }

    public static int[] generateMonth(int count) {
        Random rand = new Random();
        int[] months = new int[count];
        for(int i = 0; i < count; i++) {
            months[i] = rand.nextInt(12) + 1;
        }
        Arrays.sort(months);
        return months;
    }

    public static int[] generateReturnMonth(int count, int[] rentMonths, int[] retYear, int[] rentalMonths) {
        Random rand = new Random();
        int[] retMonths = new int[count];

        for (int i = 0; i < count; i++) {
            int tempSumMonth = rentalMonths[i] + rentMonths[i];
            if (tempSumMonth > 12) {
                retYear[i]++;
                retMonths[i] = rentalMonths[i] + rentMonths[i] -12;
            }
            else {
                retMonths[i] = rentalMonths[i] + rentMonths[i];
            }

        }
        return retMonths;
    }

    public static void main(String[] args) {
       System.out.println(generateInput(500, 2014));
       System.out.println(generateInput(500, 2015));
       System.out.println(generateInput(500, 2016));
       System.out.println(generateInput(500, 2017));
       System.out.println(generateInput(500, 2018));
       System.out.println(generateInput(500, 2019));
       System.out.println(generateInput(500, 2020));
    }
}
