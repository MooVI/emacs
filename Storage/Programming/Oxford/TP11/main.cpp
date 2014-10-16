/* 
 * File:   main.cpp
 * Author: Jack Kemp
 *
 * Created on 13 October 2014, 11:54
*/

#if 0

#include<Eigen/Dense>
#include<Eigen/unsupported/Eigen/MPRealSupport>
#include<NumericalMethods/NumericalMethods/Random.h>
#include<NumericalMethods/NumericalMethods/Statistics.h>
#include<Plotting/Plotter/Plotter.h>
#include<iostream>
#include<gsl/gsl_statistics.h>
#include<mpreal.h>

typedef mpfr::mpreal mpreal;

/*
 * 
 */
int main() {
    mpreal::set_default_prec(512);
    ScatterPlotter plotter;
    const int L = 10000000;
    const int sample = 10000;
    double W = 0.7;
    double halfW = W/2;
    Eigen::Matrix<mpreal, L/sample, 1> results;
  //  Eigen::Matrix<mpreal, L/sample, 1> convergence;
    Eigen::Matrix<int, L/sample, 1> samples;
    samples.setLinSpaced(L/sample, 0, L);
    Eigen::Matrix<mpreal, 2, 1> psi_n, psi_n1; psi_n << 1.0, 0.0;
    
    results[0] = 0;
//    convergence[0] = 0;
    Eigen::Matrix<mpreal,2,2> T; T << 0, -1,
                         1, 0;
    NumMethod::RandomClosed random;
    for (int i = 0, j=0; i < L; i++,j++){
        T(0,0) = random.randomgen(-halfW, halfW);
        psi_n1 = T*psi_n;
        psi_n = psi_n1;
        if (j == sample) {
            results[i/sample] = (1/(mpreal) i)*log(fabs(psi_n[0]));
    //        convergence[i/sample] = results[i/sample]-results[(i/sample) -1];
            j-=sample;
        }
    }
    plotter.plot2(samples.tail(100), (1/results.array()).tail(100), "results");
   // plotter.plot2(samples.tail(100), (convergence.array()/results.array()).tail(100));
    NumMethod::RunningStats<mpreal> stats(1/results.tail(100).array());
    std::cout<< stats.Mean() << std::endl << stats.StandardDeviation();
    plotter.wait();
    
    return 0;
}

#endif