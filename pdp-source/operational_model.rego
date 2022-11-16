package egrbac
import future.keywords.in
default op_allow := false

op_allow{
print("Entering allow")
    # if input.user is in the user's list
    input.user in data.U
    print("input.user in U")
    # if input.object is a valid device
    input.object in data.D
    print("input.object in D")
    # if input.action is a valid operation
    input.action in data.OP
    print("input.action in OP")
    # if input.context is a valid environmental condition
    input.context in data.EC
    print("input.context in EC")
    # list of valid Environmental roles
    er_list := { EA_item.ER |
    some EA_item in data.EA
    input.context in EA_item.EC
    }
	print("er_list", er_list)
    
    # lookup the list of user_roles for the user
    user_roles := data.UA[input.user]
    print("user_roles", user_roles)
	
    # lookup the device roles for role pair rp
    rpdra_list := {
        rpdra_item | 
        some rpdra_item in data.RPDRA
        some key,value in rpdra_item.RP
        print("key", key)
        print("value", value)
        # rpdra_item.RP.first in ur
        key in user_roles
        print("key present in user_roles")
        # rpdra_item.RP.second == rp
        value[_] in er_list[_]
        print("value present in er_list")
    }
    print("rpdra_list", rpdra_list)

    # Device roles
    device_roles := rpdra_list[_].DR
    print("device_roles", device_roles)

    # look up the permissions associated with the device role    
    allowed_permissions := { pdra_item |
        some pdra_item in data.PDRA
        pdra_item.DR[_] == device_roles[_]
    }
    print("allowed_permissions", allowed_permissions)
    
    # for each permission
    p := allowed_permissions[_].P[_]
    print("p", p)

    permission_object = data.P[p]

    # check if the permission granted to the user matches the user's request
    input.action in permission_object.OP
    print("input.action in p.OP")
    input.object in permission_object.D
    print("input.object in p.D")


    # # if input.user is in the user's list
    # input.user in data.U
    # # if input.object is a valid device
    # input.object in data.D
    # # if input.action is a valid operation
    # input.action in data.OP
    # # if input.context is a valid environmental condition
    # input.context in data.EC
    # # list of valid Environmental roles
    # er_list := { EA_item.ER |
    # some EA_item in data.EA
    # input.context in EA_item.EC
    # }
    
    # # lookup the list of user_roles for the user
    # user_roles := data.UA[input.user]
	
    # # lookup the device roles for role pair rp
    # rpdra_list := {
    #     rpdra_item | 
    #     some rpdra_item in data.RPDRA
    #     some key,value in rpdra_item.RP
    #     # rpdra_item.RP.first in ur
    #     key in user_roles
    #     # rpdra_item.RP.second == rp
    #     value[_] in er_list[_]
    # }

    # # Device roles
    # device_roles := rpdra_list[_].DR

    # # look up the permissions associated with the device role    
    # allowed_permissions := { pdra_item |
    #     some pdra_item in data.PDRA
    #     pdra_item.DR[_] == device_roles[_]
    # }
    
    # # for each permission
    # p := allowed_permissions[_].P[_]

    # # check if the permission granted to the user matches the user's request
    # input.action in p.OP
    # input.object in p.D
}

# User "Alex" wants to perform "on" action/operation the "oven" object/device. 
# We need to check if it is allowed or not

