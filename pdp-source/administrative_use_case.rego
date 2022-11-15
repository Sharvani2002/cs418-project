package play

import future.keywords.if

# Welcome to the Rego playground! Rego (pronounced "ray-go") is OPA's policy language.
#
# Try it out:
#
#   1. Click Evaluate. Note: 'hello' is 'true'
#   2. Change "world" to "hello" in the INPUT panel. Click Evaluate. Note: 'hello' is 'false'
#   3. Change "world" to "hello" on line 25 in the editor. Click Evaluate. Note: 'hello' is 'true'
#
# Features:
#
#         Examples  browse a collection of example policies
#         Coverage  view the policy statements that were executed
#         Evaluate  execute the policy with INPUT and DATA
#          Publish  share your playground and experiment with local deployment
#            INPUT  edit the JSON value your policy sees under the 'input' global variable
#    (resize) DATA  edit the JSON value your policy sees under the 'data' global variable
#           OUTPUT  view the result of policy execution





import future.keywords.in
default op_allow := false


# Users
U := ["Alex", "Bob", "Susan", "James", "Julia"]
# Roles
R := ["kid", "parent", "babySitter", "guest"]
# user_roles
UA := {
    "Alex": ["kid"], 
    "Bob": ["parent"], 
    "Susan": ["babySitter"], 
    "James": ["guest"], 
    "Julia": ["parent"]
}
RP := {
    "kid": ["Entertainment_Time"],
    "parent": ["Any_Time"],
    "babySitter": ["Any_Time"],
    "guest": ["Any_Time"], 
    "parent": ["Not_At_Home"]
}
DR := ["Entertainment_Devices", "Adult_Controlled", "Owner_Controlled", "Kids_Friendly_Content"]

RPDRA = {
    {"RP": {"parent": ["Any_Time"]}, "DR": ["Adult_Controlled"]},
    {"RP": {"parent": ["Any_Time"]}, "DR": ["Owner_Controlled"]},
    {"RP": {"parent": ["Any_Time"]}, "DR": ["Entertainment_Devices"]},
    {"RP": {"kid":["Entertainment_Time"]}, "DR": ["Kids_Friendly_Content"]},
    {"RP": {"babySitter":["Any_Time"]}, "DR": ["Adult_Controlled"]},
    {"RP": {"guest":["Any_Time"]}, "DR": ["Entertainment_Devices"]}
}

# Users
AUser := ["Bob", "Julia"]
# Roles
AR := ["Entertainment_Manager", "Home_Owner", "Adult_Manager"]
# user_roles
AUA := {
    "Bob": ["Home_Owner"], 
    "Julia": ["Home_Owner"], 
    "Julia": ["Adult_Manager"], 
    "Bob": ["Entertainment_Manager"]
}
AU := ["Entertainment_Management", "Ownership_Control", "Adult_Management"]

ProhibitedAssignment := {
	  {"RP": {"kid": ["Entertainment_Time"]}, "DR": ["Entertainment_Devices"]},
}

at1 := {
	  {"RP": {"kid": ["Entertainment_Time"], "babySitter" : ["Any_Time"]}, "DR": ["Entertainment_Devices", "Kids_Friendly_Content"]}
}

at2 := {
	  {"RP": {"parent": ["Any_Time"], "babySitter" : ["Any_Time"]}, "DR": ["Adult_Controlled"]}
}

at3 := {
	  {"RP": {"parent": ["Any_Time"]}, "DR": ["Owner_Controlled"]}
}

AT := [at1, at2, at3]

RolePair := {
  {"at": [at1], "RP": {"parent": ["Any_Time"], "guest" : ["Any_Time"], "kid": ["Entertainment_Time"]}}
}

DeviceRole :={
  {"at": [at2], "DR": ["Adult_Controlled"] }
}

InclusiveRoles :={
{"at":[at1] , "RPDR":{"RP": {"kid": ["Entertainment_Time"]}, "DR": ["Kids_Friendly_Content"]}}
}

ARATA := {
{"at":[at1] , "AR" : ["Entertainment_Manager"]},
{"at":[at2] , "AR" : ["Adult_Manager"]},
{"at":[at3] , "AR" : ["Home_Owner"]}
}