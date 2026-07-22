from flask import Blueprint, render_template, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required

from app.auth.forms import RegistrationForm, LoginForm
from app.extensions import db, bcrypt
from app.models.user import User

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/register", methods=["GET", "POST"])
def register():

    form = RegistrationForm()

    if form.validate_on_submit():

        hashed_password = bcrypt.generate_password_hash(
            form.password.data
        ).decode("utf-8")

        user = User(
            full_name=form.full_name.data,
            email=form.email.data,
            password=hashed_password,
            role=form.role.data
        )

        db.session.add(user)
        db.session.commit()

        flash("Registration successful!", "success")

        return redirect(url_for("auth.login"))

    return render_template(
        "register.html",
        form=form
    )

@auth_bp.route("/login", methods=["GET", "POST"])
def login():

    form = LoginForm()

    if form.validate_on_submit():

        user = User.query.filter_by(
            email=form.email.data
        ).first()

        if user and bcrypt.check_password_hash(
            user.password,
            form.password.data
        ):

            login_user(user)

            flash(
                "Welcome back!",
                "success"
            )

            return redirect(
                url_for("dashboard.dashboard")
            )

        flash(
            "Invalid email or password.",
            "danger"
        )

    return render_template(
        "login.html",
        form=form
    )

@auth_bp.route("/logout")
@login_required
def logout():

    logout_user()

    flash(
        "You have been signed out.",
        "success"
    )

    return redirect(
        url_for("home.home")
    )