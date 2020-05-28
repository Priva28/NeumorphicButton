//
//  SoftToggleButton.swift
//  softbutton
//
//  Created by Christian P on 26/2/20.
//  Copyright © 2020 Christian P. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct SoftToggleButton: View {
    
    @State private var isPressedDown = false
    @State private var isPressed = false
    
    var text: String?
    var cornerRadius: CGFloat = 30
    
    let engine = try? CHHapticEngine()
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
    
    var body: some View {
        return GeometryReader { geometry in
            // The actual button
            ZStack {
                
                // if the button hasnt been toggled and isnt being pressed
                if self.isPressed == false && self.isPressedDown == false {
                    Rectangle()
                        .foregroundColor(Color("Background"))
                        .cornerRadius(self.cornerRadius)
                        .blur(radius: 1)
                        .shadow(color: Color("ShadowLight"), radius: 10, x: -6, y: -6)
                        .shadow(color: Color("ShadowDark"), radius: 10, x: 6, y: 6)
                    Text("\(self.text ?? "")")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                // if the button has been toggled and isnt being pressed
                } else if self.isPressed == false && self.isPressedDown == true {
                    Rectangle()
                        .foregroundColor(Color("Background"))
                        .cornerRadius(self.cornerRadius)
                        .shadow(color: Color("ShadowLight"), radius: 15, x: -6, y: -6)
                        .shadow(color: Color("ShadowDark"), radius: 15, x: 6, y: 6)
                        
                        // Inner shadow here
                        .overlay(
                            RoundedRectangle(cornerRadius: self.cornerRadius)
                                .stroke(Color("Background"), lineWidth: 4)
                                .shadow(color: Color("ShadowDark"), radius: 8, x: 5, y: 5)
                                .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                                .shadow(color: Color("ShadowLight"), radius: 8, x: -2, y: -2)
                                .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                        )
                        .blur(radius: 1)
                    Text("\(self.text ?? "")")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.8, green: 0.75, blue: 0.3))
                        .scaleEffect(0.99)
                    
                // if the button is being pressed
                } else if self.isPressed == true {
                    Rectangle()
                        .foregroundColor(Color("Background"))
                        .cornerRadius(self.cornerRadius)
                        .shadow(color: Color("ShadowLight"), radius: 10, x: -6, y: -6)
                        .shadow(color: Color("ShadowDark"), radius: 10, x: 6, y: 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: self.cornerRadius)
                                .stroke(Color("Background"), lineWidth: 4)
                                .shadow(color: Color("ShadowDark"), radius: 18, x: 5, y: 5)
                                .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                                .shadow(color: Color("ShadowLight"), radius: 18, x: -2, y: -2)
                                .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                        )
                        .blur(radius: 1)
                    Text("\(self.text ?? "")")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.8, green: 0.75, blue: 0.3))
                }
            }
            
            // when its touched, see extension
            .onTouchGesture(
                
                // what to do when the touch began
                touchBegan: {
                    
                    // tell the view that the button is being pressed
                    self.isPressed = true
                    
                    // play click in or out sound
                    if self.isPressedDown {
                        playSound(sound: "clickin-1", type: "wav")
                    } else {
                        playSound(sound: "clickout-1", type: "wav")
                    }
                    
                    // check if haptic feedback is possible
                    if self.engine != nil {
                        // if it is - give some haptic feedback
                        let pattern = try? CHHapticPattern(events: [self.event], parameters: [])
                        let player = try? self.engine?.makePlayer(with: pattern!)
                        try? self.engine!.start()
                        try? player?.start(atTime: 0)
                    }
                },
                
                // what to do when the touch ends. sometimes this doesnt work if you hold it too long :(
                touchEnd: { end in
                    // tell the view that the user lifted their finger
                    self.isPressed = false
                    
                    // if the button isnt already pressed down, tell the view it now is, if it already is, tell the view it now isnt
                    // also play sound
                    if self.isPressedDown {
                        playSound(sound: "clickin-2", type: "wav")
                        self.isPressedDown = false
                    } else {
                        playSound(sound: "clickout-2", type: "wav")
                        self.isPressedDown = true
                    }
                    
                    // check if haptic feedback is possible
                    if self.engine != nil {
                        // if it is - give some haptic feedback
                        let pattern = try? CHHapticPattern(events: [self.event], parameters: [])
                        let player = try? self.engine?.makePlayer(with: pattern!)
                        try? self.engine!.start()
                        try? player?.start(atTime: 0)
                    }
                },
                
                // if the user drags their finger away, abort the action
                abort: { _ in
                    self.isPressed = false
                    if self.isPressedDown {
                        self.isPressedDown = true
                    } else {
                        self.isPressedDown = false
                    }
                }
            )
            // springy animation, im not sure why its kinda flat still find a way to make it more springy and satisfying.
            .animation(.spring())
        }
    }
}

struct SoftToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        SoftToggleButton()
    }
}
