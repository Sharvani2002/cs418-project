# Entry point for the application.
"""
OPA is expected to be running on default port 8181
"""
import json
import logging
from . import app    # For application discovery by the 'flask' command.
from flask_opa import OPA
from flask import Flask, request

app.logger.setLevel(logging.DEBUG)

from . import views  # For import side-effects of setting up routes.


if __name__ == '__main__':
    views.create_all()
    app.run(debug=True)