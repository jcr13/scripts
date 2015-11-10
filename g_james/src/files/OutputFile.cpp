/*
 * OutputFile.cpp
 *
 *  Created on: Oct 6, 2010
 *      Author: victor
 */

#include "OutputFile.h"

OutputFile::OutputFile() :
	FileHandler(fstream::out)
{
	// TODO Auto-generated constructor stub

}

OutputFile::OutputFile(fstream::openmode openMode) :
	FileHandler(openMode)
{
	// TODO Auto-generated constructor stub

}

OutputFile::~OutputFile()
{
	// TODO Auto-generated destructor stub
}
