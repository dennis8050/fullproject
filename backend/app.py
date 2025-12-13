from flask import Flask, request, jsonify
import psycopg2
import os

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "postgres"),
        database=os.getenv("DB_NAME", "userdb"),
        user=os.getenv("DB_USER", "user"),
        password=os.getenv("DB_PASSWORD", "password")
    )
    return conn

@app.route('/api/apply', methods=['POST'])
def apply():
    data = request.get_json()
    name = data.get("name")
    email = data.get("email")
    message = data.get("message")

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO applications (name, email, message) VALUES (%s, %s, %s)",
                (name, email, message))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"status": "success", "msg": "Application saved"}), 201

@app.route('/api/applications', methods=['GET'])
def get_apps():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, name, email, message FROM applications")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    apps = [{"id": r[0], "name": r[1], "email": r[2], "message": r[3]} for r in rows]
    return jsonify(apps)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
