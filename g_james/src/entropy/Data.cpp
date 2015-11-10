/*
 * Data.cpp
 *
 *  Created on: Jan 4, 2013
 *      Author: victor
 */

#include "Data.h"

Data::Data(const long int &size)
{
	// TODO Auto-generated constructor stub
	currentPos = -1;
	numberOfLines = 0;
	this->x.reserve(size);
	this->y.reserve(size);
}

Data::~Data()
{
	// TODO Auto-generated destructor stub
}

double Data::computeAverage(const long int &begin, const long int &end)
{
	double average;
	long int b = begin, e = end;
	long int endtime;

	if(begin < 0)
		b = 0;

	if(end < 0)
		e = this->y.size()-1;

	if(b > e)
	{
		cerr << "Initial time cannot be bigger than end time" << endl;
		exit(-1);
	}

	average = 0;
	endtime = e+1;
	for(long int i = b;  i < endtime; i++)
		average += this->y.at(i);

	average /= this->npoints(b, e);

	return average;
}

double Data::computeVariance(const long int &begin, const long int &end)
{
	double average, variance;

	long int b = begin, e = end;
	long int endtime;

	if(begin < 0)
		b = 0;

	if(end < 0)
		e = this->y.size()-1;

	if(b > e)
	{
		cerr << "Initial time cannot be bigger than end time" << endl;
		exit(-1);
	}

	average = computeAverage(b, e);

	variance = 0;
	endtime = e+1;
	for(int i = b;  i < endtime; i++)
		variance += (this->y.at(i) - average) * (this->y.at(i) - average);

	variance /= this->npoints(b, e) -1;

	return variance;
}
