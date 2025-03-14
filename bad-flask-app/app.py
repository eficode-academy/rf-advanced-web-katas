import random
from copy import deepcopy
from flask import Flask, render_template, request, jsonify, make_response
from flask_restful import Resource, Api
import os

app = Flask(__name__, template_folder='templates')
api = Api(app)

PORT = os.getenv("PORT", 5000)

@app.route('/')
def index():
    r1 = random.randint(10000, 900000)
    r2 = random.randint(10000, 900000)
    dropdown_open = "open" if random.randint(1,5) > 2 else ""
    return render_template('index.html', iframe=f"http://localhost:{PORT}/form", random_number1=r1, random_number2=r2, open=dropdown_open)

@app.route('/form', methods = ['GET', 'POST'])
def form():
    if request.method == 'POST':
        return render_template('success.html')
    else:
        return render_template('form.html')

@app.route('/success', methods = ['GET','POST'])
def success():
    if request.method == 'POST':
        return render_template('form.html')
    else:
        return render_template('success.html')

@api.resource('/api/auth')
class BadFlaskAppAuth(Resource):
    def post(self):
        return make_response("NotAGoodToken", 200)


@api.resource('/api/forms', '/api/forms/<id>')
class BadFlaskApp(Resource):
    data = [{
            "id": 1,
            "name": "John Doe",
            "email": "holy@macaroni.noodle",
            "message": "Today was a good day.",
            "company": "Non-Existant Inc.",
            "date": "31.05.2020",
            "important-number": "15"
            },
            {"id": 2,
            "name": "Mickey Mouse",
            "email": "mouse@mickey.yes",
            "message": "I'm the lord of the Disney World",
            "company": "Best Corp.",
            "date": "01.06.2020",
            "important-number": "88"
            }]
    response_403 = "403 - Unauthorized. Did you forget your header?\n"
    ids = [x["id"] for x in data]

    def is_authenticated(self, request):
        try:
            return request.headers["authorization"].strip() == "Bearer NotAGoodToken"
        except KeyError:
            return False

    def get(self, id=None):
        if self.is_authenticated(request):
            if id == None:
                return make_response(jsonify(self.data), 200)
            try:
                data = self.data[int(id)-1]
                return make_response(jsonify(data), 200)
            except IndexError:
                return make_response("404 - Not Found.\n", 404)
        return make_response(self.response_403, 403)

    def post(self):
        if self.is_authenticated(request):
            x = request.get_json()
            try:
                if x["id"] in self.ids:
                    return make_response("400 - Bad request. Id already in use.\n", 400)
                return make_response(jsonify(x), 201)
            except KeyError:
                return make_response("400 - Bad request. Id is a mandatory field.\n", 400)
        return make_response(self.response_403, 403)

    def put(self, id=None):
        if self.is_authenticated(request):
            try:
                x = request.get_json()
                response = {}
                if id != None:
                    x["id"] = id
                if x["id"] in self.ids:
                    i = self.ids.index(x["id"])
                    response = deepcopy(self.data[i])
                response.update(x)
                return make_response(jsonify(response), 200)
            except KeyError:
                return make_response("400 - Bad request. Id is mandatory either in endpoint or data.\n", 400)
        return make_response(self.response_403, 403)

if __name__ == '__main__':
    app.secret_key = 'etikinaarvaaasalaistaavaintani'
    app.config['SESSION_TYPE'] = 'filesystem'

    app.run(debug=True, host='0.0.0.0')
