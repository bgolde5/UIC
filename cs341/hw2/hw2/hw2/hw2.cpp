// hw2.cpp : Defines the entry point for the console application.\
//

//
// C++ program to compute student exam averages.
//
// Bradley Golden
// U. of Illinois, Chicago
// CS341, Fall2015
// Homework 2
//

#include "stdafx.h"
#include <iostream>
#include <fstream>
#include <iterator>
#include <string>
#include <vector>
#include <algorithm>
#include <numeric>

using namespace std;


class Student {
private:
	vector<int> scores;

public:
	int uin;
	string netID;
	double average;


	Student(string id, int u) {
		netID = id;
		uin = u;
		average = 0;
	}

	void addScore(int aScore) {
		//add a score to the student's score vector
		scores.push_back(aScore);
	}

	void setAverage() {
		average = accumulate(scores.begin(), scores.end(), 0.0) / scores.size();
	}

	void printScores() {
		//print n-1 scores
		for (vector<int>::iterator s = scores.begin(); s != scores.end() - 1; ++s) {
			cout << *s << ", ";
		}
		// don't forget to print the last score without a comma!
		cout << scores[scores.size()-1] << endl;
	}
	
	void printDetails() {
		//display's in this format: "avg = <average> based on exams <score1>, <score2>, ..., <scoreN>"
		cout << "avg = " << average << " based on on exams ";
		printScores();
	}

	void printNetIdDetails() {
		cout << " " << netID << ": ";
		printDetails();
	}

	void printUinDetails() {
		cout << " " << uin << ": ";
		printDetails();
	}

}; //end class Student

bool compareUin(const Student& a, const Student& b) { return (a.uin < b.uin); }

bool compareNetID(const Student& a, const Student& b) { return a.netID.compare(b.netID) < 0; }

bool compareAve(Student& a, Student &b) {

	// if average is the same swap the students by NetID
	if (a.average == b.average && compareNetID(a,b) == true) {
		Student temp = a;
		a = b;
		b = temp;
	}

	return a.average > b.average; 
}

vector<Student> buildStudents(vector<string>& data) {

	// Create vector of students
	vector<Student> students;

	// Parse text file data into student objects
	// Each student object is pushed into a vector
	for (vector<string>::iterator d = data.begin(); d != data.end(); ++d) {

		// get the netID
		string netID = *d;
		++d;

		// get the uin
		int uin = atoi((*d).c_str());

		// create the student object with the netID and uin
		Student student = Student(netID, uin); // populate student object with netID and uin

											   // add three scores to the student object
		++d;
		student.addScore(atoi((*d).c_str()));
		++d;
		student.addScore(atoi((*d).c_str()));
		++d;
		student.addScore(atoi((*d).c_str()));

		//determine the average of the student's scores
		student.setAverage();

		// push the student object to students vector
		students.push_back(move(student));
	}

	return students;
}// end buildStudents

void printByAverage(vector<Student>& students) {
	// print the students by average sorted in descending order
	sort(students.begin(), students.end(), compareAve);

	cout << "By exam average:" << endl;
	for (auto stu : students) {
		stu.printNetIdDetails();
	}
	cout << endl;
} //end printByAverage

void printByNetID(vector<Student>& students) {
	// print the students by netID sorted in ascending order
	sort(students.begin(), students.end(), compareNetID);
	cout << "By NetID:" << endl;
	for (auto stu : students) {
		stu.printNetIdDetails();
	}
	cout << endl;
} //end printByNetID

void printByUIN(vector<Student>& students) {
	// print the students by UIN sorted in ascending order
	sort(students.begin(), students.end(), compareUin);
	cout << "By UIN:" << endl;
	for (auto stu : students) {
		stu.printUinDetails();
	}
	cout << endl;
} //end printbyUIN

int main() {
	// Create file and iterator objects to read the file
	ifstream file("students.txt");
	istream_iterator<string> start(file), end;

	// Read entire file as string
	vector<string> data(start, end);

	// Create vector of students containing file contents
	vector<Student> students = buildStudents(data);

	// Print out contents of students vector sorted by it's respective field
	printByAverage(students);
	printByNetID(students);
	printByUIN(students);

    return 0;
} // end main
