use obfstr::obfstr;
use crate::api::status::UpdateButtStatus;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
/// Demo functions
pub fn get_remote_url() -> String {
    obfstr!("https://PATH/").to_string()
}

pub fn check_update() -> (UpdateButtStatus, String) {
    (UpdateButtStatus::UpdateAvailable, "VERSION NEWER".to_string())
}

pub fn get_latest_release_note() -> String {
    obfstr!(
        r#"1. Improved system stability and performance.
2. Fixed some known bugs and issues.
3. Updated security patches to enhance device security.
4. Added new features and optimizations for a better user experience.
5. Improved battery life and power management.
6. Enhanced compatibility with third-party apps and services.
7. Updated user interface for a more modern and intuitive design.
8. Improved camera performance and added new shooting modes.
9. Enhanced privacy features and controls for better user data protection.
"#).to_string()
}
