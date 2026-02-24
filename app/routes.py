#teste
from flask import Blueprint, render_template, request

main = Blueprint("main", __name__)

@main.route("/")
def home():
    return render_template("index.html")

@main.route("/processar", methods=["POST"])
def processar():
    nome = request.form.get("nome")
    return render_template("resultado.html", nome=nome)