namespace Skyhook.Util.GQL {
    public errordomain AuthError {
        failed,
        no_token
    }
    public class Client {
        private Soup.Session session;
        private string? token;
        private const string API_URL = "https://backboard.railway.app/graphql/v2";

        public Client() {
            session = new Soup.Session();
            var token_file = File.new_for_path(Environment.get_home_dir() + "/.skyhook-token");
            if(token_file.query_exists()) {
                try {
                    token = (string)token_file.read().read_bytes(37, null).get_data();
                    token.data[38] = 0;
                    token = token.strip();
                } catch(Error e) {}
            }
        }

        private Soup.Message create_message(string query) {
            var msg = new Soup.Message("POST", API_URL);
            var valid_query = query.replace("\n", "");
            msg.set_request_body_from_bytes("application/json", new Bytes(@"{\"query\":\"$(valid_query)\"}".data));
            return msg;
        }

        private async Json.Node run_message(Soup.Message msg) throws Error {
            var result = yield session.send_and_read_async(msg, GLib.Priority.DEFAULT, null);
            print((string)result.get_data());
            var node = Json.from_string((string)result.get_data());
            return node.get_object().get_member("data");
        }

        public void set_token(string token) {
            this.token = token;
            var token_file = File.new_for_path(Environment.get_home_dir() + "/.skyhook-token");
            try {
                size_t size;
                token_file.create(FileCreateFlags.REPLACE_DESTINATION, null).write_all(token.data, out size, null);
            } catch(Error e) {}
        }

        public bool has_token() {
            return this.token != null;
        }

        public async Json.Node run_anonymous(string query) throws Error {
            return yield run_message(create_message(query));
        }

        public async Json.Node run_with_auth(string query) throws AuthError, Error {
            if(token == null) throw new AuthError.no_token("No token provided");
            var msg = create_message(query);
            msg.request_headers.append("Authorization", @"Bearer $token");
            return yield run_message(msg);
        }

        public async Json.Node run(string query) throws AuthError, Error {
            if(token == null) return yield run_anonymous(query);
            else return yield run_with_auth(query);
        }
    }
}
