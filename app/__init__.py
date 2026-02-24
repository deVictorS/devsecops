from flask import Flask

def create_app():
    app = Flask(__name__)

    import app.routes as routes
    app.register_blueprint(routes.main)

    return app