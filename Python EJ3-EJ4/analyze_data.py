from fxpoint._fixedInt import DeFixedInt
from fxpoint._fixedInt import arrayFixedInt
import matplotlib.pyplot as plt
from scipy import signal
import numpy as np
from generate_stimulus_signal import *

#Se describe los polinomios.
b = [1,-1,1,1]    
a = [1,-0.5,-0.25]

#Polos y ceros
p = np.roots(a)
z = np.roots(b)

#Se replica el esimulo con el generó la información de exitación del sistema.
[xx,yy] = generate_stimulus_signal(0.25,20,0.1)
output_simulation_file = "data_out.txt"

#Con el archivo generado con el tertbench se generar una señal
#Utilizamos csv porque ya podemos usar direcamente todo lo que corresponde a archivos separados por comas.
import csv

#En este punto se ingresa una palabra con presición Q1.7 y como salida se tiene Q4.7.
output_fp = np.array([],dtype = np.int64)
with open(output_simulation_file) as csvfile:
    reader = csv.reader(csvfile, delimiter=' ')
    for row in reader:
        output_fp = np.append(output_fp,np.array(row[0],dtype = np.int64))
#Como como salida se tiene una maxima presicion de Q4.7
#Aca hacemos la convversión para poder pasarlo y verlos en la misma escala.
output_float = (output_fp / 2**7)
print(output_float.size)
plt.plot(xx,yy ,'g')
plt.plot(xx,output_float,'ro')
plt.plot(xx,output_float ,'b')
plt.grid()