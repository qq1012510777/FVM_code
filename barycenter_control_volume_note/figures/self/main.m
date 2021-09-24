clc;
clear all;
close all;

Triangle1 = [2^0.5, 2^0.5;
        0, 0;
        2^0.5, -2^0.5];

Triangle2 = [0, -1;
        0, 0;
        2^0.5, -2^0.5];

Triangle3 = [-1, 0;
        0, 0;
        2^0.5, 2^0.5];

Triangle4 = [2^0.5, 2^0.5;
        2^0.5, -2^0.5;
        2 * 2^0.5, 0];

figure(1);
plot([Triangle1(:, 1); Triangle1(1, 1)], [Triangle1(:, 2); Triangle1(1, 2)], 'k-', 'linewidth', 2);
hold on;
plot([Triangle2(:, 1); Triangle2(1, 1)], [Triangle2(:, 2); Triangle2(1, 2)], 'k-', 'linewidth', 2);
hold on;
plot([Triangle3(:, 1); Triangle3(1, 1)], [Triangle3(:, 2); Triangle3(1, 2)], 'k-', 'linewidth', 2);
hold on;
plot([Triangle4(:, 1); Triangle4(1, 1)], [Triangle4(:, 2); Triangle4(1, 2)], 'k-', 'linewidth', 2);

f2 = figure(2);
center1 = center(Triangle1(1, :), Triangle1(2, :), Triangle1(3, :), 'barycenter');
center2 = center(Triangle2(1, :), Triangle2(2, :), Triangle2(3, :), 'barycenter');;
center3 = center(Triangle3(1, :), Triangle3(2, :), Triangle3(3, :), 'barycenter');;
center4 = center(Triangle4(1, :), Triangle4(2, :), Triangle4(3, :), 'barycenter');;
close(f2);

line1 = [center1'; center2'];
line2 = [center1'; center3'];
line3 = [center1'; center4'];

figure(1);
scatter(center1(1), center1(2), 'o', 'k', 'filled');
hold on;
text(center1(1), center1(2), '$P$', 'fontsize', 20, 'Interpreter', 'latex');
hold on;

scatter(center2(1), center2(2), 'o', 'k', 'filled');
hold on;
text(center2(1), center2(2), '$E_2$', 'fontsize', 20, 'Interpreter', 'latex');
hold on;

scatter(center3(1), center3(2), 'o', 'k', 'filled');
hold on;
text(center3(1), center3(2), '$E_1$', 'fontsize', 20, 'Interpreter', 'latex');
hold on;

scatter(center4(1), center4(2), 'o', 'k', 'filled');
hold on;
text(center4(1), center4(2), '$E_3$', 'fontsize', 20, 'Interpreter', 'latex');
hold on;

scatter(Triangle1(1, 1), Triangle1(1, 2), 'd', 'k', 'filled');
hold on;
text(Triangle1(1, 1), Triangle1(1, 2), '$v_1$', 'fontsize', 20, 'Interpreter', 'latex');
hold on;
scatter(Triangle1(2, 1), Triangle1(2, 2), 'd', 'k', 'filled');
hold on;
text(Triangle1(2, 1), Triangle1(2, 2), '$v_2$', 'fontsize', 20, 'Interpreter', 'latex');
hold on;
scatter(Triangle1(3, 1), Triangle1(3, 2), 'd', 'k', 'filled');
hold on;
text(Triangle1(3, 1), Triangle1(3, 2), '$v_3$', 'fontsize', 20, 'Interpreter', 'latex');
hold on;

plot(line1(:, 1), line1(:, 2), 'b--', 'linewidth', 2);
hold on;
plot(line2(:, 1), line2(:, 2), 'b--', 'linewidth', 2);
hold on;
plot(line3(:, 1), line3(:, 2), 'b--', 'linewidth', 2);
hold on;

%
% figure(1);
% plot(center_v(:, 1), center_v(:, 2), 'b--', 'linewidth', 2);
% hold on;
% text(0, 0, '$P$', 'fontsize', 20, 'Interpreter', 'latex');
% hold on;
% scatter(0, 0, 'o', 'k', 'filled');
% hold on;
% scatter(-1, 0, 'o', 'k', 'filled');
% hold on;
% scatter(2^0.5, 2^0.5, 'o', 'k', 'filled');
% hold on;
% scatter(2^0.5, -2^0.5, 'o', 'k', 'filled');
% hold on;
% scatter(0, -1, 'o', 'k', 'filled');
% hold on;
% text(-1, 0, '$E_1$', 'fontsize', 20, 'Interpreter', 'latex');
% hold on;
% text(2^0.5, 2^0.5, '$E_2$', 'fontsize', 20, 'Interpreter', 'latex');
% hold on;
% text(2^0.5, -2^0.5, '$E_3$', 'fontsize', 20, 'Interpreter', 'latex');
% hold on;
% text(0, -1, '$E_4$', 'fontsize', 20, 'Interpreter', 'latex');
% hold on;
% s1 = scatter(center_v(1:4, 1), center_v(1:4, 2), 'd', 'k');
% legend([s1], ['Barycenters'], 'fontsize', 15, 'Interpreter', 'latex');
% hold on;
% text(center_v(1:4, 1), center_v(1:4, 2), ['$v_1$'; '$v_2$'; '$v_3$'; '$v_4$'], 'fontsize', 15, 'Interpreter', 'latex')
