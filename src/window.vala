/* MIT License
 *
 * Copyright (c) 2023 Aleks Rutins
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * SPDX-License-Identifier: MIT
 */

using Skyhook.Util.GQL.Types;

namespace Skyhook {
    [GtkTemplate (ui = "/com/rutins/Skyhook/window.ui")]
    public class Window : Adw.ApplicationWindow {
        [GtkChild]
        private unowned Adw.Avatar user_icon;

        [GtkChild]
        private unowned Adw.ViewStack content_stack;

        private async void login(string token) {
            var app = (Application)application;
            var client = app.gql_client;
            client.set_token (token);
            yield actually_login();
        }

        private async void actually_login() {
            var app = (Application)application;
            var client = app.gql_client;
            content_stack.visible_child_name = "loading-spinner";
            var data = yield client.run("""
              query {
                me {
                  id
                  name
                  email
                }
                projects {
                  edges {
                    node {
                      name
                      id
                    }
                  }
                }
              }
            """);
            user_icon.show_initials = true;
            user_icon.text = data.get_object().get_object_member("me").get_string_member("name");

            content_stack.add_named(new ProjectsPage(data.get_object().get_object_member("projects").get_array_member("edges")), "projects-view");
            content_stack.visible_child_name = "projects-view";
        }

        public Window (Gtk.Application app) {
            Object (application: app);
            content_stack.add_named ((Gtk.Widget)Object.new(typeof(Gtk.Spinner), spinning: true, vexpand: true, halign: Gtk.Align.CENTER, valign: Gtk.Align.CENTER), "loading-spinner");
            content_stack.add_named (new WelcomePage (), "welcome");
            
            var login_page = new LoginPage();
            login_page.login.connect(login);
            content_stack.add_named (login_page, "login");
            content_stack.visible_child_name = "loading-spinner";
            load_projects.begin();
        }

        private async void load_projects() {
            var app = (Application)application;
            if(!app.gql_client.has_token()) {
                content_stack.visible_child_name = "login";
            } else {
                yield actually_login();
            }
        }
    }
}
