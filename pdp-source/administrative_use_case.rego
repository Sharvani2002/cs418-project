package egrbac_admin
import future.keywords.in


default op_allow := false
default revoke_RPDR := false
default assign_RPDR := false
default does_there_exist_rpdra_exact_item_match := false

does_there_exist_rpdra_exact_item_match {
    some rpdra_item in data.RPDRA
    rpdra_item.RP == input.RP
    rpdra_item.DR == input.DR
}

revoke_RPDR{
    op_allow
    
    # revoke RPDRA
    
    does_there_exist_rpdra_exact_item_match
}



assign_RPDR{

	op_allow
    
    # assign RPDRA
    not does_there_exist_rpdra_exact_item_match
}


op_allow{
	input.user in data.AUser
    
    # check for valid AR
	input.AR in data.AR
    
    
    # check for valid AUA assignment
    some key, value in data.AUA
    key == input.user
    input.AR in value
        
	# check for valid Role Pair (RP)
    some key1,value1 in input.RP
    some key2,value2 in RP
    key1 == key2
    value1 == value2
    
    # check for valid DR
    input.DR[_] in data.DR
   
    
    # finding inclusive task of rp,dr in the Inclusive Roles
    
    some tasks in data.ProhibitedAssignment
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









RP := {
    "kid": ["Entertainment_Time"],
    "parent": ["Any_Time"],
    "babySitter": ["Any_Time"],
    "guest": ["Any_Time"], 
    "parent": ["Not_At_Home"]
}








# Users

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


InclusiveRoles :={
{"AT":at1 , "RPDR":{"RP": {"kid": ["Entertainment_Time"]}, "DR": ["Kids_Friendly_Content"]}},
{"AT":at3 , "RPDR":{"RP": {"babySitter":["Any_Time"]}, "DR": ["Adult_Controlled"]}},
}

ARATA := {
{"AT":at1 , "AR" : ["Entertainment_Manager"]},
{"AT":at2 , "AR" : ["Adult_Manager"]},
{"AT":at3 , "AR" : ["Home_Owner"]}
}