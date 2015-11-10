/*
 * GaussianInputFileCreator.h
 *
 *  Created on: Oct 22, 2010
 *      Author: victor
 */

#ifndef GAUSSIANINPUTFILECREATOR_H_
#define GAUSSIANINPUTFILECREATOR_H_

#include "OutputFile.h"
#include "../molecules/Molecule.h"

class GaussianInputFileCreator : public OutputFile
{
public:

	GaussianInputFileCreator();

	virtual ~GaussianInputFileCreator();

	bool createFile(Molecule mol, string charge, string multiplicity, string base, string method, string comments, string processors, string memory, string worktype);

};

#endif /* GAUSSIANINPUTFILECREATOR_H_ */
