/*
 * CoarseGlucose.cpp
 *
 *  Created on: Oct 4, 2010
 *      Author: victor
 */

#include "CoarseGlucose.h"

CoarseGlucose::CoarseGlucose()
{
	oxygen.setMass(16.0);
	hydrogen.setMass(1.0);
	carbon.setMass(12.0);
	nitrogen.setMass(14.0);

	CV1.setName("CV1");
	CV2.setName("CV2");
	CVM.setName("CVM");
	CV6.setName("CV6");
	pCV1.setName("CV1");
	pCV2.setName("CV2");
	pCVM.setName("CVM");
	pCV6.setName("CV6");
}

CoarseGlucose::~CoarseGlucose()
{
	// TODO Auto-generated destructor stub
}

bool CoarseGlucose::defGlucoseDimerFromMolecule(Molecule mol)
{
	float x, y, z, m;

	/*
	 * Defining atom CV1
	 * Based on the atoms O1, C6 and H11
	 *
	 */
	// O1
	x = mol[0].getX() * oxygen.getMass();
	y = mol[0].getY() * oxygen.getMass();
	z = mol[0].getZ() * oxygen.getMass();
	m = oxygen.getMass();

	// C6
	x += mol[5].getX() * carbon.getMass();
	y += mol[5].getY() * carbon.getMass();
	z += mol[5].getZ() * carbon.getMass();
	m += carbon.getMass();

	// H11
	x += mol[10].getX() * hydrogen.getMass();
	y += mol[10].getY() * hydrogen.getMass();
	z += mol[10].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	x /= m;
	y /= m;
	z /= m;
	CV1.setXYZ(x,y,z);

	/*
	 * Defining atom CV2
	 * Based on the atoms C4, C5, H9, H10, O14, O15, H21 and H22
	 *
	 */
	// C4
	x = mol[3].getX() * carbon.getMass();
	y = mol[3].getY() * carbon.getMass();
	z = mol[3].getZ() * carbon.getMass();
	m = carbon.getMass();

	// C5
	x += mol[4].getX() * carbon.getMass();
	y += mol[4].getY() * carbon.getMass();
	z += mol[4].getZ() * carbon.getMass();
	m += carbon.getMass();

	// H9
	x += mol[8].getX() * hydrogen.getMass();
	y += mol[8].getY() * hydrogen.getMass();
	z += mol[8].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// H9
	x += mol[9].getX() * hydrogen.getMass();
	y += mol[9].getY() * hydrogen.getMass();
	z += mol[9].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// O14
	x += mol[13].getX() * oxygen.getMass();
	y += mol[13].getY() * oxygen.getMass();
	z += mol[13].getZ() * oxygen.getMass();
	m += oxygen.getMass();

	// O15
	x += mol[14].getX() * oxygen.getMass();
	y += mol[14].getY() * oxygen.getMass();
	z += mol[14].getZ() * oxygen.getMass();
	m += oxygen.getMass();

	// H21
	x += mol[20].getX() * hydrogen.getMass();
	y += mol[20].getY() * hydrogen.getMass();
	z += mol[20].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// H22
	x += mol[21].getX() * hydrogen.getMass();
	y += mol[21].getY() * hydrogen.getMass();
	z += mol[21].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	x /= m;
	y /= m;
	z /= m;
	CV2.setXYZ(x,y,z);

	/*
	 * Defining atom CVM
	 * Based on the atoms C3, H8 and O13
	 *
	 */
	// C3
	x = mol[2].getX() * carbon.getMass();
	y = mol[2].getY() * carbon.getMass();
	z = mol[2].getZ() * carbon.getMass();
	m = carbon.getMass();

	// H8
	x += mol[7].getX() * hydrogen.getMass();
	y += mol[7].getY() * hydrogen.getMass();
	z += mol[7].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// O13
	x += mol[12].getX() * oxygen.getMass();
	y += mol[12].getY() * oxygen.getMass();
	z += mol[12].getZ() * oxygen.getMass();
	m += oxygen.getMass();

	x /= m;
	y /= m;
	z /= m;
	CVM.setXYZ(x,y,z);

	/*
	 * Defining atom CV6
	 * Based on the atoms C2, H7, C12, H17, O18, H19 and H23
	 *
	 */
	// C2
	x = mol[1].getX() * carbon.getMass();
	y = mol[1].getY() * carbon.getMass();
	z = mol[1].getZ() * carbon.getMass();
	m = carbon.getMass();

	// H7
	x += mol[6].getX() * hydrogen.getMass();
	y += mol[6].getY() * hydrogen.getMass();
	z += mol[6].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// C12
	x += mol[11].getX() * carbon.getMass();
	y += mol[11].getY() * carbon.getMass();
	z += mol[11].getZ() * carbon.getMass();
	m += carbon.getMass();

	// H17
	x += mol[16].getX() * hydrogen.getMass();
	y += mol[16].getY() * hydrogen.getMass();
	z += mol[16].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// O18
	x += mol[17].getX() * oxygen.getMass();
	y += mol[17].getY() * oxygen.getMass();
	z += mol[17].getZ() * oxygen.getMass();
	m += oxygen.getMass();

	// H19
	x += mol[18].getX() * hydrogen.getMass();
	y += mol[18].getY() * hydrogen.getMass();
	z += mol[18].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// H23
	x += mol[22].getX() * hydrogen.getMass();
	y += mol[22].getY() * hydrogen.getMass();
	z += mol[22].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	x /= m;
	y /= m;
	z /= m;
	CV6.setXYZ(x,y,z);

	/*
	 * Defining atom pCV1
	 * Based on the atoms O24, C29 and H34
	 *
	 */
	// O24
	x = mol[23].getX() * oxygen.getMass();
	y = mol[23].getY() * oxygen.getMass();
	z = mol[23].getZ() * oxygen.getMass();
	m = oxygen.getMass();

	// C29
	x += mol[28].getX() * carbon.getMass();
	y += mol[28].getY() * carbon.getMass();
	z += mol[28].getZ() * carbon.getMass();
	m += carbon.getMass();

	// H34
	x += mol[33].getX() * hydrogen.getMass();
	y += mol[33].getY() * hydrogen.getMass();
	z += mol[33].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	x /= m;
	y /= m;
	z /= m;
	pCV1.setXYZ(x,y,z);

	/*
	 * Defining atom pCV2
	 * Based on the atoms C27, C28, H32, H33, O36, O37, H42 and H43
	 *
	 */
	// C27
	x = mol[26].getX() * carbon.getMass();
	y = mol[26].getY() * carbon.getMass();
	z = mol[26].getZ() * carbon.getMass();
	m = carbon.getMass();

	// C28
	x += mol[27].getX() * carbon.getMass();
	y += mol[27].getY() * carbon.getMass();
	z += mol[27].getZ() * carbon.getMass();
	m += carbon.getMass();

	// H32
	x += mol[31].getX() * hydrogen.getMass();
	y += mol[31].getY() * hydrogen.getMass();
	z += mol[31].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// H33
	x += mol[32].getX() * hydrogen.getMass();
	y += mol[32].getY() * hydrogen.getMass();
	z += mol[32].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// O36
	x += mol[35].getX() * oxygen.getMass();
	y += mol[35].getY() * oxygen.getMass();
	z += mol[35].getZ() * oxygen.getMass();
	m += oxygen.getMass();

	// O37
	x += mol[36].getX() * oxygen.getMass();
	y += mol[36].getY() * oxygen.getMass();
	z += mol[36].getZ() * oxygen.getMass();
	m += oxygen.getMass();

	// H42
	x += mol[41].getX() * hydrogen.getMass();
	y += mol[41].getY() * hydrogen.getMass();
	z += mol[41].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// H43
	x += mol[42].getX() * hydrogen.getMass();
	y += mol[42].getY() * hydrogen.getMass();
	z += mol[42].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	x /= m;
	y /= m;
	z /= m;
	pCV2.setXYZ(x,y,z);

	/*
	 * Defining atom pCVM
	 * Based on the atoms C26, H31 and O16
	 *
	 */
	// C26
	x = mol[25].getX() * carbon.getMass();
	y = mol[25].getY() * carbon.getMass();
	z = mol[25].getZ() * carbon.getMass();
	m = carbon.getMass();

	// H31
	x += mol[30].getX() * hydrogen.getMass();
	y += mol[30].getY() * hydrogen.getMass();
	z += mol[30].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// O16
	x += mol[15].getX() * oxygen.getMass();
	y += mol[15].getY() * oxygen.getMass();
	z += mol[15].getZ() * oxygen.getMass();
	m += oxygen.getMass();

	x /= m;
	y /= m;
	z /= m;
	pCVM.setXYZ(x,y,z);

	/*
	 * Defining atom pCV6
	 * Based on the atoms C25, H30, C35, H39, O40, H41 and H44
	 *
	 */
	// C25
	x = mol[24].getX() * carbon.getMass();
	y = mol[24].getY() * carbon.getMass();
	z = mol[24].getZ() * carbon.getMass();
	m = carbon.getMass();

	// H30
	x += mol[29].getX() * hydrogen.getMass();
	y += mol[29].getY() * hydrogen.getMass();
	z += mol[29].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// C35
	x += mol[34].getX() * carbon.getMass();
	y += mol[34].getY() * carbon.getMass();
	z += mol[34].getZ() * carbon.getMass();
	m += carbon.getMass();

	// H39
	x += mol[38].getX() * hydrogen.getMass();
	y += mol[38].getY() * hydrogen.getMass();
	z += mol[38].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// O40
	x += mol[39].getX() * oxygen.getMass();
	y += mol[39].getY() * oxygen.getMass();
	z += mol[39].getZ() * oxygen.getMass();
	m += oxygen.getMass();

	// H41
	x += mol[40].getX() * hydrogen.getMass();
	y += mol[40].getY() * hydrogen.getMass();
	z += mol[40].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	// H44
	x += mol[43].getX() * hydrogen.getMass();
	y += mol[43].getY() * hydrogen.getMass();
	z += mol[43].getZ() * hydrogen.getMass();
	m += hydrogen.getMass();

	x /= m;
	y /= m;
	z /= m;
	pCV6.setXYZ(x,y,z);

	return false;
}

ostream& operator<<(ostream& output, CoarseGlucose coarseGlucose)
{
	stringstream str;

	str.clear();

	str << coarseGlucose.getCV1() << endl;
	str << coarseGlucose.getCV2() << endl;
	str << coarseGlucose.getCVM() << endl;
	str << coarseGlucose.getCV6() << endl;
	str << coarseGlucose.getpCV1() << endl;
	str << coarseGlucose.getpCV2() << endl;
	str << coarseGlucose.getpCVM() << endl;
	str << coarseGlucose.getpCV6() << endl;

	output << str.str();
	return output;
}
