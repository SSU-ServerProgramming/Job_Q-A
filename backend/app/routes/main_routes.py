from flask import Blueprint, jsonify

main = Blueprint('main', __name__)

@main.route("/")
def test():
    return "Docker Container Test"