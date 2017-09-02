//: ## Pitch Shift Operation
//:
import AudioKitPlaygrounds
import AudioKit

let file = try AKAudioFile(readFileName: playgroundAudioFiles[0])

let player = try AKAudioPlayer(file: file)
player.looping = true

let effect = AKOperationEffect(player) { player, parameters in
    let sinusoid = AKOperation.sineWave(frequency: parameters[2])
    let shift = parameters[0] + sinusoid * parameters[1] / 2.0
    return player.pitchShift(semitones: shift)
}
effect.parameters = [0, 7, 3]

AudioKit.output = effect
AudioKit.start()
player.play()

import AudioKitUI

class PlaygroundView: AKPlaygroundView {

    override func setup() {
        addTitle("Pitch Shift Operation")
        addSubview(AKResourcesAudioFileLoaderView(player: player, filenames: playgroundAudioFiles))

        addSubview(AKSlider(property: "Base Shift",
                            value: effect.parameters[0],
                            range: -12 ... 12,
                            format: "%0.3f semitones"
        ) { sliderValue in
            effect.parameters[0] = sliderValue
        })
        addSubview(AKSlider(property: "Range",
                            value: effect.parameters[1],
                            range: 0 ... 24,
                            format: "%0.3f semitones"
        ) { sliderValue in
            effect.parameters[1] = sliderValue
        })
        addSubview(AKSlider(property: "Speed",
                            value: effect.parameters[2],
                            range: 0.001 ... 10,
                            format: "%0.3f Hz"
        ) { sliderValue in
            effect.parameters[2] = sliderValue
        })
    }
}

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = PlaygroundView()
