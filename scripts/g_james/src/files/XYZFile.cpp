/*
 * XYZFile.cpp
 *
 *  Created on: Oct 22, 2010
 *      Author: victor
 */

#include "XYZFile.h"

XYZFile::XYZFile() {
	// TODO Auto-generated constructor stub

}

XYZFile::~XYZFile() {
	// TODO Auto-generated destructor stub
}

bool XYZFile::readFile(Molecule & mol)
{
	Atom atom;
	string line;
	int numberOfAtoms = 0;
	int nlinesRead = 0;


	if(!rewind())
		return false;

	/*
	 * Reading the number of atoms
	 *
	 */
	line = readLine();

	mol.clear();
	numberOfAtoms = atoi(line.c_str());
	if(numberOfAtoms > 0)
		mol.reserve(numberOfAtoms);
	else
		return false;

	/*
	 * Jumping the line that contains the files comments
	 *
	 */
	line = readLine();

	/*
	 * Reading the atoms
	 *
	 */
	line = readLine();
	nlinesRead = 0;
	while(!eof() && nlinesRead < numberOfAtoms)
	{
		atom.clear();

		size_t p1 = line.find_first_not_of(' ');
		size_t p2 = line.find_first_of(' ', p1+1);

		size_t p3 = line.find_first_not_of(' ', p2+1);
		size_t p4 = line.find_first_of(' ', p3+1);

		size_t p5 = line.find_first_not_of(' ', p4+1);
		size_t p6 = line.find_first_of(' ', p5+1);

		size_t p7 = line.find_first_not_of(' ', p6+1);
		size_t p8 = line.find_first_of(' ', p7+1);

		atom.setName(line.substr(p1,p2-p1));
		atom.setX(atof(line.substr(p3,p4-p3).c_str()));
		atom.setY(atof(line.substr(p5,p6-p5).c_str()));
		atom.setZ(atof(line.substr(p7,p8-p7).c_str()));
		mol.addAtom(atom);
		line = readLine();
		nlinesRead++;
	}

	return true;
}
