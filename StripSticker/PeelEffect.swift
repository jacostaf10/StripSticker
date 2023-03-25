//
//  PeelEffect.swift
//  StripSticker
//
//  Created by Jorge Acosta Freire on 24/3/23.
//

import SwiftUI

struct PeelEffect<Content: View>: View {
    var content: Content
    var onDelete: () -> ()
    var secondaryAction: () -> ()
    var secondaryColor: Color = .yellow
    var secondaryIcon: String = "star"
    
    init(@ViewBuilder content: @escaping () -> Content, onDelete: @escaping () -> (), secondaryAction: @escaping () -> ()) {
        self.content = content()
        self.onDelete = onDelete
        self.secondaryAction = secondaryAction
    }
    
    @State private var dragProgress: CGFloat = 0
    @State private var isExpanded: Bool = false
    @State var isHidden: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                content
                    .hidden()
                    .overlay {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .global)
                            let minX = rect.minX
                            
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.red)
                                .overlay(alignment: .trailing) {
                                    Button {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                            dragProgress = 1
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {onDelete()}
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.title)
                                            .padding(.trailing, 20)
                                            .foregroundColor(.white)
                                    }
                                    .disabled(!isExpanded)

                                }
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            guard !isExpanded else {return}
                                            //Right to Left
                                            var translationX = value.translation.width
                                            translationX = max(-translationX, 0)
                                            let progress = min(1, translationX / rect.width)
                                            dragProgress = progress
                                        }).onEnded({ value in
                                            guard !isExpanded else {return}
                                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                                if dragProgress > 0.25 {
                                                    dragProgress = 0.6
                                                    isExpanded = true
                                                } else {
                                                    dragProgress = .zero
                                                    isExpanded = false
                                                }
                                            }
                                        })
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                        dragProgress = .zero
                                        isExpanded = false
                                    }
                                }
                            
                            Rectangle()
                                .fill(.black)
                                .padding(.vertical, 23)
                                .shadow(color: .black.opacity(0.3), radius: 15, x: 30, y: 0)
                                .padding(.trailing, rect.width * dragProgress)
                                .mask(content)
                                .allowsHitTesting(false)
                                .offset(x: dragProgress == 1 ? -minX : 0)
                            
                            content
                                .mask {
                                    Rectangle()
                                        .padding(.trailing, dragProgress * rect.width)
                                }
                                .allowsHitTesting(false)
                                .offset(x: dragProgress == 1 ? -minX : 0)
                            
                            
                        }
                    }
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size
                            let minX = proxy.frame(in: .global).minX
                            let minOpacity = dragProgress / 0.05
                            let opacity = min(1, minOpacity)
                            
                            content
                                .shadow(color: .black.opacity(dragProgress != 0 ? 0.5 : 0), radius: 5, x: 15, y: 0)
                                .overlay{
                                    Rectangle()
                                        .fill(.white.opacity(0.25))
                                        .mask(content)
                                }
                                .overlay(alignment: .trailing) {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(colors: [.clear, .white, .clear, .clear], startPoint: .leading, endPoint: .trailing)
                                        )
                                        .frame(width: 60)
                                        .offset(x: 40)
                                        .offset(x: -30 + (30 * opacity))
                                        .offset(x: size.width * -dragProgress)
                                }
                                .scaleEffect(x: -1)
                                .offset(x: size.width - (size.width * dragProgress))
                                .offset(x: size.width * -dragProgress)
                                .mask{
                                    Rectangle()
                                        .offset(x: size.width * -dragProgress)
                                }
                                .offset(x: dragProgress == 1 ? -minX : 0)
                                
                        }
                        .allowsHitTesting(false)
                }
                    .isHidden(hidden: isHidden)
                    
                content
                    .hidden()
                    .overlay {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .global)
                            let maxX = rect.maxX
                            
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(secondaryColor)
                                .overlay(alignment: .leading) {
                                    Button {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                            dragProgress = .zero
                                            isExpanded = false
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {secondaryAction()}
                                    } label: {
                                        Image(systemName: secondaryIcon)
                                            .font(.title)
                                            .padding(.leading, 20)
                                            .foregroundColor(.white)
                                    }
                                    .disabled(!isExpanded)

                                }
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            guard !isExpanded else {return}
                                            // Left to Right
                                            var translationX = -value.translation.width
                                            translationX = min(translationX, 0)
                                            let progress = max(-1, translationX / rect.width)
                                            dragProgress = -progress
                                        }).onEnded({ value in
                                            guard !isExpanded else {return}
                                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                                if dragProgress > 0.25 {
                                                    dragProgress = 0.6
                                                    isExpanded = true
                                                } else {
                                                    dragProgress = .zero
                                                    isExpanded = false
                                                }
                                            }
                                        })
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                        dragProgress = .zero
                                        isExpanded = false
                                    }
                                }
                            
                            Rectangle()
                                .fill(.black)
                                .padding(.vertical, 23)
                                .shadow(color: .black.opacity(0.3), radius: 15, x: -30, y: 0)
                                .padding(.leading, rect.width * dragProgress)
                                .mask(content)
                                .allowsHitTesting(false)
                                .offset(x: dragProgress == -1 ? maxX : 0)
                            
                            content
                                .mask {
                                    Rectangle()
                                        .padding(.leading, dragProgress * rect.width)
                                }
                                .allowsHitTesting(false)
                                .offset(x: dragProgress == -1 ? maxX : 0)
                            
                            
                        }
                    }
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size
                            let maxX = proxy.frame(in: .global).maxX
                            let minOpacity = dragProgress / 0.05
                            let opacity = max(1, minOpacity)
                            
                            content
                                .shadow(color: .black.opacity(dragProgress != 0 ? 0.5 : 0), radius: 5, x: -15, y: 0)
                                .overlay{
                                    Rectangle()
                                        .fill(.white.opacity(0.25))
                                        .mask(content)
                                }
                                .overlay(alignment: .leading) {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(colors: [.clear, .white, .clear, .clear], startPoint: .trailing, endPoint: .leading)
                                        )
                                        .frame(width: 60)
                                        .offset(x: 0)
                                        .offset(x: 3.5 - (3.5 * opacity))
                                        .offset(x: size.width * dragProgress)
                                }
                                .scaleEffect(x: -1)
                                .offset(x: -size.width + (size.width * dragProgress))
                                .offset(x: size.width * dragProgress)
                                .mask{
                                    Rectangle()
                                        .offset(x: size.width * dragProgress)
                                }
                                .offset(x: dragProgress == -1 ? maxX : 0)
                                
                        }
                        .allowsHitTesting(false)
                    }
                    .isHidden(hidden: !isHidden)
                    
            }
        }
    }
}

struct PeelEffect_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct IsHidden: ViewModifier {
    var hidden = false
    var remove = false
    func body(content: Content) -> some View {
        if hidden {
            if remove {
                
            } else {
                content.hidden()
            }
        } else {
            content
        }
    }
}

extension View {
    func isHidden(hidden: Bool = false, remove: Bool = false) -> some View {
        modifier(IsHidden(hidden: hidden, remove: remove))
    }
}
