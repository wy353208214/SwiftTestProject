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

class VideoPlayerController: UIViewController {

    private var movie: MovieModel?
    fileprivate var videoPlayer = Player()    
//    private var progressView = UISlider()

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
        view.backgroundColor = .black
        
        self.videoPlayer.playerDelegate = self
        self.videoPlayer.playbackDelegate = self
        self.videoPlayer.playerView.playerBackgroundColor = .white
        
        addChild(self.videoPlayer)
        view.addSubview(self.videoPlayer.view)
//        view.addSubview(progressView)
        
        self.videoPlayer.didMove(toParent: self)
//        self.videoPlayer.url = URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")
        self.videoPlayer.url = URL(string: movie!.mp4_url)
        self.videoPlayer.playbackLoops = true
        self.videoPlayer.fillMode = .resizeAspectFill
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.videoPlayer.view.addGestureRecognizer(tapGestureRecognizer)
        
        self.videoPlayer.view.snp.makeConstraints{(make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(0.8)
            make.center.equalToSuperview()
        }
//        progressView.snp.makeConstraints{(make) -> Void in
//            make.bottom.equalTo(videoPlayer.view.snp.bottom)
//            make.width.equalToSuperview()
//            make.height.equalTo(2)
//        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.videoPlayer.playFromBeginning()
    }
    
//    fileprivate func formateHSM(second: Int) {
//        let formatter = DateComponentsFormatter.init()
//         // . dropMiddle为  0d 00h 00m 格式 (需要其它格式可以自己点进去看看)
//        formatter.zeroFormattingBehavior = .drop
//
//       // 此处事例只写了 日 时 分；需要秒的可以在后面加上（参数： | NSCalendar.Unit.second.rawValue ）
//         formatter.allowedUnits = NSCalendar.Unit(rawValue: NSCalendar.Unit.day.rawValue | NSCalendar.Unit.hour.rawValue | NSCalendar.Unit.minute.rawValue)
//
//         formatter.unitsStyle = DateComponentsFormatter.UnitsStyle.abbreviated
//
//       // 结果默认格式为 1d 1h 1m
//         var resultStr = formatter.string(from: TimeInterval(seconds)) ?? ""
//    }
    
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
        let videoDuration = player.maximumDuration
        print("视频时长是：\(videoDuration)")
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
        let fraction = Double(player.currentTimeInterval) / Double(player.maximumDuration)
//        self._playbackViewController?.setProgress(progress: CGFloat(fraction), animated: true)
    }

    public func playerPlaybackWillLoop(_ player: Player) {
//        self. _playbackViewController?.reset()
    }

}

