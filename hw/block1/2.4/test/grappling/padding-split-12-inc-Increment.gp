set terminal pngcairo size 1920,1080
set output 'padding-split-12-inc-Increment.png'
set title 'padding-split-12-inc-Increment'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'padding-split-12-inc-Increment.dat' index 0 title 'Split-12' with yerrorlines linewidth 2, \
     'padding-split-12-inc-Increment.dat' index 1 title 'Split-Pad-12' with yerrorlines linewidth 2
