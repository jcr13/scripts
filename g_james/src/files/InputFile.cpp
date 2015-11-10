/*
 * InputFile.cpp
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#include "InputFile.h"

InputFile::InputFile() :
	FileHandler(fstream::in)
{
	// TODO Auto-generated constructor stub

}

InputFile::~InputFile()
{
	FileHandler::close();
}

bool InputFile::isStringInFile(string str)
{
	string line;

	line = readLine();
	while(line.find(str) == string::npos && !eof())
		line = readLine();

	if(line.find(str) != string::npos)
		return true;
	else
		return false;
}
