# cs418-project
## Role-Based Administration of Role-Based Smart Home IoT [Paper link]
Team Id: <b>T14</b> <br>
Team members: 
- 191EE247 Sharvani Somayaji
- 191CS117 Deepta Devkota 
- 191CS142 Prachi Priyam Singh

### Steps for Setup
- <a href="https://www.openpolicyagent.org/docs/latest/#running-opa">Download OPA</a>
```
curl -L -o opa https://openpolicyagent.org/downloads/v0.45.0/opa_linux_amd64_static
chmod 755 ./opa
```
- Clone the repo, `cs418-project`

- Create a <a href="https://docs.python.org/3/library/venv.html">virtual environment</a> and run the below command to reinstall the packages in the virtual environment:
```
pip install -r requirements.txt
```
- Go to the project, `cs418-project` and run the OPA server (PDP) with the required rego files
```
../opa run -s -w pdp-source/
```
- Run the Flask Server (PEP)
```
python -m flask run
```
- Go to the endpoint on local machine:
```
http://127.0.0.1:5000/
```

### OPA server REST API
Send the request and get authorization response (true/false) from OPA server using POSTMAN desktop app:
- Run the OPA server `../opa run -s -w pdp-source/`
- Import `EGRBAC_Collection.postman_collection.json` in the POSTMAN Desktop app



### No setup case
Run the code on the <a href="https://play.openpolicyagent.org/">Rego playground</a> for no setup

### Debugging
for debugging and getting the value of op_allow
```
./opa eval -f raw -d cs418-project/pdp-source/operational_model_debug.rego -i cs418-project/pdp-source/op_model_input.json 'data.egrbac.op_allow'
```

### Run tests
To exercise the policy, run the opa test command in the directory containing the files.
```
./opa test pdp-source -v
```
