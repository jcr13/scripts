/*
 * GaussianOutputFile.cpp
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#include "GaussianOutputFile.h"

GaussianOutputFile::GaussianOutputFile()
{
	// TODO Auto-generated constructor stub

}

GaussianOutputFile::~GaussianOutputFile()
{
	// TODO Auto-generated destructor stub
}

bool GaussianOutputFile::readFirstStandardGeometry(Molecule& mol)
{
	Atom atom;
	string line;

	if(!rewind())
		return false;

	if(isStringInFile("Standard orientation"))
	{
		/*
		 * Jumping four lines that contains the orientation header
		 *
		 */
		for(size_t i = 0; i < 4; i++)
			line = readLine();

		/*
		 * Reading the atoms
		 *
		 */
		line = readLine();
		while(line.find("-------") == string::npos)
		{
			atom.clear();
			atom.setName(line.substr(13,16));
			atom.setX(atof(line.substr(33,46).c_str()));
			atom.setY(atof(line.substr(47,59).c_str()));
			atom.setZ(atof(line.substr(60,70).c_str()));
			mol.addAtom(atom);
			line = readLine();


		}

	}
	else
		return false;

	return true;
}

bool GaussianOutputFile::readFirstInputOrientationGeometry(Molecule& mol)
{
	Atom atom;
	string line;

	if(!rewind())
		return false;

	if(isStringInFile("Input orientation"))
	{
		/*
		 * Jumping four lines that contains the orientation header
		 *
		 */
		for(size_t i = 0; i < 4; i++)
			line = readLine();

		/*
		 * Reading the atoms
		 *
		 */
		line = readLine();
		while(line.find("-------") == string::npos)
		{
			atom.clear();
			atom.setName(line.substr(13,16));
			atom.setX(atof(line.substr(33,46).c_str()));
			atom.setY(atof(line.substr(47,59).c_str()));
			atom.setZ(atof(line.substr(60,70).c_str()));
			mol.addAtom(atom);
			line = readLine();


		}

	}
	else
		return false;

	return true;
}

bool GaussianOutputFile::readStandardGeometries(vector<Molecule>& molecules)
{
	Atom atom;
	Molecule mol;
	string line;
	bool ok;

	ok = false;

	while(isStringInFile("completed"))
	{
		if(isStringInFile("Standard orientation"))
		{
			/*
			 * Jumping four lines that contains the orientation header
			 *
			 */
			for(size_t i = 0; i < 4; i++)
				line = readLine();

			/*
			 * Reading the atoms
			 *
			 */
			line = readLine();
			while(line.find("-------") == string::npos)
			{
				atom.clear();
				atom.setName(line.substr(13,16));
				atom.setX(atof(line.substr(33,46).c_str()));
				atom.setY(atof(line.substr(47,59).c_str()));
				atom.setZ(atof(line.substr(60,70).c_str()));
				mol.addAtom(atom);
				line = readLine();
			}

			molecules.push_back(mol);

			mol.clear();

			ok = true;
		}
	}

	if(ok)
		return true;
	else
		return false;
}

bool GaussianOutputFile::readInputOrientationGeometries(vector<Molecule>& molecules)
{
	Atom atom;
	Molecule mol;
	string line;
	bool ok;

	ok = false;

	int i;

	i = 0;
	while(isStringInFile("Input orientation"))
	{
//		if(isStringInFile("Input orientation"))
//		{
			/*
			 * Jumping four lines that contains the orientation header
			 *
			 */
			for(size_t i = 0; i < 4; i++)
				line = readLine();

			/*
			 * Reading the atoms
			 *
			 */
			line = readLine();
			while(line.find("-------") == string::npos)
			{
				atom.clear();
				atom.setName(line.substr(13,16));
				atom.setX(atof(line.substr(33,46).c_str()));
				atom.setY(atof(line.substr(47,59).c_str()));
				atom.setZ(atof(line.substr(60,70).c_str()));
				mol.addAtom(atom);
				line = readLine();
			}

			molecules.push_back(mol);

			mol.clear();

			ok = true;
//		}
	}

	if(ok)
		return true;
	else
		return false;
}

bool GaussianOutputFile::readEnergies(vector<double>& energies)
{
	string line;

	double energy;

	rewind();

	line = readLine();
	while(!eof())
	{
		if(line.find("SCF Done:") != string::npos)
		{
			energy = atof(line.substr(20,37).c_str());
		}
		else if(line.find("completed") != string::npos)
		{
			energies.push_back(energy);
		}
		line = readLine();
	}

	return true;
}

bool GaussianOutputFile::readMullikenCharges(Molecule& mol)
{
	string line;
	size_t i;
	Atom atom;

	rewind();

	if(isStringInFile("Mulliken atomic charges:"))
	{
		/*
		 * Jumping the junk line
		 */
		line = readLine();

		i = 0;
		line = readLine();
		while(line.find("Sum of Mulliken atomic charges") == string::npos)
		{
			atom.clear();
			atom = mol.at(i);
			atom.setCharge(atof(line.substr(10,21).c_str()));

			mol.replace(i,atom);

			line = readLine();
			i++;
		}
	}
	else
		return false;

	return true;
}
