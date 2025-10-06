# Screenshotbase (CocoaPods)

- Website: https://screenshotbase.com
- API Docs: https://screenshotbase.com/docs/

## Installation

Add to your Podfile:

```ruby
pod 'Screenshotbase', :git => 'https://github.com/everapihq/screenshotbase-ios.git', :tag => '0.1.0'
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

## License
MIT
