//
//  ContentView.swift
//  TestProject
//
//  Created by Yang on 2020/6/11.
//  Copyright © 2020 hackyang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, SwiftUI!").font(.title).foregroundColor(.green)
            Text("Placeholder").font(.subheadline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
