/*
 * ProgramArguments.cpp
 *
 *  Created on: Jul 25, 2010
 *      Author: victor
 */

#include "ProgramArguments.h"

ProgramArguments::ProgramArguments(int argc, char * argv[])
{
	space = 8;

	numberOfColumns = 80;

	programName = argv[0];

	// short program name
	int pos =  programName.find_last_of("/");
	shortProgramName = programName.substr(pos+1,programName.length());

	// number of arguments passed to the program by the user
	userDefinedArguments = new vector<string>;
	userDefinedArguments->reserve(argc-1);
	if((argc -1) > 0)
	{
		for(int i = 1; i < argc; i++)
		{
			userDefinedArguments->push_back(argv[i]);
		}
	}

	arguments = new vector<string>;
	comments = new vector<string>;
	acceptsArgs = new vector<bool>;

	errorMessage = "Usage: " + shortProgramName + " [OPTION]\nTry '"+ shortProgramName + " -h' for more information.";
}

ProgramArguments::~ProgramArguments()
{
	delete arguments;
	delete comments;
	delete acceptsArgs;
	delete userDefinedArguments;
}

void ProgramArguments::addArguments(string argument, string comments, bool acceptsArgs)
{
	this->arguments->push_back(argument);
	this->comments->push_back(comments);
	this->acceptsArgs->push_back(acceptsArgs);
}

string ProgramArguments::printProgramArguments()
{
	stringstream str;

	size_t j = 0;
	size_t pos = space;
	size_t len;

	for(size_t i = 0; i < arguments->size(); i++)
	{
		str << arguments->at(i);

		if(arguments->at(i).length() < space)
		{
			for(size_t j = 0; j < space - arguments->at(i).length(); j++)
			{
				str << " ";
			}
		}

		j = 0;
		pos = space;

		while(j < comments->at(i).length())
		{
			if(!(pos % numberOfColumns) && pos != 0)
			{
				str << "\n";
				for(size_t k = 0; k < space; k++)
					str << " ";

				pos = space;
			}

			len = sizeOfWordToTheRight(comments->at(i), j);

			if(len + pos + 1 < numberOfColumns)
			{
				str << comments->at(i).substr(j, len) << " ";
				j = j + len;
				pos = pos + len;
			}
			else if(len != string::npos)
			{
				str << "\n";
				for(size_t k = 0; k < space; k++)
					str << " ";

				pos = space;

				str << comments->at(i).substr(j, len) << " ";
				j = j + len;
				pos = pos + len;
			}
			pos++;
			j++;
		}
		str << "\n";
	}
	return str.str();
}

bool ProgramArguments::checkUserDefinedArguments()
{
	if(userDefinedArguments->size() > 0)
	{
		size_t i = 0;
		while(i < userDefinedArguments->size())
		{
			if(checkUserDefinedArgument(userDefinedArguments->at(i)))
			{
				if(checkIfNeedsArgument(userDefinedArguments->at(i)))
				{
					i++;
					if(i < userDefinedArguments->size())
					{
						if(checkUserDefinedArgument(userDefinedArguments->at(i)))
							return false;
					}
					else
						return false;
				}
				i++;
			}
			else
				return false;
		}
	}
	else
		return false;

	return true;
}

bool ProgramArguments::checkUserDefinedArgument(string argument)
{
	for(size_t i = 0; i < arguments->size(); i++)
	{
		if(arguments->at(i) == argument)
		{
			return true;
		}
	}
	return false;
}

size_t ProgramArguments::sizeOfWordToTheRight(string str, size_t pos)
{
	// Checking the valid range
	if(pos >= str.length())
		return 0;

	// checking if the position has a word
	if(str.substr(pos, 1) == " ")
		return 0;

	if(str.find(" ", pos) != string::npos)
		return str.find(" ", pos) - pos;
	else if(str.length() > pos)
		return str.length() - pos;
	else
		return 0;
}

bool ProgramArguments::checkIfNeedsArgument(string argument)
{
	for(size_t i = 0; i < arguments->size(); i++)
	{
		if(arguments->at(i) == argument)
		{
			if(acceptsArgs->at(i))
				return true;
			else
				return false;
		}
	}
	return false;
}

bool ProgramArguments::isThereArgument(string argument)
{
	for(size_t i = 0; i < userDefinedArguments->size(); i++)
	{
		if(userDefinedArguments->at(i) == argument)
		{
			return true;
		}
	}
	return false;
}

string ProgramArguments::getProgramArgument(string arg)
{
	size_t pos;
	bool increment;
	size_t size = userDefinedArguments->size();

	pos = 0;
	increment = true;
	while(pos < size && increment)
	{
		if(userDefinedArguments->at(pos) == arg)
			increment = false;
		else
			pos++;
	}

	if(pos == size)
	{
		return "";
	}
	else if(checkIfNeedsArgument(userDefinedArguments->at(pos)) == false)
	{
		return "";
	}

	pos++;
	if(pos < size)
	{
		return userDefinedArguments->at(pos);
	}
	else
	{
		return "";
	}
}
