/*
 * OutputFile.h
 *
 *  Created on: Oct 6, 2010
 *      Author: victor
 */

#ifndef OUTPUTFILE_H_
#define OUTPUTFILE_H_

#include "FileHandler.h"

using namespace std;


class OutputFile : public FileHandler
{

public:

	OutputFile();

	OutputFile(fstream::openmode openMode);

	virtual ~OutputFile();

	template <class T>
	fstream& operator<<(T input)
	{
		file << input;
		return file;
	}
};

#endif /* OUTPUTFILE_H_ */
