using Gtk;

namespace Skyhook {
    public class ProjectWindow : Adw.Window {
        private string id;
        private string name;
        private Box box;
        private Spinner spinner;
        public ProjectWindow(string id, string name) {
            Object(title: name);
            this.id = id;
            this.name = name;
            
            box = new Gtk.Box(VERTICAL, 6);
            box.append (new Adw.HeaderBar ());
            spinner = new Spinner();
            spinner.spinning = true;
            spinner.vexpand = true;
            spinner.hexpand = true;
            box.append(spinner);
            content = box;
            load_data.begin();
        }

        private async void load_data() {
            var client = ((Application)GLib.Application.get_default()).gql_client;
            var result = yield client.run("""
            query {
                project(id: \"""" + id + """\") {
                    name
                    description
                }
            }
            """);

            spinner.unparent();

            box.append(new Label(result.get_object().get_object_member("project").get_string_member("name")) { css_classes = {"title-1"}, margin_top = 10, margin_bottom = 10 });
            box.append(new Label(result.get_object().get_object_member("project").get_string_member("description")));
        }
    }
}