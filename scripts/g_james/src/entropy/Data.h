/*
 * Data.h
 *
 *  Created on: Jan 4, 2013
 *      Author: victor
 */

#ifndef DATA_H_
#define DATA_H_

#include <stdlib.h>
#include <vector>
#include <iostream>

using namespace std;


class Data
{

private:

	vector<double> x, y;

	long int numberOfLines;

	long int currentPos;


public:

	Data(const long int &size);

	virtual ~Data();

	void setX(vector<double> x)
	{
		this->x = x;
	}

	void setY(vector<double> y)
	{
		this->y = y;
	}

	double computeAverage(const long int &begin, const long int &end);

	double computeVariance(const long int &begin, const long int &end);

	const double npoints(const long int &begin, const long int &end)
	{
		long int b = begin, e = end;

		if(begin < 0)
			b = 0;

		if(end < 0)
			e = this->y.size()-1;

//		cerr << "b inside data " << b << endl;
//		cerr << "e inside data " << e << endl;
//		cerr << "this->y.size() inside data " << this->y.size() << endl;
//		cerr << "==" <<endl;

		if(b > e)
		{
			cerr << "Initial time cannot be bigger than end time" << endl;
			exit(-1);
		}


		return (e - b) + 1;
	}

	const double nextValue()
	{
		currentPos++;
		return this->y.at(currentPos);
	}

	void setCurrentPos(const long int &pos)
	{
		this->currentPos = pos;
	}

	double at(long int pos) const
	{
		return this->y.at(pos);
	}
};

#endif /* DATA_H_ */
