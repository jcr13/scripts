/*
 * InputFile.h
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#ifndef INPUTFILE_H_
#define INPUTFILE_H_

#include "FileHandler.h"

#include <iostream>

using namespace std;

class InputFile : public FileHandler
{

public:

	InputFile();

	virtual ~InputFile();

	string readLine()
	{
		string str;

		getline(file, str);

		return str;
	}

	bool eof()
	{
		return file.eof();
	}

	bool isStringInFile(string str);

	bool rewind()
	{
		close();
		return open();
	}

};

#endif /* INPUTFILE_H_ */
