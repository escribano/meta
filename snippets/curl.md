curl -i -H "Accept: application/json" -X PUT -d "phone=1-800-999-9999" http://192.168.0.165/persons/person/1  

curl -i -H "Accept: application/json" -X PUT -d "phone=1-800-999-9999" http://localhost:3000/system/admin/remote 

curl -i -H "Accept: application/json" -X PUT -d "phone=1-800-999-9999" http://localhost:3000/system/rest/user 