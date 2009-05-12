# SCRIPT PARA ARREGLAR EL FORMATO DE UN FICHERO "hybrid.qc" DE CABOG Y UTILIZAR LOS DATOS DE LA TABLA QUE CONTIENE PARA REALIZAR UN PLOT DE DENSIDADES
# Noe Fernandez Pozo
# 21-ABRIL-2009

# para saber dónde están los datos
#setwd("/Users/Noe/Desktop/")

args=(commandArgs(true))

library(graphics)

print(args[1])


# para cargar la tabla del fichero pig_t.txt en el objeto datos
datos <- read.table(args[1], header = FALSE, sep = "", dec =".", skip = 19, strip.white = TRUE)
colnames(datos) <- cbind("d", "< 3kbp", "< 10kbp", "< 1Mbp", "< inf")

colx <- as.numeric(datos[,1])
col1 <- as.numeric(datos[,2])
col2 <- as.numeric(datos[,3])
col3 <- as.numeric(datos[,4])

x1 <- rep(colx, col1)
x2 <- rep(colx, col2)
x3 <- rep(colx, col3)

#imgWdw <- function(h=5, w=5){
#	get(getOption("device"))(height = h, width = w)
#}

#imgWdw(h=5, w=8)

#plot(density(x1, bw="sj"),col='blue')
# cambiando el valor del bw se consigue cambiar el aspecto de las curvas, 3 parece un valor medio

png(file="cabog_plot.png",type = "cairo1")
plot(density(x1, bw=3),col='black', xlab="depth", main="CaBog Density Plot")
lines(density(x2, bw=3),col='blue')
lines(density(x3, bw=3),col='red')
legend(x="topright", c("< 3kb", "< 10kb", "<1Mb"), text.col=c("black", "blue", "red"))
dev.off()

