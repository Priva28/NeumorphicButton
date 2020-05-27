//
//  SoftToggleButton.swift
//  softbutton
//
//  Created by Christian P on 26/2/20.
//  Copyright © 2020 Christian P. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct SoftButton: ButtonStyle {
    
    @State private var isPressed = false
    
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat = 30
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .background(
                Group {
                    if configuration.isPressed {
                        Rectangle()
                            .foregroundColor(Color("Background"))
                            .blur(radius: 0.5)
                            .cornerRadius(self.cornerRadius)
                            .shadow(color: Color("ShadowLight"), radius: 20, x: -6, y: -6)
                            .shadow(color: Color("ShadowDark"), radius: 20, x: 6, y: 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: self.cornerRadius)
                                    .stroke(Color("Background"), lineWidth: 4)
                                    .shadow(color: Color("ShadowDark"), radius: 10, x: 5, y: 5)
                                    .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                                    .shadow(color: Color("ShadowLight"), radius: 10, x: -2, y: -2)
                                    .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius)))
                    } else {
                        Rectangle()
                            .foregroundColor(Color("Background"))
                            .blur(radius: 0.5)
                            .cornerRadius(self.cornerRadius)
                            .shadow(color: Color("ShadowLight"), radius: 10, x: -6, y: -6)
                            .shadow(color: Color("ShadowDark"), radius: 10, x: 6, y: 6)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring())
    }
}

struct SoftToggle: ToggleStyle {
    var width: CGFloat = 50
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack(alignment: configuration.isOn ? .trailing : .leading) {
            Button(action: {
                playHaptic()
                configuration.isOn.toggle()
            }, label: {
                RoundedRectangle(cornerRadius: width/3, style: .circular)
                    .frame(width: width, height: width/2)
                    .foregroundColor(Color("Background"))
                    .overlay(
                        RoundedRectangle(cornerRadius: width/3)
                            .stroke(Color("Background"), lineWidth: 4)
                            .shadow(color: Color("ShadowDark"), radius: 3, x: 3, y: 3)
                            .clipShape(RoundedRectangle(cornerRadius: width/3))
                            .shadow(color: Color("ShadowLight"), radius: 3, x: -3, y: -3)
                            .clipShape(RoundedRectangle(cornerRadius: width/3))
                    )
                    .overlay(
                        SoftToggleCircle(isOn: configuration.$isOn, width: width)
                            .frame(width: width/3, height: width/3)
                    )
                    .animation(.spring())
                }).buttonStyle(SoftToggleButtonStyle())
        }
    }
}

struct SoftToggleButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .animation(.spring())
    }
}

struct SoftToggleCircle: View {
    
    @Binding var isOn: Bool
    var width: CGFloat = 50
    
    var body: some View {
        Circle()
            .fill(self.isOn ? .orange : Color("ShadowDark"))
            .offset(x: self.isOn ? width/5 : -width/5)
            .shadow(color: Color("ShadowLight"), radius: 3, x: -1, y: -1)
            .shadow(color: Color("ShadowDark"), radius: 3, x: 1, y: 1)
    }
}

struct SoftToggleButton: View {
    
    @State private var isPressedDown = false
    @State private var isPressed = false
    
    var text: String?
    var cornerRadius: CGFloat?
    
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
                        .cornerRadius(self.cornerRadius ?? 30)
                        .blur(radius: 0.5)
                        .shadow(color: Color("ShadowLight"), radius: 10, x: -6, y: -6)
                        .shadow(color: Color("ShadowDark"), radius: 10, x: 6, y: 6)
                    Text("\(self.text ?? "")")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                // if the button has been toggled and isnt being pressed
                } else if self.isPressed == false && self.isPressedDown == true {
                    Rectangle()
                        .foregroundColor(Color("Background"))
                        .cornerRadius(self.cornerRadius ?? 30)
                        .blur(radius: 0.5)
                        .shadow(color: Color("ShadowLight"), radius: 20, x: -6, y: -6)
                        .shadow(color: Color("ShadowDark"), radius: 20, x: 6, y: 6)
                        .overlay(RoundedRectangle(cornerRadius: self.cornerRadius ?? 30).stroke(Color("Background"), lineWidth: 4).shadow(color: Color("ShadowDark"), radius: 5, x: 5, y: 5).clipShape(RoundedRectangle(cornerRadius: self.cornerRadius ?? 30)).shadow(color: Color("ShadowLight"), radius: 5, x: -2, y: -2).clipShape(RoundedRectangle(cornerRadius: self.cornerRadius ?? 30)))
                    Text("\(self.text ?? "")")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.8, green: 0.75, blue: 0.3))
                        .scaleEffect(0.99)
                    
                // if the button is being pressed
                } else if self.isPressed == true {
                    Rectangle()
                        .foregroundColor(Color("Background"))
                        .cornerRadius(self.cornerRadius ?? 30)
                        .blur(radius: 0.5)
                        .shadow(color: Color("ShadowLight"), radius: 20, x: -6, y: -6)
                        .shadow(color: Color("ShadowDark"), radius: 20, x: 6, y: 6)
                        .overlay(RoundedRectangle(cornerRadius: self.cornerRadius ?? 30).stroke(Color("Background"), lineWidth: 4).shadow(color: Color("ShadowDark"), radius: 10, x: 5, y: 5).clipShape(RoundedRectangle(cornerRadius: self.cornerRadius ?? 30)).shadow(color: Color("ShadowLight"), radius: 10, x: -2, y: -2).clipShape(RoundedRectangle(cornerRadius: self.cornerRadius ?? 30)))
                    Text("\(self.text ?? "")")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.8, green: 0.75, blue: 0.3))
                        .scaleEffect(0.99)
                }
            }
            
            // when its touched, see extension below
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
                    if end {
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
