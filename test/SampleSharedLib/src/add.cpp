#include "add.h"

Add::Add(std::string name)
{
    function_name = name;
}

double Add::calculate(double first, double second)
{
    return first + second;
}