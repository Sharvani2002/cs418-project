# cs418-project

## Setup
- <a href="https://www.openpolicyagent.org/docs/latest/#running-opa">Download OPA</a>
```
curl -L -o opa https://openpolicyagent.org/downloads/v0.45.0/opa_linux_amd64_static
chmod 755 ./opa
```
- Clone the repo, `cs418-project`

- Create a virtual environment and run the below command to reinstall the packages in the virtual environment:
```
pip install -r requirements.txt
```
- Go to the project, `cs418-project` and run the OPA server with the required rego files
```
../opa run -s -w pdp-source/
```

#### No setup case
Run the code on the <a href="https://play.openpolicyagent.org/">Rego playground</a> for no setup

#### Debugging
for debugging and getting the value of op_allow
```
./opa eval -f raw -d cs418-project/pdp-source/operational_model_debug.rego -i cs418-project/pdp-source/op_model_input.json 'data.egrbac.op_allow'
```

#### Run tests
To exercise the policy, run the opa test command in the directory containing the files.
```
./opa test pdp-source -v
```