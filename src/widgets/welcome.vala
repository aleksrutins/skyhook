using Gtk;

namespace Skyhook {
    class WelcomePage : Widget {
        private Label label;
        static construct {
            set_layout_manager_type(typeof(Gtk.GridLayout));
        }
        public WelcomePage() {
            hexpand = true;
            label = new Label(null);
            label.set_markup ("<span size=\"xx-large\" weight=\"bold\" rise=\"20pt\">Welcome</span>\nCreate a project to get started.");
            label.hexpand = true;
            label.vexpand = true;
            label.halign = FILL;
            label.valign = FILL;
            label.justify = CENTER;
            label.set_parent (this);
        }

        ~WelcomePage() {
            label.unparent();
        }
    }
}
