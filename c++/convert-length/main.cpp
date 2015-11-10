//
//  main.cpp
//  convert-ft-mi-km
//
//  Created by James Robertson on 1/30/14.
//  Copyright (c) 2014 James Robertson. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
    const double ft_per_mile = 5280.0;
    const double km_per_mile = 1.6094;
    double length = 1;
    char unit = ' ';
    std::cout << "Please enter a distance followed by a unit (f for foot, m for mile, or k for kilometer):\n";
    std::cin >>length>>unit;
    
    switch (unit) {
        case 'f':
            std::cout<<length<<" ft == "<<length/ft_per_mile<<" miles or "<<(length/ft_per_mile)*km_per_mile<<" km\n";
            break;
        case 'm':
            std::cout<<length<<" mi == "<<length*ft_per_mile<<" feet or "<<length*km_per_mile<<" km\n";
            break;
        case 'k':
            std::cout<<length<<" km == "<<length/km_per_mile<<" miles or "<<(length/km_per_mile)*ft_per_mile<<" feet\n";
            break;
        default:
            std::cout<<"Please enter a valid unit.\n";
            break;
    }
    return 0;
}