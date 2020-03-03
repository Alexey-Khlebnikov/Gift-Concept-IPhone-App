//
//  RowView.swift
//  gift_app
//
//  Created by Alguz on 10/27/19.
//  Copyright © 2019 Lexy. All rights reserved.
//
import UIKit
enum RowDirection {
    case row
    case column
    case row_reverse
    case column_reverse
}

import Foundation
class FlexView: MyBaseView {
    private var _direction: RowDirection = .row
    
    var direction: RowDirection = .row {
        didSet {
            if self.direction != self._direction {
                self._direction = self.direction
            }
        }
    }
    var isFramed: Bool = false
    
    var totalCol: Int = 32 {
        didSet {
            if isFramed {
                reframe()
            }
        }
    }
    
    var col: Int = 0 {
        didSet {
            if isFramed {
                reframe()
            }
        }
    }
    var len: CGFloat = 0 {
        didSet {
            if isFramed {
                reframe()
            }
        }
    }
    
    private var sub_static_view_count = 0
    
    var sub_static_col: Int = 0 {
        didSet {
            if isFramed {
                reframe()
            }
        }
    }
    
    var sub_flex_col: Int = 0 {
        didSet {
            if isFramed {
                reframe()
            }
        }
    }
    
    var margin: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            if isFramed {
                reframe()
            }
        }
    }
    
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            if isFramed {
                reframe()
            }
        }
    }
    
    var items: [FlexView] = []
    
    override func setupViews() {
        super.setupViews()
    }
    
    func addSubview(_ view: FlexView, _ isReframe: Bool = false) {
        super.addSubview(view)
        appendCol(view)
        if isReframe {
            reframe()
        }
    }
    
    func addSubview(_ view: FlexView) {
        self.addSubview(view, false)
    }
    
    func appendCol(_ view: FlexView) {
        view.tag = items.count
        items.append(view)
        if view.col > 0 {
            sub_static_view_count += 1
            sub_static_col += view.col
        }
        recalcFlexCol()
    }
    
    private func recalcFlexCol() {
        sub_flex_col = (totalCol - sub_static_col) / (items.count - sub_static_view_count)
    }
    
    func removeCol(_ view: FlexView) {
        items.remove(at: view.tag)
        if view.col > 0 {
            sub_static_view_count -= 1
            sub_static_col -= view.col
        }
        recalcFlexCol()
        if isFramed {
            reframe()
        }
    }
    
    override func removeFromSuperview() {
        if let _superview = self.superview as? FlexView {
            _superview.removeCol(self)
        }
        super.removeFromSuperview()
    }
    
    func reframe() {
        isFramed = true
        switch _direction {
        case .row:
            reframeNoWrapRow()
        default:
            reframeNoWrapCol()
        }
    }
    
    func reframeNoWrapRow() {
        let top = padding.top
        var left = padding.left
        let width = frame.width - padding.left - padding.right
        let height = frame.height - padding.top - padding.bottom
        let segment_width: CGFloat = width / CGFloat(totalCol)
        for item in items {
            var item_width: CGFloat = 0
            if item.col > 0 {
                item_width = segment_width * CGFloat(item.col)
            } else {
                item_width = segment_width * CGFloat(sub_flex_col)
            }
            let item_frame = CGRect(
                x: left + item.margin.left,
                y: top + item.margin.top,
                width: item_width - item.margin.left - item.margin.right,
                height: height - item.margin.top - item.margin.bottom
            )
            item.frame = item_frame
            
            left += item_width
        }
    }
    func reframeNoWrapCol() {
        var top = padding.top
        let left = padding.left
        let width = frame.width - padding.left - padding.right
        let height = frame.height - padding.top - padding.bottom
        let segment_height: CGFloat = height / CGFloat(totalCol)
        for item in items {
            var item_height: CGFloat = 0
            if item.col > 0 {
                item_height = segment_height * CGFloat(item.col)
            } else {
                item_height = segment_height * CGFloat(sub_flex_col)
            }
            let item_frame = CGRect(
                x: left + item.margin.left,
                y: top + item.margin.top,
                width: width - item.margin.left - item.margin.right,
                height: item_height - item.margin.top - item.margin.bottom
            )
            item.frame = item_frame
            
            top += item_height
        }
    }
    
}
