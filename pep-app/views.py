from datetime import datetime
from flask import Flask, render_template, request, session
from . import app
import json
from . import utils
from flask_opa import OPA, OPAException
import requests  

from flask import Flask,render_template,request,redirect
from flask_login import login_required, current_user, login_user, logout_user
# from models import UserModel,db,login
 

# app.secret_key = 'xyz'
 
# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
 
 
# db.init_app(app)
# login.init_app(app)
# login.login_view = 'login'
 
# @app.before_first_request
# def create_all():
#     db.create_all()

# # login.init_app(app)
# # login.login_view = 'login'

# @app.route('/login', methods = ['POST', 'GET'])
# def login():
#     if current_user.is_authenticated:
#         return redirect('/adminUser')
     
#     if request.method == 'POST':
#         email = request.form['email']
#         user = UserModel.query.filter_by(email = email).first()
#         if user is not None and user.check_password(request.form['password']):
#             login_user(user)
#             return redirect('/adminUser')
     
#     return render_template('login.html')

# @app.route('/register', methods=['POST', 'GET'])
# def register():
#     if current_user.is_authenticated:
#         return redirect('/adminUser')
     
#     if request.method == 'POST':
#         email = request.form['email']
#         username = request.form['username']
#         password = request.form['password']
 
#         if UserModel.query.filter_by(email=email):
#             return ('Email already Present')
             
#         user = UserModel(email=email, username=username)
#         user.set_password(password)
#         db.session.add(user)
#         db.session.commit()
#         return redirect('/login')
#     return render_template('register.html')

# @app.route('/logout')
# def logout():
#     logout_user()
#     return redirect('/')

from flask import Flask, render_template, flash, redirect, request, session, logging, url_for
from flask_sqlalchemy import SQLAlchemy
from forms import LoginForm, RegisterForm
from werkzeug.security import generate_password_hash, check_password_hash

# app = Flask(__name__)
app.config['SECRET_KEY'] = '!9m@S-dThyIlW[pHQbN^'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

@app.before_first_request
def create_all():
    db.create_all()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name= db.Column(db.String(15), unique=True)
    username = db.Column(db.String(15), unique=True)
    email = db.Column(db.String(50), unique=True)
    password = db.Column(db.String(256), unique=True)


@app.route('/login/', methods = ['GET', 'POST'])
def login():
    form = LoginForm(request.form)
    if request.method == 'POST' and form.validate:
        user = User.query.filter_by(email = form.email.data).first()
        if user:
            if check_password_hash(user.password, form.password.data):
                flash('You have successfully logged in.', "success") 
                print('You have successfully logged in.')
                session['user_id'] = user.id           
                session['logged_in'] = True
                session['email'] = user.email 
                session['username'] = user.username
                return redirect(url_for('adminUser'))
            else:
                flash('Username or Password Incorrect', "Danger")
                return redirect(url_for('login'))

    return render_template('login.html', form = form)


@app.route('/register/', methods = ['GET', 'POST'])
def register():   
    form = RegisterForm(request.form)   
    if request.method == 'POST' and form.validate():   
        hashed_password = generate_password_hash(form.password.data, method='sha256') 
        new_user = User(         
            name = form.name.data,          
            username = form.username.data,         
            email = form.email.data,         
            password = hashed_password)
        db.session.add(new_user)
        db.session.commit()
        flash('You have successfully registered', 'success')
        return redirect(url_for('login')) 
    else: 
        return render_template('register.html', form = form)

@app.route('/logout/')
def logout():
    session['logged_in'] = False
    return redirect(url_for('home'))

from flask_login import LoginManager
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

@login_manager.user_loader
def load_user(id):
    return User.query.get(int(id))

import functools
def login_required(func):
    @functools.wraps(func)
    def secure_function(*args, **kwargs):
        if "email" not in session:
            return redirect(url_for("login", next=request.url))
        return func(*args, **kwargs)

    return secure_function

@app.route("/adminUser", methods =["GET", "POST"])
@login_required
def adminUser():
    if request.method == "GET":
        return render_template("adminUser.html")
    if request.method == "POST":
        admin_method_assign = request.form.get("admin_method_assign")
        if admin_method_assign == "RPDR":
            return redirect(url_for('admin_operation_rpdr'))
        else:
            return redirect(url_for('admin_operation_pdr'))
    return render_template("adminUser.html")   


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
    return {
        "input": {
            "user": arg[0],
            "action": arg[1],
            "object": arg[2],
            "context": arg[3]
        }
    }

def obtain_permission(p):
    data_JSON = opa_get_query("q=data.P."+p)
    # data_dict = json.loads(data_JSON)
    return data_JSON

def validate_admin_operation_input_function_pdr(*arg, **kwargs):
    return {
        "input": {
            "user": arg[0],
            "AR": arg[1],
            "P": [obtain_permission(arg[2])],
            "DR": [arg[3]]
        }
    }


def validate_admin_operation_input_function_rpdr(*arg, **kwargs):
    return {
        "input": {
            "user": arg[0],
            "AR": arg[1],
            "RP": {arg[2]},
            "DR": [arg[3]]
        }
    }


def opa_get_query(query):
    response = requests.post("http://localhost:8181/v1/query?" + query, timeout=200000) 
    app.logger.info("Response from data (query): %s", response)
    json_response = response.json()
    print(json_response)
    return json_response

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

@app.route('/admin_operation_rpdr', methods =["GET", "POST"])
@login_required
def admin_operation_rdpr():
    if request.method == "POST":
        user = session['username']
    #    user = request.form.get("user")
        adminRole = request.form.get("AR")
        rolePair = request.form.get("RP")
        deviceRole = request.form.get("DR")
        admin_method = request.form.get("admin_method")

        if admin_method == "assign":
            response = requests.post(app.config["OPA_ADMIN_URL_ASSIGN_RPDR"], json=validate_admin_operation_input_function_rpdr(user, adminRole, rolePair, deviceRole), timeout=200000) 
        else:
            response = requests.post(app.config["OPA_ADMIN_URL_REVOKE_RPDR"], json=validate_admin_operation_input_function_rpdr(user, adminRole, rolePair, deviceRole), timeout=200000) 
        app.logger.info("Admin operation allowed: %s", response)
        json_response = response.json()
        print(json_response)

        if json_response['result'] == True:
            return render_template("operation_allowed.html")
        else:
            return render_template("operation_not_allowed.html")

    return render_template("admin_operation_form_rpdr.html")

@app.route('/admin_operation_pdr', methods =["GET","POST"])
@login_required
def admin_operation_pdr():
    if request.method == "POST":
        user = session['username']
        adminRole = request.form.get("AR")
        permission = request.form.get("P")
        deviceRole = request.form.get("DR")
        admin_method = request.form.get("admin_method")

        if admin_method == "assign":
            response = requests.post(app.config["OPA_ADMIN_URL_ASSIGN_PDR"], json=validate_admin_operation_input_function_pdr(user, adminRole, permission, deviceRole), timeout=200000)
        else:
            response = requests.post(app.config["OPA_ADMIN_URL_REVOKE_PDR"], json=validate_admin_operation_input_function_pdr(user, adminRole, permission, deviceRole), timeout=200000)
        app.logger.info("Admin operation allowed: %s", response)
        json_response = response.json()
        print(json_response)

        if json_response['result'] == True:
            return render_template("operation_allowed.html")
        else:
            return render_template("operation_not_allowed.html")

    return render_template("admin_operation_form_pdr.html")


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