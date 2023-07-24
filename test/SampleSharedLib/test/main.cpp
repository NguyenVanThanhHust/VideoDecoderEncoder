#include <iostream>

#include "add.h"

using namespace std;

int main()
{
    Add sample_add = Add("sample");
    double res = sample_add.calculate(10.2, 12.1);
    cout<<res<<endl;
    return 0;
}