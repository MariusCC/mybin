#!/usr/bin/ruby1.8

require 'gtk2'
require 'open3'
require 'net/telnet'
require 'fileutils'
require 'date'


DESTINATION_DIR = "/media/hda4/webcam"
MAXIMUM_DURATION= 5
UVC_STREAM_COMMAND=%{uvc_stream -r 640x480 -f 30 -p 5555}
VLC_COMMAND=%{vlc -IRC --rc-host localhost:4444 --sout '#transcode{vcodec=mp4v,vb=3072,scale=1,acodec=mpga,ab=192,channels=2}:duplicate{dst=display,dst=std{access=file,mux=mp4,dst="/media/hda4/webcam/test.mpg"}}'}



class Recorder
def delete_event( widget, event )
Gtk.main_quit
return false
end
def initialize
start_uvc_stream
start_vlc
Gtk.init
window = Gtk::Window.new( Gtk::Window::TOPLEVEL )
window.signal_connect( 'delete_event' ) { |w,e| delete_event( w, e ) }
window.title=( "VLC/webcam controller" )
window.border_width = ( 10 )
window.set_default_size(200,100)
window.set_keep_above(true)
window.focus_on_map=(true)
Gdk::Window::GRAVITY_SOUTH_EAST
window.move(Gdk.screen_width - 200, Gdk.screen_height - 100)
tcontainer = Gtk::HBox.new( false, 0 )
window.add( tcontainer )
ttable = Gtk::Table.new( 2, 2, true )
tcontainer.pack_start( ttable, true, true, 0 )
tbutton = Gtk::Button.new("Start Recording")
@button = tbutton
tbutton.signal_connect("clicked") {
start_stop
}
ttable.attach( tbutton, 0, 2, 0, 1 )
tframe = Gtk::Frame.new( "Status:" )
tlabel = Gtk::Label.new
tlabel.text = 'Stopped'
@label = tlabel
tframe.add( tlabel )
ttable.attach( tframe, 0, 2, 1, 2 )
tlabel.show
tframe.show
tbutton.show
ttable.show
tcontainer.show
window.show
@recording = false
#@root = TkRoot.new { title "Ex1" }
@telnet = nil
begin
@telnet = Net::Telnet.new( "Host" => "localhost", "Port" => 4444, "TelnetMode" => false, "Prompt" => //)
rescue Exception => e
sleep 1
retry
end
sleep 2
start_recording
#bind('Return') { start_stop }
Gtk.main
end


def update_button
if !@recording
start_recording
else
stop_recording
end
end
def start_vlc
@vlc_thread = Thread.new do
system VLC_COMMAND
end
@vlc_started = true
end
def start_uvc_stream
@uvc_stream_thread = Thread.new do
system UVC_STREAM_COMMAND
end
@uvc_stream_started = true
end

def start_recording
@recording = true
@button.label = 'Stop Recording'
@label.text = 'Recording...'
@telnet.cmd("add http://localhost:5555")
#sleep 1
#@telnet.cmd("f")
# @start_time = Time.now
# @counter_thread = Thread.new(@label, @start_time) do |rlabel, rstart|
# while ((duration = (Time.now - rstart).to_i)<5)
# sleep 1
# rlabel.text = %{and #{MAXIMUM_DURATION - duration - 1}s are left }
# end
# end
# stop_recording
end
def stop_recording
@recording = false
#@telnet.cmd("f")
#sleep 1
@telnet.cmd("stop")
@button.label = 'Start Recording'
file = DateTime.now.strftime("%Y-%m-%dT%H:%M:%S")
FileUtils.mv("/media/hda4/webcam/test.mpg", DESTINATION_DIR+"/"+file+".mpg")
# @counter_thread.kill
# @label.text = %{#{MAXIMUM_DURATION}}
@label.text = 'Stopped'
end

def start_stop
update_button
end
def terminate
@telnet.cmd("quit")
end
end



r = Recorder.new
r.terminate

