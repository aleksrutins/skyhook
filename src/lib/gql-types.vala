namespace Skyhook.Util.GQL.Types {
    public class User : Object {
        public string email;
        public string id;
        public string name;
    }
    public class MeResponse : Object {
        public User me;
    }
}