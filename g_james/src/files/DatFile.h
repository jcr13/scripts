/*
 * DatFile.h
 *
 *  Created on: Dec 5, 2012
 *      Author: victor
 */

#ifndef DATFILE_H_
#define DATFILE_H_

#include "InputFile.h"

#include <stdlib.h>
#include <vector>


class DatFile : public InputFile
{

private:

	vector<double> x, y;
	long int currentPosX, currentPosY;

	long int numberOfLines;

public:

	DatFile();

	virtual ~DatFile();

	bool readNLines();

	bool readFile();

	bool readNextValue(double& val);

	const vector<double>& getX() const
	{
		return x;
	}

	const vector<double>& getY() const
	{
		return y;
	}

	const double nextX()
	{
		currentPosX++;
		return this->x.at(currentPosX);
	}

	const double nextY()
	{
		currentPosY++;
		return this->y.at(currentPosY);
	}

	const long int getNumberOfLines()
	{
		return this->numberOfLines;
	}

};

#endif /* DATFILE_H_ */
