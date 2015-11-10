	/*
 * SummaryFile.h
 *
 *  Created on: Dec 6, 2012
 *      Author: victor
 */

#ifndef SUMMARYFILE_H_
#define SUMMARYFILE_H_

#include "InputFile.h"

#include <stdlib.h>
#include <vector>
#include <string>


class SummaryFile : public InputFile
{
private:

	vector<double> energyAverages, potentialEnergyAverages;
	vector<double> potentialEnergyVariances;
	vector<int>    degreesOfFreedom;
	vector<string> potentialEnergyFileNames, totalEnergyFileNames;

public:

	SummaryFile();

	virtual ~SummaryFile();

	bool readFile();

	const vector<int>* getDegreesOfFreedom() const {
		return &degreesOfFreedom;
	}

	const vector<double>* getEnergyAverages() const {
		return &energyAverages;
	}

	const vector<double>* getPotentialEnergyAverages() const {
		return &potentialEnergyAverages;
	}

	const vector<string>* getPotentialEnergyFileNames() const {
		return &potentialEnergyFileNames;
	}

	const vector<string>* getTotalEnergyFileNames() const {
		return &totalEnergyFileNames;
	}

	const vector<double>* getPotentialEnergyVariances() const {
		return &potentialEnergyVariances;
	}
};

#endif /* SUMMARYFILE_H_ */
