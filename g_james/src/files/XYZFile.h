/*
 * XYZFile.h
 *
 *  Created on: Oct 22, 2010
 *      Author: victor
 */

#ifndef XYZFILE_H_
#define XYZFILE_H_

#include "InputFile.h"
#include "../molecules/Molecule.h"

#include <stdlib.h>

class XYZFile : public InputFile
{

public:

	XYZFile();

	virtual ~XYZFile();

	bool readFile(Molecule & mol);

};

#endif /* XYZFILE_H_ */
