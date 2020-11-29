#!/bin/bash
#creating exit function
function out {
	if [ $? == 1 ]
	then
		exit
	fi
}
function video {
	#HandBrakeCLI -i $i -o "$destfolder"/"${i%.*}.mp4" -f mp4 -O --auto-anamorphic --modulus 2 -e x264_10bit -r 30 --pfr -q 20 -E aac -6 stereo -R Auto -B 192k-x --deinterlace --decomb
	ffmpeg -i "$i" -hide_banner -c:v libx264 -preset slow -crf 20 -deinterlace -c:a aac -b:a 192k -ar 44100 -ac 2  -f mp4 "$destfolder"/"${i%.*}.mp4"
}
function audio {
	ffmpeg -i "$i"  -vn -f mp3 -codec:a libmp3lame -b:a 320k "$destfolder"/"${i%.*}.mp3"
}
function audio1 {
	ffmpeg -i "$i" -c:a libvorbis "$destfolder"/"${i%.*}.ogg"
}
# if you ran the script accidentally then exit
zenity --question --text='<span foreground="#ff1493" font="20">You are Here To Convert \n\n<b> Any Video To MP4 \n\n Any Video To MP3 \n\n Any Audio To MP3\n\n Any Audio To OGG </b> </span> <span foreground="blue" font="9">\n\n\n\n Courtesy To Handbrake And FFMPEG \n MP3 output is 320kbps now. </span>' --width="400" --height="400" --ok-label=GOHEAD --cancel-label=NOTNOW
out
#Ask user for the folders
zenity --info --text='<span foreground="#ffa07a" font="20"> Now Your are going to choose Source folder, OK!</span>' --width="400" --height="400"
sourcefolder=$(zenity --file-selection --directory --title='Please Select Source Folder')
#if User cancels then exit
out
zenity --info --text='<span foreground="#32cd32" font="20"> Now You are going to choose Destination folder, OK!</span>' --width="400" --height="400"
destfolder=$(zenity --file-selection --directory --title='Please Choose Destination Folder')
#if user cancel then exit
out
#if Source and destination folders are same, ask if that's ok and if not exit
if [ "$sourcefolder" == "$destfolder" ]
then
  zenity --question --text='<span foreground="red" font="20">Source and Destination Folders are same.\n\n File can be over written. \n\n \n<big> OK! </big> </span>' --width="400" --height="400"
  if [ $? == 1 ]; then exit; fi
fi
choice=$( zenity --list \
--title='Please choose your job' \
--width="400" --height="400" \
--text='<span foreground="#ff00ff" font="20"> Please Select Appropriate Conversion Job </span>' \
--column='Available Conversion Jobs are As follows' \
'ANY_VIDEO_TO_MP4' \
'ANY_VIDEO_TO_MP3' \
'ANY_AUDIO_TO_MP3' \
'ANY_AUDIO_TO_OGG')
#IF user cancels then exit
out
echo "$sourcefolder"
echo "$destfolder"
if [ $choice = ANY_VIDEO_TO_MP4 ]
then
cd "$sourcefolder"
for i in *
do
	if [[ "$i" == *.mp4 || "$i" == *.avi || "$i" == *.mov || "$i" == *.mkv || "$i" == *.3gp || "$i" == *.flv || "$i" == *.FLV ]]
	then
		video
	fi
done
fi
if [ $choice = ANY_VIDEO_TO_MP3 ]
then
cd "$sourcefolder"
for i in *
do
	if [[ "$i" == *.mp4 || "$i" == *.avi || "$i" == *.mov || "$i" == *.mkv || "$i" == *.3gp || "$i" == *.flv ]]
	then
		audio
	fi
done
fi
if [ $choice = ANY_AUDIO_TO_MP3 ]
then
cd "$sourcefolder"
for i in *
do
	if [[ "$i" == *.mp3 || "$i" == *.wav || "$i" == *.aac || "$i" == *.ogg || "$i" == *.m4a ]]
	then
		audio
	fi
done
fi
if [ $choice = ANY_AUDIO_TO_OGG ]
then
cd "$sourcefolder"
for i in *
do
	if [[ "$i" == *.mp3 || "$i" == *.wav || "$i" == *.aac || "$i" == *.ogg || "$i" == *.m4a ]]
	then
		audio1
	fi
done
fi

