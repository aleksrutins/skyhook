using Gtk;
using Skyhook.Util.GQL.Types;

namespace Skyhook {
    public class LoginPage : Widget {
        private Entry token_entry;

        public signal void login(string token);

        public string token {
            get {
                return token_entry.text;
            }
        }

        static construct {
            set_layout_manager_type (typeof(BoxLayout));
        }

        private void login_clicked() {
            login(token_entry.text);
        }

        public LoginPage() {
            set_layout_manager (new BoxLayout(VERTICAL));
            margin_top = margin_bottom = margin_start = margin_end = 20;
            
            (new Label("Log In") {
                css_classes = {"title-1"},
                margin_bottom = 5,
            }).set_parent(this);

            var clamp = (new Adw.Clamp() {
                tightening_threshold = 300,
            });
            var box = (new Box(VERTICAL, 0) {
                css_classes = { "vertical", "linked" },
            });
            {
                token_entry = new Entry () {
                    width_request = 100,
                    placeholder_text = "API Token",
                };
                box.append(token_entry);

                var login_button = new Button.with_label("Log In");
                login_button.clicked.connect(login_clicked);
                box.append(login_button);
            }
            box.set_parent(clamp);
            clamp.set_parent(this);

            (new Label("<a href='https://docs.railway.app/reference/public-api#authentication'>What's this?</a>") {
                use_markup = true,
                margin_top = 5,
            }).set_parent(this);
        }
    }
}