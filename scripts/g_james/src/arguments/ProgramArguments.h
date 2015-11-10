/*!
 * @file ProgramArguments.h
 *
 * @date Jul 25, 2010
 *
 * @author: Victor Holanda Rusu
 *
 */

#ifndef PROGRAMARGUMENTS_H_
#define PROGRAMARGUMENTS_H_

#include <vector>
#include <sstream>

using namespace std;

class ProgramArguments
{

private:

	//! Full program name
	string programName;

	//! Program name without the directories
	string shortProgramName;

	/*!
	 * Vectors of arguments understood by the program and the comments
	 * associated to these arguments
	 *
	 */
	vector<string> * arguments,
	 	 	 	   * comments,
	 	 	 	   * userDefinedArguments;

	//! Vector that tells if an argument requires data
	vector<bool> * acceptsArgs;

	//! defines the space between the  arguments and the comments
	size_t space;

	//! defines the number of columns
	size_t numberOfColumns;

	string errorMessage;

	/*!
	 * Checks whether the passed argument by the user is defined in the program
	 *
	 */
	bool checkUserDefinedArgument(string argument);

	/*!
	 * Checks whether the argument needs complement
	 *
	 */
	bool checkIfNeedsArgument(string argument);

	/*!
	 * Returns the number of characters to the right before the space character
	 *
	 */
	size_t sizeOfWordToTheRight(string str, size_t pos);

public:

	ProgramArguments(int argc, char * argv[]);

	virtual ~ProgramArguments();

    int getNumberOfProgramArguments() const
    {
        return arguments->size();
    }

    size_t getNumberOfUserDefinedArguments() const
    {
        return userDefinedArguments->size();
    }

    string getProgramName() const
    {
        return programName;
    }

    string getShortProgramName() const
    {
        return shortProgramName;
    }

    string printProgramArguments();

    void addArguments(string argument, string comments, bool acceptsArgs);

    void setSpace(size_t space)
    {
    	this->space = space;
    }

    void setNumberOfColumns(size_t numberOfColumns)
    {
    	this->numberOfColumns = numberOfColumns;
    }

    /*!
	 * Checks whether the passed arguments by the user are defined in the program
	 *
	 */
    bool checkUserDefinedArguments();

    bool isThereArgument(string argument);

    string getErrorMessage() const
    {
        return errorMessage;
    }

    void setErrorMessage(string errorMessage)
    {
        this->errorMessage = errorMessage;
    }

    string getProgramArgument(string arg);

};

#endif /* PROGRAMARGUMENTS_H_ */
