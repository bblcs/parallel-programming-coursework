set terminal pngcairo size 1920,1080
set output 'Padding-Split-Alot-Get.png'
set title 'Padding-Split-Alot-Get'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'Padding-Split-Alot-Get.dat' index 0 title 'Split-Alot' with yerrorlines linewidth 2, \
     'Padding-Split-Alot-Get.dat' index 1 title 'Split-Pad-Alot' with yerrorlines linewidth 2
