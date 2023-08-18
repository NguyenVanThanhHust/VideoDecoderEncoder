#include <string>
#include <iostream>

class Add
{
    std::string function_name;
public:
    Add(std::string class_name);
    double calculate(double first, double second);
};