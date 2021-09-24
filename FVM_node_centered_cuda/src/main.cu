#include "FVM.h"
#include "GPU_mat.cu"
#include "Using_UMFPACK.h"
#include "mesh.h"
#include <chrono>
#include <iostream>
#include <sys/time.h>

int main()
{

    for (size_t i = 0; i < 1; ++i)
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
        mesh M{domain_vertices, 1};

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
        //M.matlabplot();

        FVM fvm;

        fvm.NUM_nodes = M.JXY.size();

        MatrixXf K = MatrixXf::Zero(fvm.NUM_nodes, fvm.NUM_nodes);
        MatrixXf F = MatrixXf::Zero(fvm.NUM_nodes, 1);

        fvm.Assemble_matrix_regular_control_volume(M, K);
        fvm.Address_boundary_control_colume(M, K, F);

        //fvm.Pressure = Eigen::MatrixXf::Zero(fvm.NUM_nodes, 1);
        //fvm.Pressure = K.inverse() * F;
        cout << " ******matrix dimension: " << fvm.NUM_nodes << "******\n";
        cout << " ******start comparison******\n";
        if (1)
        {
            double *K_host = new double[fvm.NUM_nodes * fvm.NUM_nodes];
            double *F_host = new double[fvm.NUM_nodes];

            if (K_host == NULL || F_host == NULL)
            {
                cout << "wrong 9\n";
                exit(0);
            }
            for (size_t i = 0; i < fvm.NUM_nodes; ++i)
            {
                F_host[i] = F(i, 0);
                for (size_t j = 0; j < fvm.NUM_nodes; ++j)
                    K_host[i * fvm.NUM_nodes + j] = K(i, j);
            }
            auto start = std::chrono::steady_clock::now();

            Using_UMFPACK u{K_host, fvm.NUM_nodes, F_host};

            auto end = std::chrono::steady_clock::now();
            std::chrono::duration<double, std::micro> elapsed = end - start; // std::micro time (us)
            std::cout << "UMFPACK: " << elapsed.count() << " μs.\n";

            fvm.Pressure = Eigen::MatrixXf::Zero(fvm.NUM_nodes, 1);
            for (size_t i = 0; i < fvm.NUM_nodes; ++i)
                fvm.Pressure(i, 0) = (float)F_host[i];

            fvm.Velocity_of_each_element(M);
            fvm.Inlet_and_outlet(M);
            fvm.Matlab_plot(M);
            delete[] K_host;
            K_host = NULL;
            delete[] F_host;
            F_host = NULL;
        }

        if (1)
        {
            double *K_host = new double[fvm.NUM_nodes * fvm.NUM_nodes];
            double *F_host = new double[fvm.NUM_nodes];

            if (K_host == NULL || F_host == NULL)
            {
                cout << "wrong 9\n";
                exit(0);
            }

            for (size_t i = 0; i < fvm.NUM_nodes; ++i)
            {
                F_host[i] = F(i, 0);
                for (size_t j = 0; j < fvm.NUM_nodes; ++j)
                    K_host[j * fvm.NUM_nodes + i] = K(i, j);
            }
            auto start = std::chrono::steady_clock::now();

            GPU_mat(K_host, F_host, fvm.NUM_nodes, fvm.NUM_nodes);

            auto end = std::chrono::steady_clock::now();
            std::chrono::duration<double, std::micro> elapsed = end - start; // std::micro time (us)
            std::cout << "CUDA: " << elapsed.count() << " μs.\n";
            /*
            fvm.Pressure = Eigen::MatrixXf::Zero(fvm.NUM_nodes, 1);
            for (size_t i = 0; i < fvm.NUM_nodes; ++i)
                fvm.Pressure(i, 0) = (float)F_host[i];

            fvm.Velocity_of_each_element(M);
            fvm.Inlet_and_outlet(M);
            fvm.Matlab_plot(M);*/

            delete[] K_host;
            K_host = NULL;
            delete[] F_host;
            F_host = NULL;
        }
    }
    return 0;
}