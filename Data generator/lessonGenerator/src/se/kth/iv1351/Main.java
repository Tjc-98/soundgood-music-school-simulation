package se.kth.project;

import java.util.Random;

public class Main {

    public static void main(String[] args) {
        Random rand = new Random();
        int count = 40;
        int numberOfLessons = 40;

        String[] lessonType = new String[]{"individual", "group"};
        int[] instructorIds = generateInstructorId(15, numberOfLessons);
        String[] instruments = generateInstrumentKind(numberOfLessons);
        String[] lessonTypeList = generateLessonTypeList(lessonType, numberOfLessons);
        int[] enrolledStudents = generateNumberEnrolledStudents(numberOfLessons, lessonTypeList);
        String[] availableLessonLevel = new String[]{"beginner", "intermediate", "advanced"};
        String[] lessonLevelList = new String[numberOfLessons];
        for (int i=0; i<numberOfLessons; i++) {
            lessonLevelList[i] = availableLessonLevel[rand.nextInt(3)];
        }
        for (int i = 0; i< numberOfLessons; i++) {
            if(lessonTypeList[i] == "individual") {
                System.out.println("(" + instructorIds[i] + ", '" + instruments[i] + "', '" + lessonTypeList[i] + "', " + 1 + ", " + 1 + ", " + 1 + ", '"+ lessonLevelList[i] + "'),");
            }
            else {
                System.out.println("(" + instructorIds[i] + ", '" + instruments[i] + "', '" + lessonTypeList[i] + "', " + 2 + "," + 30 + ", " + enrolledStudents[i] + ", '"+ lessonLevelList[i] + "'),");
            }
        }
        System.out.println("");
    }

    public static String[] generateLessonTypeList (String[] lessonType, int numberOfLessons) {
        Random rand = new Random();
        String[] lessonTypeList = new String[numberOfLessons];
        for (int i= 0; i<numberOfLessons; i++) {
            lessonTypeList[i] = lessonType[rand.nextInt(2)];
        }
        return lessonTypeList;
    }


    public static int[] generateInstructorId(int numberOfInstructors, int numberOfLessons) {
        Random rand = new Random();
        int[] instructorId = new int[numberOfInstructors];
        for (int i=0; i<numberOfInstructors; i++) {
            instructorId[i] = i+1;
        }
        int[] randomListOFIds = new int[numberOfLessons];

        for (int i = 0; i < numberOfLessons ; i++) {
            randomListOFIds[i] = rand.nextInt(numberOfInstructors) + 1;
        }
        return randomListOFIds;
    }

    public static String[] generateInstrumentKind(int numberOfLessons) {
        Random rand = new Random();
        String[] instrumentKind = new String[numberOfLessons];
        String[] availableInstrumentKind = new String[] {"Piano", "Violin", "Drums", "Saxophone", "Clarinet", "Trumpet"};
        for (int i =0; i<numberOfLessons; i++) {
            instrumentKind[i] = availableInstrumentKind[rand.nextInt(6)];
        }
        return instrumentKind;
    }



    public static int[] generateNumberEnrolledStudents(int numberOfLesson, String[] lessonType) {
        Random rand = new Random();
        int[] enrolledStudents = new int[numberOfLesson];
        for (int i =0; i<numberOfLesson; i++) {
            if (lessonType[i] == "individual") {
                enrolledStudents[i] = 1;
            }
            else {
                enrolledStudents[i] = rand.nextInt(29) + 2;
            }
        }
        return enrolledStudents;
    }
}
