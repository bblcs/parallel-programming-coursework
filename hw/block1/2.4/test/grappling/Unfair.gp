set terminal pngcairo size 1920,1080
set output 'Unfair.png'
set title 'Unfair'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'Unfair.dat' index 0 title 'Increment' with yerrorlines linewidth 2, \
     'Unfair.dat' index 1 title 'Get' with yerrorlines linewidth 2
