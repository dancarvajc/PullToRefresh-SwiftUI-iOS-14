//
//  PullToRefreshModifier.swift
//  PullToRefresh SwiftUI iOS 14
//
//  Created by Daniel Carvajal on 09-05-22.
//

import SwiftUI

//MARK: Modifier that can be used like refreshable() on iOS 14
struct PullToRefreshModifier: ViewModifier {
    
    @State private var initialPosition: CGFloat = -777
    @State private var task: Task<Void, Never>?
    @State private var isStartingDragging: Bool = false
    @State private var isAbleToRunningTask: Bool = false
    @State private var firstAppear:Bool =  true
    @State private var isRefreshing: Bool = false
    @State private var isThresholdPassed: Bool = false
    @State private var offset: CGFloat = 0
    let action: () async -> Void
    private let progressViewSize: CGFloat = 50  //You can change this
    
    func body(content: Content) -> some View {
        ZStack(alignment:.top) {
            
            //MARK: ProgressView Area
            if isRefreshing{
                //You can modify this
                ProgressView()
                    .progressViewStyle(CustomProgressViewStyle())
                
                //Don't change below
                    .frame(width: progressViewSize, height: progressViewSize)
                    .offset(y:  isRefreshing ? 0 : -progressViewSize + offset)
                    .zIndex(1)
                    .onAppear {
                        task = Task {
                            await action()
                            withAnimation {
                                isAbleToRunningTask = false
                                isRefreshing = false
                                offset = 0
                            }
                        }
                    }
                    .onDisappear {
                        task?.cancel()
                        task = nil
                    }
            }else{
                //You can modify this
                Image(systemName: "arrow.down")
                    .resizable() //--> Keep this if you are using Image
                    .foregroundColor(isAbleToRunningTask ? .orange : Color(.label))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
                    .shadow(radius: 3)
                
                //Don't change below
                    .frame(width: progressViewSize, height: progressViewSize)
                    .opacity(isStartingDragging ? 1 : 0)                       .rotationEffect(.degrees(isAbleToRunningTask ? 180: 0))
                    .offset(y:isStartingDragging ? (-progressViewSize + offset) : -progressViewSize)
                    .zIndex(1)
            }
            
            //MARK: Wrapped View
            //Where the magic happens. Get the position of the wrapped view and calculates the height scrolled, executes the async task and show a ProgressView
            content
                .offset(y: isRefreshing ? progressViewSize : offset > 0 ? offset : 0)
                .zIndex(0)
                .background(
                    GeometryReader{ proxy in
                        let localFrame = proxy.frame(in: .global)
                        
                        Color.clear
                            .onChange(of: localFrame.minY) { newValue in
                                if firstAppear {
                                    //Save the initial position of the wrapped view 0.5 sec after (to get the correct value)
                                    firstAppear = false
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                                        initialPosition = proxy.frame(in: .global).minY
                                    }
                                }
                                
                                //Ensures initialPosition is saved
                                guard initialPosition != -777 else{return}
                                
                                //Space scrollView has been scrolled
                                offset = newValue - initialPosition
                                
                                withAnimation {
                                    isStartingDragging = newValue > initialPosition // When start to drag the View
                                }
                                
                                isThresholdPassed = newValue > initialPosition + progressViewSize //Passed the threshold (height of progressview)
                                
                                withAnimation {
                                    if isThresholdPassed {
                                        isAbleToRunningTask = true
                                    }
                                    
                                    //Show the progressView to execute the task when the dragging is under the threshold (when user ends dragging)
                                    if isThresholdPassed == false && isAbleToRunningTask{
                                        isRefreshing = true
                                    }
                                }
                            }
                    })
            
        }
        
    }
    
}

//MARK: extension for usability
extension View{
    func pullToRefresh(action: @escaping () async -> Void) -> some View {
        modifier(PullToRefreshModifier(action: action))
    }
}

//MARK: Custom ProgressView style
struct CustomProgressViewStyle: ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
            .shadow(radius: 3)
    }
}
