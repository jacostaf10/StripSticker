//
//  ContentView.swift
//  StripSticker
//
//  Created by Jorge Acosta Freire on 24/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            PeelEffect {
                CardView(image: "tools")
            } onDelete: {
                let _ = withAnimation(.easeInOut(duration: 0.35)) {
                    
                }
            } secondaryAction: {
                
            }

        }.padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
