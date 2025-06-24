use tao::{
    event::{Event, StartCause, WindowEvent},
    event_loop::{ControlFlow, EventLoop},
    window::WindowBuilder,
};
use wry::WebViewBuilder;
use std::path::PathBuf;

fn resolve_html_path() -> std::io::Result<PathBuf> {
    // Try bundle-style path
    if let Ok(exe_path) = std::env::current_exe() {
        if let Some(bundle_path) = exe_path
            .parent()
            .and_then(|p| p.parent())
            .map(|p| p.join("Resources/dist/index.html"))
        {
            if bundle_path.exists() {
                return Ok(bundle_path);
            }
        }
    }

    // Fallback to dev path
    let dev_path = std::env::current_dir()?
        .join("frontend")
        .join("dist")
        .join("index.html");

    if dev_path.exists() {
        return Ok(dev_path);
    }

    Err(std::io::Error::new(
        std::io::ErrorKind::NotFound,
        "index.html not found in .app bundle or dev path",
    ))
}

fn main() -> wry::Result<()> {
    let event_loop = EventLoop::new();
    let window = WindowBuilder::new()
        .build(&event_loop)
        .expect("🪟 Failed to create window");

    let html_path = resolve_html_path()?;
    let url = format!("file://{}", html_path.display());

    let _webview = WebViewBuilder::new()
        .with_url(&url)
        .with_initialization_script(
            r#"
            document.title = 'Taku IDE';
            console.log('🌐 Wry is alive!');
        "#,
        )
        .build(&window)?;

    event_loop.run(move |event, _, control_flow| {
        *control_flow = ControlFlow::Wait;

        match event {
            Event::NewEvents(StartCause::Init) => println!("🌀 App started."),
            Event::WindowEvent {
                event: WindowEvent::CloseRequested,
                ..
            } => {
                println!("👋 Exiting...");
                *control_flow = ControlFlow::Exit;
            }
            _ => (),
        }
    });
}
