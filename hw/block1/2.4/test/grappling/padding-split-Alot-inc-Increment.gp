set terminal pngcairo size 1920,1080
set output 'padding-split-Alot-inc-Increment.png'
set title 'padding-split-Alot-inc-Increment'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'padding-split-Alot-inc-Increment.dat' index 0 title 'Split-Alot' with yerrorlines linewidth 2, \
     'padding-split-Alot-inc-Increment.dat' index 1 title 'Split-Pad-Alot' with yerrorlines linewidth 2
