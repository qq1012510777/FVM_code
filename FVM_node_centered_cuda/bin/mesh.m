clc;
clear all;
close all;
JM = [	15, 16, 25
	22, 18, 23
	19, 21, 27
	5, 22, 23
	19, 12, 24
	11, 19, 27
	16, 20, 25
	21, 19, 28
	19, 24, 25
	17, 18, 22
	18, 1, 23
	2, 5, 23
	24, 15, 25
	20, 17, 22
	12, 13, 24
	10, 11, 27
	14, 13, 4
	9, 3, 10
	20, 22, 26
	13, 14, 24
	9, 10, 27
	11, 12, 19
	19, 25, 28
	16, 17, 20
	5, 6, 22
	6, 7, 26
	22, 6, 26
	7, 8, 21
	7, 21, 26
	14, 15, 24
	8, 9, 27
	21, 8, 27
	25, 20, 28
	20, 26, 28
	26, 21, 28
	1, 2, 23
];
JXY = [	45, 0
	55, 0
	100, 100
	0, 100
	62.5, 16.6667
	70, 33.3333
	77.5, 50
	85, 66.6667
	92.5, 83.3333
	80, 100
	60, 100
	40, 100
	20, 100
	7.5, 83.3333
	15, 66.6667
	22.5, 50
	30, 33.3333
	37.5, 16.6667
	51.0956, 79.4877
	42.4142, 48.5976
	66.8162, 64.8285
	50.2472, 29.3457
	50.0494, 12.5358
	28.6933, 82.7896
	35.3319, 64.8145
	59.8776, 47.9084
	72.5686, 82.386
	51.1071, 61.1274
];
Centers = [	24.2773, 60.4937
	45.9322, 19.516
	63.4935, 75.5674
	54.2655, 19.516
	39.9296, 87.4258
	61.2214, 87.2913
	33.4153, 54.4707
	56.3396, 68.4812
	38.3736, 75.6973
	39.2491, 26.4486
	44.1831, 9.73416
	55.8498, 9.73416
	26.3417, 71.4236
	40.8871, 37.0922
	29.5644, 94.2632
	70.8562, 94.1287
	9.16667, 94.4444
	90.8333, 94.4444
	50.8463, 41.9506
	18.7311, 88.7076
	81.6895, 88.5731
	50.3652, 93.1626
	45.8448, 68.4765
	31.6381, 43.977
	60.9157, 26.4486
	69.1259, 43.7472
	60.0416, 36.8625
	76.4387, 60.4984
	68.0646, 54.2456
	17.0644, 77.5965
	83.3562, 77.462
	74.795, 71.2937
	42.951, 58.1798
	51.133, 52.5445
	59.267, 57.9548
	50.0165, 4.1786
];
Control_volume(1) = struct('adj_ele', [0]);
Control_volume(1).adj_ele = [ 0 ];
Control_volume(2).adj_ele = [ 0 ];
Control_volume(3).adj_ele = [ 0 ];
Control_volume(4).adj_ele = [ 0 ];
Control_volume(5).adj_ele = [ 0 ];
Control_volume(6).adj_ele = [ 0 ];
Control_volume(7).adj_ele = [ 0 ];
Control_volume(8).adj_ele = [ 0 ];
Control_volume(9).adj_ele = [ 0 ];
Control_volume(10).adj_ele = [ 0 ];
Control_volume(11).adj_ele = [ 0 ];
Control_volume(12).adj_ele = [ 0 ];
Control_volume(13).adj_ele = [ 0 ];
Control_volume(14).adj_ele = [ 0 ];
Control_volume(15).adj_ele = [ 0 ];
Control_volume(16).adj_ele = [ 0 ];
Control_volume(17).adj_ele = [ 0 ];
Control_volume(18).adj_ele = [ 0 ];
Control_volume(19).adj_ele = [3, 6, 22, 5, 9, 23, 8, ];
Control_volume(20).adj_ele = [7, 24, 14, 19, 34, 33, ];
Control_volume(21).adj_ele = [3, 8, 35, 29, 28, 32, ];
Control_volume(22).adj_ele = [2, 4, 25, 27, 19, 14, 10, ];
Control_volume(23).adj_ele = [2, 11, 36, 12, 4, ];
Control_volume(24).adj_ele = [5, 15, 20, 30, 13, 9, ];
Control_volume(25).adj_ele = [1, 7, 33, 23, 9, 13, ];
Control_volume(26).adj_ele = [19, 27, 26, 29, 35, 34, ];
Control_volume(27).adj_ele = [3, 32, 31, 21, 16, 6, ];
Control_volume(28).adj_ele = [8, 23, 33, 34, 35, ];

Boundary_control_volume(1) = struct('vertice', [0]);
Boundary_control_volume(1).vertice = [  41.25 8.33333; 45  0; 50  0; 50.0165  4.1786; 44.1831 9.73416; ];
Boundary_control_volume(2).vertice = [50.0165  4.1786; 50  0; 55  0;   58.75 8.33333; 55.8498 9.73416; ];
Boundary_control_volume(3).vertice = [  96.25 91.6667; 100 100;  90 100; 90.8333 94.4444; ];
Boundary_control_volume(4).vertice = [ 10 100;   0 100;    3.75 91.6667; 9.16667 94.4444; ];
Boundary_control_volume(5).vertice = [55.8498 9.73416;   58.75 8.33333;    62.5 16.6667; 66.25    25; 60.9157 26.4486; 54.2655  19.516; ];
Boundary_control_volume(6).vertice = [66.25    25;      70 33.3333;   73.75 41.6667; 69.1259 43.7472; 60.0416 36.8625; 60.9157 26.4486; ];
Boundary_control_volume(7).vertice = [  73.75 41.6667; 77.5   50;   81.25 58.3333; 76.4387 60.4984; 68.0646 54.2456; 69.1259 43.7472; ];
Boundary_control_volume(8).vertice = [  81.25 58.3333;      85 66.6667; 88.75    75; 83.3562  77.462;  74.795 71.2937; 76.4387 60.4984; ];
Boundary_control_volume(9).vertice = [81.6895 88.5731; 83.3562  77.462; 88.75    75;    92.5 83.3333;   96.25 91.6667; 90.8333 94.4444; ];
Boundary_control_volume(10).vertice = [81.6895 88.5731; 90.8333 94.4444;  90 100;  80 100;  70 100; 70.8562 94.1287; ];
Boundary_control_volume(11).vertice = [70.8562 94.1287;  70 100;  60 100;  50 100; 50.3652 93.1626; 61.2214 87.2913; ];
Boundary_control_volume(12).vertice = [50.3652 93.1626;  50 100;  40 100;  30 100; 29.5644 94.2632; 39.9296 87.4258; ];
Boundary_control_volume(13).vertice = [ 30 100;  20 100;  10 100; 9.16667 94.4444; 18.7311 88.7076; 29.5644 94.2632; ];
Boundary_control_volume(14).vertice = [   3.75 91.6667;     7.5 83.3333; 11.25    75; 17.0644 77.5965; 18.7311 88.7076; 9.16667 94.4444; ];
Boundary_control_volume(15).vertice = [26.3417 71.4236; 17.0644 77.5965; 11.25    75;      15 66.6667;   18.75 58.3333; 24.2773 60.4937; ];
Boundary_control_volume(16).vertice = [  18.75 58.3333; 22.5   50;   26.25 41.6667; 31.6381  43.977; 33.4153 54.4707; 24.2773 60.4937; ];
Boundary_control_volume(17).vertice = [40.8871 37.0922; 31.6381  43.977;   26.25 41.6667;      30 33.3333; 33.75    25; 39.2491 26.4486; ];
Boundary_control_volume(18).vertice = [39.2491 26.4486; 33.75    25;    37.5 16.6667;   41.25 8.33333; 44.1831 9.73416; 45.9322  19.516; ];
Boundary_control_volume(19).vertice = [ 0 ];
Boundary_control_volume(20).vertice = [ 0 ];
Boundary_control_volume(21).vertice = [ 0 ];
Boundary_control_volume(22).vertice = [ 0 ];
Boundary_control_volume(23).vertice = [ 0 ];
Boundary_control_volume(24).vertice = [ 0 ];
Boundary_control_volume(25).vertice = [ 0 ];
Boundary_control_volume(26).vertice = [ 0 ];
Boundary_control_volume(27).vertice = [ 0 ];
Boundary_control_volume(28).vertice = [ 0 ];

Point_type = [	0, 1, 1, 0
	0, 1, 0, 1
	1, 0, 0, 1
	1, 0, 1, 0
	0, 0, 0, 1
	0, 0, 0, 1
	0, 0, 0, 1
	0, 0, 0, 1
	0, 0, 0, 1
	1, 0, 0, 0
	1, 0, 0, 0
	1, 0, 0, 0
	1, 0, 0, 0
	0, 0, 1, 0
	0, 0, 1, 0
	0, 0, 1, 0
	0, 0, 1, 0
	0, 0, 1, 0
	0, 0, 0, 0
	0, 0, 0, 0
	0, 0, 0, 0
	0, 0, 0, 0
	0, 0, 0, 0
	0, 0, 0, 0
	0, 0, 0, 0
	0, 0, 0, 0
	0, 0, 0, 0
	0, 0, 0, 0
];

Shared_edge = [	1, 7, 16, 25;
	1, 13, 15, 25;
	2, 4, 22, 23;
	2, 10, 18, 22;
	2, 11, 18, 23;
	3, 6, 19, 27;
	3, 8, 19, 21;
	3, 32, 21, 27;
	4, 12, 5, 23;
	4, 25, 5, 22;
	5, 9, 19, 24;
	5, 15, 12, 24;
	5, 22, 12, 19;
	6, 16, 11, 27;
	6, 22, 11, 19;
	7, 24, 16, 20;
	7, 33, 20, 25;
	8, 23, 19, 28;
	8, 35, 21, 28;
	9, 13, 24, 25;
	9, 23, 19, 25;
	10, 14, 17, 22;
	11, 36, 1, 23;
	12, 36, 2, 23;
	13, 30, 15, 24;
	14, 19, 20, 22;
	14, 24, 17, 20;
	15, 20, 13, 24;
	16, 21, 10, 27;
	17, 20, 13, 14;
	18, 21, 9, 10;
	19, 27, 22, 26;
	19, 34, 20, 26;
	20, 30, 14, 24;
	21, 31, 9, 27;
	23, 33, 25, 28;
	25, 27, 6, 22;
	26, 27, 6, 26;
	26, 29, 7, 26;
	28, 29, 7, 21;
	28, 32, 8, 21;
	29, 35, 21, 26;
	31, 32, 8, 27;
	33, 34, 20, 28;
	34, 35, 26, 28;
];

figure(2)
[m, ~] = size(JXY);
P = patch('Vertices', JXY, 'Faces', JM, 'FaceVertexCData', zeros(m, 1), 'FaceColor', 'interp', 'EdgeAlpha', 0.9, 'facealpha', 0);
hold on;
for i = 1:1:45
	IO = [rand rand rand];
	PNT1 = [Centers(Shared_edge(i, 1), :); Centers(Shared_edge(i, 2), :)];
	PNT2 = [JXY(Shared_edge(i, 3), :); JXY(Shared_edge(i, 4), :)];
	plot(PNT1(:, 1)', PNT1(:, 2)', '-', 'color', IO);hold on;
	plot(PNT2(:, 1)', PNT2(:, 2)', '-', 'color', IO);hold on;
end
figure(1)
[m, ~] = size(JXY);
P = patch('Vertices', JXY, 'Faces', JM, 'FaceVertexCData', zeros(m, 1), 'FaceColor', 'interp', 'EdgeAlpha', 0.9, 'facealpha', 0);
hold on;
[k, ~] = size(Centers);
for i = 1:k
	text(Centers(i, 1), Centers(i, 2), num2str(i));
	hold on;
end
for i = 1:28
	text(JXY(i, 1), JXY(i, 2), num2str(i));
end
for i = 1:1:28
	[~, m] = size(Control_volume(i).adj_ele);
	if (Point_type(i, 1) ~= 1 && Point_type(i, 2) ~= 1 && Point_type(i, 3) ~= 1 && Point_type(i, 4) ~= 1)
		for j = 1:1:m
			Centers_k(j, :) = Centers(Control_volume(i).adj_ele(j), :);
		end
		plot([Centers_k(:, 1); Centers_k(1, 1)], [Centers_k(:, 2); Centers_k(1, 2)]); hold on;
		clear Centers_k;
	else
		[m, ~] = size(Boundary_control_volume(i).vertice);
		for j = 1:1:m
			Centers_k = [Boundary_control_volume(i).vertice(:, :); Boundary_control_volume(i).vertice(1, :)];
		end
		plot([Centers_k(:, 1)], [Centers_k(:, 2)]); hold on;
		clear Centers_k;
	end
end

hold on;
YT = [rand rand rand];
plot(43.125, 4.16667, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(47.5, 0, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([55, 45], [0, 0], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(45, 0, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([50.0494, 45], [12.5358, 0], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(45, 0, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([37.5, 45], [16.6667, 0], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(45, 0, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([45, 55], [0, 0], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(55, 0, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(52.5, 0, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(56.875, 4.16667, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([62.5, 55], [16.6667, 0], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(55, 0, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([50.0494, 55], [12.5358, 0], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(55, 0, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(98.125, 95.8333, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(95, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([92.5, 100], [83.3333, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(100, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([92.5, 100], [83.3333, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(100, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(5, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(1.875, 95.8333, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([7.5, 0], [83.3333, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(0, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([7.5, 0], [83.3333, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(0, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([55, 62.5], [0, 16.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(62.5, 16.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(60.625, 12.5, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(64.375, 20.8333, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([70, 62.5], [33.3333, 16.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(62.5, 16.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([50.2472, 62.5], [29.3457, 16.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(62.5, 16.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([50.0494, 62.5], [12.5358, 16.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(62.5, 16.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(68.125, 29.1667, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(71.875, 37.5, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([77.5, 70], [50, 33.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(70, 33.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([59.8776, 70], [47.9084, 33.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(70, 33.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([50.2472, 70], [29.3457, 33.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(70, 33.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([62.5, 70], [16.6667, 33.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(70, 33.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(75.625, 45.8333, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(79.375, 54.1667, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([85, 77.5], [66.6667, 50], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(77.5, 50, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([66.8162, 77.5], [64.8285, 50], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(77.5, 50, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([59.8776, 77.5], [47.9084, 50], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(77.5, 50, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([70, 77.5], [33.3333, 50], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(77.5, 50, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(83.125, 62.5, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(86.875, 70.8333, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([92.5, 85], [83.3333, 66.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(85, 66.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([72.5686, 85], [82.386, 66.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(85, 66.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([66.8162, 85], [64.8285, 66.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(85, 66.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([77.5, 85], [50, 66.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(85, 66.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([72.5686, 92.5], [82.386, 83.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(92.5, 83.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([85, 92.5], [66.6667, 83.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(92.5, 83.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(90.625, 79.1667, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(94.375, 87.5, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([100, 92.5], [100, 83.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(92.5, 83.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([80, 92.5], [100, 83.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(92.5, 83.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([92.5, 80], [83.3333, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(80, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([100, 80], [100, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(80, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(85, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(75, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([60, 80], [100, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(80, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([72.5686, 80], [82.386, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(80, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([80, 60], [100, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(60, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(65, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(55, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([40, 60], [100, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(60, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([51.0956, 60], [79.4877, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(60, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([72.5686, 60], [82.386, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(60, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([60, 40], [100, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(40, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(45, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(35, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([20, 40], [100, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(40, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([28.6933, 40], [82.7896, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(40, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([51.0956, 40], [79.4877, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(40, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(25, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(15, 100, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([0, 20], [100, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(20, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([7.5, 20], [83.3333, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(20, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([28.6933, 20], [82.7896, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(20, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([40, 20], [100, 100], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(20, 100, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(5.625, 87.5, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(9.375, 79.1667, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([15, 7.5], [66.6667, 83.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(7.5, 83.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([28.6933, 7.5], [82.7896, 83.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(7.5, 83.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([20, 7.5], [100, 83.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(7.5, 83.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([0, 7.5], [100, 83.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(7.5, 83.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([28.6933, 15], [82.7896, 66.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(15, 66.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([7.5, 15], [83.3333, 66.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(15, 66.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(13.125, 70.8333, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(16.875, 62.5, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([22.5, 15], [50, 66.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(15, 66.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([35.3319, 15], [64.8145, 66.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(15, 66.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(20.625, 54.1667, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(24.375, 45.8333, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([30, 22.5], [33.3333, 50], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(22.5, 50, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([42.4142, 22.5], [48.5976, 50], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(22.5, 50, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([35.3319, 22.5], [64.8145, 50], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(22.5, 50, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([15, 22.5], [66.6667, 50], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(22.5, 50, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([42.4142, 30], [48.5976, 33.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(30, 33.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([22.5, 30], [50, 33.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(30, 33.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(28.125, 37.5, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(31.875, 29.1667, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([37.5, 30], [16.6667, 33.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(30, 33.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([50.2472, 30], [29.3457, 33.3333], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(30, 33.3333, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([30, 37.5], [33.3333, 16.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(37.5, 16.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(35.625, 20.8333, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot(39.375, 12.5, 'o', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([45, 37.5], [0, 16.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(37.5, 16.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([50.0494, 37.5], [12.5358, 16.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(37.5, 16.6667, '^', 'color', YT);
hold on;
hold on;
YT = [rand rand rand];
plot([50.2472, 37.5], [29.3457, 16.6667], '-', 'color', YT, 'linewidth', 2);
hold on;
plot(37.5, 16.6667, '^', 'color', YT);
hold on;


figure(3)
[m, ~] = size(JXY);
P = patch('Vertices', JXY, 'Faces', JM, 'FaceVertexCData', zeros(m, 1), 'FaceColor', 'interp', 'EdgeAlpha', 0.9, 'facealpha', 0);
hold on;
for i = 1:1:28
	[~, m] = size(Control_volume(i).adj_ele);
	if (Point_type(i, 1) ~= 1 && Point_type(i, 2) ~= 1 && Point_type(i, 3) ~= 1 && Point_type(i, 4) ~= 1)
		for j = 1:1:m
			Centers_k(j, :) = Centers(Control_volume(i).adj_ele(j), :);
		end
		plot([Centers_k(:, 1); Centers_k(1, 1)], [Centers_k(:, 2); Centers_k(1, 2)]); hold on;
		clear Centers_k;
	else
		[m, ~] = size(Boundary_control_volume(i).vertice);
		for j = 1:1:m
			Centers_k = [Boundary_control_volume(i).vertice(:, :); Boundary_control_volume(i).vertice(1, :)];
		end
		plot([Centers_k(:, 1)], [Centers_k(:, 2)]); hold on;
		clear Centers_k;
	end
end

Normal_vector = [	 43.125 4.16667, 0.911922 0.410365;
	47.5    0, -0  1;
	50.0082  2.0893,  -0.999992 0.00394394;
	47.0998 6.95638, -0.689655 -0.724138;
	42.7166 9.03374,  0.430958 -0.902372;
	50.0082  2.0893,    0.999992 -0.00394394;
	52.5    0, -0  1;
	 56.875 4.16667, -0.911922  0.410365;
	57.2999 9.03374, -0.434934 -0.900463;
	52.9331 6.95638,  0.689655 -0.724138;
	 98.125 95.8333, -0.911922  0.410365;
	 95 100, -0 -1;
	90.4167 97.2222, 0.988936  0.14834;
	93.5417 93.0556, 0.456317 0.889817;
	  5 100, -0 -1;
	  1.875 95.8333, 0.911922 0.410365;
	6.45833 93.0556, -0.456317  0.889817;
	9.58333 97.2222, -0.988936   0.14834;
	57.2999 9.03374, 0.434934 0.900463;
	60.625   12.5, -0.911922  0.410365;
	 64.375 20.8333, -0.911922  0.410365;
	63.5829 25.7243, -0.262066  -0.96505;
	57.5906 22.9823, 0.721649 -0.69226;
	55.0577 14.6251, 0.987137 0.159876;
	 68.125 29.1667, -0.911922  0.410365;
	71.875   37.5, -0.911922  0.410365;
	71.4379  42.707,  -0.41032 -0.911942;
	64.5837 40.3049,  0.604011 -0.796976;
	60.4787 31.6555,  0.996496 0.0836442;
	63.5829 25.7243, 0.262066  0.96505;
	 75.625 45.8333, -0.911922  0.410365;
	 79.375 54.1667, -0.911922  0.410365;
	78.8444 59.4159, -0.410365 -0.911922;
	72.2517  57.372,  0.598294 -0.801277;
	68.5952 48.9964,  0.99493 0.100575;
	71.4379  42.707,  0.41032 0.911942;
	83.125   62.5, -0.911922  0.410365;
	 86.875 70.8333, -0.911922  0.410365;
	86.0531  76.231, -0.415241 -0.909711;
	79.0756 74.3779,  0.584565 -0.811347;
	75.6169 65.8961, 0.988605 0.150533;
	78.8444 59.4159, 0.410365 0.911922;
	82.5229 83.0176, 0.988936  0.14834;
	86.0531  76.231, 0.415241 0.909711;
	 90.625 79.1667, -0.911922  0.410365;
	94.375   87.5, -0.911922  0.410365;
	93.5417 93.0556, -0.456317 -0.889817;
	86.2614 91.5088,  0.540313 -0.841464;
	86.2614 91.5088, -0.540313  0.841464;
	90.4167 97.2222, -0.988936  -0.14834;
	 85 100, -0 -1;
	 75 100, -0 -1;
	70.4281 97.0643, 0.989534 0.144303;
	76.2729 91.3509, 0.456317 0.889817;
	70.4281 97.0643, -0.989534 -0.144303;
	 65 100, -0 -1;
	 55 100, -0 -1;
	50.1826 96.5813,  0.998577 0.0533336;
	55.7933 90.2269, 0.475711 0.879602;
	66.0388   90.71, -0.578736  0.815515;
	50.1826 96.5813,  -0.998577 -0.0533336;
	 45 100, -0 -1;
	 35 100, -0 -1;
	29.7822 97.1316,    0.99713 -0.0757045;
	 34.747 90.8445,  0.55064 0.834743;
	45.1474 90.2942, -0.481741  0.876314;
	 25 100, -0 -1;
	 15 100, -0 -1;
	9.58333 97.2222, 0.988936 -0.14834;
	13.9489  91.576, 0.514373 0.857567;
	24.1478 91.4854, -0.456317  0.889817;
	29.7822 97.1316,  -0.99713 0.0757045;
	5.625  87.5, 0.911922 0.410365;
	  9.375 79.1667, 0.911922 0.410365;
	14.1572 76.2983, -0.407755  0.913091;
	17.8978 83.1521, -0.988936   0.14834;
	13.9489  91.576, -0.514373 -0.857567;
	6.45833 93.0556,  0.456317 -0.889817;
	21.7031 74.5101,  -0.55396 -0.832543;
	14.1572 76.2983,  0.407755 -0.913091;
	 13.125 70.8333, 0.911922 0.410365;
	16.875   62.5, 0.911922 0.410365;
	21.5136 59.4135, -0.364039  0.931384;
	25.3095 65.9587, -0.982625    0.1856;
	 20.625 54.1667, 0.911922 0.410365;
	 24.375 45.8333, 0.911922 0.410365;
	 28.944 42.8218, -0.394084  0.919074;
	32.5267 49.2238, -0.985959  0.166989;
	28.8463 57.4822, -0.550327 -0.834949;
	21.5136 59.4135,  0.364039 -0.931384;
	36.2626 40.5346, -0.597108 -0.802161;
	 28.944 42.8218,  0.394084 -0.919074;
	28.125   37.5, 0.911922 0.410365;
	 31.875 29.1667, 0.911922 0.410365;
	36.4995 25.7243, -0.254729  0.967012;
	40.0681 31.7704, -0.988364   0.15211;
	36.4995 25.7243,  0.254729 -0.967012;
	 35.625 20.8333, 0.911922 0.410365;
	39.375   12.5, 0.911922 0.410365;
	42.7166 9.03374, -0.430958  0.902372;
	45.0577 14.6251, -0.984387  0.176015;
	42.5906 22.9823, -0.719936  -0.69404;
	62.3574 81.4293, -0.981734  -0.19026;
	55.7933 90.2269, -0.475711 -0.879602;
	45.1474 90.2942,  0.481741 -0.876314;
	39.1516 81.5615, 0.991314 -0.13152;
	42.1092 72.0869,  0.69495 0.719059;
	51.0922 68.4789, -0.000445636            1;
	59.9166 72.0243, -0.703741  0.710456;
	32.5267 49.2238,  0.985959 -0.166989;
	36.2626 40.5346, 0.597108 0.802161;
	45.8667 39.5214, -0.438439  0.898761;
	50.9897 47.2475, -0.999634 0.0270462;
	 47.042 55.3621, -0.567232 -0.823558;
	38.1832 56.3253,  0.362513 -0.931979;
	59.9166 72.0243,  0.703741 -0.710456;
	57.8033  63.218, 0.963439 0.267928;
	63.6658 56.1002, 0.388488 0.921454;
	72.2517  57.372, -0.598294  0.801277;
	75.6169 65.8961, -0.988605 -0.150533;
	69.1442 73.4306, -0.353708 -0.935356;
	50.0989  19.516, 6.00053e-12           1;
	57.5906 22.9823, -0.721649   0.69226;
	60.4787 31.6555,  -0.996496 -0.0836442;
	 55.444 39.4065, -0.484159  -0.87498;
	45.8667 39.5214,  0.438439 -0.898761;
	40.0681 31.7704, 0.988364 -0.15211;
	42.5906 22.9823, 0.719936  0.69404;
	45.0577 14.6251,  0.984387 -0.176015;
	47.0998 6.95638, 0.689655 0.724138;
	52.9331 6.95638, -0.689655  0.724138;
	55.0577 14.6251, -0.987137 -0.159876;
	50.0989  19.516, -6.00053e-12           -1;
	 34.747 90.8445,  -0.55064 -0.834743;
	24.1478 91.4854,  0.456317 -0.889817;
	17.8978 83.1521, 0.988936 -0.14834;
	21.7031 74.5101,  0.55396 0.832543;
	32.3577 73.5604, -0.334711  0.942321;
	39.1516 81.5615, -0.991314   0.13152;
	28.8463 57.4822, 0.550327 0.834949;
	38.1832 56.3253, -0.362513  0.931979;
	44.3979 63.3282, -0.962704  0.270558;
	42.1092 72.0869,  -0.69495 -0.719059;
	32.3577 73.5604,  0.334711 -0.942321;
	25.3095 65.9587, 0.982625  -0.1856;
	 55.444 39.4065, 0.484159  0.87498;
	64.5837 40.3049, -0.604011  0.796976;
	68.5952 48.9964,  -0.99493 -0.100575;
	63.6658 56.1002, -0.388488 -0.921454;
	   55.2 55.2496,  0.553823 -0.832634;
	50.9897 47.2475,   0.999634 -0.0270462;
	69.1442 73.4306, 0.353708 0.935356;
	79.0756 74.3779, -0.584565  0.811347;
	82.5229 83.0176, -0.988936  -0.14834;
	76.2729 91.3509, -0.456317 -0.889817;
	66.0388   90.71,  0.578736 -0.815515;
	62.3574 81.4293, 0.981734  0.19026;
	51.0922 68.4789, 0.000445636          -1;
	44.3979 63.3282,  0.962704 -0.270558;
	 47.042 55.3621, 0.567232 0.823558;
	   55.2 55.2496, -0.553823  0.832634;
	57.8033  63.218, -0.963439 -0.267928;
];
quiver(Normal_vector(:, 1), Normal_vector(:, 2), Normal_vector(:, 3), Normal_vector(:, 4), 'AutoScaleFactor', 0.6, 'Linewidth', 2);
hold on
[k, ~] = size(Centers);
for i = 1:k
	text(Centers(i, 1), Centers(i, 2), num2str(i));
	hold on;
end
for i = 1:28
	text(JXY(i, 1), JXY(i, 2), num2str(i));
end
