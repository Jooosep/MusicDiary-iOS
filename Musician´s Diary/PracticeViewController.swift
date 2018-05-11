//
//  PracticeViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 21/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit
import AVFoundation

class PracticeViewController: UIViewController,AVAudioPlayerDelegate {
    
    var db = PilliPaevikDatabase.dbManager
    var harjutusId: Int!
    var audioPlayer = AVAudioPlayer()
    var path: URL!
    var playing = false
    var paused = false
    var reachedEnd = false
    var duration: TimeInterval!
    var timer = Timer()
    var timeFormatter = DateComponentsFormatter()
    
    @IBOutlet var rateButtons: [UIButton]!
    

    @IBOutlet weak var practiceDescriptionField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var audioProgressView: UIView!
    @IBOutlet var progressTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var audioProgress: UIProgressView!
    @IBOutlet weak var audioToolbar: UIToolbar!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var currentRateButton: UIButton!
    

    
    @IBAction func practiceTrashed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete practice session?", message: "Are you sure you want to delete the practice and its recording", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            SongViewController.destroyPracticeId = self.harjutusId
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        print("destroyId: \(harjutusId!)")
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectRate(_ sender: UIButton) {
        rateButtons .forEach { (button) in
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.currentRateButton.isHidden = true
                button.isHidden = !button.isHidden
            }
        }
        
    }
    @IBAction func rate1Tapped(_ sender: UIButton) {
        audioPlayer.rate = 0.5
        currentRateButton.setTitle(sender.titleLabel?.text, for: .normal)
        rateButtons .forEach { (button) in
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                button.isHidden = !button.isHidden
                self.currentRateButton.isHidden = false
            }
        }
        
    }
    @IBAction func rate2Tapped(_ sender: UIButton) {
        audioPlayer.rate = 1.0
        currentRateButton.setTitle(sender.titleLabel?.text, for: .normal)
        rateButtons .forEach { (button) in
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                button.isHidden = !button.isHidden
                self.currentRateButton.isHidden = false
            }
        }
    }
    @IBAction func rate3Tapped(_ sender: UIButton) {
        audioPlayer.rate = 1.5
        currentRateButton.setTitle(sender.titleLabel?.text, for: .normal)
        rateButtons .forEach { (button) in
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                button.isHidden = !button.isHidden
                self.currentRateButton.isHidden = false
            }
        }
    }
    @IBAction func rate4Tapped(_ sender: UIButton) {
        audioPlayer.rate = 2.0
        currentRateButton.setTitle(sender.titleLabel?.text, for: .normal)
        rateButtons .forEach { (button) in
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                button.isHidden = !button.isHidden
                self.currentRateButton.isHidden = false
            }
        }
    }
    
    
    
    @IBAction func rewindPressed(_ sender: Any) {
        
        timer.invalidate()
        if reachedEnd {
            audioProgress.setProgress(1.0, animated: false)
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                self.audioProgress.setProgress(self.audioProgress.progress - 0.03, animated: true)
                self.audioPlayer.currentTime = Double(self.audioProgress.progress) * self.duration
                print(self.audioProgress.progress)
                self.timeLabel.text = "\(self.timeString(time: Int(self.audioPlayer.currentTime)))/\(self.timeString(time: Int(self.duration)))"
            })
            reachedEnd = false
        }
        else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                if self.audioPlayer.currentTime > 0 {
                    self.audioProgress.setProgress(self.audioProgress.progress - 0.03, animated: true)
                    self.audioPlayer.currentTime = Double(self.audioProgress.progress) * self.duration
                    self.timeLabel.text = "\(self.timeString(time: Int(self.audioPlayer.currentTime)))/\(self.timeString(time: Int(self.duration)))"
                }
            })
        }
    }
    @IBAction func rewindReleased(_ sender: Any) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            if self.audioPlayer.currentTime > 0 {
                self.audioProgress.setProgress(Float(self.audioPlayer.currentTime/self.duration), animated: true)
                self.timeLabel.text = "\(self.timeString(time: Int(self.audioPlayer.currentTime)))/\(self.timeString(time: Int(self.duration)))"
            }
        })

    }
    @IBAction func fastForwardPressed(_ sender: Any) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.audioProgress.setProgress(self.audioProgress.progress + 0.03, animated: true)
            self.audioPlayer.currentTime = Double(self.audioProgress.progress) * self.duration
            self.timeLabel.text = "\(self.timeString(time: Int(self.audioPlayer.currentTime)))/\(self.timeString(time: Int(self.duration)))"
        })
    }
    @IBAction func fastForwardReleased(_ sender: Any) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            if self.audioPlayer.currentTime > 0 {
                self.audioProgress.setProgress(Float(self.audioPlayer.currentTime/self.duration), animated: true)
                self.timeLabel.text = "\(self.timeString(time: Int(self.audioPlayer.currentTime)))/\(self.timeString(time: Int(self.duration)))"
            }
        })
    }
    
    
    @IBAction func progressViewTapped(_ sender: UITapGestureRecognizer) {
        reachedEnd = false
        let point = sender.location(in: audioProgressView)
        print("point : \(point)")
        if point.x > (0.9 * audioProgressView.bounds.width) {
            self.audioProgress.setProgress(1.0, animated: true)
            self.audioPlayer.currentTime = duration
            reachedEnd = true
            timer.invalidate()
        }
        else if point.x < (0.1 * audioProgressView.bounds.width) {
            self.audioProgress.setProgress(0.0, animated: true)
            self.audioPlayer.currentTime = 0
        }
        else {
            let progressBarLength = (0.9 * audioProgressView.bounds.width) - (0.1 * audioProgressView.bounds.width)
            let point = point.x - (0.1 * audioProgressView.bounds.width)
            self.audioProgress.setProgress(Float(point / progressBarLength), animated: true)
            self.audioPlayer.currentTime = Double(self.audioProgress.progress) * duration
        }
    }
    @IBAction func playButtonTapped(_ sender: UIBarButtonItem) {
        print("playtapped")
        reachedEnd = false
        if !playing {
            if !paused {
                self.audioProgress.setProgress(0.0, animated: false)
            }
            playing = true
            playButton.setBackgroundImage(#imageLiteral(resourceName: "pause-button"), for: UIControlState.normal, style: .plain, barMetrics: .default)
            audioPlayer.play()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                if self.audioPlayer.currentTime > 0 && self.playing{
                    self.audioProgress.setProgress(Float(self.audioPlayer.currentTime/self.duration), animated: true)
                    self.timeLabel.text = "\(self.timeString(time: Int(self.audioPlayer.currentTime)))/\(self.timeString(time: Int(self.duration)))"
                }
            })
            print("playing")
            
        }
        else {
            playButton.setBackgroundImage(#imageLiteral(resourceName: "play-button"), for: UIControlState.normal, style: .plain, barMetrics: .default)
            audioPlayer.pause()
            playing = false
            paused = true
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            self.playButton.setBackgroundImage(#imageLiteral(resourceName: "play-button"), for: UIControlState.normal, style: .plain, barMetrics: .default)
        }
        playing = false
        paused = false
        reachedEnd = true

    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    func timeString(time:Int) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%2i:%02i",minutes,seconds)
    }
    private func secToClock(sec : TimeInterval) -> String{
        timeFormatter.allowedUnits = [.hour,.minute]
        timeFormatter.zeroFormattingBehavior = .pad
        return timeFormatter.string(from: sec)!
    }

    override func viewDidLoad() {
        SongViewController.enteringFromLeft = false
        practiceDescriptionField.underlinedMercury()
        var labels = db.selectHarjutuskordRow(pos: harjutusId)
        dateLabel.text = labels[0]
        durationLabel.text = secToClock(sec: Double(labels[1])!)
        let filename = db.returnHarjutusFilePath(harjutusId: harjutusId)
        if filename != "" {
            let transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
            audioProgress.transform = transform
            playButton.setBackgroundImage(#imageLiteral(resourceName: "play-button"), for: UIControlState.normal, style: .plain, barMetrics: .default)
            audioProgress.setProgress(0.0, animated: false)
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let audioDirectoryPath = documentDirectoryPath?.appending("/recordings")
            print(filename)
            path = URL(string: audioDirectoryPath!.appending(filename))
            print(path)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: path)
            }catch{
                print(error)
            }
            duration = audioPlayer.duration
            audioPlayer.delegate = self
            audioPlayer.enableRate = true
            
            timeLabel.text = "\(timeString(time: 0))/\(timeString(time: Int(duration)))"
        }
        else {
            audioProgressView.isHidden = true
            audioToolbar.isHidden = true
            currentRateButton.isHidden = true
        }

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
