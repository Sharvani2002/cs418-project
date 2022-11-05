# cs418-project

## Setup
- <a href="https://www.openpolicyagent.org/docs/latest/#running-opa">Download OPA</a>
```
curl -L -o opa https://openpolicyagent.org/downloads/v0.45.0/opa_linux_amd64_static
chmod 755 ./opa
```
- Clone the repo, `cs418-project`

#### No setup case
Run the code on the <a href="https://play.openpolicyagent.org/">Rego playground</a> for no setup

#### Debugging
for debugging and getting the value of op_allow
```
./opa eval -f raw -d cs418-project/operational_model_debug.rego -i cs418-project/op_model_input.json 'data.egrbac.op_allow'
```

#### Run tests
To exercise the policy, run the opa test command in the directory containing the files.
```
./opa test . -v
```