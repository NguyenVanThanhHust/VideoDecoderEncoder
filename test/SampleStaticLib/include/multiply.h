#include <string>
#include <iostream>

class Multiply
{
    std::string function_name;
public:
    Multiply(std::string class_name);
    double calculate(double first, double second);
};