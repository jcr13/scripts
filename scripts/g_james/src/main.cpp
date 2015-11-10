/*
 * main.cpp
 *
 *  Created on: Aug 28, 2012
 *      Author: vrusu
 */
#include <iostream>
#include <iomanip>
#include <fstream>

#include <string>
#include <vector>

#include <cstdlib>
#include <cmath>

#include "arguments/ProgramArguments.h"

#include "entropy/Entropy.h"

#include "files/DatFile.h"


using namespace std;


int main(int argc, char * argv[])
{
	SummaryFile summaryFile;

	ProgramArguments args(argc, argv);

	Entropy::Units units;

	bool restart;

	long int begin, end;
	int windowSize;

	args.addArguments("-s", "Summary file.", true);
	args.addArguments("-o", "Output file.", true);
	args.addArguments("-u", "Entropy units. Values are j ou cal. Default values are in calories", true);
	args.addArguments("-b", "Skip the first n points.", true);
	args.addArguments("-e", "Skip the last n points.", true);
	args.addArguments("-w", "Size of the windows (number of points - not time)", true);
	args.addArguments("-r", "Restarts the calculation.", false);
	args.addArguments("-h", "Print this help.", false);


	if(args.getNumberOfProgramArguments() == 0)
	{
		cerr << args.getErrorMessage() << endl;
		return 1;
	}
	else if(!args.checkUserDefinedArguments())
	{
		cerr << args.getErrorMessage() << endl;
		return 1;
	}

	/*
	 * Checking the help
	 *
	 */
	if(args.isThereArgument("-h"))
	{
		cout << "Usage: " + args.getShortProgramName() + " [OPTION]" << endl;
		cout << "  where [OPTION] can be:" << endl << endl;
		cout << args.printProgramArguments() << endl;
		return 0;
	}

	/*
	 * Checking the units
	 *
	 */
	if(args.isThereArgument("-u"))
	{
		if(args.getProgramArgument("-u") == "j")
		{
			units = Entropy::J_PER_MOL_PER_KELVIN;
		}
		else if(args.getProgramArgument("-u") == "cal")
		{
			units = Entropy::CAL_PER_MOL_PER_KELVIN;
		}
		else
		{
			cerr << "Unknown unit system '" << args.getProgramArgument("-u") << "'" << endl;
			cerr << args.getErrorMessage() << endl;
			return 1;
		}
	}
	else
		units = Entropy::CAL_PER_MOL_PER_KELVIN;

	/*
	 * Checking the input file
	 *
	 */
	if(args.isThereArgument("-s"))
	{
		summaryFile.setFileName(args.getProgramArgument("-s"));
		if(!summaryFile.open())
		{
			cerr << "Unable to open input file " << summaryFile.getFileName() << endl;
			cerr << args.getErrorMessage() << endl;
			return 1;
		}

		if(!summaryFile.readFile())
		{
			cerr << "Unable to read input file " << summaryFile.getFileName() << endl;
			cerr << args.getErrorMessage() << endl;
			return 1;
		}
	}
	else
	{
		cerr << "No input file defined" << endl;
		cerr << args.getErrorMessage() << endl;
		return 1;
	}

	/*
	 * Checking the restart option
	 *
	 */
	if(args.isThereArgument("-r"))
		restart = true;
	else
		restart = false;


	begin = -1;
	if(args.isThereArgument("-b"))
	{
//		cerr << "args.getProgramArgument(\"-b\").c_str() = " << args.getProgramArgument("-b").c_str() << endl;
//		cerr << "atoi(args.getProgramArgument(\"-b\").c_str()) = " << atoi(args.getProgramArgument("-b").c_str()) << endl;
		begin = atoi(args.getProgramArgument("-b").c_str());
	}
//	outputFile.setBegin(begin);

	end = -1;
	if(args.isThereArgument("-e"))
	{
//		cerr << "args.getProgramArgument(\"-e\").c_str() = " << args.getProgramArgument("-e").c_str() << endl;
//		cerr << "atoi(args.getProgramArgument(\"-e\").c_str()) = " << atoi(args.getProgramArgument("-e").c_str()) << endl;
		end = atoi(args.getProgramArgument("-e").c_str());
	}
//	outputFile.setEnd(end);

	windowSize=-1;
	if(args.isThereArgument("-w"))
	{
		windowSize = atoi(args.getProgramArgument("-w").c_str());
	}
//	outputFile.setWindowSize(windowSize);


	// Restart is not working yet ...
	//Entropy outputFile(summaryFile, restart);
	Entropy outputFile(summaryFile, false, begin, end, windowSize);

	/*
	 * Checking the output file
	 *
	 */
	if(args.isThereArgument("-o"))
	{
		outputFile.setFileName(args.getProgramArgument("-o"));

		if(outputFile.getFileNameExt() != "xvg")
			outputFile.setFileName(args.getProgramArgument("-o") + ".xvg");

		if(!outputFile.open())
		{
			cerr << "Unable to open output file " << outputFile.getFileName() << endl;
			cerr << args.getErrorMessage() << endl;
			return 1;
		}
	}
	else
	{
		cerr << "No output file defined" << endl;
		cerr << args.getErrorMessage() << endl;
		return 1;
	}

//	outputFile.checkloop();

//	return -1;
	if(!outputFile.computeDS(0, units))
	{
		cerr << "Unable to compute entropies" << endl;
	}




/*
	ifstream potentialFile1, potentialFile2;

	ifstream energyFile1, energyFile2;

	ifstream inputFile;

	int filenamesize = 1000;

	char potentialFileName1[filenamesize], potentialFileName2[filenamesize];

	char energyFileName1[filenamesize], energyFileName2[filenamesize];

	double avePotentialEnergy1, variancePotentialEnergy1, avePotentialEnergy2, variancePotentialEnergy2;

	bool avePotential1_lower_than_avePotential2;

	Number aveTotalEnergy1, aveTotalEnergy2, dS;

	double lambda;

	size_t i;

	int restartline, ierror;

	vector<Number> lDS, lErf1, lErf2;

	long int degreesOfFreedom1, degreesOfFreedom2;

	ofstream outputFile;

	string str;
*/
/*
	//
	// Checking the inputfile existence
	//
	if(argc < 3 || argc > 4)
	{
		cerr << "Error in usage" << endl;
		cerr << "Should be " << argv[0] << " <summaryFile> <outputfile> [restart line]" << endl;
		cerr << endl;
		cerr << "Default restart line is 0 but you can choose any line from the <summaryFile> to restart." << endl;
		return -1;
	}

	restartline = 0;

	if(argc == 4)
		restartline=atoi(argv[3]);

	//
	// Checking the inputfile existence
	//
	summaryFile.open(argv[1]);

	if(!summaryFile.is_open())
	{
		cerr << "Unable to open input file " << argv[1] << endl;
		return -1;
	}

	// Looping over the summaryFile
	i = 0;

	outputFile.open(argv[2]);
	if(!outputFile.is_open())
	{
		cerr << "Unable to open the output file " << endl;
		return -1;
	}

	for(i = 0; i < restartline; i++)
		getline(summaryFile, str);

	getline(summaryFile, str);
	if(str.length() > 0)
	{
		sscanf(str.c_str(),"%lf %lf %s %lf %s %ld", &potmean1, &potdev1, filename1, &e1, e1FileName, &degreesOfFreedom1);

		inputFile1.open(filename1);

		if(!inputFile1.is_open())
		{
			cerr << "Unable to open input file " << filename1 << endl;
			return -1;
		}

		e1File.open(e1FileName);
		if(!e1File.is_open())
		{
			cerr << "Unable to open input file " << e1FileName << endl;
			return -1;
		}


		getline(summaryFile, str);
		while(!summaryFile.eof() && str.length() > 0)
		{
			sscanf(str.c_str(),"%lf %lf %s %lf %s %ld", &potmean2, &potdev2, filename2, &e2, e2FileName, &degreesOfFreedom2);

			inputFile2.open(filename2);

			if(!inputFile2.is_open())
			{
				cerr << "Unable to open input file " << filename2 << endl;
				return -1;
			}

			e2File.open(e2FileName);
			if(!e2File.is_open())
			{
				cerr << "Unable to open input file " << e2FileName << endl;
				return -1;
			}

			etotal1=e1;
			etotal2=e2;

			cout << "computing steps with files " << filename1 << " and " << filename2 << endl;

			ierror = 0;

			dS = computeDS(inputFile1, inputFile2, etotal1, etotal2, e1File, e2File, degreesOfFreedom1, degreesOfFreedom2, potmean1, potmean2, potdev1, potdev2, filename1, filename2, ierror);

			if(potmean1 < potmean2)
			{
				lErf1.push_back(erf((-sqrt(potdev1*(potmean2-potmean1)))/(sqrt(2.0)*(potdev1+potdev2))));
				lErf2.push_back(erf((-sqrt(potdev2*(potmean2-potmean1)))/(sqrt(2.0)*(potdev1+potdev2))));
			}
			else
			{
				lErf1.push_back(erf((-sqrt(potdev2*(potmean1-potmean2)))/(sqrt(2.0)*(potdev1+potdev2))));
				lErf2.push_back(erf((-sqrt(potdev1*(potmean1-potmean2)))/(sqrt(2.0)*(potdev1+potdev2))));
			}

			if(ierror == 1)
				return -1;

			lDS.push_back(dS);

			outputFile << i << "  " << dS << endl;

			outputFile.flush();

			potmean1=potmean2;
			potdev1=potdev2;
			for(int j = 0; j < filenamesize; j++)
				filename1[j]=filename2[j];

			for(int j = 0; j < filenamesize; j++)
				e1FileName[j]=e2FileName[j];

			inputFile2.close();
			inputFile1.close();
			e1File.close();
			e2File.close();

			inputFile1.open(filename1);

			if(!inputFile1.is_open())
			{
				cerr << "Unable to open input file " << filename1 << endl;
				return -1;
			}

			e1File.open(e1FileName);
			if(!e1File.is_open())
			{
				cerr << "Unable to open input file " << e1FileName << endl;
				return -1;
			}

			e1=e2;
			degreesOfFreedom1=degreesOfFreedom2;

			i++;
			getline(summaryFile, str);
		}
	}
	else
	{
		cerr << "No data found in input file " << argv[1] << endl;
		return -1;
	}

	outputFile.close();
	outputFile.open(argv[2]);
	if(!outputFile.is_open())
	{
		cerr << "Unable to open the output file " << endl;
		return -1;
	}

	dS = 0;
	for(i = 0; i < lDS.size(); i++)
	{
		dS += lDS.at(i);
	}

	outputFile << "# " << endl;
	outputFile << "# " << endl;
	outputFile << "# Total Entroy Change is: " << dS << endl;
	outputFile << "# " << endl;
	outputFile << "# " << endl;
	outputFile << "@target G0.S0 " << endl;
	outputFile << "@type xydydy " << endl;

	int  j = lDS.size();
	for(i = 0; i < lDS.size(); i++)
	{
		lambda = float(i)/float(j);

		outputFile << lambda << "  " << lDS.at(i) << "  " << lErf1.at(i) << "  " << lErf2.at(i) << endl;
	}

	outputFile.close();
	*/

	return 0;
}


Number computeDS(ifstream& inputFile1, ifstream& inputFile2, Number etotal1, Number etotal2, ifstream& e1File, ifstream& e2File, long int degreesOfFreedom1, long int degreesOfFreedom2, double potmean1, double potmean2, double potdev1, double potdev2, char * filename1, char * filename2, int &ierror)
{
	//
	// Computing alpha and e0
	//
	double alpha;

	double e0;

	bool firstE0 = false, getin1, getin2;

	long int ne1=0, ne2=0;

	Number b, c;

	string str;

	Number e, ex, sigma1, sigma2, kb = 1.9872041; // 0.0019872041;


	if(potmean1 < potmean2)
	{
		alpha = potdev1 / (potdev2 + potdev1);
		e0 = (alpha * potmean2) + ((1. - alpha) * potmean1);
		firstE0=true;
	}
	else
	{
		alpha = potdev2 / (potdev2 + potdev1);
		e0 = (alpha * potmean1) + ((1. - alpha) * potmean2);
		firstE0=false;
	}

	//
	//
	// Filter the files based on e0
	//
	//
	sigma1=0.0;
	sigma2=0.0;

	//
	// Computing sigma 1
	//
	ex = (degreesOfFreedom1/2.0);

	ne1=0;
	getline(inputFile1, str);
	if(str.length() > 0)
	{
		getin1 = false;
		while(!inputFile1.eof() && str.length() > 0)
		{
			e = str.c_str();
			getline(e1File, str);
			etotal1 = str.c_str();
			if(e < e0)
			{
				getin1 = true;
				c = Exp(ex*Ln(etotal1 -e));

				sigma1 += c;

				ne1++;
			}
			getline(inputFile1, str);
		}
	}
	else
	{
		cerr << "No data found in input file " << filename1 << endl;
		ierror = 1;
		exit(1);
	}


	//
	// Computing sigma 2
	//
	ex = (degreesOfFreedom2/2.0);

	ne2=0;
	getline(inputFile2, str);
	if(str.length() > 0)
	{
		getin2 = false;
		while(!inputFile2.eof() && str.length() > 0)
		{
			e = str.c_str();
			getline(e2File, str);
			etotal2 = str.c_str();
			if(e < e0)
			{
				getin2 = true;
				c = Exp(ex*Ln(etotal2 -e));
				sigma2 += c;

				ne2++;
			}
			getline(inputFile2, str);
		}
	}
	else
	{
		cerr << "No data found in input file2 " << filename2 << endl;
		ierror = 1;
		exit(1);
	}

/*
	if(getin1)
	{
		b = 1.0;
		sigma1 = b / sigma1;
		sigma1 /= ne1;
	}
	else
	{
		cerr << "sigma is zero within file " << filename1 << endl;
		ierror = 1;
		exit(1);
	}

	if(getin2)
	{
		b = 1.0;
		sigma2 = b / sigma2;
		sigma2 /= ne2;
	}
	else
	{
		cerr << "sigma is zero within file " << filename2 << endl;
		ierror = 1;
		exit(1);
	}

	//return kb * Ln(sigma1/sigma2);
*/
	if(firstE0)
	{
		if(!getin1)
		{
			cerr << "sigma is zero within file " << filename1 << endl;
			ierror = 1;
			exit(1);
		}
		// I am not computing sigma as 1/ne * 1/exp(E-Ep)
		// I am computing sigma as exp(E-Ep)
		// So we still need to divide the sigmas for ne
		// and check if sigma in the denominator is zero
		return kb * Ln((sigma2 * ne2)/(sigma1 * ne1));

		//return kb * Ln(sigma1/sigma2);
	}
	else
	{
		if(!getin2)
		{
			cerr << "sigma is zero within file " << filename2 << endl;
			ierror = 1;
			exit(1);
		}
		// I am not computing sigma as 1/ne * 1/exp(E-Ep)
		// I am computing sigma as exp(E-Ep)
		// So we still need to divide the sigmas for ne
		// and check if sigma in the denominator is zero
		return -kb * Ln((sigma1 * ne1)/(sigma2 * ne2));

		//return kb * Ln(sigma2/sigma1);
	}


}


