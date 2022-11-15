package egrbac
import future.keywords.in
default op_allow := false

op_allow{

	input.user in AUser
    
    # finding inclusive task of rp,dr in the Inclusive Roles
    
    some tasks in ProhibitedAssignment
    not input.RP in tasks.RP
    not input.DR in tasks.DR
    
    
    at_list := {
        task_item.AT |
    some task_item in InclusiveRoles
    task_item.RPDR.DR == input.DR
    task_item.RPDR.RP == input.RP
    }
    
        
	# finding out the Administrative role associated with this Adminstrative Task
    some arata_item in ARATA
    some ats in at_list
    ats == arata_item.AT
    
    # checking if the Adminstrative Role is same as that of the given input
    input.AR in arata_item.AR
    
    # if it return true:
    	# it means that the user can add to the access rules in RPDRA of the operational model
    	# it replicates the assignPDRA 
        
        # it means that the user can revoke to the access rules in RPDRA of the operational model
    	# it replicates the revokePDRA 

    
    
}

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
{"AT":at1 , "RPDR":{"RP": {"kid": ["Entertainment_Time"]}, "DR": ["Kids_Friendly_Content"]}},
{"AT":at3 , "RPDR":{"RP": {"babySitter":["Any_Time"]}, "DR": ["Adult_Controlled"]}},
}

ARATA := {
{"AT":at1 , "AR" : ["Entertainment_Manager"]},
{"AT":at2 , "AR" : ["Adult_Manager"]},
{"AT":at3 , "AR" : ["Home_Owner"]}
}