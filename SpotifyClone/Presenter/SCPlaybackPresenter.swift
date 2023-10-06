//
//  SCPlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 12/09/23.
//

import UIKit
import AVFoundation

protocol SCPlayerDataSource: AnyObject {
    var songTitle: String? { get }
    var title: String? { get }
    var subtitle: String? { get }
    var artworkImageURL: URL? { get }
}

final class SCPlaybackPresenter {
    
    public static let shared = SCPlaybackPresenter()
    
    fileprivate var track: SCTrack?
    fileprivate var tracks: [SCTrack] = []
    fileprivate var currentTrackIndex = 0
    fileprivate var currentTrack: SCTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks[currentTrackIndex]
        }
        
        return nil
    }
    fileprivate var player: AVPlayer?
    
    private lazy var unavailableSongAlert: UIAlertController = {
        let alertController = UIAlertController(
            title: "Unavailable",
            message: "We are sorry! The song is not currently available to play.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: "Dismiss",
            style: .cancel
        ))
        
        return alertController
    }()
    
    // MARK: - Initialization
    
    private init() {}
    
    fileprivate func createAVQueuePlayer(with items: [SCTrack]) -> AVQueuePlayer {
        return AVQueuePlayer(
            items: items.compactMap { track in
                guard let url = URL(string: track.previewURL ?? "") else {
                    return nil
                }
                
                return AVPlayerItem(url: url)
            }
        )
    }
    
    public func startPlayback(from viewController: UIViewController, track: SCTrack) {
        guard let url = URL(string: track.previewURL ?? "") else {
            viewController.present(unavailableSongAlert, animated: true)
            
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.3
        
        self.track = track
        self.tracks = []
        
        let vc = SCPlayerViewController()
        vc.title = track.artists.compactMap { $0.name }.joined(separator: ", ")
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        
        vc.dataSource = self
        vc.delegate = self
        
        viewController.present(nav, animated: true) { [weak self] in
            self?.player?.play()
        }
    }
    
    public func startPlayback(from viewController: UIViewController, tracks: [SCTrack], startAt index: Int) {
        self.track = nil
        self.tracks = tracks
        self.currentTrackIndex = index
        
        guard let url = URL(string: currentTrack?.previewURL ?? "") else {
            viewController.present(unavailableSongAlert, animated: true)
            return
        }
        
        self.player = nil
        self.player = AVPlayer(url: url)
        self.player?.volume = 0.3
        
        let vc = SCPlayerViewController()
        vc.title = tracks.first?.artists.compactMap { $0.name }.joined(separator: ", ")
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        vc.dataSource = self
        vc.delegate = self
        
        viewController.present(nav, animated: true) { [weak self] in
            self?.player?.play()
        }
    }
    
}

// MARK: - Extension SCPlayerView Controller Delegate

extension SCPlaybackPresenter: SCPlayerViewControllerDelegate {
    func scPlayerViewControllerDelegate(_ viewController: SCPlayerViewController, didTapBackward: ((AVPlayer.TimeControlStatus) -> Void)?) {
        if self.tracks.isEmpty {
            player?.seek(to: .zero)
            player?.play()
            didTapBackward?(.playing)
        } else {
            if currentTrackIndex > 0 {
                currentTrackIndex -= 1
            }
            guard let url = URL(string: currentTrack?.previewURL ?? "") else { return }
            self.player = AVPlayer(url: url)
            self.player?.play()
        }
    }
    
    func scPlayerViewControllerDelegate(_ viewController: SCPlayerViewController, didTapForward: ((AVPlayer.TimeControlStatus) -> Void)?) {
        if self.tracks.isEmpty {
            player?.pause()
            didTapForward?(.paused)
        } else {
            if currentTrackIndex < tracks.count - 1 {
                currentTrackIndex += 1
                guard let url = URL(string: currentTrack?.previewURL ?? "") else { return }
                self.player = AVPlayer(url: url)
                self.player?.play()
            } else {
                currentTrackIndex = 0
                didTapForward?(.paused)
                guard let url = URL(string: currentTrack?.previewURL ?? "") else { return }
                self.player = AVPlayer(url: url)
                self.player?.play()
                didTapForward?(.playing)
            }
        }
    }
    
    func scPlayerViewControllerDelegate(_ viewController: SCPlayerViewController, didTapPlayPause: ((AVPlayer.TimeControlStatus) -> Void)?) {
        guard let player = self.player else { return }
        
        switch player.timeControlStatus {
        case .playing:
            player.pause()
            didTapPlayPause?(.paused)
        case .paused:
            player.play()
            didTapPlayPause?(.playing)
        default:
            break
        }
    }
    
    func scPlayerViewControllerDelegate(_ viewController: SCPlayerViewController, didSlideVolumeSlider value: Float) {
        player?.volume = value
    }
    
}

// MARK: - Extension SCPlayerDataSource

extension SCPlaybackPresenter: SCPlayerDataSource {
    public var songTitle: String? {
        return currentTrack?.name
    }
    
    public var title: String? {
        return currentTrack?.artists.compactMap { $0.name }.joined(separator: ", ")
    }
    
    public var subtitle: String? {
        return title
    }
    
    public var artworkImageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? currentTrack?.artists.first?.images?.first?.url ?? "")
    }
    
}
