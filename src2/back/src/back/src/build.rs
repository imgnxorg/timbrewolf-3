use std::process::Command;

fn main() {
    println!("cargo:rerun-if-changed=frontend/"); // or remove if not using that folder

    let status = Command::new("yarn")
        .arg("build")
        .status()
        .expect("❌ Failed to run 'yarn build'");

    if !status.success() {
        panic!("❌ 'yarn build' failed — aborting Rust build.");
    }

    println!("✅ Frontend built successfully.");
}
