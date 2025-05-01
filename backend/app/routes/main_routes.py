from flask import Blueprint

main = Blueprint('main', __name__)

@main.route("/", methods=["GET"])
def test():
    return "Docker Container Test"