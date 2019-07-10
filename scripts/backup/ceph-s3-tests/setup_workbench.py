import httplib
import json
import requests

ACCESSER = 'localhost'
PORT = 8080

ADMIN_PORT = 8337
ADMIN_USER = 'user'
ADMIN_PASS = 'password'

USER_1 = 'user1'
USER_2 = 'user2'

CONFIG_FILE = 'workbench.ini'

def list_accounts():
    list_account_url = 'http://%s:%s/accounts' % (ACCESSER, ADMIN_PORT)
    resp = requests.get(url=list_account_url, auth=(ADMIN_USER, ADMIN_PASS))
    if resp.status_code == httplib.OK:
        return json.loads(resp.text)['accounts']
    elif resp.status_code == httplib.NO_CONTENT:
        return []

def create_account(user_id):
    create_account_url = 'http://%s:%s/accounts/%s' % (ACCESSER, ADMIN_PORT, user_id)
    resp = requests.put(url=create_account_url, auth=(ADMIN_USER, ADMIN_PASS))
    assert resp.status_code == httplib.CREATED, "Expected: %s, Received: %s" % (
        httplib.CREATED, resp.status_code)
        
def create_credential(user_id):
    url = 'http://%s:%s/credentials/' % (ACCESSER, ADMIN_PORT)
    cred = {"credential": {"type": "ec2", "project_id": user_id}}
    resp = requests.post(url=url, auth=(ADMIN_USER, ADMIN_PASS),
                         data=json.dumps(cred))
    assert resp.status_code == httplib.CREATED, \
        "Error occurred while creating credentials. , Expected: %s, Received: %s" % (
            httplib.CREATED, resp.status_code)
    j = json.loads(str(resp.text))
    a = j['credential']['blob']['access']
    s = j['credential']['blob']['secret']
    return a, s
    
def user_config(user_id):
    if user_id in [acc['id'] for acc in list_accounts()]:
        print '\nAccount for %s already exists' % user_id
    else:
        print '\nCreating new account for %s' % user_id
        create_account(user_id)
    print 'Getting credentials for %s' % user_id
    access_key, secret_key = create_credential(user_id)
    return """user_id = %(user_id)s
display_name = %(user_id)s
email = %(user_id)s
access_key = %(access_key)s
secret_key = %(secret_key)s
""" % locals()
    
def main():
    print 'Writing config to %s' % CONFIG_FILE
    with open(CONFIG_FILE, 'w') as config:
        config.write('[DEFAULT]\n')
        config.write('host = %s\n' % ACCESSER)
        config.write('port = %s\n' % PORT)
        config.write('calling_format = ordinary\n')
        config.write('is_secure = no\n')
        config.write('\n')
        config.write('[fixtures]\n')
        config.write('bucket prefix = s3test-jetengine-{random}\n')
        config.write('\n')
        config.write('[s3 main]\n')
        config.write(user_config(USER_1))
        config.write('\n')
        config.write('[s3 alt]\n')
        config.write(user_config(USER_2))


if __name__ == '__main__':
    main()
        