use obfstr::obfstr;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
/// Demo functions
pub fn get_remote_url() -> String{
    obfstr!("https://xxtvrxx233.github.io/").to_string()
}