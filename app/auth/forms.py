from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SelectField, SubmitField
from wtforms.validators import DataRequired, Email, EqualTo


class RegistrationForm(FlaskForm):

    full_name = StringField(
        "Full Name",
        validators=[DataRequired()]
    )

    email = StringField(
        "Email",
        validators=[DataRequired(), Email()]
    )

    role = SelectField(
        "Role",
        choices=[
            ("Scientist", "Scientist"),
            ("Reviewer", "Reviewer")
        ]
    )

    password = PasswordField(
        "Password",
        validators=[DataRequired()]
    )

    confirm_password = PasswordField(
        "Confirm Password",
        validators=[
            DataRequired(),
            EqualTo("password")
        ]
    )

    submit = SubmitField("Register")


class LoginForm(FlaskForm):

    email = StringField(
        "Email",
        validators=[DataRequired(), Email()]
    )

    password = PasswordField(
        "Password",
        validators=[DataRequired()]
    )

    submit = SubmitField("Sign In")