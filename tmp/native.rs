use jni::JNIEnv;
use jni::objects::{JClass, JObject, JString};
use jni::sys::{jboolean, jint, jstring};

const PROP_AUTHOR: &str = "ro.build.portrom.author";
const PROP_VERSION: &str = "ro.port.version";

const VAL_AUTHOR: &str = "xxtvrxx233";
const VAL_VERSION: &str = "版本: 16.0.1.301(FindX8U_25.12.11)";

const URL_P2: &str = "https://xxtvrxx233.github.io/";
const URL_P1: &str = "https://rdhyf.github.io/";

const COPYRIGHT: &str = "Copyright © NatsuYuki, xxtvrxx233";

fn get_system_property(name: &str) -> Option<String> {
    std::fs::read_to_string(format!("/system/build.prop"))
        .ok()
        .and_then(|content| {
            content
                .lines()
                .find_map(|line| {
                    let line = line.trim();
                    if line.starts_with(name) {
                        line.split('=').nth(1).map(|s| s.trim().to_string())
                    } else {
                        None
                    }
                })
        })
}

unsafe fn get_system_property_native(name: &str) -> Option<String> {
    let cname = std::ffi::CString::new(name).ok()?;
    let mut value = [0i8; libc::PROP_VALUE_MAX as usize];
    let len = libc::__system_property_get(cname.as_ptr(), value.as_mut_ptr());
    if len > 0 {
        Some(std::ffi::CStr::from_ptr(value.as_ptr()).to_string_lossy().into_owned())
    } else {
        None
    }
}

fn check_system_prop(prop_name: &str, expected_value: &str) -> bool {
    unsafe { get_system_property_native(prop_name) }
        .as_deref()
        .map(|v| v == expected_value)
        .unwrap_or(false)
}

#[no_mangle]
pub extern "system" fn Java_com_oplus_otaui_activity_EntryActivity_verifyEnvironmentNative(
    mut env: JNIEnv,
    _thiz: JObject,
) -> jint {
    let p2_match = check_system_prop(PROP_AUTHOR, VAL_AUTHOR);
    let p1_match = check_system_prop(PROP_VERSION, VAL_VERSION);

    if !p2_match && !p1_match {
        return 0;
    }

    if p2_match { 2 } else { 1 }
}

#[no_mangle]
pub extern "system" fn Java_com_oplus_ota_OtaHelper_UpdateChecker_nativeGetRemoteBaseUrl(
    mut env: JNIEnv,
    _class: JClass,
    is_p2_match: jboolean,
) -> jstring {
    let url = if is_p2_match != 0 { URL_P2 } else { URL_P1 };
    env.new_string(url).unwrap().into_raw()
}

#[no_mangle]
pub extern "system" fn Java_com_oplus_otaui_activity_EntryActivity_nativeGetCopyrightText(
    mut env: JNIEnv,
    _thiz: JObject,
) -> jstring {
    env.new_string(COPYRIGHT).unwrap().into_raw()
}
