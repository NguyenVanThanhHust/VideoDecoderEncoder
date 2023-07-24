#include "multiply.h"

Multiply::Multiply(std::string class_name)
{
    function_name = class_name;
}

double Multiply::calculate(double first, double second)
{
    return first * second;
}