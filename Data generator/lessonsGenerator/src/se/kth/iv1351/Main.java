package se.kth.project;

import java.util.Random;

public class Main {

    public static void main(String[] args) {
        int count = 15;
        int[] ids = idGenerator(count);
        String[] phoneNumbers = phoneNumberGenerator(count);
        String[] emails = new String[] {"itstatus@mac.com", "yruan@live.com", "emcleod@me.com", "evans@icloud.com", "gerlo@verizon.net", "demmel@msn.com",
                "kwilliams@yahoo.ca", "tellis@gmail.com", "koudas@aol.com", "madler@optonline.net", "thrymm@gmail.com", "stecoop@aol.com", "biglou@yahoo.com",
                "augusto@hotmail.com", "munson@verizon.net", "hillct@gmail.com"};

       for (int i =0; i< phoneNumbers.length; i++) {
           if (i == phoneNumbers.length-1) {
               System.out.print("("+ids[i] + ", " + phoneNumbers[i] + ", '" + emails[i] + "');");
           }
           else {
               System.out.print("(" + ids[i] + ", " + phoneNumbers[i] + ", '" + emails[i] + "'),");
           }
       }
    }

    public static String[] phoneNumberGenerator(int count) {
        Random rand = new Random();
        String[] numbers = new String[count];
        for (int i = 0; i < count; i++) {
            numbers[i] = "0";
            for (int j = 0; j< 9; j++) {
                numbers[i] += rand.nextInt(10);
            }
        }
        return numbers;
    }

    public static int[] idGenerator(int count) {
        int[] ids = new int[count];
        for (int i=0; i<count; i++) {
            ids[i] = i+1;
        }
        return ids;
    }

}
