Red [
	title: "RED Forms Generator"
	author: "PlanetSizeCpu"
	contributor: "Yaron Koresh"
	file: %forms.red
	version: 1.0.0
	needs: 'view
	Usage:  {
		Use for form scripts generation, save result then copy&paste or load code
	}
	History: [
		0.1.0 "22-08-2017"	"Start of work."
		0.3.4 "26-03-2018"	"Source editor split"
		0.3.5 "30-04-2018"	"Dynamic code arrangement"
		0.3.6 "30-07-2018"	"Fixed font size typo"
		0.3.7 "27-08-2018"	"Fixed on-drop issue"
		0.3.8 "05-10-2018"	"Fixed widgets toolbox issue"
	]
]

WindowSizeX: 1000
WindowSizeY: 800
WindowSize: as-pair WindowSizeX WindowSizeY
WindowMinSizeX: 1000
WindowMinSizeY: 800
AllWidgets: [
        "area" "base" "box" "button"
        "calendar" "camera" "check"
        "drop-down" "drop-list" "field"
        "group-box" "image" "panel"
        "progress" "radio" "scroller"
        "slider" "tab-panel" "text" "text-list"
]
ToolboxSizeX: 130
ToolboxFormSheetSize: as-pair ToolboxSizeX 60
ToolboxWidgetsSize: as-pair ToolboxSizeX 200
ToolboxFontSize: as-pair ToolboxSizeX 125
ToolboxFileSize: as-pair ToolboxSizeX 85
ToolboxWidgetList: AllWidgets
FontSelection: none
FontName: "Arial"
FontStyle: 'normal
FontSize: 14
FontGroupFontName: none
FontGroupFontStyle: none
FontGroupFontSize: none
FormSheet: none
FormSheetSize: none
FormSheetSizeX: none
FormSheetSizeY: none
FormSheetOriginX: ToolboxSizeX + 10
FormSheetOriginY: 0
FormSheetOrigin: as-pair FormSheetOriginX FormSheetOriginY
FormSheetWidgetForeground: none
FormSheetWidgetBackground: none
FormSheetContent: []
FormSheetRecodeBlock: []
StaticEditor: none
StaticEditorOrigin: none
StaticEditorOriginX: 0
StaticEditorOriginY: none
StaticEditorSizeX: none
StaticEditorSizeY: 300
StaticEditorSize: none
DynamicEditor: none
DynamicEditorOrigin: none
DynamicEditorOriginX: none
DynamicEditorOriginY: 0
DynamicEditorSize: none
DynamicEditorSizeX: 360
DynamicEditorSizeY: WindowSizeY
Globalcode: ""
DefaultForegroundColor: black
DefaultBackgroundColor: white
FormSheetCounter: 0
Globalcode: ""

gui-updater: func [] [
    print "gui-updater: func called"
    mainScreenSizeAdjust
    FormSheetContent: []
    FormSheetRecodeBlock: []
    if none? FormSheetWidgetBackground [
        FormSheetWidgetBackground: DefaultBackgroundColor
        print "gui-updater: FormSheetWidgetBackground is none, set to default"
    ]
    if none? FormSheetWidgetForeground [
        FormSheetWidgetForeground: DefaultForegroundColor
        print "gui-updater: FormSheetWidgetForeground is none, set to default"
    ]
    FormSheetWidgetSize: 150x50
    DynamicCode: ""
    if none? FontSelection [
        print "gui-updater: FontSelection is none, attempting to create default font"
        FontSelection: attempt [
            make font! [
                name: FontName
                size: FontSize
                style: FontStyle
                color: FormSheetWidgetForeground
            ]
        ]
        if none? FontSelection [
            FontSelection: make font! [
                name: "Arial"
                size: 14
                style: 'normal
                color: 0.0.0
            ]
            print "gui-updater: Default font creation failed, using basic fallback."
        ]
    ]
    mainScreenSizeGuard
    Recode
]

mainScreenSizeGuard: func [] [
    print "mainScreenSizeGuard: func called"
    if not none? FormSheet [
        parent-face: FormSheet/parent
        if none? parent-face [
            print "mainScreenSizeGuard: FormSheet parent is none, returning"
            return false
        ]
        resized: false
        current-size: parent-face/size
        if current-size/x < WindowMinSizeX [
            parent-face/size/x: WindowMinSizeX
            resized: true
            print ["mainScreenSizeGuard: Width less than minimum, setting to" WindowMinSizeX]
        ]
        if current-size/y < WindowMinSizeY [
            parent-face/size/y: WindowMinSizeY
            resized: true
            print ["mainScreenSizeGuard: Height less than minimum, setting to" WindowMinSizeY]
        ]
        if resized [
            mainScreenSizeAdjust
        ]
        if value? 'InfoGroupFormSize [
            InfoGroupFormSize/text: mold FormSheetSize
        ]
        Recode
    ]
]

mainScreenSizeAdjust: func [] [
    print "mainScreenSizeAdjust: func called"
    copyWindowSizeX: none
    copyWindowSizeY: none
    either all [object? FormSheet object? FormSheet/parent] [
        parent-face: FormSheet/parent
        try-resize: none
        try-resize: attempt [
            copyWindowSizeX: parent-face/size/x
            copyWindowSizeY: parent-face/size/y
            print ["mainScreenSizeAdjust: Got size from parent:" copyWindowSizeX "x" copyWindowSizeY]
            true
        ]
        if none? try-resize [
            print "mainScreenSizeAdjust: Error accessing parent size, using defaults."
            copyWindowSizeX: WindowSizeX
            copyWindowSizeY: WindowSizeY
        ]
    ] [
        copyWindowSizeX: WindowSizeX
        copyWindowSizeY: WindowSizeY
        print ["mainScreenSizeAdjust: Using default size:" copyWindowSizeX "x" copyWindowSizeY]
    ]
    if any [none? copyWindowSizeX not number? copyWindowSizeX] [
        print [
            "mainScreenSizeAdjust: Invalid X size detected ("
            mold copyWindowSizeX
            "), falling back to minimum:"
            WindowMinSizeX
        ]
        copyWindowSizeX: WindowMinSizeX
    ]
    if any [none? copyWindowSizeY not number? copyWindowSizeY] [
        print [
            "mainScreenSizeAdjust: Invalid Y size detected ("
            mold copyWindowSizeY
            "), falling back to minimum:"
            WindowMinSizeY
        ]
        copyWindowSizeY: WindowMinSizeY
    ]
    copyWindowSize: as-pair copyWindowSizeX copyWindowSizeY
    WindowSize: copyWindowSize
    WindowSizeX: copyWindowSizeX
    WindowSizeY: copyWindowSizeY
    DynamicEditorSizeY: WindowSizeY
    StaticEditorSizeX: to-integer (WindowSizeX - DynamicEditorSizeX)
    StaticEditorSize: as-pair StaticEditorSizeX StaticEditorSizeY
    DynamicEditorSize: as-pair DynamicEditorSizeX DynamicEditorSizeY
    DynamicEditorOriginX: to-integer (WindowSizeX - DynamicEditorSizeX)
    FormSheetSizeX: to-integer (DynamicEditorOriginX - FormSheetOriginX)
    FormSheetSizeY: to-integer (WindowSizeY - FormSheetOriginY - StaticEditorSizeY)
    FormSheetSize: as-pair FormSheetSizeX FormSheetSizeY
    StaticEditorOriginY: to-integer (FormSheetOriginY + FormSheetSizeY)
    DynamicEditorOrigin: as-pair DynamicEditorOriginX DynamicEditorOriginY
    StaticEditorOrigin: as-pair StaticEditorOriginX StaticEditorOriginY
    if object? FormSheet [
        FormSheet/offset: FormSheetOrigin
        FormSheet/size: FormSheetSize
        print ["mainScreenSizeAdjust: Setting FormSheet offset/size to" FormSheetOrigin FormSheetSize]
    ]
    if object? StaticEditor [
        StaticEditor/offset: StaticEditorOrigin
        StaticEditor/size: StaticEditorSize
        print ["mainScreenSizeAdjust: Setting StaticEditor offset/size to" StaticEditorOrigin StaticEditorSize]
    ]
    if object? DynamicEditor [
        DynamicEditor/offset: DynamicEditorOrigin
        DynamicEditor/size: DynamicEditorSize
        print ["mainScreenSizeAdjust: Setting DynamicEditor offset/size to" DynamicEditorOrigin DynamicEditorSize]
    ]
]

FormFontChange: func [] [
    print "FormFontChange: func called"
    newFont: attempt [make font! request-font]
    either all [not error? newFont object? newFont] [
        FontSelection/color: FormSheetWidgetForeground
        print [newline newFont newline]
        FontName: newFont/name
        FontSize: newFont/size
        FontStyle: newFont/style
        if object? FontGroupFontName [
            if string? FontName [
                FontGroupFontName/text: FontName
                FontSelection/name: FontName
            ]
            if integer? FontSize [
                FontGroupFontSize/text: to string! FontSize
                FontSelection/size: FontSize
            ]
            if word? FontStyle [
                FontGroupFontStyle/text: to string! FontStyle
                FontSelection/style: FontStyle
            ]
        ]
        print ["FormFontChange: Font changed to" FontName (to string! FontSize) (to string! FontStyle)]
    ][
        print "FormFontChange: Error getting new font"
    ]
]

GetSelectedType: func [] [
    return to-word copy to string! pick ToolboxWidgetList WidgetGroupList/selected
]

FormSheetAddWidget: func [] [
    print "FormSheetAddWidget: func called"
    if none? FormSheetCounter [
        FormSheetCounter: 0
        print "FormSheetAddWidget: FormSheetCounter is none, initialized to 0"
    ]
    if none? FormSheetContent [
        FormSheetContent: []
        print "FormSheetAddWidget: FormSheetContent is none, initialized to []"
    ]
    if none? FontSelection [
        print "Error: FontSelection is not initialized."
        return false
    ]
    if none? FormSheet [
        print "Error: FormSheet panel not initialized."
        return false
    ]
    FormSheetCounter: add FormSheetCounter 1
    widget-index: WidgetGroupList/selected
    if none? widget-index [
        widget-index: 1
        print "FormSheetAddWidget: widget-index is none, set to 1"
    ]
    FormSheetStr: to-string pick ToolboxWidgetList widget-index
    FormSheetWidgetType: to-word copy FormSheetStr
    append FormSheetStr to-string FormSheetCounter
    append FormSheetStr ":"
    FormSheetWidgetName: to-set-word FormSheetStr
    FormSheetWidgetFiller: none
    widget-default-size: WidgetGroupSize/data
    switch FormSheetWidgetType [
        any ['area 'base 'box 'button 'calendar 'camera 'check
        'field 'group-box 'image 'panel 'progress 'radio
        'slider 'scroller 'text 'text-list] [
            FormSheetWidgetFiller: to-string FormSheetWidgetName
        ]
        'drop-down 'drop-list [
            FormSheetWidgetFiller: copy ["Sample"]
        ]
        'tab-panel [
            FormSheetWidgetFiller: reduce ["Tab 1" []]
        ]
    ]
    if none? FormSheetWidgetFiller [
        FormSheetWidgetFiller: ""
        print "FormSheetAddWidget: FormSheetWidgetFiller is none, set to ''"
    ]
    new-widget-spec: reduce [
        FormSheetWidgetName
        FormSheetWidgetType
        widget-default-size
        FormSheetWidgetFiller
        'font
        FontSelection
        FormSheetWidgetBackground
        FormSheetWidgetForeground
        'all-over
    ]
    print ["FormSheetAddWidget: new-widget-spec is" mold new-widget-spec]
    Dly: attempt [layout new-widget-spec]
    if error? Dly [
        print ["Error creating widget layout:" mold Dly]
        return false
    ]
    if none? Dly/pane [
        print ["Error: Layout resulted in no pane for widget: " FormSheetWidgetName]
        return false
    ]
    append FormSheet/pane Dly/pane
    Wgw: attempt [get to-word FormSheetWidgetName]
    if any [none? Wgw not object? Wgw] [
        print ["Error: Failed to get reference to new widget:" FormSheetWidgetName]
        return false
    ]
    append FormSheetContent FormSheetStr
    Wgw/menu: [
        "Position: Up" U
        "Position: Down" D
        "Position: Left" L
        "Position: Right" R
        "Position: Apply default" pos
        "Size: Increase" Size+
        "Size: Decrease" Size-
        "Size: Apply default" Defsize
        "Font: Apply default" Deffont
        "Colors: Apply default" Defcolor
        "Delete Widget!" Deletewt
    ]
    Wgw/actors: make object! [
        on-menu: func [face event] [
            switch event/picked [
                U [
                    face/offset/y: max 25 face/offset/y - 50
                    Recode
                ]
                D [
                    face/offset/y: face/offset/y + 50
                    Recode
                ]
                L [
                    face/offset/x: max 25 face/offset/x - 75
                    Recode
                ]
                R [
                    face/offset/x: face/offset/x + 75
                    Recode
                ]
                Size+ [
                    face/size: face/size + 25x25
                    Recode
                ]
                Size- [
                    face/size: max 20x20 face/size - 25x25
                    Recode
                ]
                Defsize [
                    face/size: WidgetGroupSize/data
                    Recode
                ]
                Deffont [
                    face/font: copy FontSelection
                    Recode
                ]
                Defcolor [
                    FormSheetSetDefcolor face
                    Recode
                ]
                Deletewt [
                    FormSheetDeleteWidget face face/text
                    Recode
                ]
            ]
        ]
        on-key-down: func [face event] [
            face/enabled?: no
            face/enabled?: yes
        ]
    ]
    Wgw/offset: 175x225
    Recode
    print ["FormSheetAddWidget: Added widget" FormSheetWidgetName "of type" FormSheetWidgetType]
]

FormSheetDeleteWidget: func [
    face[object!]
    name[string!]
    /local widget-name-str widget-name-word widget-face
][
    print "FormSheetDeleteWidget: func called"
    face-name-str: copy trim/with name ":"
    widget-name-str: none
    widget-name-word: none
    widget-face: none
    foreach name-str FormSheetContent [
        probe-word: attempt [to-word name-str]
        if all [
            word? probe-word
        ] [
            face-name-str-2: trim/with (to string! probe-word) ":"
            print ["Checking equality:" face-name-str face-name-str-2]
            if all [face-name-str = face-name-str-2][
                widget-name-str: copy name-str
                widget-name-word: probe-word
                widget-face: get probe-word
                break
            ]
        ]
    ]
    if none? widget-name-str [
        print ["Error: Could not find name string for face to delete: " mold face/text]
        return false
    ]
    remove-each item FormSheetContent [item = widget-name-str]
    parent-panel: widget-face/parent
    either find parent-panel/pane widget-face [
        remove find parent-panel/pane widget-face
        print ["FormSheetDeleteWidget: Removed face from parent pane:" mold widget-face/text]
    ][
        print ["Warning: Face to delete not found in parent pane:" mold widget-face/text]
    ]
    if all [word? widget-name-word value? widget-name-word] [
        unset widget-name-word
        print ["FormSheetDeleteWidget: Unset variable:" widget-name-word]
    ]
    Recode
]

FormSheetSetDefcolor: func [face [object!]] [
    print "FormSheetSetDefcolor: func called"
    face/color: FormSheetWidgetBackground
    face/font/color: FormSheetWidgetForeground
    Recode
]

Recode: func [] [
    print "Recode: func called"
    if none? FormSheetContent [
        FormSheetContent: []
        print "Recode: FormSheetContent is none, initialized to []"
    ]
    if none? FormSheetRecodeBlock [
        FormSheetRecodeBlock: []
        print "Recode: FormSheetRecodeBlock is none, initialized to []"
    ]
    if none? FormSheetSize [
        mainScreenSizeAdjust
        print "Recode: FormSheetSize is none, calling mainScreenSizeAdjust"
    ]
    size-line: copy "size "
    append size-line mold FormSheetSize
    clear FormSheetRecodeBlock
    append FormSheetRecodeBlock size-line
    foreach WgtNameStr FormSheetContent [
        WgtNameStr: trim/with WgtNameStr ":"
        Wgw: attempt [get to-word WgtNameStr]
        if any [none? Wgw not object? Wgw] [
            print ["Error: Could not find widget object during Recode for name:" WgtNameStr]
            continue
        ]
        Wgw/text: WgtNameStr
        WidgetLine: copy ""
        w-offset: Wgw/offset
        append WidgetLine "at "
        append WidgetLine mold w-offset
        append WidgetLine " "
        append WidgetLine WgtNameStr
        append WidgetLine ": "
        w-type: either word? Wgw/type [Wgw/type] ['base]
        append WidgetLine mold w-type
        append WidgetLine " "
        w-size: either pair? Wgw/size [Wgw/size] [150x25]
        append WidgetLine mold w-size
        append WidgetLine " "
        w-color-bg: either tuple? Wgw/color [Wgw/color] [white]
        append WidgetLine mold w-color-bg
        append WidgetLine " "
        w-color-fg: either all [object? Wgw/font tuple? Wgw/font/color] [Wgw/font/color] [black]
        append WidgetLine mold w-color-fg
        append WidgetLine " "
        w-filler-str: copy mold rejoin [WgtNameStr]
        append WidgetLine w-filler-str
        append WidgetLine " "
        either all [object? Wgw/font] [
            font-name: either string? Wgw/font/name [Wgw/font/name] ["Arial"]
            font-size: either integer? Wgw/font/size [Wgw/font/size] [14]
            font-style: either word? Wgw/font/style [Wgw/font/style] ['normal]
            font-color: either tuple? Wgw/font/color [Wgw/font/color] [0.0.0]
            append WidgetLine "font [name: "
            append WidgetLine mold font-name
            append WidgetLine " size: "
            append WidgetLine font-size
            append WidgetLine " style: '"
            append WidgetLine font-style
            append WidgetLine "]"
        ][
            append WidgetLine "font [name: "
            append WidgetLine mold "Arial"
            append WidgetLine " size: 12 style: '"
            append WidgetLine "normal"
            append WidgetLine "]"
        ]
        append FormSheetRecodeBlock WidgetLine
        print ["Recode: Processed widget:" WgtNameStr]
    ]
    Globalcode: copy ""
    append Globalcode "Red ["
    append Globalcode newline
    append Globalcode " Title: "
    append Globalcode mold "My App"
    append Globalcode newline
    append Globalcode " Needs: 'view"
    append Globalcode newline
    append Globalcode "]"
    append Globalcode newline
    append Globalcode "gui: layout ["
    append Globalcode newline
    append Globalcode " title "
    append Globalcode mold "My Red Language Application"
    append Globalcode newline
    append Globalcode " backdrop white"
    append Globalcode newline
    foreach WgtLine FormSheetRecodeBlock [
        append Globalcode " "
        append Globalcode WgtLine
        append Globalcode newline
    ]
    append Globalcode "]"
    append Globalcode newline
    append Globalcode "DynamicCode: does ["
    append Globalcode newline
    dynamic-user-code: either object? DynamicEditor [DynamicEditor/text] [""]
    append Globalcode dynamic-user-code
    append Globalcode newline
    append Globalcode "]"
    append Globalcode newline
    append Globalcode "gui/actors: make object! ["
    append Globalcode newline
    append Globalcode " on-create: func [face event] [attempt [do DynamicCode]]"
    append Globalcode newline
    append Globalcode "]"
    append Globalcode newline
    append Globalcode "view/flags gui [resize]"
    append Globalcode newline
    if object? StaticEditor [
        StaticEditor/text: GlobalCode
        print "Recode: gui-updater StaticEditor text"
    ]
    attempt [show FormSheet/pane]
    SourceSave
    print "Recode: gui-updater Globalcode"
]

SourceRun: function [] [
    SourceSave
    do %generated_form.red
]

SourceCompile: func [] [
    SourceSave
    call "red.exe -r -t windows -o generated_form generated_form.red"
]

SourceSave: func [] [
    write %generated_form.red Globalcode
]

gui-updater

mainScreen: layout [
    title "Red Forms"
    size WindowSize
    backdrop 250.250.250
    style btn: button 100x20 red black bold font-size 11
    
    at 5x2
    InfoGroup: group-box ToolboxFormSheetSize "Form-sheet size" [
        InfoGroupFormSize: text 100x25 center bold font-size 14 "N/A"
    ]
    at 5x62
    WidgetGroup: group-box ToolboxWidgetsSize "Widgets" [
        below center
        text center 100x15 bold "Size:"
        WidgetGroupSize: field 100x20 data 150x25
        across middle
        text 70x20 left "Foreground:"
        WidgetGroupFgn: box 20x20 defaultForegroundColor [
            color-slider [WidgetGroupFgn FontSelection]
        ]
        return
        text 70x20 left "Background:"
        WidgetGroupBgn: box 20x20 defaultBackgroundColor [
            color-slider [WidgetGroupBgn]
        ]
        return
        below center
        WidgetGroupList: drop-down 110x24 data AllWidgets select 1
        WidgetGroupAddbtn: btn bold "Add" [FormSheetAddWidget]
    ]
    at 5x262
    FontGroup: group-box ToolboxFontSize "Font" [
        below
        FontGroupFontName: text bold 90x15 FontName
        FontGroupFontStyle: text bold 90x15 "Normal"
        across
        text 30x15 bold "Size:"
        FontGroupFontSize: text bold 30x15 "14"
        return
        FontGroupFontBtn: btn bold "Font" [FormFontChange]
    ]
    at 5x387
    SourceGroup: group-box ToolboxFileSize "File" [
        below center
        RunButton: btn "Run" [
            SourceRun
        ]
        CompileButton: btn "Compile" [
            SourceCompile
        ]
    ]
    at FormSheetOrigin
    FormSheet: panel 600x400 white black cursor cross []
    
    at StaticEditorOrigin
    StaticEditor: area 200x200 font [
        name: "Arial"
        size: 10
        style: 'normal
        color: black
    ] white ""
    
    at DynamicEditorOrigin
    DynamicEditor: area 600x650 font [
        name: "Arial"
        size: 14
        style: 'bold
        color: green
    ] black ""
]

mainScreen/actors: make object! [
    on-key-up: func [mainScreenFace mainScreenEvent] [
        Recode
    ]
    on-resize: func [mainScreenFace mainScreenEvent] [
        gui-updater
    ]
    on-close: func [face event] [
        print "Closing Red Forms Generator."
    ]
]

gui-updater

system/view/debug?: no
view/flags mainScreen [resize]
