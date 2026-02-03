import socket
import struct
import time
import os
import pandas as pd

from threading import Thread

HOST = '0.0.0.0'  # Aceitar conexões de qualquer IP
PORT = 12346
BUFFER_SIZE = 10 * 1024 * 1024  # 10 MB de buffer


count = 0
arquivo = 0
file_path = f'data_345.csv'


def save_to_file(data, filename):
    if(data == ''):
        return

    with open(filename, 'a') as f:
        f.write(data)

def save_to_parquet(filename):
    df = pd.read_csv(filename, header=None, names=['x', 'y', 'z'])
    df.to_parquet(filename.replace('.csv', '.parquet'), index=False)
    print(f'Dados salvos em .parquet: {filename.replace(".csv", ".parquet")}')

def process_data(message):
    global file_path
    global arquivo
    data_to_save = ''

    for i in range(0, len(message), 6):
        if i + 5 < len(message):  # Garantir que haja pelo menos 6 bytes para processar
            # Desempacotar os dados usando a estrutura apropriada
            x, y, z = struct.unpack('<hhh', message[i:i + 6])  # '>' para big-endian, 'h' para short
            # Dividir por 100 para recuperar a precisão original
            x /= 100
            y /= 100
            z /= 100

            data_to_save += f'{x};{y};{z}\n'

            global count
            count += 1

            if(count >= 600000):
                save_to_file(data_to_save, file_path)
                save_to_parquet(file_path)
                data_to_save=''
                count=0
                arquivo+=1
                file_path = f'data_{arquivo}.csv'
                break
    
    Thread(target=save_to_file, args=(data_to_save, file_path)).start()


if __name__ == '__main__':
    # Criar socket UDP
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_socket.bind((HOST, PORT))
    print(f'Servidor UDP rodando em {HOST}:{PORT}')

    try:
        while True:
            message, address = server_socket.recvfrom(BUFFER_SIZE)
            print(f'Dados recebidos de {address[0]}:{address[1]}')
            process_data(message)

            if(arquivo == 1):
                break
    except KeyboardInterrupt:
        print('Servidor encerrado.')
    finally:
        server_socket.close()
    
