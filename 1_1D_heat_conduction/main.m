% this code is finished by Tingchang Yin
clc;
close all
clear all;

% solve a 1D heat conduction problem
% equation: d(k * (dT/dx))/dx = 0
% k: conductivity, which is 1000 W/(m * K)
% a rod = 0.5 m, cross_section = 1 * 10^-2 m^2,
% left temperature Ta = 100 degree, right Tb = 500 degree

Model_len = 0.5;
k = 1000;
A = 1e-2;
TA = 100;
TB = 500;

% below is the meshing
NUM_ele = 5;

Ele_size = Model_len / NUM_ele;

Bound_eles = [1, NUM_ele]; % NO. 1 and NO. NUM_ele are boundary elements.

Element(1) = struct('x_min', 0, ...
    'x_max', Ele_size, ...
    'size', Ele_size, ...
    'center', Ele_size / 2);

for i = 2:1:NUM_ele
    Element(i).x_min = Element(i - 1).x_max;
    Element(i).x_max = Element(i).x_min + Ele_size;
    Element(i).size = Ele_size;
    Element(i).center = Element(i).x_min + Ele_size / 2;
end

% below is to initialize the matrix (for solve linear equations)
Matrix_A = zeros(NUM_ele, NUM_ele);
Matrix_B = zeros(NUM_ele, 1);

% assemble the matrix now
% for non-boundary elements first
for i = 2:1:NUM_ele - 1
    aw = k / (abs(Element(i - 1).center - Element(i).center)) * A;
    ae = k / (abs(Element(i).center - Element(i + 1).center)) * A;
    ap = aw + ae;
    Matrix_A(i, i - 1) = -aw;
    Matrix_A(i, i + 1) = -ae;
    Matrix_A(i, i) = ap;
end

% for left element
aw = 0;
ae = k / (abs(Element(1).center - Element(2).center)) * A;
ap = aw + ae + k / abs(Element(1).center - Element(1).x_min) * A;
su = k / abs(Element(1).center - Element(1).x_min) * A * TA;

Matrix_A(1, 1) = ap;
Matrix_A(1, 1 + 1) = -ae;
Matrix_B(1) = su;

% for right element
aw = k / (abs(Element(NUM_ele).center - Element(NUM_ele - 1).center)) * A;
ae = 0;
ap = aw + ae + k / abs(Element(NUM_ele).center - Element(NUM_ele).x_max) * A;
su = k / abs(Element(NUM_ele).center - Element(NUM_ele).x_max) * A * TB;

Matrix_A(NUM_ele, NUM_ele) = ap;
Matrix_A(NUM_ele, NUM_ele - 1) = -aw;
Matrix_B(NUM_ele) = su;

% solve the equations
Matrix_x = inv(Matrix_A) * Matrix_B;

% visulization
figure(1);
title('FVM solution of 1D head conduction')
xlabel('x(m)')
ylabel('Degree')
hold on;

x = [0:(Model_len - 0) / 100:Model_len];
y = x * 800 + 100;
exact_solution = plot(x, y, 'b-', 'linewidth', 2);
hold on;


for i = 1:1:NUM_ele
    x_s(i, 1) = Element(i).center;
    y_s(i, 1) = Matrix_x(i, 1);
end
s1 = scatter(x_s, y_s, 100, 'd');
hold on;
legend([s1, exact_solution],  'Numerical solution','Exact solution');