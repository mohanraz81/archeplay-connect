from flask import Flask, jsonify
from flask import request
import sys,os,boto3
import logging,json
import pymysql, base64
import random,string
import hashlib,uuid,datetime
    

app = Flask(__name__)
@app.route('/api/v1.0/addinstance', methods=['POST'])
def create_task():
    rds_host = os.environ['MYSQL_HOST']
    name = os.environ['MYSQL_USER']
    password = os.environ['MYSQL_PASSWORD']
    db_name = os.environ['MYSQL_DATABASE']
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    
    event = request.json['add']
    try:
      conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
      logger.info("Connection to RDS MySQL")
    except pymysql.MySQLError as e:
      logger.error("ERROR: Unexpected error: Could not connect to DB "+str(e))
      sys.exit()
    
    try:
      conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
      logger.info("Connection to RDS MySQL")
    except pymysql.MySQLError as e:
      logger.error("ERROR: Unexpected error: Could not connect to DB "+str(e))
      sys.exit()
    
    user = event[0]
    EmailId = user['EmailId']
    InstanceDetails = user['InstanceData']
    try:
      cursor = conn.cursor()
      try:
        print("Creating User Entity")
        sql = "INSERT INTO guacamole_entity (name, type) VALUES ('{0}', 'USER');".format(EmailId)
        cursor.execute(sql)
        LastInsertId = cursor.lastrowid
      except:
        print('User Exsist')
        sql_sel = "SELECT entity_id FROM guacamole_entity WHERE name = '{0}';".format(EmailId)
        cursor.execute(sql_sel)
        records = cursor.fetchall()
        for row in records:
          LastInsertId=row[0]
      sql_salt = "SET @salt = UNHEX(SHA2(UUID(), 256));"
      cursor.execute(sql_salt)
      try:
        sql_user_insert = "INSERT INTO guacamole_user (entity_id,password_salt,password_hash,password_date,expired) VALUES ('{1}',  @salt, UNHEX(SHA2(CONCAT('{0}', HEX(@salt)), 256)), CURRENT_TIMESTAMP, 1)".format(EmailId, LastInsertId)
        print("---Executing User Creation--------")
        cursor.execute(sql_user_insert)
        print(sql_user_insert)
      except:
        print('User Exsist')
          
      eachinstance = InstanceDetails[0]
      if 'ConnectionType' not in eachinstance:
        ConnectionType = 'rdp'
        if 'Port' not in eachinstance:
            Port='3389'
        else:
            Port=eachinstance['Port']
        protocol='rdp'
    
      sql_connection = "INSERT INTO guacamole_connection (connection_name,max_connections,max_connections_per_user,protocol) VALUES ('{0}',3,3 ,'{1}');".format(eachinstance['InstanceId'],protocol)
      cursor.execute(sql_connection)
      LastConnectionId = cursor.lastrowid
      print(sql_connection)
      sql_conn_with_host_param = "INSERT INTO guacamole_connection_parameter  VALUES ('{0}', 'hostname', '{1}');".format(LastConnectionId, eachinstance['DnsName'])
      print(sql_conn_with_host_param)
      cursor.execute(sql_conn_with_host_param)
      sql_conn_with_port_param = "INSERT INTO guacamole_connection_parameter VALUES ('{0}', 'port', '{1}');".format(LastConnectionId, Port)
      print(sql_conn_with_port_param)
      cursor.execute(sql_conn_with_port_param)
      sql_conn_with_user_param = "INSERT INTO guacamole_connection_parameter VALUES ('{0}', 'username', '{1}');".format(LastConnectionId, eachinstance['UserName']) 
      print(sql_conn_with_user_param)
      cursor.execute(sql_conn_with_user_param)
      sql_conn_with_security_param = "INSERT INTO guacamole_connection_parameter VALUES ('{0}', 'security', '{1}');".format(LastConnectionId, "any")
      print(sql_conn_with_security_param)
      cursor.execute(sql_conn_with_security_param)
      sql_conn_with_ignore_cert_param = "INSERT INTO guacamole_connection_parameter VALUES ('{0}', 'ignore-cert', '{1}');".format(LastConnectionId, "true")
      print(sql_conn_with_ignore_cert_param)
      cursor.execute(sql_conn_with_ignore_cert_param)
      sql_conn_assoc_with_user = "INSERT INTO guacamole_connection_permission VALUES ('{0}', '{1}', '{2}');".format(LastInsertId,LastConnectionId, "READ")
      print(sql_conn_assoc_with_user)
      cursor.execute(sql_conn_assoc_with_user)
      print("done")
      if ConnectionType == "rdp":
        sql_conn_with_password_param = "INSERT INTO guacamole_connection_parameter VALUES ('{0}', 'password', '{1}');".format(LastConnectionId, eachinstance['Password'])
        print(sql_conn_with_password_param)
        cursor.execute(sql_conn_with_password_param)
      if ConnectionType == "ssh":
        sql_conn_with_password_param = "INSERT INTO guacamole_connection_parameter VALUES ('{0}', 'private-key', '{1}');".format(LastConnectionId, eachinstance['PrivateKey'])
        print(sql_conn_with_password_param)
        cursor.execute(sql_conn_with_password_param)
      
      print("All sql statements added")
      eachinstance.update({"ConnectionUrl": "https://connect.vms.courseandlabs.com/archeplay/#/client/?username=EmailId&password=redhat123"})
      conn.commit()
          
    except Exception as e:
      logger.error("ERROR: Unexpected error: "+str(e))
      conn.rollback()
    
    print(json.dumps(event))
    conn.close()
    return(json.dumps(event))