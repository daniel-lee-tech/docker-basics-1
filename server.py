from http.server import BaseHTTPRequestHandler, HTTPServer

hostName = "0.0.0.0" # THIS CANNOT BE LOCALHOST, it will not work in docker containers.
serverPort = 8080

class MyWebServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<p>Simple web server from python</p>", "utf-8"))


if __name__ == "__main__":
    webServer = HTTPServer((hostName, serverPort), MyWebServer)
    print("server started at host: " + hostName + " on port: " + str(serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        webServer.server_close()
        print("Server stopped.")
