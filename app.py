from flask import Flask, render_template, request, redirect, url_for, flash
import os

app = Flask(__name__)
app.secret_key = "your_secret_key"  # For flash messages

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


@app.route('/')
def index():
    return render_template("index.html")


@app.route('/create_database', methods=['POST'])
def create_database():
    db_name = request.form.get('db_name')
    db_directory = request.form.get('db_directory', BASE_DIR)

    if not db_name.isalnum():
        flash("Invalid database name. Only alphanumeric characters are allowed.", "error")
        return redirect(url_for('index'))

    db_path = os.path.join(db_directory, db_name)

    if os.path.exists(db_path):
        flash(f"Database {db_name} already exists.", "error")
    else:
        os.makedirs(db_path)
        flash(f"Database {db_name} created successfully.", "success")

    return redirect(url_for('index'))


@app.route('/list_databases')
def list_databases():
    # Get list of databases (directories) in the base folder
    databases = [name for name in os.listdir(BASE_DIR) if os.path.isdir(os.path.join(BASE_DIR, name))]
    return render_template("index.html", databases=databases)


@app.route('/drop_database/<db_name>', methods=['POST'])
def drop_database(db_name):
    db_path = os.path.join(BASE_DIR, db_name)
    if os.path.exists(db_path):
        os.rmdir(db_path)
        flash(f"Database {db_name} has been deleted.", "success")
    else:
        flash(f"Database {db_name} does not exist.", "error")
    return redirect(url_for('index'))


@app.route('/connect_to_database', methods=['POST'])
def connect_to_database():
    db_name = request.form.get('db_name')

    db_path = os.path.join(BASE_DIR, db_name)

    if os.path.exists(db_path):
        flash(f"Connected to {db_name} successfully.", "success")
    else:
        flash(f"Database {db_name} does not exist.", "error")

    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True)
