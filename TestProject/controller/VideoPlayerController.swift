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
    
    private let progressContent = UIView.init(frame: .zero)
    private let progressView = UISlider()
    private let lengthLabel = UILabel()
    private let currentTimeLabel = UILabel()
    
    
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
        
        //设置播放状态监听
        self.videoPlayer.playerDelegate = self
        self.videoPlayer.playbackDelegate = self
        self.videoPlayer.playerView.playerBackgroundColor = .black
        
        //设置播放器控制条
        progressView.maximumTrackTintColor = .white
        progressView.minimumTrackTintColor = .systemGreen
        //总时长
        lengthLabel.textColor = .white
        lengthLabel.font = .systemFont(ofSize: 12)
        lengthLabel.numberOfLines = 1
        lengthLabel.preferredMaxLayoutWidth = 20
        //当前播放位置
        currentTimeLabel.textColor = .white
        currentTimeLabel.font = .systemFont(ofSize: 12)
        currentTimeLabel.numberOfLines = 1
        currentTimeLabel.preferredMaxLayoutWidth = 20
        progressContent.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        
        addChild(self.videoPlayer)
        view.addSubview(self.videoPlayer.view)
        //添加底部控制器
        progressContent.addSubview(progressView)
        progressContent.addSubview(lengthLabel)
        progressContent.addSubview(currentTimeLabel)
        view.addSubview(progressContent)
        
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
        
        progressContent.snp.makeConstraints{(make) -> Void in
            make.bottom.equalTo(videoPlayer.view.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        lengthLabel.snp.makeConstraints{(make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-2)
        }
        currentTimeLabel.snp.makeConstraints{(make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(2)
        }
        progressView.snp.makeConstraints{(make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalTo(currentTimeLabel.snp.right).offset(2)
            make.right.equalTo(lengthLabel.snp.left).offset(-2)
            make.height.equalTo(4)
        }
        //默认先隐藏控制条
        progressContent.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.videoPlayer.playFromBeginning()
    }
    
    //秒转换成01:31:08格式的时间
    func formateHSM(second: Int) -> String {
        let formatter = DateComponentsFormatter.init()
        formatter.zeroFormattingBehavior = .pad
        if second >= 3600 {
            formatter.allowedUnits = NSCalendar.Unit(rawValue: NSCalendar.Unit.hour.rawValue | NSCalendar.Unit.minute.rawValue | NSCalendar.Unit.second.rawValue)
        }else {
            formatter.allowedUnits = NSCalendar.Unit(rawValue: NSCalendar.Unit.minute.rawValue | NSCalendar.Unit.second.rawValue)
        }
        formatter.unitsStyle = DateComponentsFormatter.UnitsStyle.positional
        let resultStr = formatter.string(from: TimeInterval.init(second))
        return resultStr!
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        //拖动到指定时间
        let cmt = CMTimeMake(value: Int64(slider.value), timescale:1)
        self.videoPlayer.seek(to: cmt)
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
        let videoDuration = Int(player.maximumDuration)
        print("视频时长是：\(videoDuration)秒, 格式化：\(formateHSM(second: videoDuration))")
        
        self.progressView.maximumValue = Float(videoDuration)
        lengthLabel.text = formateHSM(second: videoDuration)
        //准备好播放之后显示控制条
        progressContent.isHidden = false
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
        currentTimeLabel.text = formateHSM(second: Int(player.currentTimeInterval))
    }

    public func playerPlaybackWillLoop(_ player: Player) {
//        self. _playbackViewController?.reset()
    }

}

