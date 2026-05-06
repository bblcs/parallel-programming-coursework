set terminal pngcairo size 1920,1080
set output 'Split-Pad-1.png'
set title 'Pad-no-pad-1'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'Pad-no-pad-1.dat' index 0 title 'Increment' with yerrorlines linewidth 2, \
     'Pad-no-pad-1.dat' index 1 title 'Get' with yerrorlines linewidth 2
