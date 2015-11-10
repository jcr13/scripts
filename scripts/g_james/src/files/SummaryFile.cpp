/*
 * SummaryFile.cpp
 *
 *  Created on: Dec 6, 2012
 *      Author: victor
 */

#include "SummaryFile.h"

SummaryFile::SummaryFile()
{
	// TODO Auto-generated constructor stub

}

SummaryFile::~SummaryFile()
{
	// TODO Auto-generated destructor stub
}

bool SummaryFile::readFile()
{
	string line;
	int p1, p2, p3, p4, p5,p6,p7,p8,p9,p10;

	if(!rewind())
		return false;

	/*
	 * Reading the lines
	 *
	 */
	line = readLine();
	while(!eof())
	{
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
					p5 = line.find_first_not_of(' ', p4+1);
					p6 = line.find_first_of(' ', p5+1);
					p7 = line.find_first_not_of(' ', p6+1);
					p8 = line.find_first_of(' ', p7+1);
					p9 = line.find_first_not_of(' ', p8+1);
					p10 = line.find_first_of(' ', p9+1);

//					potentialEnergyAverages.push_back(atof(line.substr(p1,p2-p1).c_str()));
//					potentialEnergyVariances.push_back(atof(line.substr(p3,p4-p3).c_str()));
//					potentialEnergyFileNames.push_back(line.substr(p5,p6-p5));
//					energyAverages.push_back(atof(line.substr(p7,p8-p7).c_str()));
//					degreesOfFreedom.push_back(atof(line.substr(p9,p10-p9).c_str()));

					potentialEnergyFileNames.push_back(line.substr(p1,p2-p1));
					totalEnergyFileNames.push_back(line.substr(p3,p4-p3));
					degreesOfFreedom.push_back(atof(line.substr(p5,p6-p5).c_str()));
				}
			}
		}

		line = readLine();
	}


	return true;
}
