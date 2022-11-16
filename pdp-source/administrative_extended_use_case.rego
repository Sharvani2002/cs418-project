package egrbac_admin_extended
import future.keywords.in

default op_allow := false
default revokePDR := false
default assignPDR := false
default does_exist_pdra := false

does_exist_pdra{
	some pdra in PDRA
 	pdra.P == input.P
    pdra.DR == input.DR
}

assignPDR{
	op_allow
    not does_exist_pdra
    
}

revokePDR{

    op_allow
    does_exist_pdra
    
}


op_allow{
	input.user in AUser
    
    # check for valid AR
	input.AR in AR
    
    
    # check for valid AUA assignment
    some key, value in AUA
    key == input.user
    input.AR in value
        
	# check for valid Permission
	every p in input.P{
    some p1 in P
    p == p1
    }
    
    
    
    # check for valid DR
    input.DR[_] in DR
   
    
   # get all the valid administrative task    
    at_list := {
        task_item.AT |
    some task_item in InclusiveRoles
    task_item.PDRA.P == input.P
    task_item.PDRA.DR == input.DR
    }
    

	# get all the Administrative role associated with the Administrative Task
    some arata_item in ARATA
    some ats in at_list
    ats == arata_item.AT
    input.AR in arata_item.AR
    
 
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
#     {"RP": {"babySitter":["Any_Time"]}, "DR": ["Adult_Controlled"]},
    {"RP": {"guest":["Any_Time"]}, "DR": ["Entertainment_Devices"]}
}

P1 := {"D":["TV" , "DVD", "PlayStation"], "OP": ["On", "Off", "PG", "R" ]}
P2 := {"D":["TV", "DVD", "PlayStation"], "OP": ["On", "Off", "PG"] }
P3 := {"D":["Oven"], "OP": ["On_Oven", "Off_Oven"] }
P4 := {"D":["FrontDoor"], "OP": ["Lock", "Unlock"] }
P5 := {"D":["SurveillanceCamera"], "OP": ["StartRecording", "StopRecording" ]}
P6 := {"D":["BurglarAlarm"], "OP": ["Activate", "Deactivate" ]}
P7 := {"D":["GarageDoor"], "OP": ["OpenGarageDoor" , "CloseGarageDoor" ]}
P8 := {"D":["Thermostat"], "OP": ["On_Thermostat", "Off_Thermostat", "Schedule_Thermostat"]}
P9 := {"D":["Thermostat"], "OP": ["On_Thermostat", "Off_Thermostat"]}
P10 := {"D":["OutDoorCamera"], "OP": ["OnOutDoorCamera", "OffOutDoorCamera"]}

P := [P1, P2, P3, P4, P5, P6, P7, P8, P9, P10]

PDRA = {
    {"P": [P1], "DR": ["Entertainment_Devices"] },
    {"P": [P2], "DR": ["Kids_Friendly_Content"] },
    {"P": [P3, P4, P9], "DR": ["Adult_Controlled"]},
    {"P": [P5, P6, P7, P8], "DR": ["Owner_Controlled"]}
}



# Users
AUser := ["Bob", "Julia"]
# Roles
AR := ["Entertainment_Manager", "Home_Owner", "Adult_Manager"]
# user_roles
AUA := {
    "Bob": ["Home_Owner", "Entertainment_Manager"], 
    "Julia": ["Home_Owner", "Adult_Manager"], 
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
{"AT":at3 , "PDRA": {"P": [P1], "DR": ["Entertainment_Devices"] }},


}



ARATA := {
{"AT":at1 , "AR" : ["Entertainment_Manager"]},
{"AT":at2 , "AR" : ["Adult_Manager"]},
{"AT":at3 , "AR" : ["Home_Owner"]}
}