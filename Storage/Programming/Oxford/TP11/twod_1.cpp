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
#include<NumericalMethods/NumericalMethods/SamplingForLoops.h>
#include <NumericalMethods/NumericalMethods/Mod.h>
#include<Plotting/Plotter/Plotter.h>
#include<iostream>
#include<mpreal.h>
#include<chrono>
#include<functional>

typedef double mpreal;

/*
 * 
 */
int main() {
    //    mpreal::set_default_prec(128);
    ScatterPlotter plotter;
    const int L = 1000000;
    const int sample = 10;
    const int numPoints = 100;

    typedef Eigen::Matrix<mpreal, Eigen::Dynamic, Eigen::Dynamic> Matrix2w2w;
    typedef Eigen::Matrix<mpreal, Eigen::Dynamic, Eigen::Dynamic> Matrixww;
    typedef Eigen::Matrix<mpreal, Eigen::Dynamic, 1> Vector2w;
    typedef Eigen::Matrix<mpreal, Eigen::Dynamic, 1> Vectorw;


    const double W = 5.0;
    const double halfW = W/2;
    const double E = 0.0;
    mpreal rel_err = 0.01;
    
    Eigen::Matrix<mpreal, numPoints, 1> mfp;
    
    NumMethod::LogFor forloop;
    NumMethod::ForLoopParams<double> forparams;

    forparams.numPoints = numPoints;
    forparams.start = 1.0;
    forparams.end = 50.0;
    NumMethod::RandomClosed random;
    std::ofstream outfile;
    outfile.open("mfp_5d", std::ios::trunc);
    int oldwidth = 0;
    auto t1 = std::chrono::high_resolution_clock::now();
    
    mpreal eps;
    
    auto shoot = [&] (double dwidth, int iW) {  
    int width = (int) ceil(dwidth);
    if (oldwidth == width) return false;
    oldwidth = width;
    Matrix2w2w T(2 * width, 2 * width);
    T << Matrixww::Zero(width, width), -Matrixww::Identity(width, width),
            Matrixww::Identity(width, width), Matrixww::Zero(width, width);

    for (int i = 0; i < width; i++) {
        T(i, NumMethod::posmod((i + 1), width)) = -1;
        T(i, NumMethod::posmod((i - 1), width)) = -1;
    }
    Matrix2w2w M = T, initM = T;
    mpreal c = 0, d = 0;
        double halfW = W / 2;
        M = initM;
        int iL = 0;
        for (int j = 0; iL < L; iL++, j++) {
            for (int iT = 0; iT < width; iT++)
                T(iT, iT) = random.randomgen(-halfW, halfW) - E;
            M = T*M;
            Vector2w b = Vector2w::Zero(2 * width);
            if (j == sample) {
                j -= sample;
                for (int it = 0; it < width; it++) {
                    Vector2w sum = Vector2w::Zero(2 * width);
                    for (int jt = 0; jt < it; jt++) sum += (M.col(jt).dot(M.col(it))) * M.col(jt);
                    sum = M.col(it) - sum;
                    b[it] = sum.norm();
                    M.col(it) = sum / b[it];
                }
                mpreal lb = log(b[width-1]);
                c = c + lb;
                d = d + lb*lb;
                mpreal r = (c/(mpreal)iL);
                eps = sqrt((d/(mpreal) iL - r*r)/(mpreal) iL)/r;
                if (eps < rel_err and iL > 10000) break;
            }
        }
        mfp[iW] = iL / c;
        auto t2 = std::chrono::high_resolution_clock::now();
        outfile << mfp[iW] << " " << width << " " << " " << eps << " "  << iL << " "
                << std::chrono::duration_cast<std::chrono::seconds>(t2-t1).count()
                << std::endl;
        t1 = t2;
        c = 0;
        return false;
    };

    forloop.loop(shoot, forparams);
    plotter.plot1(mfp.col(0));
    outfile.close();
    plotter.wait();
    return 0;
}
#endif 
