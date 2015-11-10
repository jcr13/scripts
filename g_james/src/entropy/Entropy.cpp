/*
 * Entropy.cpp
 *
 *  Created on: Dec 3, 2012
 *      Author: victor
 */

#include "Entropy.h"

Entropy::Entropy(SummaryFile &summaryFile, bool append = false, long int begin = -1, long int end = -1, int windowSize = -1) :
	OutputFile(append ? fstream::app : fstream::out)
{
	// Reading the information from the summary file
	this->potentialEnergyFileNames = summaryFile.getPotentialEnergyFileNames();
	this->totalEnergyFileNames = summaryFile.getTotalEnergyFileNames();
	this->degreesOfFreedom = summaryFile.getDegreesOfFreedom();

	this->begin = begin;
	this->end = end;
	this->windowSize = windowSize;

	activeTotalEnergyAverage = NULL;

//	cerr << "potentialEnergyFileNames" << endl;
//	for(int i = 0; i < this->potentialEnergyFileNames->size(); i++)
//		cerr << this->potentialEnergyFileNames->at(i) << endl;
//
//	cerr << "totalEnergyFileNames" << endl;
//	for(int i = 0; i < this->totalEnergyFileNames->size(); i++)
//		cerr << this->totalEnergyFileNames->at(i) << endl;
//
//	cerr << "degreesOfFreedom" << endl;
//	for(int i = 0; i < this->degreesOfFreedom->size(); i++)
//		cerr << this->degreesOfFreedom->at(i) << endl;

	/*
	this->energyAverages = summaryFile.getEnergyAverages();
	this->potentialEnergyAverages = summaryFile.getPotentialEnergyAverages();

	this->potentialEnergyVariances = summaryFile.getPotentialEnergyVariances();


	 */

	//
	// Reading the potential energies from the energy files
	//
	this->potentialEnergies.reserve(this->potentialEnergyFileNames->size());

	for(size_t i = 0; i < this->potentialEnergyFileNames->size(); i++)
	{
		DatFile file;
		file.setFileName(this->potentialEnergyFileNames->at(i));
		if(!file.open())
		{
			cerr << "Unable to open file " << file.getFileName() << endl;
			exit(-1);
		}

		if(!file.readNLines())
		{
			cerr << "Unable to read the number of lines from file " << file.getFileName() << endl;
			exit(-1);
		}

		if(!file.readFile())
		{
			cerr << "Unable to read file " << file.getFileName() << endl;
			exit(-1);
		}

		Data data = Data(file.getNumberOfLines());

		data.setX(file.getX());
		data.setY(file.getY());

		this->potentialEnergies.push_back(data);
	}

//	cerr << "this->potentialEnergies.at(0).nextValue() = " << setprecision(10) << this->potentialEnergies.at(0).nextValue() << endl;
//	cerr << "this->potentialEnergies.at(0).nextValue() = " << setprecision(10) << this->potentialEnergies.at(0).nextValue() << endl;
//	cerr << "this->potentialEnergies.at(0).nextValue() = " << setprecision(10) << this->potentialEnergies.at(0).nextValue() << endl;
//
//	cerr << "this->potentialEnergies.at(1).nextValue() = " << setprecision(10) << this->potentialEnergies.at(1).nextValue() << endl;
//	cerr << "this->potentialEnergies.at(1).nextValue() = " << setprecision(10) << this->potentialEnergies.at(1).nextValue() << endl;
//	cerr << "this->potentialEnergies.at(1).nextValue() = " << setprecision(10) << this->potentialEnergies.at(1).nextValue() << endl;

	// Checking the number of lines in each potential energy file
	for(size_t i = 1; i < this->potentialEnergyFileNames->size(); i++)
	{
		if(this->potentialEnergies.at(i-1).npoints(-1,-1) != this->potentialEnergies.at(i).npoints(-1,-1))
		{
			cerr << "-----------------" << endl;
			cerr << "---- Warning ----" << endl;
			cerr << "-----------------" << endl;
			cerr << "Files " << this->potentialEnergyFileNames->at(i-1) << "(" << this->potentialEnergies.at(i-1).npoints(-1,-1) << ")"  << " and " << this->potentialEnergyFileNames->at(i)  << "(" << this->potentialEnergies.at(i).npoints(-1,-1) << ")" << " have different number of lines" << endl;
			cerr << "This many result in an unbalanced entropy calculation" << endl << endl;
			cerr << "The program does not supports the calculation of unbalanced entropies" << endl;
			exit(-1);
		}
	}


	//
	// Reading the total energies from the energy files
	//
	this->totalEnergies.reserve(this->totalEnergyFileNames->size());

	for(size_t i = 0; i < this->totalEnergyFileNames->size(); i++)
	{
		DatFile file;
		file.setFileName(this->totalEnergyFileNames->at(i));
		if(!file.open())
		{
			cerr << "Unable to open file " << file.getFileName() << endl;
			exit(-1);
		}

		if(!file.readNLines())
		{
			cerr << "Unable to read the number of lines from file " << file.getFileName() << endl;
			exit(-1);
		}

		if(!file.readFile())
		{
			cerr << "Unable to read file " << file.getFileName() << endl;
			exit(-1);
		}

		Data data = Data(file.getNumberOfLines());

		data.setX(file.getX());
		data.setY(file.getY());

		this->totalEnergies.push_back(data);
	}

//	cerr << "this->totalEnergies.at(0).nextValue() = " << setprecision(10) << this->totalEnergies.at(0).nextValue() << endl;
//	cerr << "this->totalEnergies.at(0).nextValue() = " << setprecision(10) << this->totalEnergies.at(0).nextValue() << endl;
//	cerr << "this->totalEnergies.at(0).nextValue() = " << setprecision(10) << this->totalEnergies.at(0).nextValue() << endl;
//
//	cerr << "this->totalEnergies.at(1).nextValue() = " << setprecision(10) << this->totalEnergies.at(1).nextValue() << endl;
//	cerr << "this->totalEnergies.at(1).nextValue() = " << setprecision(10) << this->totalEnergies.at(1).nextValue() << endl;
//	cerr << "this->totalEnergies.at(1).nextValue() = " << setprecision(10) << this->totalEnergies.at(1).nextValue() << endl;

	// Checking the number of lines in each potential energy file
	for(size_t i = 1; i < this->totalEnergyFileNames->size(); i++)
	{
		if(this->totalEnergies.at(i-1).npoints(-1,-1) != this->totalEnergies.at(i).npoints(-1,-1))
		{
			cerr << "-----------------" << endl;
			cerr << "---- Warning ----" << endl;
			cerr << "-----------------" << endl;
			cerr << "Files " << this->totalEnergyFileNames->at(i-1) << "(" << this->totalEnergies.at(i-1).npoints(-1,-1) << ")" << " and " << this->totalEnergyFileNames->at(i) << "(" << this->totalEnergies.at(i).npoints(-1,-1) << ")"  << " have different number of lines" << endl;
			cerr << "This many result in an unbalanced entropy calculation" << endl;
			cerr << "This program does not supports the calculation of unbalanced entropies" << endl;
			exit(-1);
		}
	}

	// Checking whether the number of lines in each potential energy file is the same in each energy file
	for(size_t i = 0; i < this->totalEnergyFileNames->size(); i++)
	{
		if(this->totalEnergies.at(i).npoints(-1,-1) != this->potentialEnergies.at(i).npoints(-1,-1))
		{
			cerr << "-----------------" << endl;
			cerr << "---- Warning ----" << endl;
			cerr << "-----------------" << endl;
			cerr << "Files " << this->potentialEnergyFileNames->at(i) << " and " << this->totalEnergyFileNames->at(i) << " have different number of lines" << endl;
			exit(-1);
		}
	}


//	cerr << "this->potentialEnergies.at(0).npoints(-1,-1) = " << this->potentialEnergies.at(0).npoints(-1,-1) << endl;

	// Obtaining the total number of windows to compute
	// the number of windows will be computed from the total number of points
	// and the window size defined by the user

	if(begin < 0)
		this->begin = 0;

	if(end < 0)
		this->end = this->potentialEnergies.at(0).npoints(this->begin, this->end)-1;

//	cerr << "begin " << this->begin << endl;
//	cerr << "end " << this->end << endl;
//	cerr << "windowSize " << this->windowSize << endl;

//	cerr << "this->potentialEnergies.at(0).npoints(begin, end) = " << this->potentialEnergies.at(0).npoints(this->begin, this->end) << endl;

	this->numberOfWindows = 0;
	if(!this->computeNumberOfWindows(this->potentialEnergies.at(0).npoints(this->begin, this->end)))
	{
//		cerr << "Unable to compute the number of windows" << endl;
		exit(-1);
	}

	// if the number of windows is one the windowSize is the complete
	// number of points
//	this->windowSize = this->potentialEnergies.at(0).npoints(-1,-1);


	// Now we can allocate the required memory for each step of the calculation
	this->ezero = 0;
	this->avePotential_i_lower_than_avePotential_j = false;
	totalEnergyAverages_i = 0.0;
	totalEnergyAverages_j = 0.0;
	potentialEnergyAverages_i = 0.0;
	potentialEnergyAverages_j = 0.0;
	potentialEnergyVariances_i = 0.0;
	potentialEnergyVariances_j = 0.0;
}

Entropy::~Entropy()
{
	// TODO Auto-generated destructor stub
}

bool Entropy::computeNumberOfWindows(long int totalNumberOfPoints)
{
	if(this->windowSize < 1)
	{
		this->numberOfWindows = 1;
		this->windowSize = totalNumberOfPoints;
	}
	else
	{
		this->numberOfWindows = totalNumberOfPoints / this->windowSize;

		long int remainer  = totalNumberOfPoints % this->windowSize;

		if(totalNumberOfPoints < this->windowSize)
			cerr << "The windows size (" << this->windowSize << ") is greater than the total number of points (" << totalNumberOfPoints << ")" << endl;

		if(numberOfWindows < 1)
			return false;

		if(remainer != 0)
			numberOfWindows++;
	}

	cerr << "totalNumberOfPoints " << totalNumberOfPoints << endl;
	cerr << "windowSize " << this->windowSize << endl;
	cerr << "numberOfWindows " << numberOfWindows << endl;

	return true;
}

bool Entropy::computeBeginAndEndTime(int window, long int & begin, long int & end)
{
	if(window >= numberOfWindows)
		return false;

	begin = this->begin;
	end = (this->begin + ((window + 1) * this->windowSize))-1;

	return true;
}

bool Entropy::updateAveragesAndVariances(const size_t i, const size_t j, const int begin, const int end)
{
	if(i >= this->totalEnergies.size())
		return false;

	if(j >= this->totalEnergies.size())
		return false;

	if(begin < this->begin)
		return false;

	if(end > this->end)
		return false;

	totalEnergyAverages_i = this->totalEnergies.at(i).computeAverage(begin, end);
	totalEnergyAverages_j = this->totalEnergies.at(j).computeAverage(begin, end);

	potentialEnergyAverages_i = this->potentialEnergies.at(i).computeAverage(begin, end);
	potentialEnergyAverages_j = this->potentialEnergies.at(j).computeAverage(begin, end);

	potentialEnergyVariances_i = this->potentialEnergies.at(i).computeVariance(begin, end);
	potentialEnergyVariances_j = this->potentialEnergies.at(j).computeVariance(begin, end);

	return true;
}

bool Entropy::computeEZero(size_t i, size_t j)
{
	double alpha, one = 1.000000000000000000000;

	//if(this->potentialEnergyAverages.at(i) < this->potentialEnergyAverages.at(j))
	if(this->potentialEnergyAverages_i < this->potentialEnergyAverages_j)
	{
		avePotential_i_lower_than_avePotential_j = true;
		alpha = potentialEnergyVariances_i / (potentialEnergyVariances_i + potentialEnergyVariances_j);
		ezero = (alpha * potentialEnergyAverages_j) + ((one - alpha) * potentialEnergyAverages_i);
		return true;
	}
	else
	{
		avePotential_i_lower_than_avePotential_j = false;
		alpha = potentialEnergyVariances_j / (potentialEnergyVariances_i + potentialEnergyVariances_j);
		ezero = (alpha * potentialEnergyAverages_i) + ((one - alpha) * potentialEnergyAverages_j);
		return true;
	}

	return false;
}

bool Entropy::computeSigmaTimesNe(const size_t i, const long int begin, const long int end, Number& sigmaTimesNe)
{
	long int nlines;

	long int pos, endtime;

	vector<double> x, y;

	DatFile potentialEnergyFile;

	string str;

	double potentialEnergy;

	Number exponent, one = 1.0;

	bool computedSigma = false;

//	potentialEnergyFile.setFileName(this->potentialEnergyFileNames->at(i));

//	if(!potentialEnergyFile.open())
//		return false;

	sigmaTimesNe = 0.0;

	exponent = Number(this->degreesOfFreedom->at(i) * 0.5000000000);

	nlines = 0;

//	while(potentialEnergyFile.readNextValue(potentialEnergy))
//	{
//		if(potentialEnergy < this->ezero.at(ezero_pos))
//		{
//			computedSigma = true;
//			sigmaTimesNe += ttmath::Exp(exponent * ttmath::Ln(Number(this->energyAverages.at(i)) - potentialEnergy));
//			/*
//			cout << "sigmaTimesNe " << sigmaTimesNe << " "
//				 << "potentialEnergy " << potentialEnergy << " "
//				 << "exponent " << exponent << " "
//			     << "this->energyAverages->at(i)-potentialEnergy " << this->energyAverages->at(i) - potentialEnergy << "\n";
//			 */
//			nlines++;
//		}
//	}

	// this is just used to avoid the comparison and to increment the end variable for each step of the loop
	endtime = end+1;
	for(pos = begin; pos < endtime; pos++)
	{
		potentialEnergy = this->potentialEnergies.at(i).at(pos);
		if(potentialEnergy < ezero)
		{
			computedSigma = true;
			sigmaTimesNe += one / ttmath::Exp(exponent * ttmath::Ln(Number(*activeTotalEnergyAverage) - potentialEnergy));
			nlines++;
		}
	}
//	cout << "finished computing " << this->potentialEnergyFileNames->at(i) << endl;

//	cerr << "sigmaTimesNe = " << sigmaTimesNe << "\n";
//	cerr << "activeTotalEnergyAverage = " << *activeTotalEnergyAverage << "\n";

	sigmaTimesNe /= nlines;

//	cerr << "sigmaTimesNe = " << sigmaTimesNe << "\n";

	if(!computedSigma)
	{
		cerr << "No sigma computed for file " << this->potentialEnergyFileNames->at(i) << endl;
		return false;
	}

	potentialEnergyFile.close();

	return true;
}

bool Entropy::computePairEntropy(const size_t i, const size_t j, const int window, Number &dS)
{
	Number sigma_i, sigma_j;

	long int begin, end;

	if(!this->computeBeginAndEndTime(window, begin, end))
	{
		cerr << "Unable to update the time table. Which is really strange" << endl;
		cerr << "Please review your input files" << endl;
		return false;
	}

//	cerr << "b = " << begin << " e = " << end << endl;

	if(!updateAveragesAndVariances(i, j, begin, end))
	{
		cerr << "Unable to update the averages. Which is really strange" << endl;
		cerr << "Please review your input files" << endl;
		return false;
	}

//	cerr << "i = " << i << endl;
//	cerr << "j = " << j << endl;

//	cerr << "totalEnergyAverages_i = " << totalEnergyAverages_i << endl;
//	cerr << "totalEnergyAverages_j = " << totalEnergyAverages_j << endl;

//	cerr << "potentialEnergyAverages_i = " << potentialEnergyAverages_i << endl;
//	cerr << "potentialEnergyAverages_j = " << potentialEnergyAverages_j << endl;

//	cerr << "potentialEnergyVariances_i = " << potentialEnergyVariances_i << endl;
//	cerr << "potentialEnergyVariances_j = " << potentialEnergyVariances_j << endl;


	if(!computeEZero(i, j))
	{
		cerr << "Unable to compute eZero. Which is really strange" << endl;
		cerr << "Please review your input files" << endl;
		return false;
	}
//	else
//	{
//		cerr << "Points " << (i+1) << " and " << (j+1) << " have eZero of " << this->ezero
//		     << " and average potential energies of " << this->potentialEnergyAverages_i
//		     << " and " << this->potentialEnergyAverages_j << endl;
//	}

	activeTotalEnergyAverage = &totalEnergyAverages_i;
	if(!computeSigmaTimesNe(i, begin, end, sigma_i))
	{
		cerr << "Unable to compute sigma for step " << (i+1) << endl;
		cerr << "Potential energy file " << this->potentialEnergyFileNames->at(i) << endl;
		cerr << "Probably there is no overlap between the potential energies" << endl;
		return false;
	}

	activeTotalEnergyAverage = &totalEnergyAverages_j;
	if(!computeSigmaTimesNe(j, begin, end, sigma_j))
	{
		cerr << "Unable to compute sigma for step " << (j+1) << endl;
		cerr << "Potential energy file " << this->potentialEnergyFileNames->at(j) << endl;
		cerr << "Probably there is no overlap between the potential energies" << endl;
		return false;
	}

	// Computing the division sigma_E / sigma_E'
	//
	// For we do not compute the sigma_E as the article
	// but one/sigma_E the division is defined as:
	//
	// sigma_E' / sigma_E
	//
	if(avePotential_i_lower_than_avePotential_j)
//		dS = sigma_j / sigma_i;
		dS = sigma_i / sigma_j;
	else
//		dS = sigma_i / sigma_j;
		dS = sigma_j / sigma_i;

	return true;
}

/**
 * author Victor
 *
 *
 */
bool Entropy::computeDS(size_t skipPoints, Units units)
{
	Number kb;

	Number dS, totaldS = 0.0;

	double erf1, erf2;

	size_t numberOfDSPoints = this->degreesOfFreedom->size()-1;
	size_t i, j;

	string unitString;

	if(units == Entropy::CAL_PER_MOL_PER_KELVIN)
	{
		kb = 1.9872041;
		unitString = "cal mol\\S-1\\N K\\S-1\\N";
	}
	else if (units == Entropy::J_PER_MOL_PER_KELVIN)
	{
		kb = 8.3144621;
		unitString = "J mol\\S-1\\N K\\S-1\\N";
	}

	this->file << "#\n# Energies are in " << unitString << "\n#\n";
//	this->file << "@ title Energies in \"" << unitString << "\"\n";
	this->file << "@ yaxis label \"\\Delta Entropy / " << unitString << "\" \n";
	this->file << "@ xaxis label \"Frame\"\n";
	this->file << "@ type xydydy\n";
	for(i = 0; i < numberOfDSPoints; i++)
	{
		j = i + 1;
		for(int window = 0; window < numberOfWindows; window++)
		{
			cerr << "Computing window " << (window+1) << " of points " << (i+1) << " and " << (j+1) << endl;
			if(computePairEntropy(i, j, window, dS))
			{
				/*
				cout << "dS = " << dS << "\n";
				cout << "ttmath::Ln(dS) = " << ttmath::Ln(dS) << "\n";
				cout << "   std::ln(dS) = " << setprecision(18) << std::log(dS.ToDouble()) << "\n";
				 */
				dS = kb * ttmath::Ln(dS);

				if(!this->avePotential_i_lower_than_avePotential_j)
					dS = -dS;

//				erf1 = erf((-sqrt(this->potentialEnergyVariances.at(i))*(this->potentialEnergyAverages.at(j)-this->potentialEnergyAverages.at(i)))/(sqrt(2.0)*(this->potentialEnergyVariances.at(i)+this->potentialEnergyVariances.at(j))));
//				erf2 = erf((-sqrt(this->potentialEnergyVariances.at(j))*(this->potentialEnergyAverages.at(j)-this->potentialEnergyAverages.at(i)))/(sqrt(2.0)*(this->potentialEnergyVariances.at(i)+this->potentialEnergyVariances.at(j))));
				erf1 = erf((-sqrt(this->potentialEnergyVariances_i)*(this->potentialEnergyAverages_j-this->potentialEnergyAverages_i))/(sqrt(2.0)*(this->potentialEnergyVariances_i+this->potentialEnergyVariances_j)));
				erf2 = erf((-sqrt(this->potentialEnergyVariances_j)*(this->potentialEnergyAverages_j-this->potentialEnergyAverages_i))/(sqrt(2.0)*(this->potentialEnergyVariances_i+this->potentialEnergyVariances_j)));

//				totaldS += dS;
//				this->file << (i+1) << "   " << setw(10) << dS << " " << setprecision(6) << erf1 << " " << setprecision(6) << erf2  << "\n";
				if(dS < 0)
					this->file << ((window+1)*this->windowSize) << "  " << dS << " " << setw(13) << setprecision(6) << erf1 << " " << setprecision(6) << erf2  << "\n";
				else
					this->file << ((window+1)*this->windowSize) << "   " << dS << " " << setw(13) << setprecision(6) << erf1 << " " << setprecision(6) << erf2  << "\n";

//				this->file << (i+1) << "   " << dS << " " << erf1 << " " << erf2 << " "
//						<< this->ezero << " "
//						<< this->degreesOfFreedom->at(i) << " "
//						<< this->degreesOfFreedom->at(j) << "\n";
			}
			else
			{
				cerr << "Error while computing the pair entropy " << i << " and " << j << endl;
				return false;
			}
		}
	}

//	this->file << "#\n# Total Entropy " << setprecision(4) << totaldS << " " << unitString << "\n";

	return true;
}

void Entropy::checkloop()
{
	size_t numberOfDSPoints = this->degreesOfFreedom->size()-1;
	size_t i, j;
	int window;

	long int begin, end;

	for(i = 0; i < numberOfDSPoints; i++)
	{
		j = i + 1;
		for(window = 0; window < numberOfWindows; window++)
		{
			this->computeBeginAndEndTime(window, begin, end);
			cerr << "w: " << window << " b: " << begin << " e: " << end << endl;
		}
	}
}

