from flask import Blueprint, render_template
from flask_login import login_required

from app.models.experiment import Experiment

dashboard_bp = Blueprint("dashboard", __name__)


@dashboard_bp.route("/dashboard")
@login_required
def dashboard():

    total = Experiment.query.count()

    draft = Experiment.query.filter_by(
        status="Draft"
    ).count()

    in_progress = Experiment.query.filter_by(
        status="In Progress"
    ).count()

    completed = Experiment.query.filter_by(
        status="Completed"
    ).count()

    recent = Experiment.query.order_by(
        Experiment.created_at.desc()
    ).limit(5).all()

    return render_template(
        "dashboard.html",
        total=total,
        draft=draft,
        in_progress=in_progress,
        completed=completed,
        recent=recent
    )