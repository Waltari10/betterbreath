import SwiftUI

struct TimerView: View {
    @State private var timeElapsed = 0.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()  // Updates every second for simplicity

    var body: some View {
        Text(timeFormatted(timeElapsed))
            .font(.title)
            .onReceive(timer) { _ in
                timeElapsed += 1  // Increment the counter by 1 second
            }
            .onDisappear() {
                timer.upstream.connect().cancel()  // Stop the timer when the view disappears
            }
    }

    func timeFormatted(_ totalSeconds: Double) -> String {
        let seconds: Int = Int(totalSeconds) % 60
        let minutes: Int = Int(totalSeconds) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
