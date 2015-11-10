//
//  main.cpp
//  convert-mass
//
//  Created by James Robertson on 1/30/14.
//  Copyright (c) 2014 James Robertson. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
    const double kg_per_lb = 0.453592;
    double mass = 1;
    char unit = ' ';
    std::cout << "Please enter a mass followed by a unit (p for pound or k for kilogram):\n";
    std::cin >>mass>>unit;
    
    if(unit=='p')
        std::cout<<mass<<" p == "<<kg_per_lb*mass<<" kg\n";
    else if(unit=='k')
        std::cout<<mass<<" k == "<<mass/kg_per_lb<<" lb\n";
    else
        std::cout<<"Sorry, the unit is not recognized.\n";
    return 0;
}