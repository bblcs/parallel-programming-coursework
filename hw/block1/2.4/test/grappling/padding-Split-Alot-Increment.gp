set terminal pngcairo size 1920,1080
set output 'padding-Split-Alot-Increment.png'
set title 'padding-Split-Alot-Increment'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'padding-Split-Alot-Increment.dat' index 0 title 'Split-Alot' with yerrorlines linewidth 2, \
     'padding-Split-Alot-Increment.dat' index 1 title 'Split-Pad-Alot' with yerrorlines linewidth 2
