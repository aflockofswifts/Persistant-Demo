//
//  ContentView.swift
//  Persistant Demo
//
//  Created by John James Retina on 7/18/20.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var userSettings = UserSettings(storageService: FileStorageService(filename: "test"))
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("PROFILE")) {
          TextField("Username", text: $userSettings.settings.username)
          Toggle(isOn: $userSettings.settings.isPrivate) {
            Text("Private Account")
          }
          Picker(selection: $userSettings.settings.ringtone, label: Text("Ringtone")) {
            ForEach(userSettings.ringtones, id: \.self) { ringtone in
              Text(ringtone)
            }
          }
          HStack{
            Text("Counter:")
            Spacer()
            Text(" \(userSettings.settings.counter)")
          }
          HStack{
            Button("Inc") {
              userSettings.incrementCounter()
            }
            Spacer()
            Button("Dec") {
              userSettings.decrementCounter()
            }
          }.padding()
          .buttonStyle(FilledButton())
        }
      }
      .navigationBarTitle("Settings")
    }
  }
}

struct FilledButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .foregroundColor(configuration.isPressed ? .gray : .white)
      .padding()
      .background(Color.accentColor)
      .cornerRadius(8)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
