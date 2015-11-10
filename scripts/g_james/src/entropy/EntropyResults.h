/*
 * EntropyResults.h
 *
 *  Created on: Jan 10, 2013
 *      Author: victor
 */

#ifndef ENTROPYRESULTS_H_
#define ENTROPYRESULTS_H_

class EntropyResults
{

private:

//	int numberOfDSPoints, numberOfWindows;
//	double **matrix;

public:

	enum Property { ENTROPY, ERF1, ERF2, EZERO, DOF1, DOF2 };

	EntropyResults(const int &numberOfDSPoints, const int &numberOfWindows);

	virtual ~EntropyResults();



};

#endif /* ENTROPYRESULTS_H_ */
