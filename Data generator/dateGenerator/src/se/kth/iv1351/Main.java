package se.kth.project;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Random;

public class Main {

    public static String generateInput(int count, String year) {
        StringBuilder data = new StringBuilder();
        int[] months = generateMonth(count);
        String[] hours = new String[] {"08", "09", "10", "11", "12", "13", "14", "15", "16", "17"};
        String[] minutes = new String[] {"00", "15", "30", "45"};
        Random rand = new Random();

        for(int i = 0 ; i < count; i++) {
            int temp = 0;
            String tempMonth= "", tempDay ="";
            if(months[i] == 2) {
                temp = rand.nextInt(28) + 1;
            } else {
                temp = rand.nextInt(30) + 1;
            }
            data.append("(");
            data.append(rand.nextInt(40) + 1);
            data.append(", '");
            data.append(year);
            data.append("-");
            if(months[i] < 10) {
                tempMonth = "0" + months[i];
                data.append("0" + months[i]);
            } else {
                tempMonth = "" + months[i];
                data.append(months[i]);
            }
            data.append("-");
            if(temp < 10) {
                tempDay = "0" + temp;
                data.append("0" + temp);
            } else {
                tempDay = "" + temp;
                data.append(temp);
            }
            data.append(" ");
            data.append(hours[rand.nextInt(hours.length)]);
            data.append(":");
            data.append(minutes[rand.nextInt(minutes.length)]);
            data.append(":00', '");
            String date = "";
            if(months[i] < 10) {
                date = year + "-" + tempMonth + "-" + tempDay;
            } else {
                date = year + "-" + tempMonth + "-" + tempDay;
            }
            data.append(getWeekday(date));
            if(i == count - 1) {
                data.append("'),");
            } else {
                data.append("'),\n");
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

    // date format YYYY-MM-DD
    public static String getWeekday(String date) {
        String weekday = "";
        LocalDate  d = LocalDate.parse(date);
        DayOfWeek day = d.getDayOfWeek();
        weekday = day.toString().toLowerCase();
        return weekday;
    }

    public static void main(String[] args) {
//        String data0 = generateInput(700, "2014");
//        String data1 = generateInput(500, "2015");
//        String data2 = generateInput(400, "2016");
//        String data3 = generateInput(800, "2017");
//        String data4 = generateInput(900, "2018");
//        String data5 = generateInput(1000, "2019");
//        String data6 = generateInput(600, "2020");
//        System.out.println(data0);
//        System.out.println(data1);
//        System.out.println(data2);
//        System.out.println(data3);
//        System.out.println(data4);
//        System.out.println(data5);
//        System.out.println(data6);
        String data6 = generateInput(650, "2015");
        System.out.println(data6);
    }
}
