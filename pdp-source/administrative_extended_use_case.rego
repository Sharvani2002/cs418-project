package egrbac_admin_extended
import future.keywords.in
import future.keywords.every

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
	input.user in data.AUser
    
    # check for valid AR
	input.AR in data.AR
    
    
    # check for valid AUA assignment
    some key, value in data.AUA
    key == input.user
    input.AR in value
        
	# check for valid Permission
	every p in input.P{
    some p1 in P
    p == p1
    }
    
    
    
    # check for valid DR
    input.DR[_] in data.DR
   
    
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

# P := [data.P1, data.P2, data.P3, data.P4, data.P5, data.P6, data.P7, data.P8, data.P9, data.P10]

PDRA = {
    {"P": [P1], "DR": ["Entertainment_Devices"] },
    {"P": [P2], "DR": ["Kids_Friendly_Content"] },
    {"P": [P3, P4, P9], "DR": ["Adult_Controlled"]},
    {"P": [P5, P6, P7, P8], "DR": ["Owner_Controlled"]}
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



InclusiveRoles :={
{"AT":at3 , "PDRA": {"P": [P1], "DR": ["Entertainment_Devices"] }},


}



ARATA := {
{"AT":at1 , "AR" : ["Entertainment_Manager"]},
{"AT":at2 , "AR" : ["Adult_Manager"]},
{"AT":at3 , "AR" : ["Home_Owner"]}
}