set terminal pngcairo size 1920,1080
set output 'padding-Split-12-Increment.png'
set title 'padding-Split-12-Increment'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'padding-Split-12-Increment.dat' index 0 title 'Split-12' with yerrorlines linewidth 2, \
     'padding-Split-12-Increment.dat' index 1 title 'Split-Pad-12' with yerrorlines linewidth 2
