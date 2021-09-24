#include "FVM.h"
#include "mesh.h"

int main()
{
    std::vector<Vector2d> domain_vertices(4);
    Vector2d A, B, C, D;
    A << 45, 0;
    B << 55, 0;
    C << 100, 100;
    D << 0, 100;

    domain_vertices[0] = A;
    domain_vertices[1] = B;
    domain_vertices[2] = C;
    domain_vertices[3] = D;

    std::vector<Vector2d> TOP = {C, D};
    std::vector<Vector2d> BOT = {A, B};
    std::vector<Vector2d> LEFT = {D, A};
    std::vector<Vector2d> RIGHT = {B, C};

    //cout << 1 << endl;
    mesh M{domain_vertices, 2};

    //cout << 2 << endl;
    M.identify_point_types(TOP, BOT, LEFT, RIGHT);
    //cout << 3 << endl;
    M.identify_centers();
    //cout << 4 << endl;
    M.identify_shared_edge();

    // cout << 5 << endl;
    M.identify_control_volume();

    // cout << 6 << endl;
    M.identify_normal_vector();
    //cout << 7 << endl;
    M.matlabplot();

    FVM fvm(M);
    fvm.Velocity_of_each_element(M);
    fvm.Inlet_and_outlet(M);
    fvm.Matlab_plot(M);

    return 0;
}