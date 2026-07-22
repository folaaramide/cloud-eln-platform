from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required

from app.extensions import db
from app.models.experiment import Experiment

experiments_bp = Blueprint("experiments", __name__)


@experiments_bp.route("/experiments", methods=["GET", "POST"])
@login_required
def experiments():

    if request.method == "POST":

        experiment = Experiment(
            experiment_id=request.form["experiment_id"],
            title=request.form["title"],
            product=request.form["product"],
            batch_number=request.form["batch_number"],
            sample_id=request.form["sample_id"],
            test_type=request.form["test_type"],
            objective=request.form["objective"]
        )

        db.session.add(experiment)
        db.session.commit()

        flash("Experiment created successfully!", "success")

        return redirect(url_for("experiments.experiments"))

    experiment_list = Experiment.query.order_by(
        Experiment.created_at.desc()
    ).all()

    return render_template(
        "experiments.html",
        experiments=experiment_list
    )

@experiments_bp.route("/experiment/<int:id>")
@login_required
def view_experiment(id):

    experiment = Experiment.query.get_or_404(id)

    return render_template(
        "experiment_details.html",
        experiment=experiment
    )

@experiments_bp.route("/experiment/<int:id>/edit", methods=["GET", "POST"])
@login_required
def edit_experiment(id):

    experiment = Experiment.query.get_or_404(id)

    if request.method == "POST":

        experiment.title = request.form["title"]
        experiment.product = request.form["product"]
        experiment.batch_number = request.form["batch_number"]
        experiment.sample_id = request.form["sample_id"]
        experiment.test_type = request.form["test_type"]
        experiment.objective = request.form["objective"]
        experiment.results = request.form["results"]
        experiment.conclusion = request.form["conclusion"]
        experiment.notes = request.form["notes"]
        experiment.status = request.form["status"]

        db.session.commit()

        flash("Experiment updated successfully!", "success")

        return redirect(
            url_for("experiments.view_experiment", id=id)
        )

    return render_template(
        "edit_experiment.html",
        experiment=experiment
    )

@experiments_bp.route("/experiment/<int:id>/delete", methods=["GET", "POST"])
@login_required
def delete_experiment(id):

    experiment = Experiment.query.get_or_404(id)

    if request.method == "POST":

        db.session.delete(experiment)
        db.session.commit()

        flash("Experiment deleted successfully!", "success")

        return redirect(
            url_for("experiments.experiments")
        )

    return render_template(
        "delete_experiment.html",
        experiment=experiment
    )