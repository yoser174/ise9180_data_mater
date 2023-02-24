###
#
# Fix:

import logging
import MySQLdb
from datetime import datetime
import time,sys

VERSION  = '0.0.0.1'

#reload(sys)  
#sys.setdefaultencoding('ISO-8859-1')


class my_db(object):
    username = 'avl_drv'
    password = 'P455word'

    def __init__(self,server,db):
        logging.debug('start my_db host[%s] db[%s]' % (server,db))
        # mysql connection
        self.my_conn = None
        self.server = server
        self.db = db
        logging.info('my_db version [%s]' % VERSION)

    def connect(self):
        self.my_conn = MySQLdb.connect(host=self.server,
                  user=self.username,
                  passwd=self.password,
                  db=self.db)

    def close(self):
        self.my_conn.close()


    def is_float(self,res_value):
        logging.info('check is float [%s]' % res_value)
        try:
            fl = float(str(res_value))
            logging.info('True')
            return True
        except:
            logging.info('False')
            return False


    def costum_flag_range(self,tes_ref,tes_unit,tes_flag):
        tes_ref = str(tes_ref).replace('-',' - ')
        tes_unit = str(tes_unit).replace('*','^')
        tes_flag = tes_flag
        return tes_ref,tes_unit,tes_flag


    def my_select(self,sql):
        my_conn = MySQLdb.connect(host=self.server,
                  user=self.username,
                  passwd=self.password,
                  db=self.db)
        logging.info(sql)
        cursor = my_conn.cursor()
        try:
            cursor.execute(sql)
            res = cursor.fetchall()
            logging.info(res)
            my_conn.close()
            return res
        except MySQLdb.Error as e:
            logging.error(e)
            my_conn.close()


    def my_insert(self,sql):
        my_conn = MySQLdb.connect(host=self.server,
                  user=self.username,
                  passwd=self.password,
                  db=self.db)
        logging.info(sql)
        cursor = my_conn.cursor()
        try:
            cursor.execute(sql)
            my_conn.commit()
            my_conn.close()
            return cursor.lastrowid
        except MySQLdb.Error as e:
            logging.error(e)
            self.my_conn.rollback()
            my_conn.close()

    def my_update(self,sql):
        my_conn = MySQLdb.connect(host=self.server,
                  user=self.username,
                  passwd=self.password,
                  db=self.db)
        logging.info(sql)
        cursor = my_conn.cursor()
        try:
            cursor.execute(sql)
            my_conn.commit()
            my_conn.close()
            return cursor.lastrowid
        except MySQLdb.Error as e:
            logging.error(e)
            my_conn.rollback()
            my_conn.close()

    def my_delete(self,sql):
        my_conn = MySQLdb.connect(host=self.server,
                  user=self.username,
                  passwd=self.password,
                  db=self.db)
        logging.info(sql)
        cursor = my_conn.cursor()
        try:
            cursor.execute(sql)
            my_conn.commit()
            my_conn.close()
            return cursor.lastrowid
        except MySQLdb.Error as e:
            logging.error(e)
            my_conn.rollback()
            my_conn.close()

    
