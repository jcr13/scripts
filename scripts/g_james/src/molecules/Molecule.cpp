/*
 * Molecule.cpp
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#include "Molecule.h"

Molecule::Molecule(size_t numberOfAtoms)
{
	switch (numberOfAtoms)
	{
		case 0:
			break;
		default:
			molecule.reserve(numberOfAtoms);
			break;
	}
}

Molecule::~Molecule()
{
	// TODO Auto-generated destructor stub
}

ostream& operator<<(ostream& output, Molecule mol)
{
	output.setf(ios_base::scientific,ios_base::floatfield);
	output.precision(7);

	for(size_t i = 0; i < mol.size(); i++)
		output << mol.at(i) << endl;

	return output;
}
