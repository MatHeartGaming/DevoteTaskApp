//
//  DevoteWidgetBundle.swift
//  DevoteWidget
//
//  Created by Matteo Buompastore on 28/07/23.
//

import WidgetKit
import SwiftUI

@main
struct DevoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        DevoteWidget()
        DevoteWidgetLiveActivity()
    }
}
