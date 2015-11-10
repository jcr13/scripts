/*
 * FileHandler.h
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#ifndef FILEHANDLER_H_
#define FILEHANDLER_H_

#include <string>
#include <fstream>

using namespace std;


class FileHandler
{

private:

	string fileName;

	fstream::openmode openMode;

protected:

	fstream file;

public:

	FileHandler(fstream::openmode openMode);

	virtual ~FileHandler();

    string getFileName() const
    {
        return fileName;
    }

    string getFileNameWithoutExt()
    {
    	size_t pos = fileName.rfind('.');

    	return fileName.substr(0,pos);
    }

    string getFileNameExt()
    {
    	size_t pos = fileName.rfind('.');

    	return fileName.substr(pos+1,fileName.length());
    }

    void setFileName(string fileName)
    {
        this->fileName = fileName;
    }

    bool open();

    bool close();

    bool isOpen() const
    {
    	return file.is_open();
    }



};

#endif /* FILEHANDLER_H_ */
