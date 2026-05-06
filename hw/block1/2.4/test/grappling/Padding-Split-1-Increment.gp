set terminal pngcairo size 1920,1080
set output 'Padding-Split-1-Increment.png'
set title 'Padding-Split-1-Increment'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'Padding-Split-1-Increment.dat' index 0 title 'Split-01' with yerrorlines linewidth 2, \
     'Padding-Split-1-Increment.dat' index 1 title 'Split-Pad-01' with yerrorlines linewidth 2
