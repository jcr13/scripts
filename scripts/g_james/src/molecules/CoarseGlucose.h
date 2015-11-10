/*
 * CoarseGlucose.h
 *
 *  Created on: Oct 4, 2010
 *      Author: victor
 */

#ifndef COARSEGLUCOSE_H_
#define COARSEGLUCOSE_H_

#include "Molecule.h"

using namespace std;

class CoarseGlucose : public Molecule
{

private:

	Atom CV1;

	Atom CV2;

	Atom CVM;

	Atom CV6;

	Atom pCV1;

	Atom pCV2;

	Atom pCVM;

	Atom pCV6;

	Atom oxygen;

	Atom hydrogen;

	Atom nitrogen;

	Atom carbon;

public:

	CoarseGlucose();

	virtual ~CoarseGlucose();

	bool defGlucoseDimerFromMolecule(Molecule mol);

    Atom getCV1() const
    {
        return CV1;
    }

    Atom getCV2() const
    {
        return CV2;
    }

    Atom getCV6() const
    {
        return CV6;
    }

    Atom getCVM() const
    {
        return CVM;
    }

    Atom getpCV1() const
    {
        return pCV1;
    }

    Atom getpCV2() const
    {
        return pCV2;
    }

    Atom getpCV6() const
    {
        return pCV6;
    }

    Atom getpCVM() const
    {
        return pCVM;
    }

    float dihedral61Mp2p()
    {
    	return CV6.dihedralThisABC(CV1,pCVM,pCV2);
    }

    float dihedral61Mp6p()
    {
    	return CV6.dihedralThisABC(CV1,pCVM,pCV6);
    }

    float dihedral21Mp2p()
    {
    	return CV2.dihedralThisABC(CV1,pCVM,pCV2);
    }

    float dihedral21Mp6p()
    {
    	return CV2.dihedralThisABC(CV1,pCVM,pCV6);
    }

};

ostream& operator<<(ostream& output, CoarseGlucose coarseGlucose);


#endif /* COARSEGLUCOSE_H_ */
