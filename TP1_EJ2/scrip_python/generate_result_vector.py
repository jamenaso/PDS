import numpy as np
import sk_dsp_comm.fec_conv as fec

def bitfield(n):
    return [int(digit) for digit in '{0:16b}'.format(n)] 

cc1 = fec.fec_conv(('1111001','1011011'))

state = '0000000'
result = np.array([],dtype=np.uint8)
int_array = np.array([0x8001,0x8002,0x8003,0x8004],dtype=np.uint64)
print("Para las Entradas:",)

for item in int_array:    
    print('0x' + hex(item)) 
for item in int_array:
    bit_array =  bitfield(item)
    bit_array = bit_array[::-1]
    y,state = cc1.conv_encoder(bit_array,state)
    y = np.packbits(y[::-1].astype(np.int64),bitorder = 'big')
    result = np.concatenate([result,y])

result = result.reshape(result.size//4,4).astype(dtype = np.int64)

print("\nSe obtiene las Salidas:")
for item in result:    
    print('0x' + hex(int.from_bytes(list(item),byteorder = 'big'))[2:].zfill(8)) 