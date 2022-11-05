package egrbac
import future.keywords

test_Alex_TV_On_weekends_allowed if {
    op_allow with input as {
    "user": "Alex",
    "action": "On",
    "object": "TV",
    "context":"weekends"
}
}

test_Susan_On_Oven_TRUE_allowed if {
    op_allow with input as {
    "user": "Susan",
    "action": "On_Oven",
    "object": "Oven",
    "context":"TRUE"
}
}

test_Susan_Off_Oven_TRUE_allowed if {
    op_allow with input as {
    "user": "Susan",
    "action": "Off_Oven",
    "object": "Oven",
    "context":"TRUE"
}
}

test_Susan_SurveillanceCamera_TRUE_not_allowed if {
    not op_allow with input as {
    "user": "Susan",
    "action": "StartRecording",
    "object": "SurveillanceCamera",
    "context":"TRUE"
}
}