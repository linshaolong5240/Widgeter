//
//  StorageUsageView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/9.
//

import SwiftUI

struct StorageUsageView: View {
    enum SizeFormatter {
        case MB
        case GB
    }
    let sizeFormatter: SizeFormatter = .GB
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(Device.current.usedDiskSpaceInGB) \((Device.current.totalDiskSpaceInGB))")
            ProgressView(value: CGFloat(Double(Device.current.freeDiskSpaceInBytes) / Double(Device.current.totalDiskSpaceInBytes)))
        }
    }
}

struct StorageUsageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageUsageView()
    }
}
