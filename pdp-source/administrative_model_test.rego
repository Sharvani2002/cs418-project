package egrbac
import future.keywords

test_assign_RPDA_allowed if {
    "user" : "Bob",
    "AR" : "Entertainment_Manager",
    "RP": {
                "kid": [
                    "Entertainment_Time"
                ]
            },
    "DR" : ["Kids_Friendly_Content"]
}


test_assign_RPDA_not_allowed  {
    "user" : "Julia",
    "AR" : "Home_Owner",
    "RP": {
                "kid": [
                    "Entertainment_Time"
                ]
            },
    "DR" : ["Kids_Friendly_Content"]
}

test_assign_RPDA_allowed if {
    "user" : "Julia",
    "AR" : "Home_Owner",
    "RP": {
                "babySitter": [
                    "Any_Time"
                ]
            },
    "DR" : ["Adult_Controlled"]
}

test_assign_RPDA_not_allowed  {
    "user" : "Bob",
    "AR" : "Home_Owner",
    "RP": {
                "kid": [
                    "Entertainment_Time"
                ]
            },
    "DR" : ["Entertainment_Devices"]
}