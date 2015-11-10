/*
 * Atom.cpp
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#include "Atom.h"

Atom::Atom()
{
	// TODO Auto-generated constructor stub
	name = "";
	mass = 0.0;
	charge = 0.0;
	x = 0.0;
	y = 0.0;
	z = 0.0;
}

Atom::~Atom()
{
	// TODO Auto-generated destructor stub
}

ostream& operator<<(ostream& output, Atom atom)
{
	stringstream str;

	str.clear();

	str << setw(4) << setiosflags(ios_base::fixed) << atom.getName() << "   "
		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << atom.getX() << " "
		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << atom.getY() << " "
		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << atom.getZ();
	output << str.str();
	return output;
}
