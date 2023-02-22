mod auth;

use iced::widget::{button, column, text};
use iced::{Alignment, Element, Sandbox, Settings};

pub fn main() -> iced::Result {
    App::run(Settings::default())
}

struct App {
    auth_state: railwayapp::gql::,
}

#[derive(Debug, Clone, Copy)]
enum Message {
    LogIn,
}

impl Sandbox for App {
    type Message = Message;

    fn new() -> Self {
        Self { logged_in: false }
    }

    fn title(&self) -> String {
        String::from("Skyhook")
    }

    fn update(&mut self, message: Message) {
        match message {
            Message::LogIn => {
                self.
            }
        }
    }

    fn view(&self) -> Element<Message> {
        column![
            button("Increment").on_press(Message::IncrementPressed),
            text(self.value).size(50),
            button("Decrement").on_press(Message::DecrementPressed)
        ]
        .padding(20)
        .align_items(Alignment::Center)
        .into()
    }
}

