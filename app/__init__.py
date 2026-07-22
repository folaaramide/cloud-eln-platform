from flask import Flask

from config import Config

from app.extensions import (
    db,
    migrate,
    bcrypt,
    login_manager
)

from app.models.user import User
from app.models.experiment import Experiment

from app.routes.home import home_bp
from app.routes.dashboard import dashboard_bp
from app.routes.experiments import experiments_bp
from app.routes.reports import reports_bp

from app.auth import auth_bp


def create_app():

    app = Flask(__name__)

    app.config.from_object(Config)

    db.init_app(app)
    migrate.init_app(app, db)
    bcrypt.init_app(app)
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

    app.register_blueprint(home_bp)
    app.register_blueprint(dashboard_bp)
    app.register_blueprint(experiments_bp)
    app.register_blueprint(reports_bp)
    app.register_blueprint(auth_bp)

    return app