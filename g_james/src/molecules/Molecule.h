/*
 * Molecule.h
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#ifndef MOLECULE_H_
#define MOLECULE_H_

#include <vector>


#include "Atom.h"

class Molecule
{

private:

	vector<Atom> molecule;

	string name;

public:

	Molecule(size_t numberOfAtoms = 0);

	virtual ~Molecule();

	size_t numberOfAtoms() const
	{
		return molecule.size();
	}

	void addAtom(Atom atom)
	{
		molecule.push_back(atom);
	}

	float distance(size_t pos1, size_t pos2)
	{
		return molecule.at(pos1).distanceTo(molecule.at(pos2));
	}

	float angle123(size_t pos1, size_t pos2, size_t pos3)
	{
		return molecule.at(pos2).angleAThisB(molecule.at(pos1),molecule.at(pos3));
	}

	float angle213(size_t pos1, size_t pos2, size_t pos3)
	{
		return molecule.at(pos1).angleAThisB(molecule.at(pos2),molecule.at(pos3));
	}

	float angle231(size_t pos1, size_t pos2, size_t pos3)
	{
		return molecule.at(pos3).angleAThisB(molecule.at(pos2),molecule.at(pos1));
	}

	float dihedral1234(size_t pos1, size_t pos2, size_t pos3, size_t pos4)
	{
		return molecule.at(pos1).dihedralThisABC(molecule.at(pos2),molecule.at(pos3),molecule.at(pos4));
	}

	void clear()
	{
		molecule.clear();
	}

	size_t size() const
	{
		return molecule.size();
	}

	Atom at(size_t pos) const
	{
		return molecule.at(pos);
	}

	bool replace(size_t i, Atom atom)
	{
		if(i < molecule.size())
		{
			molecule[i] = atom;
		}
		else
			return false;

		return true;
	}

	void reserve(size_t size)
	{
		molecule.reserve(size);
	}

	Atom operator[] (size_t i)
	{
	  return molecule[i];
	}

	string print() const
	{
    	stringstream str;

    	str.setf(ios_base::scientific,ios_base::floatfield);
    	str.precision(7);

    	for(size_t i = 0; i < molecule.size(); i++)
    		str << molecule.at(i).print() << endl;

    	return str.str();
	}

	string printPDBFormat() const
	{
    	stringstream str;

    	for(size_t i = 0; i < molecule.size(); i++)
        	str << setw(6) << setiosflags(ios_base::left) << "ATOM  "
        		<< setw(5) << setiosflags(ios_base::right) << i
        		<< setw(5) << setiosflags(ios_base::right) << molecule.at(i).getName()
        		<< setw(4) << setiosflags(ios_base::right) << "UNK"
        		<< setw(2) << setiosflags(ios_base::right) << "A"
        		<< setw(4) << setiosflags(ios_base::right) << 1
        		<< setw(4) << setiosflags(ios_base::right) << "" // I do not know why
        		<< setw(8) << setiosflags(ios_base::fixed) << setprecision(3) << molecule.at(i).getX()
        		<< setw(8) << setiosflags(ios_base::fixed) << setprecision(3) << molecule.at(i).getY()
        		<< setw(8) << setiosflags(ios_base::fixed) << setprecision(3) << molecule.at(i).getZ()
        		<< setw(6) << setiosflags(ios_base::fixed) << setprecision(2) << 0.
        		<< setw(6) << setiosflags(ios_base::fixed) << setprecision(2) << 0.
        		<< endl;
    	str << "END";

    	return str.str();
	}

    string printWithCharge() const
    {
    	stringstream str;

    	str.setf(ios_base::scientific,ios_base::floatfield);
    	str.precision(7);

    	for(size_t i = 0; i < molecule.size(); i++)
    		str << molecule.at(i).printWithCharge() << endl;

    	return str.str();
    }

    string printWithChargeAndAtomicNumbers() const
    {
    	stringstream str;

    	str.setf(ios_base::scientific,ios_base::floatfield);
    	str.precision(7);

    	for(size_t i = 0; i < molecule.size(); i++)
    		str << (i+1) << " " << molecule.at(i).printWithCharge() << endl;

    	return str.str();
    }

    string printWithChargeAndMass() const
    {
    	stringstream str;

    	str.setf(ios_base::scientific,ios_base::floatfield);
    	str.precision(7);

    	for(size_t i = 0; i < molecule.size(); i++)
    		str << molecule.at(i).printWithChargeAndMass() << endl;

    	return str.str();
    }

};

ostream& operator<<(ostream& output, Molecule mol);

#endif /* MOLECULE_H_ */
