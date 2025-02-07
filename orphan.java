import java.io.*;
import java.util.Arrays;
import java.util.Scanner;

public class ProcessSorting {
    
    public static void bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                if (arr[i] > arr[j]) {
                    int temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
            }
        }
        System.out.println("Sorted array using Bubble Sort from child process: " + Arrays.toString(arr));
    }
    
    public static void selectionSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                if (arr[j] < arr[minIdx]) {
                    minIdx = j;
                }
            }
            int temp = arr[minIdx];
            arr[minIdx] = arr[i];
            arr[i] = temp;
        }
        System.out.println("Sorted array using Selection Sort from parent process: " + Arrays.toString(arr));
    }
    
    public static void main(String[] args) throws IOException, InterruptedException {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter size of array: ");
        int size = scanner.nextInt();
        
        int[] arr = new int[size];
        System.out.println("Enter " + size + " numbers in array: ");
        for (int i = 0; i < size; i++) {
            arr[i] = scanner.nextInt();
        }
        
        // Create a child process
        ProcessBuilder pb = new ProcessBuilder("java", "BubbleSortChild", Arrays.toString(arr));
        pb.redirectOutput(ProcessBuilder.Redirect.INHERIT);
        pb.redirectError(ProcessBuilder.Redirect.INHERIT);
        Process childProcess = pb.start();
        
        System.out.println("\n-------Hello from parent process-------");
        System.out.println("Parent process id: " + ProcessHandle.current().pid());
        selectionSort(arr);
        
        childProcess.waitFor(); // Wait for child process to finish
    }
}

// Separate class for child process
class BubbleSortChild {
    public static void main(String[] args) {
        int[] arr = Arrays.stream(args[0].replaceAll("[\[\]]", "").split(", "))
                .mapToInt(Integer::parseInt).toArray();
        
        System.out.println("\n-------Hello from child process-------");
        System.out.println("Child process id: " + ProcessHandle.current().pid());
        
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        bubbleSort(arr);
    }
    
    private static void bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                if (arr[i] > arr[j]) {
                    int temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
            }
        }
        System.out.println("Sorted array using Bubble Sort from child process: " + Arrays.toString(arr));
    }
}
