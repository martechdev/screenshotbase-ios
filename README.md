# Screenshotbase (CocoaPods)

- Website: https://screenshotbase.com
- API Docs: https://screenshotbase.com/docs/

## Installation

Add to your Podfile:

```ruby
pod 'Screenshotbase', :git => 'https://github.com/martechdev/screenshotbase-ios.git', :tag => '0.1.0'
```

Then run:

```bash
pod install
```

## Usage

```swift
import Screenshotbase

let client = ScreenshotbaseClient(configuration: .init(apiKey: "YOUR_API_KEY"))

Task {
    do {
        let json = try await client.capture(options: [
            "url": "https://example.com",
            "width": 1280,
            "height": 800
        ])
        print(json)
    } catch {
        print(error)
    }
}
```

For platforms without async/await, use the completion variant:

```swift
client.capture(options: ["url": "https://example.com"]) { result in
    switch result {
    case .success(let json):
        print(json)
    case .failure(let error):
        print(error)
    }
}
```

## Examples

### Render PDF instead of image

```swift
let pdf = try await client.capture(options: [
    "url": "https://example.com/invoice/123",
    "format": "pdf",
    "pdfBackground": true,
    "margin": ["top": "20px", "right": "20px", "bottom": "20px", "left": "20px"]
])
```

### Wait for an element (SPAs)

```swift
let ready = try await client.capture(options: [
    "url": "https://app.example.com/dashboard",
    "waitFor": ["selector": "#dashboard-loaded"],
    "deviceScaleFactor": 2
])
```

### Full‑page screenshot, transparent background

```swift
let full = try await client.capture(options: [
    "url": "https://example.com",
    "fullPage": true,
    "omitBackground": true
])
```

### Authenticated pages via headers

```swift
let authed = try await client.capture(options: [
    "url": "https://example.com/private",
    "headers": ["Authorization": "Bearer \(token)"]
])
```

### HTML string capture (no public URL)

```swift
let html = """
<!doctype html><html><body><h1>Hello</h1></body></html>
"""
let fromHtml = try await client.capture(options: [
    "html": html,
    "width": 800,
    "height": 400
])
```

### Save response to file (if response includes a data URL or direct URL)

```swift
if let urlString = (try? await client.capture(options: ["url": "https://example.com"]))?["url"] as? String,
   let remote = URL(string: urlString) {
    let (data, _) = try await URLSession.shared.data(from: remote)
    try data.write(to: URL(fileURLWithPath: "/tmp/screenshot.png"))
}
```

### SwiftUI integration (basic)

```swift
struct ScreenshotView: View {
    @State private var image: UIImage?
    let client = ScreenshotbaseClient(configuration: .init(apiKey: "YOUR_API_KEY"))

    var body: some View {
        Group {
            if let image = image { Image(uiImage: image).resizable().scaledToFit() }
            else { ProgressView() }
        }
        .task {
            do {
                if let urlString = try await client.capture(options: ["url": "https://apple.com"]) ["url"] as? String,
                   let remote = URL(string: urlString) {
                    let (data, _) = try await URLSession.shared.data(from: remote)
                    image = UIImage(data: data)
                }
            } catch { print(error) }
        }
    }
}
```

## License
MIT
