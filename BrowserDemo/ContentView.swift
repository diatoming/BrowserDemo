//
//  ContentView.swift
//  BrowserDemo
//
//  Created by Diatoming on 6/14/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var urlString = ""
    
    var body: some View {
        VStack {
        }
        .padding()
        .frame(idealWidth: 800, maxWidth: .infinity, idealHeight: 680, maxHeight: .infinity)
        .presentedWindowToolbarStyle(.expanded)
        .toolbar {
            Spacer()
            TextField("", text: $urlString)
                .frame(minWidth: 500)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    
                }
            
            Spacer()
        }
    }
}
