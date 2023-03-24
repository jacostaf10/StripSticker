//
//  CardView.swift
//  StripSticker
//
//  Created by Jorge Acosta Freire on 24/3/23.
//

import SwiftUI

struct CardView: View {
    let image: String
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
        }
        .frame(height: 130)
        .contentShape(Rectangle())
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(image: "tools")
    }
}
