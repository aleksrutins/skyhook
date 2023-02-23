namespace Skyhook.Util.GQL {
    errordomain AuthError {
        failed,
        no_token
    }
    class Client {
        private Soup.Session session;
        private string? token;
        private const string API_URL = "https://backboard.railway.app/graphql/v2";

        public Client() {
            session = new Soup.Session();
        }

        private Soup.Message create_message(string query) {
            var msg = new Soup.Message("POST", API_URL);
            msg.set_request_body_from_bytes("application/json", new Bytes(@"{\"query\":\"$(query)\"}".data));
            return msg;
        }

        private async Result run_message<Result>(Soup.Message msg) throws Error {
            var result = yield session.send_and_read_async(msg, GLib.Priority.DEFAULT, null);
            return Json.gobject_from_data(typeof(Result), (string) result.get_data(), result.length);
        }

        public void set_token(string token) {
            this.token = token;
        }

        public async Result run_anonymous<Result>(string query) throws Error {
            return yield run_message(create_message(query));
        }

        public async Result run_with_auth<Result>(string query) throws AuthError, Error {
            if(token == null) throw new AuthError.no_token("No token provided");
            var msg = create_message(query);
            msg.request_headers.append("Authorization", @"Bearer $token");
            return yield run_message(msg);
        }

        public async Result run<Result>(string query) throws AuthError, Error {
            if(token == null) return yield run_anonymous<Result>(query);
            else return yield run_with_auth<Result>(query);
        }
    }
}
