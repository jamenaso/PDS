# -*- coding: utf-8 -*-
"""
Created on Thu Jul  9 20:37:41 2020

@author: Usuario
"""
import numpy as np

def generate_stimulus_signal(A,N,fs):
    #Por decto siempre trabajamos con frecuencia normalizada a 1Hz.
    fa = 0.05 #FRecuencia de 0.1 Nyquist para ejercicio 4
    #fa = 0.4 #FRecuencia de 0.8 Nyquist para ejercicio 4    
    ## Generamos una senoidal
    xx = np.linspace(0,N*fs,N,endpoint = False)
    #Señal DC con amplitud de 0.5
    #yy = A*np.full_like(xx, 1)
    #Señal sinusoidal con frecuencia Nyquist y amplitud de 0.5
    yy = A*np.sin(2*np.pi*(fa/fs)*xx) # fa = 0.25    
    #Señal sinusoidal con frecuencia Nyquist / 2 y amplitud de 0.5
    #yy = A*np.cos(2*np.pi*(fa/fs)*xx) # fa = 0.5
    return xx,yy

