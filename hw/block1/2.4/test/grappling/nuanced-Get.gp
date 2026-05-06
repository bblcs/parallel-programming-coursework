set terminal pngcairo size 1920,1080
set output 'nuanced-Get.png'
set title 'nuanced-Get'
set xlabel 'Number of Threads'
set xtics (1, 2, 4, 8, 12, 24)
set ylabel 'Score'
set yrange [0:*]
set grid
plot 'nuanced-Get.dat' index 0 title 'Unfair' with yerrorlines linewidth 2, \
     'nuanced-Get.dat' index 1 title 'Fair' with yerrorlines linewidth 2, \
     'nuanced-Get.dat' index 2 title 'Split-01' with yerrorlines linewidth 2, \
     'nuanced-Get.dat' index 3 title 'Split-02' with yerrorlines linewidth 2, \
     'nuanced-Get.dat' index 4 title 'Split-12' with yerrorlines linewidth 2, \
     'nuanced-Get.dat' index 5 title 'Split-Alot' with yerrorlines linewidth 2, \
     'nuanced-Get.dat' index 6 title 'Split-Pad-01' with yerrorlines linewidth 2, \
     'nuanced-Get.dat' index 7 title 'Split-Pad-02' with yerrorlines linewidth 2, \
     'nuanced-Get.dat' index 8 title 'Split-Pad-12' with yerrorlines linewidth 2, \
     'nuanced-Get.dat' index 9 title 'Split-Pad-Alot' with yerrorlines linewidth 2
