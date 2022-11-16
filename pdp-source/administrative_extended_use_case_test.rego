package egrbac_admin_extended
import future.keywords


test_RPDRA_assign_not_allowed_revoke_allowed if {
    "user" : "Julia",
    "AR" : "Home_Owner",
    "P":  [
                {
                    "D": [
                        "TV",
                        "DVD",
                        "PlayStation"
                    ],
                    "OP": [
                        "On",
                        "Off",
                        "PG",
                        "R"
                    ]
                }
            ],
    "DR" : ["Entertainment_Devices"]
}



test_RPDRA_assign_allowed_revoke_not_allowed if {
    "user" : "Bob",
    "AR" : "Entertainment_Manager",
    "P":  [
                {
                    "D": [
                        "TV",
                        "DVD",
                        "PlayStation"
                    ],
                    "OP": [
                        "On",
                        "Off",
                        "PG"
                    ]
                }
            ],
    "DR" : ["Adult_Controlled"]
}