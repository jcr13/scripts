/*
 * DatFile.cpp
 *
 *  Created on: Dec 5, 2012
 *      Author: victor
 */

#include "DatFile.h"

DatFile::DatFile()
{
	// TODO Auto-generated constructor stub
	currentPosX = -1;
	currentPosY = -1;
	numberOfLines = 0;
}

DatFile::~DatFile()
{
	// TODO Auto-generated destructor stub
}

bool DatFile::readNLines()
{
	string line;
	int p1;

	if(!rewind())
		return false;

	numberOfLines = 0;

	while(!eof())
	{
		line = readLine();
		if(line.length() > 0)
		{
			p1 = line.find_first_not_of(' ');

			if(p1 > -1)
			{
				if(line[p1] != '#' && line[p1] != '@')
					numberOfLines++;
			}
		}
	}

	return true;
}


bool DatFile::readFile()
{
	string line;
	int p1, p2, p3, p4;

	if(!rewind())
		return false;

	this->currentPosX = 0;
	this->currentPosY = 0;

	/*
	 * Reading the lines
	 *
	 */

	while(!eof())
	{
		line = readLine();
		if(line.length() > 0)
		{
			p1 = line.find_first_not_of(' ');

			if(p1 > -1)
			{
				if(line[p1] != '#' && line[p1] != '@')
				{
					p2 = line.find_first_of(' ', p1+1);
					p3 = line.find_first_not_of(' ', p2+1);
					p4 = line.find_first_of(' ', p3+1);

					x.push_back(atof(line.substr(p1,p2-p1).c_str()));
					y.push_back(atof(line.substr(p3,p4-p3).c_str()));
				}
			}
		}
	}

	return true;
}

bool DatFile::readNextValue(double& val)
{
	string line;
	int p1, p2;
	bool notFound = true;

	/*
	 * Reading line
	 *
	 */
	while(notFound && !eof())
	{
		line = readLine();
		if(line.length() > 0)
		{
			p1 = line.find_first_not_of(' ');

			if(p1 > -1)
			{
				if(line[p1] != '#' && line[p1] != '@')
				{
					p2 = line.find_first_of(' ', p1+1);

					val = atof(line.substr(p1,p2-p1).c_str());
					notFound = false;
				}
			}
		}
	}

	if(eof())
		return false;

	return true;
}
