/*
 * Entropy.h
 *
 *  Created on: Dec 3, 2012
 *      Author: victor
 */

#ifndef ENTROPY_H_
#define ENTROPY_H_

#include "Data.h"

#include "../files/OutputFile.h"
#include "../files/SummaryFile.h"
#include "../files/DatFile.h"

#include "../ttmath/ttmath.h"

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>

// Big<exponent, mantissa>
typedef ttmath::Big<TTMATH_BITS(32), TTMATH_BITS(64)> Number;

class Entropy : public OutputFile
{
private:

	// Read from the summary file
	const vector<int>     *degreesOfFreedom;
	const vector<string>  *potentialEnergyFileNames, *totalEnergyFileNames;

	// Read from the summary file
	vector<Data> 	potentialEnergies, totalEnergies;

	// Calculated based on the number of windows
	double totalEnergyAverages_i, totalEnergyAverages_j;
	double potentialEnergyAverages_i,  potentialEnergyAverages_j;
	double potentialEnergyVariances_i,  potentialEnergyVariances_j;
	double ezero;
	double avePotential_i_lower_than_avePotential_j;

	double *activeTotalEnergyAverage;

	long int begin;
	long int end;

	int windowSize;

	int numberOfWindows;

	bool computeEZero(size_t i, size_t j);

	bool computeSigmaTimesNe(size_t i, const long int begin, const long int end, Number& sigmaTimesNe);

	bool computePairEntropy(const size_t i, const size_t j, const int window, Number &dS);

	bool computeNumberOfWindows(long int totalNumberOfPoints);

	bool computeBeginAndEndTime(int window, long int & begin, long int & end);

	bool updateAveragesAndVariances(const size_t i, const size_t j, const int begin, const int end);

public:

	enum Units {CAL_PER_MOL_PER_KELVIN, J_PER_MOL_PER_KELVIN};

	Entropy(SummaryFile &summaryFile, bool append, long int begin, long int end, int windowSize);

	virtual ~Entropy();

	bool computeDS(size_t skipPoints, Units units);

	void setBegin(const long int &begin)
	{
		this->begin = begin;
	}

	void setEnd(const long int &end)
	{
		this->end = end;
	}

	void setWindowSize(const int &windowSize)
	{
		this->windowSize = windowSize;
	}

	void checkloop();

};

#endif /* ENTROPY_H_ */
