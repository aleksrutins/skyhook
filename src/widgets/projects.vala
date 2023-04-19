using Gtk;

namespace Skyhook {
    public class ProjectsPage : Widget {
        class Preview : Button {
            static construct {
                set_layout_manager_type (typeof(Gtk.BinLayout));
            }

            string id;

            public Preview(Json.Object data) {
                css_classes = {"card", "activatable"};
                var box = new Box(VERTICAL, 12);

                id = data.get_string_member ("id");
                box.append(new Label(data.get_string_member ("name")) {css_classes = {"title-2"}, margin_top = 10});
                box.append(new Label(id) {css_classes = {"caption"}, margin_start = 10, margin_end = 10, margin_bottom = 10});
                box.set_parent (this);
            }
        }
        private FlowBox content_box = new FlowBox();
        static construct {
            set_layout_manager_type (typeof(Gtk.GridLayout));
        }
        public ProjectsPage(Json.Array projects) {
            hexpand = true;
            vexpand = true;
            content_box.set_parent (this);
            content_box.hexpand = true;
            projects.foreach_element ((arr, index, project) => {
                var data = project.get_object ().get_object_member ("node");
                var preview = new Preview(data);
                preview.clicked.connect (() => {
                    (new ProjectWindow(data.get_string_member ("id"), data.get_string_member ("name"))).show ();
                });

                content_box.append (preview);
            });
        }
    }
}