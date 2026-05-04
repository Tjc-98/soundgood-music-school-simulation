package se.kth.project;

import java.util.Random;

public class Main {

    public static void main(String[] args) {
        Random rand = new Random();
        int count = 40;
        int numberOfLessons = 40;

        int[] instructorIds = generateInstructorId(15, numberOfLessons);
        String[] instruments = generateAvaliableGenre(numberOfLessons);
        String[] lessonType = new String[]{"ensemble"};
        String[] lessonTypeList = generateLessonTypeList(lessonType, numberOfLessons);
        int[] enrolledStudents = generateNumberEnrolledStudents(numberOfLessons);
        String[] availableLessonLevel = new String[]{"beginner", "intermediate", "advanced"};
        String[] lessonLevelList = new String[numberOfLessons];
        for (int i=0; i<numberOfLessons; i++) {
            lessonLevelList[i] = availableLessonLevel[rand.nextInt(3)];
        }
        for (int i = 0; i< numberOfLessons; i++) {

            System.out.println("('" + instruments[i] + "', " + instructorIds[i] + ", " + 2 + ", " + 30 + ", " + enrolledStudents[i] + ", " + enrolledStudents[i] + ", '"+ lessonLevelList[i] + "'),");
        }
        System.out.println("");
    }

    public static String[] generateLessonTypeList (String[] lessonType, int numberOfLessons) {
        Random rand = new Random();
        String[] lessonTypeList = new String[numberOfLessons];
        for (int i= 0; i<numberOfLessons; i++) {
            lessonTypeList[i] = lessonType[0];
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

    public static String[] generateAvaliableGenre(int numberOfLessons) {
        Random rand = new Random();
        String[] instrumentKind = new String[numberOfLessons];
        String[] avaliableGenre = new String[] {"Art Punk", "Alternative Rock", "Britpunk", "College Rock", "Crossover Thrash", "Experimental Rock", "Grunge", "Hard Rock", "Indie Rock"};
        for (int i =0; i<numberOfLessons; i++) {
            instrumentKind[i] = avaliableGenre[rand.nextInt(9)];
        }
        return instrumentKind;
    }



    public static int[] generateNumberEnrolledStudents(int numberOfLesson) {
        Random rand = new Random();
        int[] enrolledStudents = new int[numberOfLesson];
        for (int i =0; i<numberOfLesson; i++) {
            enrolledStudents[i] = rand.nextInt(29) + 2;
        }
        return enrolledStudents;
    }
}
