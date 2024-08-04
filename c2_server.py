from flask import Flask, send_file
import os

app = Flask(__name__)

@app.route('/c2', methods=['GET'])
def c2_action():
    malware_path = "eicar.com"
    with open(malware_path, "w") as file:
        file.write("X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FI
LE!$H+H")
    return send_file(malware_path, as_attachment=True)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
