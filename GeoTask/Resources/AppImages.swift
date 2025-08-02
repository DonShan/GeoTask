import SwiftUI

public struct AppImages {
    public static let shared = AppImages()
    
    private init() {}
    
    public let backArrow = "chevron.left"
    public let close = "xmark"
    public let add = "plus"
    public let edit = "pencil"
    public let delete = "trash"
    public let save = "checkmark"
    public let share = "square.and.arrow.up"
    
    public let task = "checklist"
    public let taskCompleted = "checkmark.circle.fill"
    public let taskPending = "circle"
    public let taskPriority = "exclamationmark.triangle"
    public let taskLocation = "location"
    public let taskCalendar = "calendar"
    public let taskTime = "clock"
    
    public let map = "map"
    public let mapPin = "mappin"
    public let location = "location.fill"
    public let locationArrow = "location.north.fill"
    public let compass = "compass"
    
    public let search = "magnifyingglass"
    public let filter = "line.3.horizontal.decrease.circle"
    public let sort = "arrow.up.arrow.down"
    public let refresh = "arrow.clockwise"
    public let settings = "gear"
    public let profile = "person.circle"
    public let notification = "bell"
    
    public let success = "checkmark.circle.fill"
    public let warning = "exclamationmark.triangle.fill"
    public let error = "xmark.circle.fill"
    public let info = "info.circle"
    
    public let home = "house"
    public let list = "list.bullet"
    public let grid = "square.grid.2x2"
    public let menu = "line.3.horizontal"
    public let more = "ellipsis"
    public let heart = "heart"
    public let star = "star"
    
    public let camera = "camera"
    public let photo = "photo"
    public let microphone = "mic"
    public let speaker = "speaker.wave.3"
    public let wifi = "wifi"
    public let battery = "battery.100"
    public let signal = "antenna.radiowaves.left.and.right"
}

extension Image {
    static let backArrow = Image(AppImages.shared.backArrow)
    static let close = Image(AppImages.shared.close)
    static let add = Image(AppImages.shared.add)
    static let edit = Image(AppImages.shared.edit)
    static let delete = Image(AppImages.shared.delete)
    static let save = Image(AppImages.shared.save)
    static let share = Image(AppImages.shared.share)
    
    static let task = Image(AppImages.shared.task)
    static let taskCompleted = Image(AppImages.shared.taskCompleted)
    static let taskPending = Image(AppImages.shared.taskPending)
    static let taskPriority = Image(AppImages.shared.taskPriority)
    static let taskLocation = Image(AppImages.shared.taskLocation)
    static let taskCalendar = Image(AppImages.shared.taskCalendar)
    static let taskTime = Image(AppImages.shared.taskTime)
    
    static let map = Image(AppImages.shared.map)
    static let mapPin = Image(AppImages.shared.mapPin)
    static let location = Image(AppImages.shared.location)
    static let locationArrow = Image(AppImages.shared.locationArrow)
    static let compass = Image(AppImages.shared.compass)
    
    static let search = Image(AppImages.shared.search)
    static let filter = Image(AppImages.shared.filter)
    static let sort = Image(AppImages.shared.sort)
    static let refresh = Image(AppImages.shared.refresh)
    static let settings = Image(AppImages.shared.settings)
    static let profile = Image(AppImages.shared.profile)
    static let notification = Image(AppImages.shared.notification)
    
    static let success = Image(AppImages.shared.success)
    static let warning = Image(AppImages.shared.warning)
    static let error = Image(AppImages.shared.error)
    static let info = Image(AppImages.shared.info)
    
    static let home = Image(AppImages.shared.home)
    static let list = Image(AppImages.shared.list)
    static let grid = Image(AppImages.shared.grid)
    static let menu = Image(AppImages.shared.menu)
    static let more = Image(AppImages.shared.more)
    static let heart = Image(AppImages.shared.heart)
    static let star = Image(AppImages.shared.star)
    
    static let camera = Image(AppImages.shared.camera)
    static let photo = Image(AppImages.shared.photo)
    static let microphone = Image(AppImages.shared.microphone)
    static let speaker = Image(AppImages.shared.speaker)
    static let wifi = Image(AppImages.shared.wifi)
    static let battery = Image(AppImages.shared.battery)
    static let signal = Image(AppImages.shared.signal)
} 