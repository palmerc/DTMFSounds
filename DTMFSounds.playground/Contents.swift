//: Playground - noun: a place where people can play

import UIKit
import AVFoundation
import XCPlayground



var _sampleRate: Float = 8000.0

var _engine = AVAudioEngine()
var _player:AVAudioPlayerNode = AVAudioPlayerNode()
var _mixer = _engine.mainMixerNode

let phoneNumber = "1234567890*#ABCD"
if let tones = DTMF.tonesForString(phoneNumber) {
    let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: Double(_sampleRate), channels: 2, interleaved: false)!

    // fill up the buffer with some samples
    var allSamples = [Float]()
    for tone in tones {
        let samples = DTMF.generateDTMF(tone, markSpace: DTMF.motorola, sampleRate: _sampleRate)
        allSamples.append(contentsOf: samples)
    }

    let frameCount = AVAudioFrameCount(allSamples.count)
    var buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameCount)!

    buffer.frameLength = frameCount
    var channelMemory = buffer.floatChannelData!
    for channelIndex in 0 ..< Int(audioFormat.channelCount) {
        var frameMemory = channelMemory[channelIndex]
        memcpy(frameMemory, allSamples, Int(frameCount) * MemoryLayout<Float>.size)
    }

    _engine.attach(_player)
    _engine.connect(_player, to:_mixer, format:audioFormat)

    do {
        try _engine.start()
    } catch let error as NSError {
        print("Engine start failed - \(error)")
    }

    _player.scheduleBuffer(buffer, at:nil, options:.loops,completionHandler:nil)
    _player.play()
}

// keep playground running
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
