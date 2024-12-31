import SwiftUI

struct TimerView: View {
    @Binding var timeElapsed: Double
    @Binding var isActive: Bool

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    @State private var startedAt: Date? = nil

    var body: some View {
        Text(
            timeFormatted(timeElapsed)
        )
        .font(.title)
        .onReceive(timer) { _ in
            if isActive {
                if startedAt == nil {
                    startedAt = Date.now // Set startedAt when isActive turns true for the first time
                }
                if let startedAt = startedAt {
                    timeElapsed = startedAt.distance(to: Date.now)
                }
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }

    func timeFormatted(_ totalSeconds: Double) -> String {
        let seconds = Int(totalSeconds) % 60
        let minutes = Int(totalSeconds) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
