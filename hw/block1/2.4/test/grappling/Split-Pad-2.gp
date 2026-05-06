set terminal pngcairo size 1920,1080
set output 'Split-Pad-2.png'
set title 'Split-Pad-2'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'Split-Pad-2.dat' index 0 title 'Increment' with yerrorlines linewidth 2, \
     'Split-Pad-2.dat' index 1 title 'Get' with yerrorlines linewidth 2
