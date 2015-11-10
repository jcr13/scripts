/*
 * FileHandler.cpp
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#include "FileHandler.h"

FileHandler::FileHandler(fstream::openmode openMode)
{
	this->openMode = openMode;
}

FileHandler::~FileHandler()
{
	file.close();
}

bool FileHandler::open()
{
	if(fileName.length() < 1)
		return false;

	file.open(fileName.c_str(), openMode);
	if(file.is_open())
		return true;
	else
		return false;
}

bool FileHandler::close()
{
	file.close();

	if(file.is_open())
		return false;
	else
		return true;
}
