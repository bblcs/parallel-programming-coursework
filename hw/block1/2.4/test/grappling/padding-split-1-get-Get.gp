set terminal pngcairo size 1920,1080
set output 'padding-split-1-get-Get.png'
set title 'padding-split-1-get-Get'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'padding-split-1-get-Get.dat' index 0 title 'Split-01' with yerrorlines linewidth 2, \
     'padding-split-1-get-Get.dat' index 1 title 'Split-Pad-01' with yerrorlines linewidth 2
