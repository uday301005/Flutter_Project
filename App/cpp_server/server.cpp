#include <iostream>
#include <string>
#include <thread>
#include <boost/asio.hpp>

using namespace std;
using boost::asio::ip::tcp;

void handle_client(tcp::socket socket) {
    try {
        boost::asio::streambuf buf;

        // Read headers first (up to the empty line)
        boost::asio::read_until(socket, buf, "\r\n\r\n");

        std::istream req_stream(&buf);
        std::string request_headers;
        std::string line;

        // Read request line and headers into a single string for logging
        while (std::getline(req_stream, line) && line != "\r") {
            request_headers += line + "\n";
        }

        cout << "📩 Request headers received:\n" << request_headers << endl;

        // Parse Content-Length if present
        size_t content_length = 0;
        auto pos = request_headers.find("Content-Length:");
        if (pos != std::string::npos) {
            // simple parse
            std::istringstream iss(request_headers.substr(pos + 15));
            iss >> content_length;
        }

        std::string body;
        if (content_length > 0) {
            // If some of the body is already in the buffer, read the rest
            std::vector<char> body_buf;
            size_t already = buf.size();
            if (already > 0) {
                body_buf.resize(already);
                req_stream.read(body_buf.data(), already);
            }

            if (content_length > already) {
                size_t to_read = content_length - already;
                body_buf.resize(content_length);
                boost::asio::read(socket, boost::asio::buffer(body_buf.data() + already, to_read));
            }

            body.assign(body_buf.begin(), body_buf.end());
            cout << "📥 Body: " << body << endl;

            // Print parsed location if available
            auto find_value = [&](const string &key) -> string {
                auto pos_key = body.find(key);
                if (pos_key == string::npos) return "";
                auto colon = body.find(':', pos_key);
                if (colon == string::npos) return "";
                auto start = colon + 1;
                while (start < body.size() && (body[start] == ' ' || body[start] == '"')) start++;
                auto end = start;
                while (end < body.size() && body[end] != ',' && body[end] != '}' && body[end] != '"') end++;
                return body.substr(start, end - start);
            };

            string lat = find_value("\"latitude\"");
            string lon = find_value("\"longitude\"");
            if (!lat.empty() && !lon.empty()) {
                cout << "📍 Parsed location: latitude=" << lat << ", longitude=" << lon << endl;
            }
        }

        // 🔥 check karo SOS API hit hua ya nahi
        if (request_headers.find("POST /sos") != string::npos) {
            cout << "🚨 SOS RECEIVED!" << endl;
        }

        string response =
            "HTTP/1.1 200 OK\r\n"
            "Content-Type: text/plain\r\n"
            "Content-Length: 2\r\n\r\n"
            "OK";

        boost::asio::write(socket, boost::asio::buffer(response));
    }
    catch (std::exception &ex) {
        cout << "❌ Error handling client: " << ex.what() << "\n";
    }
}

int main() {
    boost::asio::io_context io;
    tcp::acceptor acceptor(io, tcp::endpoint(tcp::v4(), 8080));

    cout << "🚀 Server running at http://localhost:8080\n";

    while (true) {
        tcp::socket socket(io);
        acceptor.accept(socket);

        thread(handle_client, move(socket)).detach();
    }
}