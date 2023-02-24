# -*- coding: utf-8 -*-
###############################
# run_driver.py
#
# Desc: Running driver menggunakan format minimal tanpa threading
#
# Auth: Yose
# Date: 11 Mei 2021
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import configparser
import logging.config
import yaml
import socket
import sys
from datetime import datetime
import re
import time

from DB import MysqlPython
from my_db import my_db

VERSION = "0.0.1"

HOST = '192.168.11.183'
PORT = 4001

INF_HOST = '127.0.0.1'
INF_PORT = 5050


ENCODING = 'iso-8859-1'

NULL = b'\x00'
STX = b'\x02'
ETX = b'\x03'
EOT = b'\x04'
ENQ = b'\x05'
ACK = b'\x06'
NAK = b'\x15'
ETB = b'\x17'
LF  = b'\x0A'
CR  = b'\x0D'
CRLF = CR + LF

ETX_FREN = b'\x7F'

RCV_RESP = b'\x24\x40\x00\x01\x01\x42\x7F'

MY_HOST = '127.0.0.1'
MY_DB = 'avl_worklist'



def make_checksum(message):
    if not isinstance(message[0], int):
        message = map(ord, message)
    return hex(sum(message) & 0xFF)[2:].upper().zfill(2).encode()

def data_send(msg):
    logging.info('>>%s'%msg)
    msg = msg.encode(ENCODING)
    data = b''.join((str(1 % 8).encode(), msg, CR, ETX))
    data_tx = b''.join([STX, data, make_checksum(data), CR, LF])
    logging.info('data to TX:%s' % data_tx)
    return data_tx

def main():
    # read ini file
    config = configparser.ConfigParser()
    config.read('ISE9180.ini')
    HOST = config.get('General','HOST')
    PORT = config.get('General','PORT')
    INF_HOST = config.get('General','INF_HOST')
    INF_PORT = config.get('General','INF_PORT')
    MY_HOST = config.get('General','MY_HOST')
    logging.info('try to connect to infinity [%s:%s]' % (INF_HOST,INF_PORT))
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as inf:
        inf.connect((INF_HOST, int(INF_PORT)))
        while True:
            #select pending kirim yang sudah ada sample id dan status = 2
            connect_mysql = my_db(server=MY_HOST,db=MY_DB)
            SQL = 'SELECT DISTINCT r.sample_id FROM instrument_result r WHERE r.status = {status} and sample_id is not null'
            SQL = SQL.format(status='2')
            query_res = connect_mysql.my_select(SQL)
            if len(query_res)> 0:
                for sample_id in query_res:
                    try:
                        sid = sample_id[0]
                        logging.info('sid [%s]' % sid)
                        # kirim ke INFINITY
                        logging.info('START - Kirim ke INFINITY')
                        inf.send(ENQ)
                        inf_data = inf.recv(1024)
                        ts = datetime.utcnow().strftime('%Y%m%d%H%M%S')
                        inf.sendall(data_send('H|\^&|||SAT|||||||P|E·1394-97|'+ts))
                        inf_data = inf.recv(1024)
                        inf.sendall(data_send('P|1||||MX407N|||M||||||||||||||||||||||||||'))
                        inf_data = inf.recv(1024)
                        inf.sendall(data_send('O|1|'+str(sid)+'||^^^LMG|||'+ts+'|'+ts+'|||||||||||||||||F|||||'))
                        # get detail
                        SQL = "SELECT analyt_code,result_value from instrument_result WHERE sample_id = '{sample_id}' "
                        SQL = SQL.format(sample_id=sid)
                        res = connect_mysql.my_select(SQL)
                        i = 1
                        for r in res:
                            analyt_code = str(r[0]).strip()
                            result_value = str(r[1][:-2]).strip()
                            inf_data = inf.recv(1024)
                            inf.sendall(data_send('R|1|^^^'+str(analyt_code)+'^|'+str(result_value)+'|1||||F||labtech||'+ts+'|'))
                            i = i + 1
                        inf_data = inf.recv(1024)
                        inf.sendall(data_send('L|1|N'))
                        inf_data = inf.recv(1024)
                        inf.send(EOT)
                        logging.info('END - Kirim ke INFINITY')
                        SQL = "UPDATE instrument_result set status = 1 WHERE sample_id = '{sample_id}' "
                        SQL = SQL.format(sample_id=sid)
                        connect_mysql.my_update(SQL)
                        
                    except Exception as e:
                        logging.error('gagal send ke infinity [%s]' % str(e))
                        pass


            logging.debug('sleep 2 secs.')
            time.sleep(2)
        

if __name__ == "__main__":
    with open('INF_RESULT.yaml', 'rt') as f:
        config = yaml.safe_load(f.read())
        logging.config.dictConfig(config)
    logging.info('Starting program [%s]' % str(VERSION))
    main()
