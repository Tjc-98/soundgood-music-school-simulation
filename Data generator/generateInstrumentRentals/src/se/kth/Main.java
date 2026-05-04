package se.kth;

import java.util.Arrays;
import java.util.Random;

public class Main {
    // (instrument_id, student_id, rental_date, return_date, rental_period, delivery_method)
    public static void main(String[] args) {
        String data0 = generateInput(50, 2014);
        String data1 = generateInput(60, 2015);
        String data2 = generateInput(45, 2016);
        String data3 = generateInput(53, 2017);
        String data4 = generateInput(48, 2018);
        String data5 = generateInput(51, 2019);
        String data6 = generateInput(46, 2020);

        System.out.println(data0);
        System.out.println(data1);
        System.out.println(data2);
        System.out.println(data3);
        System.out.println(data4);
        System.out.println(data5);
        System.out.println(data6);
    }

    public static String generateInput(int count, int year) {
        StringBuilder data = new StringBuilder();
        Random rand = new Random();

        int[] rentalMonths = generateMonth(count);
        int[] rentalDays = generateDay(count);
        int[] rentalPeriod = generateRentalPeriod(count);
        String[] returnDate = generateReturnDate(count, year, rentalMonths, rentalDays, rentalPeriod);
        String[] rentalDate = convertToDateFormat(count, year, rentalMonths, rentalDays);
        int[] studentId = generateStudentId(count);
        String[] deliveryMethod = generateDeliveryMethod(count);

        for (int i = 0; i < count; i++) {
            data.append("(");
            data.append((rand.nextInt(10) + 1));
            data.append(", ");
            data.append(studentId[i]);
            data.append(", '" + rentalDate[i] + "'");
            data.append(", '" + returnDate[i] + "', ");
            data.append(rentalPeriod[i]+ ", '");
            data.append(deliveryMethod[i]+ "'");
            if(i % 5 == 0) {
                data.append(", 'True', '");
                data.append( rentalDate[i]);
                data.append("'");
            }
            else {
                data.append(", 'False', Null");
            }

            if(i == count - 1) {
                data.append("),");
            } else {
                data.append("),\n");
            }
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

    public static int[] generateDay(int count) {
        Random rand = new Random();
        int[] days = new int[count];
        for(int i = 0; i < count; i++) {
            days[i] = rand.nextInt(28) + 1;
        }
        return days;
    }

    public static int[] generateRentalPeriod(int count) {
        Random rand = new Random();
        int[] rentalPeriods = new int[count];

        for(int i = 0; i < count; i++) {
            rentalPeriods[i] = rand.nextInt(12) + 1;
        }
        return rentalPeriods;
    }

    public static String[] generateReturnDate(int count, int year, int[] rentalMonths, int[] rentalDays, int[] rentalPeriods) {
        String[] returnDate = new String[count];

        for(int i = 0; i < count; i++) {
            returnDate[i] = "";
        }


        for (int i = 0; i < count; i++) {
            int tempSumMonth = rentalMonths[i] + rentalPeriods[i];
            if (tempSumMonth > 12) {
                returnDate[i] += (year + 1);
                if(tempSumMonth - 12 < 10) {
                    returnDate[i] += "-0" + (tempSumMonth - 12);
                } else {
                    returnDate[i] += "-" + (tempSumMonth - 12);
                }
            } else if(tempSumMonth < 10) {
                returnDate[i] += year;
                returnDate[i] += "-0" + tempSumMonth;
            }
            else {
                returnDate[i] += year;
                returnDate[i] += "-" + tempSumMonth;
            }
            if(rentalDays[i] < 10) {
                returnDate[i] += "-0" + rentalDays[i];
            } else {
                returnDate[i] += "-" + rentalDays[i];
            }
        }
        return returnDate;
    }

    public static String[] convertToDateFormat(int count, int year, int[] months, int[] days) {
        String[] date = new String[count];

        for(int i = 0; i < date.length; i++) {
            date[i] = "";
        }

        for (int i = 0; i < count; i++) {
            date[i] += year;
            if(months[i] < 10) {
                date[i] += "-0" + months[i];
            } else {
                date[i] += "-" + months[i];
            }
            if(days[i] < 10) {
                date[i] += "-0" + days[i];
            } else {
                date[i] += "-" + days[i];
            }
        }

        return date;
    }

    public static int[] generateStudentId(int count) {
        int[] results = new int[count];
        Random rand = new Random();
        int[] studentIds = new int[] {
                1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                21, 22, 23, 24, 25, 26, 27, 28, 29, 30};

        for(int j = 0; j < results.length; j++) {
            results[j] = 0;
        }

        int i = 0;

        while(i < studentIds.length) {
            int place = rand.nextInt(results.length);
            if(results[place] == 0) {
                results[place] = studentIds[i];
                i++;
            }
        }

        for(int k = 0; k < results.length; k++) {
            boolean check = true;
            if(results[k] == 0) {
                while (check) {
                    int randomId = rand.nextInt(30) + 1;
                    if(checkOccurrence(randomId, results) < 2) {
                        results[k] = randomId;
                        check = false;
                    }
                }
            }
        }

        return results;
    }

    public static int checkOccurrence(int num, int[] array) {
        int count = 0;
        for (int element : array) {
            if (element == num) {
                count++;
            }
        }
        return count;
    }

    public static String[] generateDeliveryMethod(int count) {
        Random rand = new Random();
        String[] deliveryMethod = new String[count];
        String[] availableDeliveryMethod = new String[] {"Deliver to house", "Pick up"};
        for(int i = 0; i < count; i++) {
            deliveryMethod[i] = availableDeliveryMethod[rand.nextInt(2)];
        }
        return deliveryMethod;
    }

}
