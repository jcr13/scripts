/*
 * GaussianInputFileCreator.cpp
 *
 *  Created on: Oct 22, 2010
 *      Author: victor
 */

#include "GaussianInputFileCreator.h"

GaussianInputFileCreator::GaussianInputFileCreator()
{
	// TODO Auto-generated constructor stub

}

GaussianInputFileCreator::~GaussianInputFileCreator()
{
	// TODO Auto-generated destructor stub
}

bool GaussianInputFileCreator::createFile(Molecule mol, string charge, string multiplicity, string base, string method, string comments, string processors, string memory, string worktype)
{
	if(processors.length() > 0)
		file << "%nprocshared=" << processors << endl;

	if(memory.length() > 0)
		file << "%mem=" << memory << endl;

	file << "#p " << method << " " << base << " " << worktype << endl << endl;

	file << comments << endl << endl;

	file << charge << " " << multiplicity << endl;

	file << mol << endl;

	return true;
}
