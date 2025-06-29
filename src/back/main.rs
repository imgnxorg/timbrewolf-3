use tao::{
    event::{Event, StartCause, WindowEvent},
    event_loop::{ControlFlow, EventLoop},
    window::WindowBuilder,
};
use wry::{WebViewBuilder, WebContext};
use std::path::PathBuf;
use serde::{Deserialize, Serialize};
use std::process::Command;
use std::fs;
use std::collections::HashMap;

#[derive(Serialize, Deserialize)]
struct BarkRequest {
    text: String,
    voice_preset: Option<String>,
    text_temp: Option<f32>,
    waveform_temp: Option<f32>,
}

#[derive(Serialize, Deserialize)]
struct BarkResponse {
    success: bool,
    audio_path: Option<String>,
    error: Option<String>,
}

async fn generate_audio_with_bark(request: BarkRequest) -> BarkResponse {
    let output_dir = std::env::current_dir()
        .unwrap()
        .join("audio_output");
    
    // Create output directory if it doesn't exist
    if let Err(_) = fs::create_dir_all(&output_dir) {
        return BarkResponse {
            success: false,
            audio_path: None,
            error: Some("Failed to create output directory".to_string()),
        };
    }

    let filename = format!("bark_output_{}.wav", chrono::Utc::now().timestamp());
    let output_path = output_dir.join(&filename);

    // Build the bark command
    let mut cmd = Command::new("python");
    cmd.arg("-m")
       .arg("bark.cli")
       .arg("--text")
       .arg(&request.text)
       .arg("--output_filename")
       .arg(&filename)
       .arg("--output_dir")
       .arg(&output_dir);

    // Add optional parameters
    if let Some(temp) = request.text_temp {
        cmd.arg("--text_temp").arg(temp.to_string());
    }
    if let Some(temp) = request.waveform_temp {
        cmd.arg("--waveform_temp").arg(temp.to_string());
    }
    if let Some(voice) = request.voice_preset {
        cmd.arg("--history_prompt").arg(voice);
    }

    // Execute the command
    match cmd.output() {
        Ok(output) => {
            if output.status.success() && output_path.exists() {
                BarkResponse {
                    success: true,
                    audio_path: Some(output_path.to_string_lossy().to_string()),
                    error: None,
                }
            } else {
                let error_msg = String::from_utf8_lossy(&output.stderr);
                BarkResponse {
                    success: false,
                    audio_path: None,
                    error: Some(format!("Bark execution failed: {}", error_msg)),
                }
            }
        }
        Err(e) => BarkResponse {
            success: false,
            audio_path: None,
            error: Some(format!("Failed to execute bark: {}", e)),
        },
    }
}

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
        .with_title("Taku - Text to Speech")
        .build(&event_loop)
        .expect("🪟 Failed to create window");

    let html_path = resolve_html_path()?;
    let url = format!("file://{}", html_path.display());

    let mut webview_builder = WebViewBuilder::new()
        .with_url(&url)
        .with_initialization_script(
            r#"
            document.title = 'Taku - Text to Speech';
            console.log('🌐 Wry is alive!');
            
            // Bark API functions
            window.generateAudio = async function(text, options = {}) {
                return new Promise((resolve) => {
                    const request = {
                        text: text,
                        voice_preset: options.voicePreset,
                        text_temp: options.textTemp || 0.7,
                        waveform_temp: options.waveformTemp || 0.7
                    };
                    
                    window.bark_requests = window.bark_requests || new Map();
                    const requestId = Date.now().toString();
                    window.bark_requests.set(requestId, resolve);
                    
                    window.ipc.postMessage(JSON.stringify({
                        type: 'generate_audio',
                        id: requestId,
                        data: request
                    }));
                });
            };
            
            window.getVoicePresets = function() {
                return [
                    'en_speaker_0', 'en_speaker_1', 'en_speaker_2', 'en_speaker_3',
                    'en_speaker_4', 'en_speaker_5', 'en_speaker_6', 'en_speaker_7',
                    'en_speaker_8', 'en_speaker_9'
                ];
            };
        "#,
        );

    // Add IPC handler
    let rt = tokio::runtime::Runtime::new().unwrap();
    webview_builder = webview_builder.with_ipc_handler(move |msg| {
        let rt_handle = rt.handle().clone();
        rt_handle.spawn(async move {
            if let Ok(request) = serde_json::from_str::<serde_json::Value>(&msg) {
                if request["type"] == "generate_audio" {
                    let bark_request: BarkRequest = serde_json::from_value(request["data"].clone()).unwrap_or(BarkRequest {
                        text: "Hello world".to_string(),
                        voice_preset: None,
                        text_temp: Some(0.7),
                        waveform_temp: Some(0.7),
                    });
                    
                    let response = generate_audio_with_bark(bark_request).await;
                    let request_id = request["id"].as_str().unwrap_or("unknown");
                    
                    // Send response back to frontend
                    println!("Bark response: {:?}", serde_json::to_string(&response));
                }
            }
        });
    });

    let _webview = webview_builder.build(&window)?;

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
