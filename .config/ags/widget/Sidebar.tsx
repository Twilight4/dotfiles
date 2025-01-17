import { App } from "astal/gtk3"
import Apps from "gi://AstalApps"
import Wp from "gi://AstalWp"
import { Variable, GLib, bind } from "astal"
import { subprocess, exec, execAsync } from "astal/process"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Brightness from "./Brightness"

function BrightnessSlider() {
    const brightness = Brightness.get_default()

    return <box className="AudioSlider" css="min-width: 140px">
        <slider
            hexpand
            value={bind(brightness, "screen")}
            onDragged={({ value }) => brightness.screen = value}
        />
    </box>
}

function AudioSlider() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!

    return <box className="AudioSlider" css="min-width: 140px">
        <slider
            hexpand
            onDragged={({ value }) => speaker.volume = value}
            value={bind(speaker, "volume")}
        />
    </box>
}

function MicrophoneSlider() {
    const microphone = Wp.get_default()?.audio.defaultMicrophone!

    return <box className="AudioSlider" css="min-width: 140px">
        <slider
            hexpand
            onDragged={({ value }) => microphone.volume = value}
            value={bind(microphone, "volume")}
        />
    </box>
}

function openwallpaper() {
    const proc = subprocess(["bash", "-c", "~/.config/hypr/scripts/wallpaper select"])    
    App.get_window("sidebar")!.hide()
}

function openwallpapereffects() {
    const proc = subprocess(["bash", "-c", "~/.config/hypr/scripts/dock-toggle-hyprland"])    
    App.get_window("sidebar")!.hide()
}

function openwaybarthemes() {
    const proc = subprocess(["bash", "-c", "~/.config/hypr/scripts/hypridle-script toggle"])    
    App.get_window("sidebar")!.hide()
}

function powerlock() {
    const proc = subprocess(["bash", "-c", "$HOME/.config/hypr/scripts/power.sh lock"])    
    App.get_window("sidebar")!.hide()
}

function powerlogout() {
    const proc = subprocess(["bash", "-c", "$HOME/.config/hypr/scripts/power.sh exit"])    
    App.get_window("sidebar")!.hide()    
}

function powersuspend() {
    const proc = subprocess(["bash", "-c", "$HOME/.config/hypr/scripts/power.sh suspend"])    
    App.get_window("sidebar")!.hide()
}

function powerrestart() {
    const proc = subprocess(["bash", "-c", "$HOME/.config/hypr/scripts/power.sh reboot"])    
    App.get_window("sidebar")!.hide()
}

function powerexit() {
    const proc = subprocess(["bash", "-c", "$HOME/.config/hypr/scripts/power.sh shutdown"])    
    App.get_window("sidebar")!.hide()
}

export default function Sidebar() {

    const anchor = Astal.WindowAnchor.TOP
        | Astal.WindowAnchor.RIGHT

    return <window 
    name="sidebar"
    application={App}
    visible={false} 
    className="Sidebar"
    anchor={anchor}
    keymode={Astal.Keymode.ON_DEMAND}
    onKeyPressEvent={function (self, event: Gdk.Event) {
        if (event.get_keyval()[1] === Gdk.KEY_Escape)
            self.hide()
    }}      
    >    
    <box className="sidebar" vertical>
        <box horizontal homogeneous>
                <button onClicked={openwallpaper} className="btnbar">Wallpapers</button>
                <button onClicked={openwallpapereffects} className="btnbar">Toggle Appdock</button>
                <button onClicked={openwaybarthemes} className="btnbar">Toggle Screensaver</button>
        </box>
        <box css="padding-bottom:20px;"></box>
        <box className="group" halign="left" vertical>
            <label css="padding-bottom:10px" label="Speaker"></label>
            <AudioSlider/>
            <label css="padding-bottom:10px" label="Microphone"></label>
            <MicrophoneSlider />
        </box>
        <box css="padding-bottom:20px;"></box>
        <box className="group" halign="left" vertical>
            <label css="padding-bottom:10px" label="Brightness"></label>
            <BrightnessSlider />
        </box>
   </box>
</window>
}
