#pragma once
#include <Eigen/Dense>
#include <iostream>
using namespace std;
using namespace Eigen;

class Normal_
{
public:
    Vector2d N;
    Normal_(Vector2d A);
};

Normal_::Normal_(Vector2d A)
{
    N << -A[1], A[0];

    N = N / N.norm();
};
