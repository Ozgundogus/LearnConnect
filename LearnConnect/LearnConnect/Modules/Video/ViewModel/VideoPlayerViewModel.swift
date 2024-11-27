import AVFoundation

class VideoPlayerViewModel {
    // MARK: - Properties
    let videoURL: URL
    
    var currentTimeDidChange: ((CMTime) -> Void)?
    var durationDidChange: ((CMTime) -> Void)?
    
    // MARK: - Init
    init(videoURL: URL) {
        self.videoURL = videoURL
    }
    
    // MARK: - Methods
    func updateCurrentTime(_ time: CMTime) {
        currentTimeDidChange?(time)
    }
    
    func updateDuration(_ duration: CMTime) {
        durationDidChange?(duration)
    }
} 