import UIKit
import AVFoundation

protocol VideoPlayerViewDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didChangeProgress(_ value: Float)
}

class VideoPlayerView: UIView {
    // MARK: - Properties
    weak var delegate: VideoPlayerViewDelegate?
    
    let playerLayer = AVPlayerLayer()
    
    // MARK: - UI Components
    private let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "goforward.10"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gobackward.10"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .gray
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .black
        layer.addSublayer(playerLayer)
        
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(playPauseButton)
        controlsContainerView.addSubview(forwardButton)
        controlsContainerView.addSubview(backwardButton)
        controlsContainerView.addSubview(progressSlider)
        controlsContainerView.addSubview(currentTimeLabel)
        controlsContainerView.addSubview(durationLabel)
        
        setupConstraints()
        setupActions()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            controlsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            controlsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            controlsContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            playPauseButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: progressSlider.topAnchor, constant: -8),
            playPauseButton.widthAnchor.constraint(equalToConstant: 44),
            playPauseButton.heightAnchor.constraint(equalToConstant: 44),
            
            backwardButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -32),
            backwardButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            backwardButton.widthAnchor.constraint(equalToConstant: 44),
            backwardButton.heightAnchor.constraint(equalToConstant: 44),
            
            forwardButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 32),
            forwardButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            forwardButton.widthAnchor.constraint(equalToConstant: 44),
            forwardButton.heightAnchor.constraint(equalToConstant: 44),
            
            currentTimeLabel.leadingAnchor.constraint(equalTo: controlsContainerView.leadingAnchor, constant: 16),
            currentTimeLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -8),
            
            durationLabel.trailingAnchor.constraint(equalTo: controlsContainerView.trailingAnchor, constant: -16),
            durationLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -8),
            
            progressSlider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor, constant: 8),
            progressSlider.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -8),
            progressSlider.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupActions() {
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardTapped), for: .touchUpInside)
        backwardButton.addTarget(self, action: #selector(backwardTapped), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(progressChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Actions
    @objc private func playPauseTapped() {
        delegate?.didTapPlayPause()
    }
    
    @objc private func forwardTapped() {
        delegate?.didTapForward()
    }
    
    @objc private func backwardTapped() {
        delegate?.didTapBackward()
    }
    
    @objc private func progressChanged(_ slider: UISlider) {
        delegate?.didChangeProgress(slider.value)
    }
    
    // MARK: - Public Methods
    func updatePlayPauseButton(isPlaying: Bool) {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func updateProgress(_ time: CMTime) {
        let currentSeconds = CMTimeGetSeconds(time)
        currentTimeLabel.text = formatTime(currentSeconds)
        
        if let duration = playerLayer.player?.currentItem?.duration {
            let durationSeconds = CMTimeGetSeconds(duration)
            progressSlider.value = Float(currentSeconds / durationSeconds)
        }
    }
    
    func updateDuration(_ duration: CMTime) {
        let durationSeconds = CMTimeGetSeconds(duration)
        durationLabel.text = formatTime(durationSeconds)
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
} 
