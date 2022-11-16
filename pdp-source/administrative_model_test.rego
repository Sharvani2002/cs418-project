package egrbac_admin_extended
import future.keywords

test_RPDRA_assign_not_allowed_revoke_allowed if {
    "user" : "Bob",
    "AR" : "Entertainment_Manager",
    "RP": {
                "kid": [
                    "Entertainment_Time"
                ]
            },
    "DR" : ["Kids_Friendly_Content"]
}


test_RPDRA_assign_allowed_revoke_not_allowed  if {
   "user" : "Julia",
   "AR" : "Home_Owner",
   "RP": {
                "babySitter": [
                    "Any_Time"
                ]
            },
    "DR" : ["Adult_Controlled"]
}
