#pragma once
#include "mesh.h"

class FVM
{
public:
    size_t k = 1;
    size_t NUM_nodes;
    MatrixXf Pressure;
    std::vector<Vector2d> Velocity;

    double inlet = 0;
    double outlet = 0;

public:
    void Assemble_matrix_regular_control_volume(mesh mesh_, MatrixXf &K);
    void Address_boundary_control_colume(mesh mesh_, MatrixXf &K, MatrixXf &F);
    void Velocity_of_each_element(mesh mesh_);
    void Inlet_and_outlet(mesh mesh_);
    void Matlab_plot(mesh mesh_);
};

void FVM::Assemble_matrix_regular_control_volume(mesh mesh_, MatrixXf &K)
{
    for (size_t i = 0; i < NUM_nodes; ++i)
    {
        if (mesh_.Point_type[i].top == false &&
            mesh_.Point_type[i].bot == false &&
            mesh_.Point_type[i].left == false &&
            mesh_.Point_type[i].right == false)
        {
            double alpha_P = 0;

            for (size_t j = 0; j < mesh_.Control_volume[i].size(); ++j)
            {
                size_t ele1_ = mesh_.Control_volume[i][j];
                size_t ele2_ = mesh_.Control_volume[i][(j + 1) % mesh_.Control_volume[i].size()];

                size_t node1 = mesh_.Shared_edge[std::make_pair(ele1_ < ele2_ ? ele1_ : ele2_, ele1_ > ele2_ ? ele1_ : ele2_)].first;
                size_t node2 = mesh_.Shared_edge[std::make_pair(ele1_ < ele2_ ? ele1_ : ele2_, ele1_ > ele2_ ? ele1_ : ele2_)].second;

                size_t node1_, node2_;

                node2_ = i;

                if (node1 == i)
                    node1_ = node2;
                else
                    node1_ = node1;

                double l_Er_P = (mesh_.JXY[node2_] - mesh_.JXY[node1_]).norm();
                double A_r = (mesh_.Centers[ele2_] - mesh_.Centers[ele1_]).norm(); //widthless element

                Vector2d Tangential_vec = mesh_.JXY[node2_] - mesh_.JXY[node1_];
                Vector2d Normal_vec = mesh_.Nor_vec_CV[i][j].second;
                Normal_vec = Normal_vec / Normal_vec.norm();

                double angle1_ = atan2(Tangential_vec[1], Tangential_vec[0]);
                double angle2_ = atan2(Normal_vec[1], Normal_vec[0]);

                double theta_Radian = abs(angle1_ - angle2_);

                /*
                cout << "node " << i + 1 << ", node " << node1_ + 1 << "\n\ttheta_angle: " << theta_Radian * 180 / M_PI << endl;
                cout << "A_r " << A_r << endl;
                cout << "l_Er_P " << l_Er_P << endl;
                cout << "Normal_vec " << Normal_vec.transpose() << endl;
                cout << "Tangential_vec " << Tangential_vec.transpose() << endl
                     << endl;
                    */

                alpha_P = alpha_P + k * (-1.) * A_r * cos(theta_Radian) / l_Er_P;

                K(i, node1_) = k * (1.) * A_r * cos(theta_Radian) / l_Er_P;
            }
            K(i, i) = alpha_P;
        }
    }
};

void FVM::Address_boundary_control_colume(mesh mesh_, MatrixXf &K, MatrixXf &F)
{
    for (size_t i = 0; i < NUM_nodes; ++i)
    {
        if ((mesh_.Point_type[i].top == false &&
             mesh_.Point_type[i].bot == false) &&
            (mesh_.Point_type[i].left == true ||
             mesh_.Point_type[i].right == true)) // left and right
        {
            //cout << "i1: " << i << endl;
            double alpha_P = 0;

            for (size_t j = 0; j < mesh_.Control_volume_boundary[i].size(); ++j)
            {
                if (mesh_.Control_volume_boundary_cross_line[i][j].first[0] != -100)
                {
                    int node1_ = mesh_.Control_volume_boundary_Node_to_Node[i][j].first;

                    double A_r = (mesh_.Control_volume_boundary[i][j] - mesh_.Control_volume_boundary[i][(j + 1) % mesh_.Control_volume_boundary[i].size()]).norm();

                    double l_Er_P = (mesh_.Control_volume_boundary_cross_line[i][j].first - mesh_.Control_volume_boundary_cross_line[i][j].second).norm();

                    Vector2d Tangential_vec = mesh_.Control_volume_boundary_cross_line[i][j].second - mesh_.Control_volume_boundary_cross_line[i][j].first;

                    Vector2d Normal_vec = mesh_.Nor_vec_CV[i][j].second;
                    Normal_vec = Normal_vec / Normal_vec.norm();

                    double angle1_ = atan2(Tangential_vec[1], Tangential_vec[0]);
                    double angle2_ = atan2(Normal_vec[1], Normal_vec[0]);

                    double theta_Radian = abs(angle1_ - angle2_);

                    alpha_P = alpha_P + k * (-1.) * A_r * cos(theta_Radian) / l_Er_P;

                    /*    
                    if (1)
                    {
                        cout << "node " << i + 1 << ", node " << node1_ + 1 << "\n\ttheta_angle: " << theta_Radian * 180 / M_PI << endl;
                        cout << "A_r " << A_r << endl;
                        cout << "l_Er_P " << l_Er_P << endl;
                        cout << "mesh_.Control_volume_boundary_cross_line[i][j].first " << mesh_.Control_volume_boundary_cross_line[i][j].first.transpose() << endl;
                        cout << "mesh_.Control_volume_boundary_cross_line[i][j].second " << mesh_.Control_volume_boundary_cross_line[i][j].second.transpose() << endl;
                        cout << "Normal_vec " << Normal_vec.transpose() << endl;
                        cout << "Tangential_vec " << Tangential_vec.transpose() << endl
                             << endl;
                    }
                    */

                    if (node1_ == -1)
                    {
                        cout << "wrong 7\n";
                        exit(0);
                    }

                    K(i, node1_) = k * (1.) * A_r * cos(theta_Radian) / l_Er_P;
                }
            }

            K(i, i) = alpha_P;
        }
        else if (mesh_.Point_type[i].top == true ||
                 mesh_.Point_type[i].bot == true)
        {
            //cout << "i2: " << i << endl;
            if (mesh_.Point_type[i].top == true)
            {
                for (size_t j = 0; j < NUM_nodes; ++j)
                {
                    F(j, 0) = F(j, 0) - 1.0 * K(j, i) * 100;
                    K(j, i) = 0;
                }

                K(i, i) = 1;
                F(i, 0) = 100;
            }
            else if (mesh_.Point_type[i].bot == true)
            {
                for (size_t j = 0; j < NUM_nodes; ++j)
                {
                    F(j, 0) = F(j, 0) - 1.0 * K(j, i) * 20;
                    K(j, i) = 0;
                }

                K(i, i) = 1;
                F(i, 0) = 20;
            }
        }
    }
};

void FVM::Velocity_of_each_element(mesh mesh_)
{
    Velocity.resize(mesh_.JM.size());

    for (size_t i = 0; i < mesh_.JM.size(); ++i)
    {
        Vector3d he;
        for (size_t j = 0; j < 3; ++j)
            he[j] = Pressure(mesh_.JM[i][j], 0);

        Vector3d x, y;
        for (size_t j = 0; j < 3; ++j)
        {
            x[j] = mesh_.JXY[mesh_.JM[i][j]][0];
            y[j] = mesh_.JXY[mesh_.JM[i][j]][1];
        }

        double L1 = (Vector2d{x[1] - x[0], y[1] - y[0]}).norm();
        double L2 = (Vector2d{x[1] - x[2], y[1] - y[2]}).norm();
        double L3 = (Vector2d{x[2] - x[0], y[2] - y[0]}).norm();

        double P = L1 + L2 + L3;

        double area = pow((P * (P - L1) * (P - L2) * (P - L3)), 0.5);

        double b1 = 1 / area * (y[2 - 1] - y[3 - 1]);
        double b2 = 1 / area * (y[3 - 1] - y[1 - 1]);
        double b3 = 1 / area * (y[1 - 1] - y[2 - 1]);
        double c1 = 1 / area * (x[3 - 1] - x[2 - 1]);
        double c2 = 1 / area * (x[1 - 1] - x[3 - 1]);
        double c3 = 1 / area * (x[2 - 1] - x[1 - 1]);

        RowVector3d Nx, Ny;
        Nx << b1, b2, b3;
        Ny << c1, c2, c3;

        Velocity[i][0] = -1.0 * Nx * he;
        Velocity[i][1] = -1.0 * Ny * he;
    }
};

void FVM::Inlet_and_outlet(mesh mesh_)
{
    for (size_t i = 0; i < mesh_.JM.size(); ++i)
    {
        for (size_t j = 0; j < 3; ++j)
        {
            size_t pntID1 = mesh_.JM[i][j],
                   pntID2 = mesh_.JM[i][(j + 1) % 3];

            if (mesh_.Point_type[pntID1].top == true && mesh_.Point_type[pntID2].top == true)
            {
                Vector2d q_v = this->Velocity[i];

                double L = (mesh_.JXY[pntID1] - mesh_.JXY[pntID2]).norm();

                inlet = inlet + q_v.dot(Vector2d{0, -1}) * L;
            }
        }
    }

    for (size_t i = 0; i < mesh_.JM.size(); ++i)
    {
        for (size_t j = 0; j < 3; ++j)
        {
            size_t pntID1 = mesh_.JM[i][j],
                   pntID2 = mesh_.JM[i][(j + 1) % 3];

            if (mesh_.Point_type[pntID1].bot == true && mesh_.Point_type[pntID2].bot == true)
            {
                Vector2d q_v = this->Velocity[i];

                double L = (mesh_.JXY[pntID1] - mesh_.JXY[pntID2]).norm();

                outlet = outlet + q_v.dot(Vector2d{0, -1}) * L;
            }
        }
    }
    cout << inlet << endl;
    cout << outlet << endl;
};

void FVM::Matlab_plot(mesh mesh_)
{
    ofstream oss("FVM.m", ios::out);
    oss << "clc;\nclear all;\nclose all;\n";
    oss << "JM = [";
    for (size_t i = 0; i < mesh_.JM.size(); ++i)
        oss << "\t" << mesh_.JM[i][0] + 1 << ", " << mesh_.JM[i][1] + 1 << ", " << mesh_.JM[i][2] + 1 << "\n";
    oss << "];\n";

    oss << "JXY = [";
    for (size_t i = 0; i < mesh_.JXY.size(); ++i)
        oss << "\t" << mesh_.JXY[i][0] << ", " << mesh_.JXY[i][1] << "\n";
    oss << "];\n";

    oss << "Pressure = [";
    for (size_t i = 0; i < (size_t)Pressure.size(); ++i)
        oss << "\t" << Pressure(i, 0) << ";\n";

    oss << "];\n";

    oss << "Velocity = [";
    for (size_t i = 0; i < this->Velocity.size(); ++i)
        oss << "\t" << this->Velocity[i].transpose() << ";\n";
    oss << "];\n";

    oss << "Centers = [";
    for (size_t i = 0; i < mesh_.Centers.size(); ++i)
        oss << "\t" << mesh_.Centers[i][0] << ", " << mesh_.Centers[i][1] << "\n";
    oss << "];\n";

    oss << "figure(1)\n";
    oss << "P = patch('Vertices', JXY, 'Faces', JM, 'FaceVertexCData', Pressure, 'FaceColor', 'interp', 'EdgeAlpha', 0.9);\n";
    oss << "hold on;\n";
    oss << "quiver(Centers(:, 1), Centers(:, 2), Velocity(:, 1), Velocity(:, 2));\n\n";
    oss << "hold on\n";
    oss << "text(50, 107, ['inlet = ', num2str(" << this->inlet << ")], 'Interpreter','latex');\n";
    oss << "hold on\n";
    oss << "text(50, -7, ['outlet = ', num2str(" << this->outlet << ")], 'Interpreter','latex');\n";
    oss << "hold on\n";
    oss << "text(50, -13, ['error = $', num2str(" << abs(this->outlet - this->inlet) / (this->outlet > this->inlet ? this->outlet : this->inlet) * 100 << "), ' \\%$'], 'Interpreter','latex');\n\n\n";
    oss << "xlim([-5, 105]);\n";
    oss << "ylim([-17, 112]);\n";

    oss << "figure(2)\n";
    oss << "title('contour of pressure')\n";
    oss << "hold on\n";
    oss << "N = 200;\n";
    oss << "x0 = linspace(min(JXY(:, 1)),max(JXY(:, 1)), N);\n";
    oss << "y0 = linspace(min(JXY(:, 2)),max(JXY(:, 2)), N);\n";
    oss << "[xq, yq] = meshgrid(x0, y0);\n";
    oss << "z = griddata(JXY(:, 1), JXY(:, 2), Pressure, xq, yq);\n";
    oss << "contourf(xq, yq, z);\n";
    oss << "hold on\n";
    oss << "colorbar\n";

    oss.close();
};