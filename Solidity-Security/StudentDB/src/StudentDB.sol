// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract StudentDB {
    /* This exercise assumes you know how structs work.
       Create a struct `Student` for a student whose name is `John` and age is `12`.
       Return John's age in the function below */

    struct Student {
        string name;
        uint256 age;
    }

    Student public student;

    constructor() {
        createStudent("John", 12);
    }

    // Create Student's data
    function createStudent(string memory _name, uint256 _age) public {
        student = Student(_name, _age);
    }

    // Return John's age
    function getJohnAge() public view returns (uint256) {
        return student.age;
    }

    // Return the entire struct data
    function getEntireStruct() public view returns (Student memory) {
        return student;
    }
}
