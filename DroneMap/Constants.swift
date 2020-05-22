//
//  DimensionConstants.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 16.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics
import UIKit

struct AppFont {
    static let smallFont = UIFont.systemFont(ofSize: 12, weight: .regular)
}

struct AppColor {
    private struct Alphas {
        static let opaque = CGFloat(1)
        static let semiOpaque = CGFloat(0.9)
        static let semiTransparent = CGFloat(0.6)
        static let transparent = CGFloat(0.4)
    }

    static let primaryColor = UIColor(red: 0.2588, green: 0.2863, blue: 0.2863, alpha: Alphas.semiOpaque)
    static let secondaryColor = UIColor(red: 0.3647, green: 0.6784, blue: 0.8863, alpha: 1.0)

    struct Text {
        static let mainTitle = UIColor.white
        static let detailTitle = UIColor.lightGray
        static let inactiveTitle = UIColor.gray
        static let error = UIColor(red: 1.0, green: 0.4, blue: 0.3, alpha: Alphas.opaque)
        static let success = UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: Alphas.opaque)
    }
}

struct AppDimensions {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let contentMargin = screenWidth * CGFloat(0.005)
    static let textMargin = screenWidth * CGFloat(0.015)

    struct ContentView {
        struct Ratio {
            static let h: [CGFloat] = [0.4, 0.45, 0.15]
            static let v: [CGFloat] = [0.09, 0.91]
        }
        static let x = contentMargin
        static let y = contentMargin
        static let width = screenWidth - contentMargin * CGFloat(2)
        static let height = screenHeight - contentMargin * CGFloat(2)
        static let spacer = contentMargin
    }

    struct MissionView {
        struct Row {
            static let height = ContentView.height * ContentView.Ratio.v[0]
            struct Slider {
                struct Ratio {
                    static let h: [CGFloat] = [0.4, 0.35, 0.25]
                }
                static let titleWidth = MissionView.width * Slider.Ratio.h[0]
                static let sliderWidth = MissionView.width * Slider.Ratio.h[1]
                static let valueWidth = MissionView.width * Slider.Ratio.h[2]
                static let sliderThumbRadius = Row.height * CGFloat(0.6)
            }
        }
        struct Section {
            struct Editor {
                static let headerHeight = Row.height * CGFloat(0.5)
                static let footerHeight = Row.height * CGFloat(0.5)
            }
            struct Command {
                static let headerHeight = Row.height * CGFloat(0.5)
                static let footerHeight = textMargin
            }
        }
        static let x = ContentView.x
        static let y = ContentView.y
        static let width = ContentView.width * ContentView.Ratio.h[0]
    }

    struct ConsoleView {
        static let x = ContentView.x + ContentView.width * ContentView.Ratio.h[0] + ContentView.spacer
        static let y = ContentView.y
        static let width = ContentView.width * (ContentView.Ratio.h[1] + ContentView.Ratio.h[2]) - ContentView.spacer
        static let height = ContentView.height * ContentView.Ratio.v[0]
    }

    struct NavigationView {
        struct Button {
            static let height = ContentView.height * ContentView.Ratio.v[0]
            static let count = CGFloat(NavigationButtonId.allCases.count)
        }
        struct Spacer {
            static let height = ContentView.spacer
            static let count = CGFloat(NavigationButtonId.allCases.count - 1)
        }
        static let x = ContentView.x + ContentView.width * (ContentView.Ratio.h[0] + ContentView.Ratio.h[1])
        static let y = ContentView.y + ContentView.height - NavigationView.height
        static let width = ContentView.width * ContentView.Ratio.h[2]
        static let height = Button.height * Button.count + Spacer.height * Spacer.count
    }
}
