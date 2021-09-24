//
//  MovieController.swift
//  TestProject
//
//  Created by steven on 2021/9/6.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import UIKit
import Player
import SnapKit
import CoreMedia

class VideoPlayerController: UIViewController {

    private var movie: MovieModel?
    fileprivate var videoPlayer = Player()    
    private var progressView = UISlider()

    deinit {
        self.videoPlayer.willMove(toParent: nil)
        self.videoPlayer.view.removeFromSuperview()
        self.videoPlayer.removeFromParent()
    }
    
    init(movie: MovieModel) {
        super.init(nibName: nil, bundle: nil)
        self.movie = movie
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //禁用左滑返回手势，防止slide无法拖动
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.videoPlayer.playerDelegate = self
        self.videoPlayer.playbackDelegate = self
        self.videoPlayer.playerView.playerBackgroundColor = .white
        
        progressView.backgroundColor = UIColor.systemGray
        progressView.minimumTrackTintColor = UIColor.systemGreen
        
        addChild(self.videoPlayer)
        view.addSubview(self.videoPlayer.view)
        view.addSubview(progressView)
        
        self.videoPlayer.didMove(toParent: self)
        self.videoPlayer.url = URL(string: movie!.mp4_url)
        self.videoPlayer.playbackLoops = true
        self.videoPlayer.fillMode = .resizeAspect
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.videoPlayer.view.addGestureRecognizer(tapGestureRecognizer)
        
        progressView.addTarget(self, action: #selector(sliderValueChanged), for: UIControl.Event.valueChanged)
        
        self.videoPlayer.view.snp.makeConstraints{(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
        progressView.snp.makeConstraints{(make) -> Void in
            make.bottom.equalTo(videoPlayer.view.snp.bottom).offset(-20)
            make.width.equalToSuperview()
            make.height.equalTo(2)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.videoPlayer.playFromBeginning()
    }
    
    func formateHSM(second: Int) -> String {
        let formatter = DateComponentsFormatter.init()
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = NSCalendar.Unit(rawValue: NSCalendar.Unit.hour.rawValue | NSCalendar.Unit.minute.rawValue | NSCalendar.Unit.second.rawValue)
        formatter.unitsStyle = DateComponentsFormatter.UnitsStyle.positional
        let resultStr = formatter.string(from: TimeInterval.init(second))
        return resultStr!
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        //拖动到指定时间
        self.videoPlayer.seek(to: CMTimeMakeWithSeconds(Float64(slider.value), preferredTimescale: 1))
    }
    
}
// MARK: - UIGestureRecognizer
extension VideoPlayerController {
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch self.videoPlayer.playbackState {
        case .stopped:
            self.videoPlayer.playFromBeginning()
            break
        case .paused:
            self.videoPlayer.playFromCurrentTime()
            break
        case .playing:
            self.videoPlayer.pause()
            break
        case .failed:
            self.videoPlayer.pause()
            break
        }
    }
    
}

// MARK: - PlayerDelegate
extension VideoPlayerController: PlayerDelegate {
    
    func playerReady(_ player: Player) {
        print("\(#function) ready")
        let videoDuration = Int(player.maximumDuration)
        print("视频时长是：\(videoDuration)秒, 格式化：\(formateHSM(second: videoDuration))")
        self.progressView.maximumValue = Float(videoDuration)
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("\(#function) \(self.videoPlayer.playbackState.description)")
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        print("\(#function) error.description")
    }
    
}

extension VideoPlayerController: PlayerPlaybackDelegate {
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }

    public func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }

    public func playerPlaybackDidEnd(_ player: Player) {
        
    }

    public func playerCurrentTimeDidChange(_ player: Player) {
        self.progressView.setValue(Float(player.currentTimeInterval) , animated: false)
    }

    public func playerPlaybackWillLoop(_ player: Player) {
//        self. _playbackViewController?.reset()
    }

}

