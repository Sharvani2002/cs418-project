package egrbac
import future.keywords.in
default op_allow := false

op_allow{
    # if input.user is in the user's list
    input.user in U
    # if input.object is a valid device
    input.object in D
    # if input.action is a valid operation
    input.action in OP
    # if input.context is a valid environmental condition
    input.context in EC
    # list of valid Environmental roles
    er_list := { EA_item.ER |
    some EA_item in EA
    input.context in EA_item.EC
    }
    
    # lookup the list of user_roles for the user
    user_roles := UA[input.user]
	
    # lookup the device roles for role pair rp
    rpdra_list := {
        rpdra_item | 
        some rpdra_item in RPDRA
        some key,value in rpdra_item.RP
        # rpdra_item.RP.first in ur
        key in user_roles
        # rpdra_item.RP.second == rp
        value[_] in er_list[_]
    }

    # Device roles
    device_roles := rpdra_list[_].DR

    # look up the permissions associated with the device role    
    allowed_permissions := { pdra_item |
        some pdra_item in PDRA
        pdra_item.DR[_] == device_roles[_]
    }
    
    # for each permission
    p := allowed_permissions[_].P[_]

    # check if the permission granted to the user matches the user's request
    input.action in p.OP
    input.object in p.D
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
# Device
D := ["TV", "DVD", "PlayStation", "DoorLock", "Oven", "SurveillanceCamera", "BurglarAlarm", "GarageDoor", "Thermostat"]
# Operation
OP := ["On", "Off", "PG", "R", "Lock", "Unlock", "Activate", "Deactivate", "On_Oven", "Off_Oven", "StartRecording", "StopRecording", "OpenGarageDoor", 
"CloseGarageDoor", "On_Thermostat", "Off_Thermostat", "Schedule_Thermostat"]

# Individual Permissions
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

#Permissions
P := [P1, P2, P3, P4, P5, P6, P7, P8, P9, P10]

# Device Roles
DR := ["Entertainment_Devices", "Adult_Controlled", "Owner_Controlled", "Kids_Friendly_Content"]

#Permission to Device Role
PDRA = {
    {"P": [P1], "DR": ["Entertainment_Devices"] },
    {"P": [P2], "DR": ["Kids_Friendly_Content"] },
    {"P": [P3, P4, P9], "DR": ["Adult_Controlled"]},
    {"P": [P5, P6, P7, P8], "DR": ["Owner_Controlled"]}
}

#Environmental condition
EC := ["weekends", "evenings", "vacation", "TRUE"]
#Environmental Role
ER := ["Entertainment_Time", "Any_Time", "Not_At_Home"]
EA := {
    {"EC": ["weekends", "evenings"], "ER": ["Entertainment_Time"]},
    {"EC": ["vacation"], "ER": ["Not_At_Home"]},
    {"EC": ["TRUE"], "ER": ["Any_Time"]}
}

#Role pair
RP = {
    "kid": ["Entertainment_Time"],
    "parent": ["Any_Time"],
    "babySitter": ["Any_Time"],
    "guest": ["Any_Time"], 
    "parent": ["Not_At_Home"]
}

#Role pair to Device Role
RPDRA = {
    {"RP": {"parent": ["Any_Time"]}, "DR": ["Adult_Controlled"]},
    {"RP": {"parent": ["Any_Time"]}, "DR": ["Owner_Controlled"]},
    {"RP": {"parent": ["Any_Time"]}, "DR": ["Entertainment_Devices"]},
    {"RP": {"kid":["Entertainment_Time"]}, "DR": ["Kids_Friendly_Content"]},
    {"RP": {"babySitter":["Any_Time"]}, "DR": ["Adult_Controlled"]},
    {"RP": {"guest":["Any_Time"]}, "DR": ["Entertainment_Devices"]}
}

# User "Alex" wants to perform "on" action/operation the "oven" object/device. 
# We need to check if it is allowed or not

