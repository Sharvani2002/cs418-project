from datetime import datetime
from flask import Flask, render_template, request
from . import app
import json
from . import utils
from flask_opa import OPA, OPAException
import requests

example_data = {
    "user": "Alex",
    "action": "On",
    "object": "TV",
    "context":"weekends"
}

@app.errorhandler(OPAException)
def handle_opa_exception(e):
    return json.dumps({"message": str(e)}), 403

@app.route("/")
def home():
    return render_template("home.html")

@app.route('/operation/', methods =["GET"])
def operation():
    return render_template("operation_form.html")

def validate_operation_input_function(*arg, **kwargs):
    # return {
    #     "input": {
    #         "user": request.headers.get("Authorization", ""),
    #         "content": arg[0]
    #     }
    # }

    # return {
    #     "input":{
    #             "user": "Susan",
    #             "action": "StartRecording",
    #             "object": "SurveillanceCamera",
    #             "context":"TRUE"
    #     }
    # }
    return {
        "input": {
            "user": arg[0],
            "action": arg[1],
            "object": arg[2],
            "context": arg[3]
        }
    }


# def checkJson(s):
#     try:
#         json.decode(s)
#         return True
#     except json.JSONDecodeError:
#         return False



@app.route('/operation/', methods =["POST"])
def operation_resp():
    if request.method == "POST":
       user = request.form.get("user")
       action = request.form.get("action")
       object = request.form.get("object")
       context = request.form.get("context")
    #    "The operation you are trying to perform is allowed? "
    # try:
    #     # utils.operate_remotely(user, action, object, context)
    #     # secure_operation = OPA(app,input_function=validate_operation_input_function(user, action, object, context))
    #     return render_template("operation_allowed.html")
    # except:
    #     return render_template("operation_not_allowed.html")
    response = requests.post(app.config["OPA_OP_URL"], json=validate_operation_input_function(user, action, object, context), timeout=200000) 
    app.logger.info("Operation allowed: %s", response)
    json_response = response.json()
    print(json_response)
    #report error
    # if not checkJson(json_response):
    #     return render_template("operation_not_allowed.html")
    if json_response['result'] == True:
        return render_template("operation_allowed.html")
    else:
        return render_template("operation_not_allowed.html")


@app.route("/about/")
def about():
    return render_template("about.html")

@app.route("/contact/")
def contact():
    return render_template("contact.html")

@app.route("/hello/")
@app.route("/hello/<name>")
def hello_there(name = None):
    return render_template(
        "hello_there.html",
        name=name,
        date=datetime.now()
    )

@app.route("/api/data")
def get_data():
    return app.send_static_file("data.json")