/*
 * GaussianOutputFile.h
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#ifndef GAUSSIANOUTPUTFILE_H_
#define GAUSSIANOUTPUTFILE_H_

#include "InputFile.h"
#include "../molecules/Molecule.h"

#include <iostream>
#include <stdlib.h>

using namespace std;

class GaussianOutputFile : public InputFile
{
public:

	GaussianOutputFile();

	virtual ~GaussianOutputFile();

	bool readFirstStandardGeometry(Molecule& mol);

	bool readFirstInputOrientationGeometry(Molecule& mol);

	bool readStandardGeometries(vector<Molecule>& molecules);

	bool readInputOrientationGeometries(vector<Molecule>& molecules);

	bool readEnergies(vector<double>& energies);

	bool readMullikenCharges(Molecule& mol);
};

#endif /* GAUSSIANOUTPUTFILE_H_ */
