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

# kode Na = 100 , K= 105, cl = 110

from DB import MysqlPython

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


def proses_hasil(msg):
    logging.info('proses [%s]' % msg)
    msg = msg.split('|')
    logging.info('split [%s]' % str(msg))
    logging.info('trying to parse and send results...')
    try:
        sample_id = msg[1]
        test_code = msg[6]
        result = msg[7]
        logging.info('Sample ID[%s] Test code[%s] Result[%s]' % (sample_id,test_code,result))
        return (sample_id,test_code,result)
    except Exception as e:
        logging.error(str(e))



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


def get_pending_sampleid():
    connect_mysql = MysqlPython()
    res_sid = connect_mysql.select_sql(' select sampleid from worklist order by id asc limit 1 ')
    logging.info(res_sid)
    if len(res_sid)>0:
        return True,res_sid
    else:
        return False,None

def insert_result(sampleid,Na,K,Cl):
    connect_mysql = MysqlPython()
    conditional_query = 'host_sample_id = %s'
    connect_mysql.delete('instrument_result',conditional_query,sampleid)
    connect_mysql.insert('instrument_result',host_sample_id=sampleid,analyt_code='Na',result_value=Na)
    connect_mysql.insert('instrument_result',host_sample_id=sampleid,analyt_code='K',result_value=K)
    connect_mysql.insert('instrument_result',host_sample_id=sampleid,analyt_code='Cl',result_value=Cl)
    return True
    


def main():
    # read ini file
    config = configparser.ConfigParser()
    config.read('ISE9180.ini')
    HOST = config.get('General','HOST')
    PORT = config.get('General','PORT')
    INF_HOST = config.get('General','INF_HOST')
    INF_PORT = config.get('General','INF_PORT')        
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        logging.info('try to connect to ISE9180 [%s:%s]' % (HOST,PORT))
        s.connect((HOST, int(PORT)))
        logging.info('connected.')
        inst_id = 165
        msg = b''
        while True:
            data = s.recv(1024)
            if data:
                try:
                    msg = msg + data
                    logging.info('data ['+data.decode(ENCODING)+']')
                    logging.info('msg ['+msg.decode(ENCODING)+']')
                    if msg.endswith(ETX):
                        # parsing message                            
                        msg = msg.decode(ENCODING)
                        logging.info('proses message len:%s' % len(msg))
                        logging.info('message:%s' % msg)
                        sampleid = str(re.search(r'Sample No.(.*?)\n', msg).group(1))
                        na = str(re.search(r'Na=(.*?)mmol/L', msg).group(1))
                        k = str(re.search(r'K =(.*?)mmol/L', msg).group(1))
                        cl = str(re.search(r'Cl=(.*?)mmol/L', msg).group(1))
                        
                        logging.info('SampleID:%s'%sampleid)
                        logging.info('Na:%s'%na)
                        logging.info('K:%s'%k)
                        logging.info('Cl:%s'%cl)

                        # insert ke MySQL
                        insert_result(sampleid,na,k,cl)
                        msg = b''
                except Exception as e:
                    logging.warning(str(e))
                    msg = b''
                    pass                  
            data = b''

if __name__ == "__main__":
    with open('ISE9180.yaml', 'rt') as f:
        config = yaml.safe_load(f.read())
        logging.config.dictConfig(config)
    logging.info('Starting program [%s]' % str(VERSION))
    main()
