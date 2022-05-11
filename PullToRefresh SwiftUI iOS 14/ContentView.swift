//
//  ContentView.swift
//  PullToRefresh SwiftUI iOS 14
//
//  Created by Daniel Carvajal on 09-05-22.
//

import SwiftUI


//MARK: Here's an example of how to use the pullToRefresh modifier

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            ScrollView {
                ForEach(0...30, id:\.self){ i in
                    Text("\(i)")
                        .frame(maxWidth:.infinity)
                        .background(Color.green)
                        .padding(5)
                }
                .pullToRefresh {
                    await asyncTask(seconds: 3)
                }
                
            }
            .navigationTitle("PullToRefresh iOS 14")
            .navigationBarTitleDisplayMode(.inline)
            
        }.navigationViewStyle(.stack) //For iPads
        
    }
}

//Simulate an async task
func asyncTask(seconds: UInt64 = 2) async {
    try? await Task.sleep(nanoseconds: seconds*1000000000) //wait x seconds
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
