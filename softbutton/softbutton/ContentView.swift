//
//  ContentView.swift
//  softbutton
//
//  Created by Christian P on 26/2/20.
//  Copyright © 2020 Christian P. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    
    let engine = try? CHHapticEngine()
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
    @State var isPressed = false
    @State var isOn = false {
        didSet {
            print("here")
            if self.engine != nil {
                // if it is - give some haptic feedback
                let pattern = try? CHHapticPattern(events: [self.event], parameters: [])
                let player = try? self.engine?.makePlayer(with: pattern!)
                try? self.engine!.start()
                try? player?.start(atTime: 0)
            }
        }
    }
    
    var body: some View {
       
        Color("Background")
            .edgesIgnoringSafeArea(.all)
        .overlay(
            VStack {
                Spacer()
                Text("Soft Buttons")
                    .font(.largeTitle)
                    .bold()
                    .shadow(radius: 10)
                Group {
                    Toggle("", isOn: $isOn)
                        .toggleStyle(SoftToggle(width: 70))
                        .padding(20)
                    SoftToggleButton(text: "idk", cornerRadius: 20)
                        .frame(width: 100, height: 100)
                    
                    Button(action: {
                        print("gfdg")
                    }) {
                        Text("new")
                            .frame(width: 200, height: 70)
                    }
                    .padding(20)
                    .buttonStyle(SoftButton(width: 70, height: 70, cornerRadius: 50))
                }
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


