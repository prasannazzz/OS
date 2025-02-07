#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
using namespace std;

string addressBook = "addressbook.txt";

void createAddressBook() {
    cout << "Enter address book name: ";
    cin >> addressBook;
    ofstream file(addressBook);
    if (file) {
        cout << addressBook << " created successfully.\n";
    } else {
        cerr << "Could not create " << addressBook << "\n";
    }
}

void viewAddressBook() {
    ifstream file(addressBook);
    if (file) {
        cout << "\n---- Address Book Contents ----\n";
        string line;
        while (getline(file, line)) {
            cout << line << endl;
        }
    } else {
        cerr << "Could not read " << addressBook << "\n";
    }
}

void insertEntry() {
    ofstream file(addressBook, ios::app);
    if (!file) {
        cerr << "Could not insert data into " << addressBook << "\n";
        return;
    }
    string name, email, phone, age, address;
    cout << "Enter name: "; cin >> name;
    cout << "Enter email: "; cin >> email;
    cout << "Enter phone number: "; cin >> phone;
    cout << "Enter age: "; cin >> age;
    cout << "Enter address: "; cin.ignore(); getline(cin, address);
    file << name << " " << email << " " << phone << " " << age << " " << address << endl;
    cout << "Data inserted successfully.\n";
}

void deleteEntry() {
    viewAddressBook();
    cout << "Enter name to delete: ";
    string name, line;
    cin >> name;
    ifstream file(addressBook);
    ofstream temp("temp.txt");
    bool found = false;
    while (getline(file, line)) {
        if (line.find(name) == string::npos) {
            temp << line << endl;
        } else {
            found = true;
        }
    }
    file.close();
    temp.close();
    remove(addressBook.c_str());
    rename("temp.txt", addressBook.c_str());
    if (found) cout << "Record deleted successfully.\n";
    else cerr << "Record not found.\n";
}

void modifyEntry() {
    viewAddressBook();
    cout << "Enter name to modify: ";
    string name, line, newPhone;
    cin >> name;
    cout << "Enter new phone number: ";
    cin >> newPhone;
    ifstream file(addressBook);
    ofstream temp("temp.txt");
    bool found = false;
    while (getline(file, line)) {
        if (line.find(name) != string::npos) {
            size_t pos = line.find_last_of(' ');
            line = line.substr(0, pos) + " " + newPhone;
            found = true;
        }
        temp << line << endl;
    }
    file.close();
    temp.close();
    remove(addressBook.c_str());
    rename("temp.txt", addressBook.c_str());
    if (found) cout << "Record modified successfully.\n";
    else cerr << "Record not found.\n";
}

void searchEntry() {
    cout << "Enter name to search: ";
    string name, line;
    cin >> name;
    ifstream file(addressBook);
    bool found = false;
    cout << "\n---- Search Results ----\n";
    while (getline(file, line)) {
        if (line.find(name) != string::npos) {
            cout << line << endl;
            found = true;
        }
    }
    if (!found) cout << "No record found.\n";
}

int main() {
    int choice;
    do {
        cout << "\n------------------------------\n";
        cout << "1 --> Create\n";
        cout << "2 --> View\n";
        cout << "3 --> Insert\n";
        cout << "4 --> Delete\n";
        cout << "5 --> Modify\n";
        cout << "6 --> Search\n";
        cout << "7 --> Exit\n";
        cout << "Enter your choice: ";
        cin >> choice;
        switch (choice) {
            case 1: createAddressBook(); break;
            case 2: viewAddressBook(); break;
            case 3: insertEntry(); break;
            case 4: deleteEntry(); break;
            case 5: modifyEntry(); break;
            case 6: searchEntry(); break;
            case 7: cout << "Exit.\n"; break;
            default: cout << "Invalid choice, try again.\n";
        }
    } while (choice != 7);
    return 0;
}
