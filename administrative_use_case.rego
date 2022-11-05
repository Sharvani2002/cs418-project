package admin_model

# TBD
AUser := ["Bob", "Julia"]

# AR := ["Entertainment_Manager", "Home_Owner", "Adult_Manager"]

# AUA := {
#     "Bob": ["Home_Owner"], 
#     "Julia": ["Home_Owner"], 
#     "Julia": ["Adult_Manager"], 
#     "Bob": ["Entertainment_Manager"]
# }

# AU := ["Entertainment_Management", "Ownership_Control", "Adult_Management"]

# ProhibitedAssignment := {[{"kid":"Entertainment_Time"}, "Entertainment_Devices"]}
# AT := ["at1", "at2", "at3"]

# at1 = { ("parent": "Any_Time" }), ("babysitter", {"Any_Time" }) } ×
# {Entertainment_Devices, Kids_Friendly_Content }
# at2 = { (parent, {Any_Time }), (babysitter, {Any_Time }) } ×
# {Adult_Controlled }
# at3 = { (parent, {Any_Time }) }: {"Owner_Controlled"} 
# RolePair(at1) = { (parent, {Any_Time }), (guest, {Any_Time}), (kid,{Entertainment_Time})}
# DeviceRole(at2) = {Adult_Controlled}
# InclusiveTask((kid,{Entertainment_Time}), Kids_Friendly_Content) = at1
# ARATA = {(Entertainment_Manager,at_1),(Adult_Manager,at_2), (Home_Owner,at_3)}
# AR_at1 = ["Entertainment_Manager"]
# AR_at2 = ["Adult_Manager"]
# AR_at3 = ["Home_Owner"]
# assignRPDR(Bob, Entertainment_Manager, ({(kid,{Entertainment_Time}), Kids_Friendly_Content})) =⇒ RPDRA =
# RPDRA ∪ {((kid,{Entertainment_Time}), Kids_Friendly_Content)}
# revokeRPDR(Bob, Entertainment_Manager, ({(kid,{Entertainment_Time}), Kids_Friendly_Content})) =⇒ RPDRA =
# RPDRA \ {((kid,{Entertainment_Time}), Kids_Friendly_Content)} =⇒
# 𝑅𝑃𝐷𝑅𝐴 = ∅
# assignPDR(Julia, Home_Owner, P10, 𝑂𝑤𝑛𝑒𝑟 _𝐶𝑜𝑛𝑡𝑟𝑜𝑙𝑙𝑒𝑑)=⇒ PDRA = PDRA ∪ {(P10, 𝑂𝑤𝑛𝑒𝑟 _𝐶𝑜𝑛𝑡𝑟𝑜𝑙𝑙𝑒𝑑) }
# revokePDR(Julia, Home_Owner, P3, 𝐴𝑑𝑢𝑙𝑡 _𝐶𝑜𝑛𝑡𝑟𝑜𝑙𝑙𝑒𝑑)=⇒ PDRA = PDRA \ {(P3, 𝐴𝑑𝑢𝑙𝑡 _𝐶𝑜𝑛𝑡𝑟𝑜𝑙𝑙𝑒𝑑) }