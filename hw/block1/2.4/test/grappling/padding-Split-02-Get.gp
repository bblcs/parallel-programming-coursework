set terminal pngcairo size 1920,1080
set output 'padding-Split-02-Get.png'
set title 'padding-Split-02-Get'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'padding-Split-02-Get.dat' index 0 title 'Split-02' with yerrorlines linewidth 2, \
     'padding-Split-02-Get.dat' index 1 title 'Split-Pad-02' with yerrorlines linewidth 2
