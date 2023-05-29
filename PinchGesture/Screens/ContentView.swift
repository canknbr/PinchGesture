//
//  ContentView.swift
//  PinchGesture
//
//  Created by Can Kanbur on 29.05.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimated = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen = false

    let pages: [Page] = pagesData
    @State private var pageIndex = 1

    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }

    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear

                Image(currentPage())
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .animation(.linear(duration: 1), value: isAnimated)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = gesture.translation
                                }
                            })
                            .onEnded({ _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ gesture in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale < 5 {
                                        imageScale = gesture
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                            .onEnded({ _ in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale > 5 {
                                        imageScale = 5
                                    } else if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            })
                    )
            }.navigationTitle("Pinch & Zoom")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: {
                    withAnimation(.linear(duration: 1)) {
                        isAnimated = true
                    }
                })
                .overlay(
                    InfoPanelView(scale: imageScale, offset: imageOffset)
                        .padding(.horizontal)
                        .padding(.top, 30)
                    , alignment: .top
                )
                .overlay(
                    Group {
                        HStack {
                            Button {
                                withAnimation(.spring()) {
                                    if imageScale > 1 {
                                        imageScale -= 1

                                        if imageScale <= 1 {
                                            resetImageState()
                                        }
                                    }
                                }
                            } label: {
                                ControlImageView(icon: "minus.magnifyingglass")
                            }
                            Button {
                                resetImageState()
                            } label: {
                                ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                            }
                            Button {
                                withAnimation(.spring()) {
                                    if imageScale < 5 {
                                        imageScale += 1

                                        if imageScale > 5 {
                                            imageScale = 5
                                        }
                                    }
                                }
                            } label: {
                                ControlImageView(icon: "plus.magnifyingglass")
                            }
                        }.padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                            .background(.ultraThinMaterial)
                            .opacity(isAnimated ? 1 : 0)
                    }
                    .padding(.bottom, 30)
                    , alignment: .bottom
                )
                .overlay(
                    HStack(spacing: 12) {
                        Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(8)
                            .foregroundColor(.secondary)

                            .onTapGesture {
                                withAnimation(.easeOut) {
                                    isDrawerOpen.toggle()
                                }
                            }

                        ForEach(pages) { page in
                            Image(page.thumbnailName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .cornerRadius(10)
                                .opacity(isDrawerOpen ? 1 : 0)
                                .animation(.easeOut(duration: 1), value: isDrawerOpen)
                                .onTapGesture {
                                    isAnimated = true
                                    pageIndex = page.id
                                }
                        }

                        Spacer()
                    }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimated ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                    , alignment: .topTrailing
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
