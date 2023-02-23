using Gtk;

namespace Skyhook {
    public class ProjectsView : Widget {
        private FlowBox content_box;
        static construct {
            set_layout_manager_type (typeof(Gtk.GridLayout));
        }
        public ProjectsView() {
            hexpand = true;
            vexpand = true;
            
        }
    }
}