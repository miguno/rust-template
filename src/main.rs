use base64::{engine::general_purpose, Engine as _};
use rust_template::sum;

pub fn main() {
    let s = "Hello, world!";
    println!("{}", s);
    println!("2 plus 2 ist {}, immer und überall!", sum(2, 2));

    // We use the base64 crate only as an example to demonstrate the use of
    // crates within this project.  For instance, try running `just deps`
    // (or `cargo tree`) in a terminal to show the dependencies of this
    // project, which will include the base64 crate.
    let b64 = general_purpose::STANDARD.encode(s.as_bytes());
    println!("'{}' in base64: '{}'", s, b64);
}
