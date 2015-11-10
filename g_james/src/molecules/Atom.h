/*
 * Atom.h
 *
 *  Created on: Oct 1, 2010
 *      Author: victor
 */

#ifndef ATOM_H_
#define ATOM_H_

#include <string>
#include <math.h>
#include <iomanip>
#include <sstream>

#include <iostream>

using namespace std;

class Atom
{

private:

	string name;

	float mass;

	float charge;

	float x;

	float y;

	float z;

public:

	Atom();

	virtual ~Atom();

    float getCharge() const
    {
        return charge;
    }

    float getMass() const
    {
        return mass;
    }

    string getName() const
    {
        return name;
    }

    float getX() const
    {
        return x;
    }

    float getY() const
    {
        return y;
    }

    float getZ() const
    {
        return z;
    }

    void setCharge(float charge)
    {
        this->charge = charge;
    }

    void setMass(float mass)
    {
        this->mass = mass;
    }

    void setName(string name)
    {
        this->name = name;
    }

    void setX(float x)
    {
        this->x = x;
    }

    void setY(float y)
    {
        this->y = y;
    }

    void setZ(float z)
    {
        this->z = z;
    }

    void setXYZ(float x, float y, float z)
    {
        this->x = x;
        this->y = y;
        this->z = z;
    }

	float distanceTo(Atom atom)
	{
		return sqrt(((atom.getX()- getX()) * (atom.getX()- getX())) +
				    ((atom.getY()- getY()) * (atom.getY()- getY())) +
				    ((atom.getZ()- getZ()) * (atom.getZ()- getZ())));
	}

    float angleAThisB(Atom a, Atom b)
	{
		/*
		 * These are not atoms but vectors in the space
		 * They are used to compute the vectors betweem the atoms
		 *
		 */
		Atom u, v, zero;

		u.setX(a.getX()-getX());
		u.setY(a.getY()-getY());
		u.setZ(a.getZ()-getZ());

		v.setX(b.getX()-getX());
		v.setY(b.getY()-getY());
		v.setZ(b.getZ()-getZ());

		zero.setX(0.0000000);
		zero.setY(0.0000000);
		zero.setZ(0.0000000);

		return acos(((u.getX()*v.getX()) + (u.getY()*v.getY()) + (u.getZ()*v.getZ())) /
				(u.distanceTo(zero)*v.distanceTo(zero)));
	}

    float angleThisAB(Atom a, Atom b)
    {
    	Atom atom;
    	atom.setX(getX());
    	atom.setY(getY());
    	atom.setZ(getZ());

    	return a.angleAThisB(atom,b);
    }

    float angleABThis(Atom a, Atom b)
    {
    	Atom atom;
    	atom.setX(getX());
    	atom.setY(getY());
    	atom.setZ(getZ());

    	return b.angleAThisB(a,atom);
    }

    float dihedralThisABC(Atom a, Atom b, Atom c)
    {
		/*
		 * These are not atoms but vectors in the space
		 * They are used to compute the vectors betweem the atoms
		 *
		 */
		Atom u, v, zero, w, wprime;

		u.setX(getX()-a.getX());
		u.setY(getY()-a.getY());
		u.setZ(getZ()-a.getZ());

		v.setX(b.getX()-a.getX());
		v.setY(b.getY()-a.getY());
		v.setZ(b.getZ()-a.getZ());

		w.setX((u.getY()*v.getZ())-(u.getZ()*v.getY()));
		w.setY((u.getZ()*v.getX())-(u.getX()*v.getZ()));
		w.setZ((u.getX()*v.getY())-(u.getY()*v.getX()));

		zero.setX(0.0000000);
		zero.setY(0.0000000);
		zero.setZ(0.0000000);

		u.setX(-v.getX());
		u.setY(-v.getY());
		u.setZ(-v.getZ());

		v.setX(c.getX()-b.getX());
		v.setY(c.getY()-b.getY());
		v.setZ(c.getZ()-b.getZ());

		wprime.setX((u.getY()*v.getZ())-(u.getZ()*v.getY()));
		wprime.setY((u.getZ()*v.getX())-(u.getX()*v.getZ()));
		wprime.setZ((u.getX()*v.getY())-(u.getY()*v.getX()));

		double d = -((w.getX() * a.getX()) + (w.getY() * a.getY()) + (w.getZ() * a.getZ()));

		double t = -((w.getX() * c.getX()) + (w.getY() * c.getY()) + (w.getZ() * c.getZ()) + d);

		t /= ((w.getX() * w.getX()) + (w.getY() * w.getY()) + (w.getZ() * w.getZ()));

//		cout << "t = " << t << endl;

		if(t > 0)
			return zero.angleAThisB(w,wprime);
		else
			return -zero.angleAThisB(w,wprime);


		return zero.angleAThisB(w,wprime);
    }

    float dihedralAThisBC(Atom a, Atom b, Atom c)
    {
    	Atom atom;
    	atom.setX(getX());
    	atom.setY(getY());
    	atom.setZ(getZ());

    	return a.dihedralThisABC(atom, b, c);
    }

    float dihedralABThisC(Atom a, Atom b, Atom c)
    {
    	Atom atom;
    	atom.setX(getX());
    	atom.setY(getY());
    	atom.setZ(getZ());

    	return a.dihedralThisABC(b, atom, c);
    }

    float dihedralABCThis(Atom a, Atom b, Atom c)
    {
    	Atom atom;
    	atom.setX(getX());
    	atom.setY(getY());
    	atom.setZ(getZ());

    	return a.dihedralThisABC(b, c, atom);
    }

    void clear()
    {
    	name = "";
    	mass = 0.0;
    	charge = 0.0;
    	x = 0.0;
    	y = 0.0;
    	z = 0.0;
    }

    string print() const
    {
    	stringstream str;

    	str << setw(4) << setiosflags(ios_base::fixed) << name << "   "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << x << " "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << y << " "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << z;

    	return str.str();
    }

    string printWithCharge() const
    {
    	stringstream str;

    	str << setw(4) << setiosflags(ios_base::fixed) << name << "   "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << x << " "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << y << " "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << z << " "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << charge;

    	return str.str();
    }

    string printWithChargeAndMass() const
    {
    	stringstream str;

    	str << setw(4) << setiosflags(ios_base::fixed) << name << "   "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << x << " "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << y << " "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << z << " "
    		<< setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << charge << " "
		    << setw(11) << setiosflags(ios_base::fixed) << setprecision(6) << mass;

    	return str.str();
    }

};

ostream& operator<<(ostream& output, Atom at);

#endif /* ATOM_H_ */

