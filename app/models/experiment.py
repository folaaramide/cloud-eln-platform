from datetime import datetime
from app.extensions import db


class Experiment(db.Model):

    __tablename__ = "experiments"

    id = db.Column(db.Integer, primary_key=True)

    experiment_id = db.Column(db.String(50), unique=True, nullable=False)

    title = db.Column(db.String(200), nullable=False)

    objective = db.Column(db.Text)

    product = db.Column(db.String(150))

    batch_number = db.Column(db.String(100))

    sample_id = db.Column(db.String(100))

    test_type = db.Column(db.String(100))

    status = db.Column(
        db.String(50),
        default="Draft"
    )

    results = db.Column(db.Text)

    conclusion = db.Column(db.Text)

    notes = db.Column(db.Text)

    created_at = db.Column(
        db.DateTime,
        default=datetime.utcnow
    )

    updated_at = db.Column(
        db.DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )