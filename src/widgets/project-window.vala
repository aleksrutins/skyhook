using Gtk;

namespace Skyhook {
    [GtkTemplate(ui = "/com/rutins/Skyhook/project-window.ui")]
    public class ProjectWindow : Adw.Window {
        private string id;

        public string project_name {get; set;}

        [GtkChild]
        private Adw.ViewStack view_stack;

        public ProjectWindow(string id, string name) {
            Object(title: name);
            this.id = id;
            this.project_name = name;
            view_stack.visible_child_name = "loading";
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

            view_stack.visible_child_name = "content";
        }
    }
}