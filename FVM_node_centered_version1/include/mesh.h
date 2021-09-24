#pragma once
#include "Graph_WL.h"
#include "If_a_2D_point_lies_on_a_line_seg.h"
#include "Normal_.h"
#include "gmsh.h"
#include <Eigen/Dense>
#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <unordered_set>
#include <vector>

using namespace std;
using namespace Eigen;

typedef Eigen::Matrix<size_t, 3, 1> Vector3S;

typedef struct Point_attribute
{
    bool top = false;
    bool bot = false;
    bool left = false;
    bool right = false;
} P_attri;

class mesh
{
public:
    std::vector<Vector2d> JXY;
    std::vector<Vector3S> JM;
    std::vector<std::vector<size_t>> Control_volume;
    std::vector<Vector2d> Centers;
    std::vector<P_attri> Point_type;
    std::map<pair<size_t, size_t>, pair<size_t, size_t>> Shared_edge; // ele1, ele2, node1, node2

    std::vector<std::vector<Vector2d>> Control_volume_boundary;
    std::vector<std::vector<pair<Vector2d, Vector2d>>> Control_volume_boundary_cross_line;
    std::vector<std::vector<pair<int, int>>> Control_volume_boundary_Node_to_Node;

    std::vector<std::vector<pair<Vector2d, Vector2d>>> Nor_vec_CV; // normal vectors of the edges of each control volume

public:
    mesh(std::vector<Vector2d> domain_vertices, double mesh_size);
    void identify_centers();
    void identify_point_types(std::vector<Vector2d> TOP,
                              std::vector<Vector2d> BOT,
                              std::vector<Vector2d> LEFT,
                              std::vector<Vector2d> RIGHT);
    void identify_shared_edge();
    void sort_control_volume(std::vector<size_t> &control_volume_i);
    void sort_boundary_control_volume(std::vector<size_t> control_volume_i, std::vector<Vector2d> extraPnt, std::vector<Vector2d> &bound_CV);
    void identify_control_volume();
    void identify_normal_vector();
    void matlabplot();
};

mesh::mesh(std::vector<Vector2d> domain_vertices, double mesh_size)
{
    gmsh::initialize();
    gmsh::option::setNumber("General.Verbosity", 2); // default level is 5
    gmsh::model::add("t2");

    size_t VertsPntID = 1;

    for (size_t i = 0; i < domain_vertices.size(); ++i)
    {
        gmsh::model::geo::addPoint(domain_vertices[i][0],
                                   domain_vertices[i][1],
                                   0,
                                   mesh_size, VertsPntID);

        VertsPntID++;
    }

    size_t LineID = 1;
    for (size_t i = 1; i <= domain_vertices.size(); ++i)
    {
        gmsh::model::geo::addLine(i, i % domain_vertices.size() + 1, LineID);
        LineID++;
    }

    std::vector<int> curveloop(domain_vertices.size());
    for (size_t i = 0; i < domain_vertices.size(); ++i)
    {
        curveloop[i] = i + 1;
    };
    gmsh::model::geo::addCurveLoop(curveloop, 1);

    std::vector<int> surfaceloop = {1};
    gmsh::model::geo::addPlaneSurface(surfaceloop, 1);

    gmsh::model::geo::synchronize();

    //gmsh::model::mesh::setOrder(1);
    //gmsh::option::setNumber("Mesh.ElementOrder", 1);
    gmsh::model::mesh::generate();

    std::vector<std::size_t> nodes;
    std::vector<double> coord, coordParam;
    gmsh::model::mesh::getNodes(nodes, coord, coordParam);
    //NUM_of_NODES = coord.size() / 3;

    for (size_t i = 0; i < coord.size(); i += 3)
    {
        Vector2d A;
        A << coord[i], coord[i + 1];
        //cout << A.transpose() << endl;
        JXY.push_back(A);
    }

    std::vector<int> elemTypes;
    std::vector<std::vector<std::size_t>> elemTags, elemNodeTags;
    gmsh::model::mesh::getElements(elemTypes, elemTags, elemNodeTags, 2, -1);

    for (size_t i = 0; i < elemNodeTags[0].size(); i += 3)
    {
        Vector3S A;
        A << elemNodeTags[0][i] - 1,
            elemNodeTags[0][i + 1] - 1,
            elemNodeTags[0][i + 2] - 1;

        //cout << A << endl;
        JM.push_back(A);
    }

    //gmsh::fltk::run();
    gmsh::clear();
    gmsh::finalize();
};

void mesh::identify_centers()
{
    Centers.resize(JM.size());

    for (size_t i = 0; i < JM.size(); ++i)
    {
        Vector2d A = JXY[JM[i][0]];
        Vector2d B = JXY[JM[i][1]];
        Vector2d C = JXY[JM[i][2]];

        Centers[i] = (A + B + C) / 3.0;
    }
};

void mesh::identify_point_types(std::vector<Vector2d> TOP,
                                std::vector<Vector2d> BOT,
                                std::vector<Vector2d> LEFT,
                                std::vector<Vector2d> RIGHT)
{
    Point_type.resize(JXY.size());

    for (size_t i = 0; i < JXY.size(); ++i)
    {
        If_a_2D_point_lies_on_a_line_seg TOP_i{TOP[0], TOP[1], JXY[i]};
        If_a_2D_point_lies_on_a_line_seg BOT_i{BOT[0], BOT[1], JXY[i]};
        If_a_2D_point_lies_on_a_line_seg LEFT_i{LEFT[0], LEFT[1], JXY[i]};
        If_a_2D_point_lies_on_a_line_seg RIGHT_i{RIGHT[0], RIGHT[1], JXY[i]};

        if (TOP_i.if_lies_on == true)
            Point_type[i].top = true;

        if (BOT_i.if_lies_on == true)
            Point_type[i].bot = true;

        if (LEFT_i.if_lies_on == true)
            Point_type[i].left = true;

        if (RIGHT_i.if_lies_on == true)
            Point_type[i].right = true;
    }
};

void mesh::identify_shared_edge()
{

    //cout << JM.size() << endl;
    for (size_t i = 0; i < JM.size(); ++i)
    //for (size_t i = 34; i < 35; ++i)
    {
        for (size_t j = 0; j < 3; ++j)
        {

            size_t edge1 = JM[i][j], edge2 = JM[i][(j + 1) % 3]; // node ID

            pair<size_t, size_t> key1 = std::make_pair(edge1 < edge2 ? edge1 : edge2,
                                                       edge1 > edge2 ? edge1 : edge2);

            //std::map<pair<size_t, size_t>, pair<size_t, size_t>>::iterator its;

            //its = Shared_edge.find(key1);

            if (1 /*its == Shared_edge.end()*/)
            {
                for (size_t k = 0; k < JM.size(); ++k)
                //for (size_t k = 64; k < 65; ++k)
                {
                    if (k != i)
                        for (size_t l = 0; l < 3; ++l)
                        {
                            size_t edge3 = JM[k][l], edge4 = JM[k][(l + 1) % 3];
                            pair<size_t, size_t> key2 = std::make_pair(edge3 < edge4 ? edge3 : edge4,
                                                                       edge3 > edge4 ? edge3 : edge4);

                            if (key1.first == key2.first && key1.second == key2.second)
                            {
                                size_t ele1 = i;
                                size_t ele2 = k;

                                Shared_edge[std::make_pair(ele1 < ele2 ? ele1 : ele2, ele1 > ele2 ? ele1 : ele2)] = key1;
                            }
                        }
                }
            }
        }
    }
};

void mesh::sort_control_volume(std::vector<size_t> &control_volume_i)
{
    std::vector<size_t> V = control_volume_i;
    sort(V.begin(), V.end());

    std::vector<size_t> connections;
    for (size_t i = 0; i < V.size() - 1; ++i)
    {
        size_t ele1 = V[i];
        for (size_t j = i + 1; j < V.size(); ++j)
        {
            size_t ele2 = V[j];
            for (size_t k = 0; k < 3; ++k)
            {
                size_t PNT1 = this->JM[ele1][k];
                size_t PNT2 = this->JM[ele1][(k + 1) % 3];

                std::pair<size_t, size_t> key1 = std::make_pair(PNT1 < PNT2 ? PNT1 : PNT2, PNT1 > PNT2 ? PNT1 : PNT2);

                for (size_t l = 0; l < 3; ++l)
                {
                    size_t PNT3 = this->JM[ele2][l];
                    size_t PNT4 = this->JM[ele2][(l + 1) % 3];

                    std::pair<size_t, size_t> key2 = std::make_pair(PNT3 < PNT4 ? PNT3 : PNT4, PNT3 > PNT4 ? PNT3 : PNT4);

                    if (key1.first == key2.first && key1.second == key2.second)
                    {
                        connections.push_back(i);
                        connections.push_back(j);
                        goto yuioo;
                    }
                }
            }
        yuioo:;
        }
    }

    std::vector<vector<size_t>> Listofcluster;
    Graph G{control_volume_i.size(), connections};
    G.CreateGraph_i(Listofcluster);

    for (size_t i = 0; i < control_volume_i.size(); ++i)
        control_volume_i[i] = V[Listofcluster[0][i]];
};

void mesh::sort_boundary_control_volume(std::vector<size_t> control_volume_i, std::vector<Vector2d> extraPnt, std::vector<Vector2d> &bound_CV)
{
    std::vector<size_t> V = control_volume_i;
    sort(V.begin(), V.end());

    std::vector<size_t> connections;
    for (size_t i = 0; i < V.size() - 1; ++i)
    {
        size_t ele1 = V[i];
        for (size_t j = i + 1; j < V.size(); ++j)
        {
            size_t ele2 = V[j];
            for (size_t k = 0; k < 3; ++k)
            {
                size_t PNT1 = this->JM[ele1][k];
                size_t PNT2 = this->JM[ele1][(k + 1) % 3];

                std::pair<size_t, size_t> key1 = std::make_pair(PNT1 < PNT2 ? PNT1 : PNT2, PNT1 > PNT2 ? PNT1 : PNT2);

                for (size_t l = 0; l < 3; ++l)
                {
                    size_t PNT3 = this->JM[ele2][l];
                    size_t PNT4 = this->JM[ele2][(l + 1) % 3];

                    std::pair<size_t, size_t> key2 = std::make_pair(PNT3 < PNT4 ? PNT3 : PNT4, PNT3 > PNT4 ? PNT3 : PNT4);

                    if (key1.first == key2.first && key1.second == key2.second)
                    {
                        connections.push_back(i);
                        connections.push_back(j);
                        //cout << "connection i j " << ele1 << ", " << ele2 << endl;
                        goto yuioo;
                    }
                }
            }
        yuioo:;
        }
    }

    //cout << "connections:\n";
    for (size_t i = 0; i < extraPnt.size(); i = i + 2)
    {
        size_t pntID = V.size() + i;

        for (size_t j = 0; j < V.size(); ++j)
        {
            for (size_t k = 0; k < 3; ++k)
            {
                size_t eleID = V[j];
                size_t pntID1_ = this->JM[eleID][k];
                size_t pntID2_ = this->JM[eleID][(k + 1) % 3];

                If_a_2D_point_lies_on_a_line_seg uy{JXY[pntID1_], JXY[pntID2_], extraPnt[i]};

                if (uy.if_lies_on == true)
                {
                    connections.push_back(pntID);
                    connections.push_back(j);
                    connections.push_back(V.size() + 1);
                    connections.push_back(pntID);
                    //cout << pntID << ", " << j << endl;
                    //cout << pntID << ", " << V.size() + 1 << endl;
                    goto yui899;
                }
            }
        }
    yui899:;
    }

    /*
    for(size_t i = 0; i < connections.size(); ++i)
        cout << connections[i] << ", ";
    cout << endl;
    */
    std::vector<vector<size_t>> Listofcluster;
    Graph G{V.size() + extraPnt.size(), connections};

    G.CreateGraph_i(Listofcluster);

    //for (size_t i = 0; i < Listofcluster[0].size(); ++i)
    //cout << Listofcluster[0][i] << ", ";
    //cout << endl;

    //bound_CV.resize(Listofcluster[0].size());

    for (size_t i = 0; i < Listofcluster[0].size(); ++i)
    {
        if (Listofcluster[0][i] < V.size())
        {
            size_t pntID = V[Listofcluster[0][i]];
            //cout << "i: " << i << ", ";
            //cout << this->Centers[pntID].transpose() << endl;
            bound_CV.push_back(this->Centers[pntID]);
        }
        else
        {
            size_t pntID = Listofcluster[0][i] - V.size();
            bound_CV.push_back(extraPnt[pntID]);
            //cout << "i: " << i << ", ";
            //cout << extraPnt[pntID].transpose() << endl;
        }
    }

    //cout << "bound_CV: " << endl;
    //for (size_t i = 0; i < bound_CV.size(); ++i)
    //cout << bound_CV[i].transpose() << endl;

    //exit(0);
};

void mesh::identify_control_volume()
{
    Control_volume.resize(JXY.size());
    Control_volume_boundary.resize(JXY.size());
    Control_volume_boundary_cross_line.resize(JXY.size());
    Control_volume_boundary_Node_to_Node.resize(JXY.size());

    //cout << 5.1 << endl;
    for (size_t i = 0; i < JXY.size(); ++i)
    {
        if (Point_type[i].top == false &&
            Point_type[i].bot == false &&
            Point_type[i].left == false &&
            Point_type[i].right == false)
        {
            //cout << 3 << endl;
            size_t PNT_ID = i;
            for (size_t j = 0; j < JM.size(); ++j)
            {
                for (size_t k = 0; k < 3; ++k)
                {
                    if (JM[j][k] == PNT_ID)
                    {
                        Control_volume[i].push_back(j);
                        break;
                    }
                }
            }
            this->sort_control_volume(Control_volume[i]);

            //----correct the orientation of polygon
            std::map<pair<double, double>, size_t> tmp_map;

            for (size_t j = 0; j < Control_volume[i].size(); ++j)
                tmp_map.insert(std::make_pair(std::make_pair(Centers[Control_volume[i][j]][0], Centers[Control_volume[i][j]][1]), Control_volume[i][j]));

            std::vector<point_type> points_1(Control_volume[i].size() + 1);

            for (size_t j = 0; j < Control_volume[i].size(); ++j)
                points_1[j] = point_type(Centers[Control_volume[i][j]][0], Centers[Control_volume[i][j]][1]);

            points_1[points_1.size() - 1] = point_type(Centers[Control_volume[i][0]][0], Centers[Control_volume[i][0]][1]);

            polygon_type poly_1;
            boost::geometry::assign_points(poly_1, points_1);
            boost::geometry::correct(poly_1);

            size_t jk = 0;
            for (auto it = boost::begin(boost::geometry::exterior_ring(poly_1)); it != boost::end(boost::geometry::exterior_ring(poly_1)); ++it)
            {
                double x = boost::geometry::get<0>(*it);
                double y = boost::geometry::get<1>(*it);

                std::pair<double, double> key_ = std::make_pair(x, y);

                Control_volume[i][jk] = tmp_map[key_];
                jk++;
            }
            //----------------counterclockwise
            std::vector<size_t> YH = Control_volume[i];
            for (size_t j = 0; j < YH.size(); ++j)
            {
                Control_volume[i][YH.size() - j] = YH[j];
            }
            //cout << 4 << endl;
        }
        else
        {

            //cout << 1 << endl;
            size_t PNT_ID = i;
            //cout << "vectice: " << PNT_ID + 1 << endl;
            //cout << "PNT_ID " << PNT_ID << endl;
            for (size_t j = 0; j < JM.size(); ++j)
            {
                for (size_t k = 0; k < 3; ++k)
                {
                    if (JM[j][k] == PNT_ID)
                    {
                        Control_volume[i].push_back(j);

                        break;
                    }
                }
            }

            std::vector<Vector2d> extraPnt(3);
            extraPnt[1] = JXY[PNT_ID];
            std::vector<size_t> tmp_ele_record;
            //------------------------------------
            std::vector<Vector2d> MidPNTs;
            std::vector<size_t> Belonging_ele;
            std::vector<size_t> Another_Node;

            //--------------------------------------
            //cout << "Control_volume[i].size() " << Control_volume[i].size() << endl;

            //$$$$$$$$$$$$$$$$$$$$
            if ((Point_type[PNT_ID].top == true ||
                 Point_type[PNT_ID].bot == true) &&
                (Point_type[PNT_ID].left == true ||
                 Point_type[PNT_ID].right == true)) // if PNT_ID is a corner point
            {
                size_t j = 0;

                for (size_t k = 0; k < Control_volume[i].size(); ++k)
                {
                    size_t eleID = Control_volume[i][k];

                    for (size_t l = 0; l < 3; ++l)
                    {
                        size_t PNTID_2_ = JM[eleID][l];
                        if ((Point_type[PNT_ID].top == true ||
                             Point_type[PNT_ID].bot == true) &&
                            (Point_type[PNT_ID].left == true ||
                             Point_type[PNT_ID].right == true)) // if PNT_ID is a corner point
                        {

                            if (PNTID_2_ != PNT_ID && (Point_type[PNTID_2_].top == true ||
                                                       Point_type[PNTID_2_].bot == true ||
                                                       Point_type[PNTID_2_].left == true ||
                                                       Point_type[PNTID_2_].right == true))
                            {
                                tmp_ele_record.push_back(eleID);

                                extraPnt[j] = JXY[PNT_ID] + JXY[PNTID_2_];
                                extraPnt[j] = extraPnt[j] * 0.5;

                                //----
                                MidPNTs.push_back(extraPnt[j]);
                                Belonging_ele.push_back(eleID);
                                Another_Node.push_back(PNTID_2_);

                                //if (PNT_ID == 0)
                                //cout << "j " << j << ", " << extraPnt[j].transpose() << endl;

                                j = j + 2;

                                if (j == 4)
                                    goto yuiop25;
                            }
                        }
                    }
                }
            yuiop25:;
            }
            else // if PNT_ID is not a corner point
            {
                for (size_t j = 0; j < 3; j = j + 2)
                {
                    for (size_t k = 0; k < Control_volume[i].size(); ++k)
                    {
                        size_t eleID = Control_volume[i][k];

                        if (find(tmp_ele_record.begin(), tmp_ele_record.end(), eleID) == tmp_ele_record.end())
                        {
                            for (size_t l = 0; l < 3; ++l)
                            {
                                size_t PNTID_2_ = JM[eleID][l];

                                if (PNTID_2_ != PNT_ID && (Point_type[PNTID_2_].top == true ||
                                                           Point_type[PNTID_2_].bot == true ||
                                                           Point_type[PNTID_2_].left == true ||
                                                           Point_type[PNTID_2_].right == true))
                                {
                                    bool COM_1[4] = {Point_type[PNT_ID].top,
                                                     Point_type[PNT_ID].bot,
                                                     Point_type[PNT_ID].left,
                                                     Point_type[PNT_ID].right};

                                    bool COM_2[4] = {Point_type[PNTID_2_].top,
                                                     Point_type[PNTID_2_].bot,
                                                     Point_type[PNTID_2_].left,
                                                     Point_type[PNTID_2_].right};
                                    size_t jklo = 0;
                                    for (size_t k = 0; k < 4; ++k)
                                        if (COM_1[k] == true)
                                            jklo = k;

                                    if (COM_2[jklo] == true)
                                    { //----------
                                        tmp_ele_record.push_back(eleID);

                                        extraPnt[j] = JXY[PNT_ID] + JXY[PNTID_2_];
                                        extraPnt[j] = extraPnt[j] * 0.5;

                                        //----if (PNT_ID == 0)
                                        //cout << "j " << j << endl;
                                        MidPNTs.push_back(extraPnt[j]);
                                        Belonging_ele.push_back(eleID);
                                        Another_Node.push_back(PNTID_2_);

                                        goto yui568;
                                    }
                                }
                            }
                        }
                    }
                yui568:;
                }
            }

            //cout << "extraPnt: " << endl;
            //for (size_t j = 0; j < 3; ++j)
            //cout << extraPnt[j].transpose() << endl;

            this->sort_boundary_control_volume(Control_volume[i], extraPnt, Control_volume_boundary[PNT_ID]);

            //---------------------

            //----correct the orientation of polygon
            //cout << "Control_volume_boundary[PNT_ID].size() " << Control_volume_boundary[PNT_ID].size() << endl;

            std::vector<point_type> points_1(Control_volume_boundary[PNT_ID].size() + 1);

            for (size_t j = 0; j < Control_volume_boundary[PNT_ID].size(); ++j)
                points_1[j] = point_type(Control_volume_boundary[PNT_ID][j][0], Control_volume_boundary[PNT_ID][j][1]);

            points_1[points_1.size() - 1] = point_type(Control_volume_boundary[PNT_ID][0][0], Control_volume_boundary[PNT_ID][0][1]);

            polygon_type poly_1;
            boost::geometry::assign_points(poly_1, points_1);
            boost::geometry::correct(poly_1);

            size_t jk_ = 1;

            for (auto it = boost::begin(boost::geometry::exterior_ring(poly_1)); it != boost::end(boost::geometry::exterior_ring(poly_1)); ++it)
            {
                if (jk_ == Control_volume_boundary[PNT_ID].size() + 1)
                    break;
                double x = boost::geometry::get<0>(*it);
                double y = boost::geometry::get<1>(*it);

                //cout << "Control_volume_boundary[PNT_ID].size() - jk_ " << Control_volume_boundary[PNT_ID].size() - jk_ << endl;
                Control_volume_boundary[PNT_ID][Control_volume_boundary[PNT_ID].size() - jk_][0] = x;
                Control_volume_boundary[PNT_ID][Control_volume_boundary[PNT_ID].size() - jk_][1] = y;
                jk_++;
            }

            //if (PNT_ID == 0)
            //{
            //    cout << "Control_volume_boundary[PNT_ID]:\n";
            //    for (size_t yk = 0; yk < Control_volume_boundary[PNT_ID].size(); ++yk)
            //        cout << Control_volume_boundary[PNT_ID][yk].transpose() << endl;
            //}
            //-------------------------------- write the Control_volume_boundary_cross_line
            // std::vector<std::vector<pair<Vector2d, Vector2d>>> Control_volume_boundary_cross_line;
            Control_volume_boundary_cross_line[PNT_ID].resize(Control_volume_boundary[i].size());
            Control_volume_boundary_Node_to_Node[PNT_ID].resize(Control_volume_boundary[i].size());

            std::map<pair<double, double>, size_t> tmp_con_V;
            for (size_t j = 0; j < Control_volume[i].size(); ++j)
                tmp_con_V.insert(std::make_pair(std::make_pair(Centers[Control_volume[i][j]][0], Centers[Control_volume[i][j]][1]), Control_volume[i][j]));

            for (size_t j = 0; j < Control_volume_boundary[i].size(); ++j)
            {
                Control_volume_boundary_cross_line[PNT_ID][j].first = Vector2d{-50, -50};
                Control_volume_boundary_cross_line[PNT_ID][j].second = Vector2d{-50, -50};

                std::pair<double, double> PNT1_ = std::make_pair(Control_volume_boundary[i][j][0], Control_volume_boundary[i][j][1]);
                std::pair<double, double> PNT2_ = std::make_pair(Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()][0], Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()][1]);

                std::map<pair<double, double>, size_t>::iterator ity1_ = tmp_con_V.find(PNT1_);
                std::map<pair<double, double>, size_t>::iterator ity2_ = tmp_con_V.find(PNT2_);

                if (ity1_ != tmp_con_V.end() && ity2_ != tmp_con_V.end()) // if the two edge's end are both element's centers
                {
                    size_t ele1_ = tmp_con_V[PNT1_];
                    size_t ele2_ = tmp_con_V[PNT2_];

                    std::pair<size_t, size_t> node_pair = Shared_edge[std::make_pair(ele1_ < ele2_ ? ele1_ : ele2_,
                                                                                     ele1_ > ele2_ ? ele1_ : ele2_)];

                    size_t anotherNODE = 0;
                    if (node_pair.first == PNT_ID)
                        anotherNODE = node_pair.second;
                    else if (node_pair.second == PNT_ID)
                        anotherNODE = node_pair.first;
                    else
                    {
                        cout << "wrong 0!\n";
                        cout << "PNT_ID " << PNT_ID << endl;
                        cout << "node_pair.first " << node_pair.first << endl;
                        cout << "node_pair.second " << node_pair.second << endl;
                        cout << "ele1_ " << ele1_ << endl;
                        cout << "ele2_ " << ele2_ << endl;

                        cout << "Control_volume_boundary:\n";
                        for (size_t k = 0; k < Control_volume_boundary[PNT_ID].size(); ++k)
                            cout << "\t" << Control_volume_boundary[PNT_ID][k].transpose() << endl;
                        exit(0);
                    }

                    Control_volume_boundary_cross_line[PNT_ID][j].first = JXY[anotherNODE];
                    Control_volume_boundary_cross_line[PNT_ID][j].second = JXY[PNT_ID];
                    Control_volume_boundary_Node_to_Node[PNT_ID][j] = std::make_pair((int)anotherNODE, (int)PNT_ID);

                    goto rye300;
                    //cout << ele1_ << ", " << ele2_ << "; " << node_pair.first << ", " << node_pair.second << endl;
                    //exit(0);
                }

                if ((Control_volume_boundary[i][j] - JXY[PNT_ID]).norm() < 1e-4 || (Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()] - JXY[PNT_ID]).norm() < 1e-4)
                {
                    // if one of the end is the node
                    Vector2d End1;

                    if ((Control_volume_boundary[i][j] - JXY[PNT_ID]).norm() < 1e-4)
                        End1 = Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()];
                    else if ((Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()] - JXY[PNT_ID]).norm() < 1e-4)
                        End1 = Control_volume_boundary[i][j];
                    else
                    {
                        cout << "wrong 2\n";
                        exit(0);
                    }

                    int Node1_ = -1;

                    for (size_t k = 0; k < Another_Node.size(); ++k)
                    {
                        Node1_ = (int)Another_Node[k];
                        if ((End1 - MidPNTs[k]).norm() < 1e-4)
                            break;
                    }

                    if (Node1_ == -1)
                    {
                        cout << "wrong3\n";
                        exit(0);
                    }

                    Control_volume_boundary_cross_line[PNT_ID][j].first = Vector2d{-100, -100};  //JXY[Node1_];
                    Control_volume_boundary_cross_line[PNT_ID][j].second = Vector2d{-100, -100}; //JXY[PNT_ID];
                    Control_volume_boundary_Node_to_Node[PNT_ID][j] = std::make_pair(-1, -1);
                    goto rye300;
                }

                if (1)
                {
                    // so, only one situation remains, one is the center of an element, another end is the midpoint of boundary edge of an element

                    Vector2d Cen_ele;

                    if (ity1_ != tmp_con_V.end() && ity2_ == tmp_con_V.end()) //Control_volume_boundary[i][j] is the center of an element
                        Cen_ele = Control_volume_boundary[i][j];
                    else if (ity1_ == tmp_con_V.end() && ity2_ != tmp_con_V.end()) // Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()] is the center of an element
                        Cen_ele = Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()];
                    else
                    {
                        cout << "wrong 4\n";
                        exit(0);
                    }

                    int ele_ = -1;
                    //cout << "node " << i << endl;
                    //cout << "Cen_ele " << Cen_ele.transpose() << endl;
                    //cout << "Control_volume[i].size() " << Control_volume[i].size() << endl;
                    for (size_t k = 0; k < Control_volume[i].size(); ++k)
                    {
                        size_t eleo_ = Control_volume[i][k];
                        //cout << "Centers[eleo_] " << Centers[eleo_].transpose() << endl;
                        if ((Cen_ele - Centers[eleo_]).norm() < 1e-4)
                        {
                            ele_ = eleo_;
                            break;
                        }
                    }
                    //cout << "ele_ " << ele_ << "\n\n\n";

                    if (ele_ == -1)
                    {
                        cout << "wrong 5\n";
                        exit(0);
                    }

                    int node_ = -1;
                    for (size_t k = 0; k < Belonging_ele.size(); ++k)
                    {
                        if (ele_ == (int)Belonging_ele[k])
                        {
                            node_ = (int)Another_Node[k];
                            break;
                        }
                    }

                    if (node_ == -1)
                    {
                        cout << "wrong 6\n";
                        cout << "PNT_ID " << PNT_ID << endl;
                        cout << "ele_ " << ele_ << endl;
                        cout << "Belonging_ele " << Belonging_ele[0] << ", " << Belonging_ele[1] << ", " << Belonging_ele[2] << endl;
                        cout << "Another_Node " << Another_Node[0] << ", " << Another_Node[1] << ", " << Another_Node[2] << endl;
                        exit(0);
                    }

                    Control_volume_boundary_cross_line[PNT_ID][j].first = JXY[node_];
                    Control_volume_boundary_cross_line[PNT_ID][j].second = JXY[PNT_ID];

                    Control_volume_boundary_Node_to_Node[PNT_ID][j] = std::make_pair((int)node_, (int)PNT_ID);
                }

            rye300:;
            }

            /////end
            Control_volume[i].clear();
            //cout << 2 << endl;
        };
    };

    //cout << 5.2 << endl;
};

void mesh::identify_normal_vector()
{

    Nor_vec_CV.resize(JXY.size());
    for (size_t i = 0; i < JXY.size(); ++i)
    {
        if (Point_type[i].top == false &&
            Point_type[i].bot == false &&
            Point_type[i].left == false &&
            Point_type[i].right == false)
        {
            Nor_vec_CV[i].resize(Control_volume[i].size());

            for (size_t j = 0; j < Control_volume[i].size(); ++j)
            {
                size_t center1_ = Control_volume[i][j];
                size_t center2_ = Control_volume[i][(j + 1) % Control_volume[i].size()];

                Vector2d End1 = Centers[center1_];
                Vector2d End2 = Centers[center2_];

                Normal_ UT{End2 - End1};

                Nor_vec_CV[i][j].first = (End1 + End2) * 0.5;
                Nor_vec_CV[i][j].second = UT.N;
            }
        }
        else
        {
            Nor_vec_CV[i].resize(Control_volume_boundary[i].size());

            for (size_t j = 0; j < Control_volume_boundary[i].size(); ++j)
            {
                Vector2d End1 = Control_volume_boundary[i][j];
                Vector2d End2 = Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()];

                Normal_ UT{End2 - End1};

                Nor_vec_CV[i][j].first = (End1 + End2) * 0.5;
                Nor_vec_CV[i][j].second = UT.N;
            }
        }
    }
};

void mesh::matlabplot()
{
    ofstream oss("mesh.m", ios::out);
    oss << "clc;\nclear all;\nclose all;\n";

    oss << "JM = [";
    for (size_t i = 0; i < JM.size(); ++i)
        oss << "\t" << JM[i][0] + 1 << ", " << JM[i][1] + 1 << ", " << JM[i][2] + 1 << "\n";
    oss << "];\n";

    oss << "JXY = [";
    for (size_t i = 0; i < JXY.size(); ++i)
        oss << "\t" << JXY[i][0] << ", " << JXY[i][1] << "\n";
    oss << "];\n";

    oss << "Centers = [";
    for (size_t i = 0; i < Centers.size(); ++i)
        oss << "\t" << Centers[i][0] << ", " << Centers[i][1] << "\n";
    oss << "];\n";

    oss << "Control_volume(1) = struct('adj_ele', [0]);\n";
    for (size_t i = 0; i < Control_volume.size(); ++i)
    {
        oss << "Control_volume(" << i + 1 << ").adj_ele = [";
        if (Control_volume[i].size() > 0)
        {
            for (size_t j = 0; j < Control_volume[i].size(); ++j)
                oss << Control_volume[i][j] + 1 << ", ";
        }
        else
            oss << " 0 ";
        oss << "];\n";
    };

    oss << "\nBoundary_control_volume(1) = struct('vertice', [0]);\n";
    for (size_t i = 0; i < Control_volume_boundary.size(); ++i)
    {
        oss << "Boundary_control_volume(" << i + 1 << ").vertice = [";
        if (Control_volume_boundary[i].size() > 0)
        {
            for (size_t j = 0; j < Control_volume_boundary[i].size(); ++j)
                oss << Control_volume_boundary[i][j].transpose() << "; ";
        }
        else
            oss << " 0 ";
        oss << "];\n";
    };

    oss << "\nPoint_type = [";
    for (size_t i = 0; i < Point_type.size(); ++i)
    {
        oss << "\t";
        if (Point_type[i].top == true)
            oss << "1"
                << ", ";
        else
            oss << "0"
                << ", ";

        if (Point_type[i].bot == true)
            oss << "1"
                << ", ";
        else
            oss << "0"
                << ", ";

        if (Point_type[i].left == true)
            oss << "1"
                << ", ";
        else
            oss << "0"
                << ", ";

        if (Point_type[i].right == true)
            oss << "1"
                << "\n";
        else
            oss << "0"
                << "\n";
    }
    oss << "];\n";

    oss << "\nShared_edge = [";
    for (std::map<pair<size_t, size_t>, pair<size_t, size_t>>::iterator i_ = Shared_edge.begin(); i_ != Shared_edge.end(); ++i_)
    {
        oss << "\t" << i_->first.first + 1 << ", " << i_->first.second + 1 << ", ";
        oss << i_->second.first + 1 << ", " << i_->second.second + 1 << ";\n";
    }
    oss << "];\n\n";

    oss << "figure(2)\n";
    oss << "[m, ~] = size(JXY);\n";
    oss << "P = patch('Vertices', JXY, 'Faces', JM, 'FaceVertexCData', zeros(m, 1), 'FaceColor', 'interp', 'EdgeAlpha', 0.9, 'facealpha', 0);\n";
    oss << "hold on;\n";
    oss << "for i = 1:1:" << Shared_edge.size() << endl;
    oss << "\tIO = [rand rand rand];\n";
    oss << "\tPNT1 = [Centers(Shared_edge(i, 1), :); Centers(Shared_edge(i, 2), :)];\n";
    oss << "\tPNT2 = [JXY(Shared_edge(i, 3), :); JXY(Shared_edge(i, 4), :)];\n";

    oss << "\tplot(PNT1(:, 1)', PNT1(:, 2)', '-', 'color', IO);hold on;\n";
    oss << "\tplot(PNT2(:, 1)', PNT2(:, 2)', '-', 'color', IO);hold on;\n";
    oss << "end\n";

    oss << "figure(1)\n";
    oss << "[m, ~] = size(JXY);\n";
    oss << "P = patch('Vertices', JXY, 'Faces', JM, 'FaceVertexCData', zeros(m, 1), 'FaceColor', 'interp', 'EdgeAlpha', 0.9, 'facealpha', 0);\n";
    oss << "hold on;\n";

    oss << "[k, ~] = size(Centers);\nfor i = 1:k\n";
    oss << "\ttext(Centers(i, 1), Centers(i, 2), num2str(i));\n";
    oss << "\thold on;\nend\n";

    oss << "for i = 1:" << JXY.size() << "\n";
    //oss << "\tif (Point_type(i, 1) == 1)\n";
    //oss << "\thold on\n";
    //oss << "\tscatter(JXY(i, 1), JXY(i, 2), 'd')\n";
    //oss << "\tend\n\n";
    //oss << "\tif (Point_type(i, 2) == 1)\n";
    //oss << "\thold on\n";
    //oss << "\tscatter(JXY(i, 1), JXY(i, 2), '+')\n";
    //oss << "\tend\n\n";
    //oss << "\tif (Point_type(i, 3) == 1)\n";
    //oss << "\thold on\n";
    //oss << "\tscatter(JXY(i, 1), JXY(i, 2), 's')\n";
    //oss << "\tend\n\n";
    //oss << "\tif (Point_type(i, 4) == 1)\n";
    //oss << "\thold on\n";
    //oss << "\tscatter(JXY(i, 1), JXY(i, 2), 'o')\n";
    //oss << "\tend\n\n";
    oss << "\ttext(JXY(i, 1), JXY(i, 2), num2str(i));\n";
    oss << "end\n";

    oss << "for i = 1:1:" << this->Control_volume.size() << endl;
    oss << "\t[~, m] = size(Control_volume(i).adj_ele);\n";
    oss << "\tif (Point_type(i, 1) ~= 1 && Point_type(i, 2) ~= 1 && Point_type(i, 3) ~= 1 && Point_type(i, 4) ~= 1)\n";
    oss << "\t\tfor j = 1:1:m\n";
    oss << "\t\t\tCenters_k(j, :) = Centers(Control_volume(i).adj_ele(j), :);\n";
    oss << "\t\tend\n";
    oss << "\t\tplot([Centers_k(:, 1); Centers_k(1, 1)], [Centers_k(:, 2); Centers_k(1, 2)]); hold on;\n";
    oss << "\t\tclear Centers_k;\n";
    oss << "\telse\n";
    oss << "\t\t[m, ~] = size(Boundary_control_volume(i).vertice);\n";
    oss << "\t\tfor j = 1:1:m\n";
    oss << "\t\t\tCenters_k = [Boundary_control_volume(i).vertice(:, :); Boundary_control_volume(i).vertice(1, :)];\n";
    oss << "\t\tend\n";
    oss << "\t\tplot([Centers_k(:, 1)], [Centers_k(:, 2)]); hold on;\n";
    oss << "\t\tclear Centers_k;\n";
    oss << "\tend\n";
    oss << "end\n\n";

    // Control_volume_boundary_cross_line[PNT_ID][j].first = Vector2d{-50, -50};

    for (size_t i = 0; i < Control_volume_boundary_cross_line.size(); ++i)
    {
        if (Control_volume_boundary_cross_line[i].size() > 0)
        {
            for (size_t j = 0; j < Control_volume_boundary_cross_line[i].size(); ++j)
            {
                if (Control_volume_boundary_cross_line[i][j].first[0] != -50)
                {

                    oss << "hold on;\n";
                    oss << "YT = [rand rand rand];\n";

                    if (Control_volume_boundary_cross_line[i][j].first[0] != -100)
                    {
                        double x1 = Control_volume_boundary_cross_line[i][j].first[0];
                        double x2 = Control_volume_boundary_cross_line[i][j].second[0];

                        double y1 = Control_volume_boundary_cross_line[i][j].first[1];
                        double y2 = Control_volume_boundary_cross_line[i][j].second[1];

                        oss << "plot([" << x1 << ", " << x2 << "], [" << y1 << ", " << y2 << "], '-', 'color', YT, 'linewidth', 2);\n";
                        oss << "hold on;\n";
                        oss << "plot(" << x2 << ", " << y2 << ", '^', 'color', YT);\nhold on;\n";
                    }
                    else
                    {
                        double x1 = Control_volume_boundary[i][j][0];
                        double x2 = Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()][0];
                        double y1 = Control_volume_boundary[i][j][1];
                        double y2 = Control_volume_boundary[i][(j + 1) % Control_volume_boundary[i].size()][1];

                        oss << "plot(" << 0.5 * (x1 + x2) << ", " << 0.5 * (y1 + y2) << ", 'o', 'color', YT);\nhold on;\n";
                    }
                }
            }
        }
    }

    oss << "\n\nfigure(3)\n";
    oss << "[m, ~] = size(JXY);\n";
    oss << "P = patch('Vertices', JXY, 'Faces', JM, 'FaceVertexCData', zeros(m, 1), 'FaceColor', 'interp', 'EdgeAlpha', 0.9, 'facealpha', 0);\n";
    oss << "hold on;\n";

    oss << "for i = 1:1:" << this->Control_volume.size() << endl;
    oss << "\t[~, m] = size(Control_volume(i).adj_ele);\n";
    oss << "\tif (Point_type(i, 1) ~= 1 && Point_type(i, 2) ~= 1 && Point_type(i, 3) ~= 1 && Point_type(i, 4) ~= 1)\n";
    oss << "\t\tfor j = 1:1:m\n";
    oss << "\t\t\tCenters_k(j, :) = Centers(Control_volume(i).adj_ele(j), :);\n";
    oss << "\t\tend\n";
    oss << "\t\tplot([Centers_k(:, 1); Centers_k(1, 1)], [Centers_k(:, 2); Centers_k(1, 2)]); hold on;\n";
    oss << "\t\tclear Centers_k;\n";
    oss << "\telse\n";
    oss << "\t\t[m, ~] = size(Boundary_control_volume(i).vertice);\n";
    oss << "\t\tfor j = 1:1:m\n";
    oss << "\t\t\tCenters_k = [Boundary_control_volume(i).vertice(:, :); Boundary_control_volume(i).vertice(1, :)];\n";
    oss << "\t\tend\n";
    oss << "\t\tplot([Centers_k(:, 1)], [Centers_k(:, 2)]); hold on;\n";
    oss << "\t\tclear Centers_k;\n";
    oss << "\tend\n";
    oss << "end\n\n";

    oss << "Normal_vector = [";
    for (size_t i = 0; i < Nor_vec_CV.size(); ++i)
    {
        for (size_t j = 0; j < Nor_vec_CV[i].size(); ++j)
        {
            oss << "\t" << Nor_vec_CV[i][j].first.transpose() << ", " << Nor_vec_CV[i][j].second.transpose() << ";\n";
        }
    }
    oss << "];\n";

    oss << "quiver(Normal_vector(:, 1), Normal_vector(:, 2), Normal_vector(:, 3), Normal_vector(:, 4), 'AutoScaleFactor', 0.6, 'Linewidth', 2);\n";
    oss << "hold on\n";
    oss << "[k, ~] = size(Centers);\nfor i = 1:k\n";
    oss << "\ttext(Centers(i, 1), Centers(i, 2), num2str(i));\n";
    oss << "\thold on;\nend\n";

    oss << "for i = 1:" << JXY.size() << "\n";
    //oss << "\tif (Point_type(i, 1) == 1)\n";
    //oss << "\thold on\n";
    //oss << "\tscatter(JXY(i, 1), JXY(i, 2), 'd')\n";
    //oss << "\tend\n\n";
    //oss << "\tif (Point_type(i, 2) == 1)\n";
    //oss << "\thold on\n";
    //oss << "\tscatter(JXY(i, 1), JXY(i, 2), '+')\n";
    //oss << "\tend\n\n";
    //oss << "\tif (Point_type(i, 3) == 1)\n";
    //oss << "\thold on\n";
    //oss << "\tscatter(JXY(i, 1), JXY(i, 2), 's')\n";
    //oss << "\tend\n\n";
    //oss << "\tif (Point_type(i, 4) == 1)\n";
    //oss << "\thold on\n";
    //oss << "\tscatter(JXY(i, 1), JXY(i, 2), 'o')\n";
    //oss << "\tend\n\n";
    oss << "\ttext(JXY(i, 1), JXY(i, 2), num2str(i));\n";
    oss << "end\n";
    oss.close();
};