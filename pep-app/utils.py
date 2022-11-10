from flask.globals import request
from . import app
from flask_opa import OPA


# def validate_operation_input_function(*arg, **kwargs):
#     # return {
#     #     "input": {
#     #         "user": request.headers.get("Authorization", ""),
#     #         "content": arg[0]
#     #     }
#     # }
#     return {
#         "input": {
#             "user": arg[0],
#             "action": arg[1],
#             "object": arg[2],
#             "context": arg[3]
#         }
#     }


# secure_operation = app.opa("Operational Model PEP", app.config["OPA_URL"], validate_operation_input_function)
# # secure_operation = app.opa(app,input_function=validate_operation_input_function)

# @secure_operation
# def operate_remotely(content):
#     # Imagine a code to log this remotely
#     app.logger.info("Operation allowed: %s", content)