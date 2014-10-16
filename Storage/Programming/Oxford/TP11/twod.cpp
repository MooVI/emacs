/* 
 * File:   main.cpp
 * Author: Jack Kemp
 *
 * Created on 13 October 2014, 11:54
*/

#if 1

#include<Eigen/Dense>
#include<Eigen/unsupported/Eigen/MPRealSupport>
#include<NumericalMethods/NumericalMethods/Random.h>
#include<NumericalMethods/NumericalMethods/Statistics.h>
#include<NumericalMethods/NumericalMethods/SamplingForLoops.h>
#include<Plotting/Plotter/Plotter.h>
#include<iostream>
#include<mpreal.h>
#include<functional>

typedef mpfr::mpreal mpreal;

/*
 * 
 */
int main() {
    mpreal::set_default_prec(512);
    ScatterPlotter plotter;
    const int L = 10000000;
    const int sample = 10000;
    const int samplenum = 100;
    const int sampleabove = L - sample*samplenum;
    const int numPoints = 100;
    
    const double E = 2.0;
    NumMethod::LogFor forloop;
    NumMethod::ForLoopParams<double> forparams;
    
    forparams.numPoints = numPoints;
    forparams.start = 0.01;
    forparams.end   = 10.0;
    
    Eigen::Matrix<mpreal, numPoints, 1> means;
    Eigen::Matrix<mpreal, numPoints, 1> stds;
   
    NumMethod::RandomClosed random;
    
    NumMethod::RunningStats<mpreal> stats;
    
   
    Eigen::Matrix<mpreal, 2, 1> psi_n, psi_n1;
    Eigen::Matrix<mpreal,2,2> T; T << 0, -1,
                                     1, 0;
    
    
    auto shoot = [&] (double W, int i){
    double halfW = W/2;
    psi_n << 1.0, 0.0;
    for (int i = 0, j=0; i < L; i++,j++){
        T(0,0) = random.randomgen(-halfW, halfW)-E;
        psi_n1 = T*psi_n;
        psi_n = psi_n1;
        if (j==sample){
            j -=sample;
            if (i > sampleabove) {
                stats.Push(((mpreal) i)/log(fabs(psi_n[0])));
            }
        }
    }
     means[i] = stats.Mean();
     stds[i]  = stats.StandardDeviation();
     stats.Clear();
     return false;
    };
    forloop.loop(shoot, forparams);
    plotter.plot1(means, "means2");
    plotter.plot1(stds, "stds2");
    plotter.wait();
    return 0;
}
#endif 
