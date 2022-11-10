# Entry point for the application.
"""
OPA is expected to be running on default port 8181
"""
import json
import logging
from . import app    # For application discovery by the 'flask' command.
from flask_opa import OPA
from flask import Flask, request

# def example_parse_input():
#     return {
#         "input": {
#             "method": request.method,
#             "path": request.path.rstrip('/').strip().split("/")[1:],
#             "user": "Alex",
#             "action": "On",
#             "object": "TV",
#             "context":"weekends"
#         }
#     }

# def parse_input(*arg, **kwargs):
#     return {
#         "input": {
#             "path": request.path.rstrip('/').strip().split("/")[1:],
#             "user": arg[0],
#             "action": arg[1],
#             "object": arg[2],
#             "context": arg[3]
#         }
#     }

app.logger.setLevel(logging.DEBUG)

# app.opa = OPA(app, input_function=parse_input)

from . import views  # For import side-effects of setting up routes.


if __name__ == '__main__':
    app.run(debug=True)