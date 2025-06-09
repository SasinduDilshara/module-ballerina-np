type Employee record {
    string name;
    int id;
    decimal salary;
    Department department;
};

type Department record {
    string name;
    int[] employees;
};
