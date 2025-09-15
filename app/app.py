from flask import Flask, render_template
import mysql.connector
import os

app = Flask(__name__)

def get_db_connection():
    conn = mysql.connector.connect(
        host="db",
        database="mydb",
        user="myuser",
        password="mypassword"
    )
    return conn

@app.route("/")
def home():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT message FROM greetings LIMIT 1;")
    greeting = cur.fetchone()[0]
    cur.close()
    conn.close()
    return render_template("index.html", greeting=greeting)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
