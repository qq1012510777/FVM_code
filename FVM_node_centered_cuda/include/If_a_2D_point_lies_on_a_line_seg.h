#pragma once
#include <cmath>
#include <iostream>
#include <list>
#include <set>
#include <string>
#include <Eigen/Dense>

using namespace std;
using namespace Eigen;

#define BOOST_GEOMETRY_DISABLE_DEPRECATED_03_WARNING

#include "boost/assign/std/vector.hpp"
#include "boost/geometry.hpp"
#include "boost/geometry/algorithms/area.hpp"
#include "boost/geometry/algorithms/assign.hpp"
#include "boost/geometry/algorithms/intersection.hpp"
#include "boost/geometry/geometries/point_xy.hpp"
#include "boost/geometry/geometries/polygon.hpp"
#include "boost/geometry/io/dsv/write.hpp"

using namespace boost::assign;
typedef boost::geometry::model::d2::point_xy<double> point_type;
typedef boost::geometry::model::polygon<point_type> polygon_type;
typedef boost::geometry::model::segment<point_type> segment_type;

class If_a_2D_point_lies_on_a_line_seg
{
public:
    bool if_lies_on = false;

    If_a_2D_point_lies_on_a_line_seg(Vector2d end_A, Vector2d end_B, Vector2d Pnt);
};

If_a_2D_point_lies_on_a_line_seg::If_a_2D_point_lies_on_a_line_seg(Vector2d end_A, Vector2d end_B, Vector2d Pnt)
{

    if ((end_A - end_B).norm() < 0.01) // if segment is a point
    {
        if ((Pnt - end_A).norm() < 0.01)
        {
            if_lies_on = true;
            return;
        }
        else
        {
            if_lies_on = false;
            return;
        }
    }

    point_type p(Pnt[0], Pnt[1]);

    segment_type EDGE_POLYGON{{end_A[0], end_A[1]},
                              {end_B[0], end_B[1]}};

    double distanceA = boost::geometry::distance(p, EDGE_POLYGON);

    if (distanceA < 0.01)
    {
        if_lies_on = true;
        return;   
    }

    if_lies_on = false;
};
